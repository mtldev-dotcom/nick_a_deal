import { ExecArgs } from "@medusajs/framework/types";
import {
    ContainerRegistrationKeys,
    Modules,
    ProductStatus,
} from "@medusajs/framework/utils";
import {
    createProductsWorkflow,
    createShippingProfilesWorkflow,
    updateStoresWorkflow,
} from "@medusajs/medusa/core-flows";
import { readFileSync } from "fs";
import { join } from "path";

interface CSVProduct {
    handle: string;
    title: string;
    subtitle: string;
    description: string;
    weight: number;
    length: number;
    width: number;
    height: number;
    cad: number;
    usd: number;
    image: string;
}

/**
 * Parses CSV file and returns array of product objects
 */
function parseCSV(filePath: string): CSVProduct[] {
    const content = readFileSync(filePath, "utf-8");
    const lines = content.trim().split("\n");
    const headers = lines[0].split(",").map((h) => h.trim());

    // Find column indices
    const getIndex = (name: string): number => {
        const index = headers.findIndex(
            (h) => h.toLowerCase().includes(name.toLowerCase())
        );
        if (index === -1) {
            throw new Error(`Column "${name}" not found in CSV`);
        }
        return index;
    };

    const handleIndex = getIndex("Product Handle");
    const titleIndex = getIndex("Product Title");
    const subtitleIndex = getIndex("Product Subtitle");
    const descIndex = getIndex("Product Description");
    const weightIndex = getIndex("Product Weight");
    const lengthIndex = getIndex("Product Length");
    const widthIndex = getIndex("Product Width");
    const heightIndex = getIndex("Product Height");
    const cadIndex = getIndex("CAD");
    const usdIndex = getIndex("USD");
    const imageIndex = getIndex("Product Image");

    const products: CSVProduct[] = [];

    // Parse data rows (skip header)
    for (let i = 1; i < lines.length; i++) {
        const line = lines[i].trim();
        if (!line) continue;

        // Handle CSV with quoted fields containing commas
        const row = parseCSVLine(line);

        if (row.length < headers.length) {
            console.warn(`Skipping row ${i + 1}: insufficient columns`);
            continue;
        }

        try {
            products.push({
                handle: row[handleIndex]?.trim() || "",
                title: row[titleIndex]?.trim() || "",
                subtitle: row[subtitleIndex]?.trim() || "",
                description: row[descIndex]?.trim() || "",
                weight: parseFloat(row[weightIndex]?.trim() || "0"),
                length: parseFloat(row[lengthIndex]?.trim() || "0"),
                width: parseFloat(row[widthIndex]?.trim() || "0"),
                height: parseFloat(row[heightIndex]?.trim() || "0"),
                cad: parseFloat(row[cadIndex]?.trim() || "0"),
                usd: parseFloat(row[usdIndex]?.trim() || "0"),
                image: row[imageIndex]?.trim() || "",
            });
        } catch (error) {
            console.warn(`Error parsing row ${i + 1}:`, error);
            continue;
        }
    }

    return products.filter(
        (p) => p.handle && p.title && (p.cad > 0 || p.usd > 0)
    );
}

/**
 * Simple CSV line parser that handles quoted fields
 */
function parseCSVLine(line: string): string[] {
    const result: string[] = [];
    let current = "";
    let inQuotes = false;

    for (let i = 0; i < line.length; i++) {
        const char = line[i];
        const nextChar = line[i + 1];

        if (char === '"') {
            if (inQuotes && nextChar === '"') {
                // Escaped quote
                current += '"';
                i++; // Skip next quote
            } else {
                // Toggle quote state
                inQuotes = !inQuotes;
            }
        } else if (char === "," && !inQuotes) {
            // Field separator
            result.push(current);
            current = "";
        } else {
            current += char;
        }
    }

    result.push(current); // Add last field
    return result;
}

/**
 * Ensures CAD currency is supported in the store
 * Preserves existing default currency when adding CAD
 */
async function ensureCADCurrency(
    storeModuleService: any,
    updateStoresWorkflowInstance: any,
    storeId: string
): Promise<void> {
    const [store] = await storeModuleService.listStores({ id: storeId });

    if (!store) {
        throw new Error(`Store with ID ${storeId} not found`);
    }

    const supportedCurrencies = store.supported_currencies || [];
    const hasCAD = supportedCurrencies.some((c: any) => c.currency_code === "cad");

    if (!hasCAD) {
        console.log("Adding CAD currency to store...");

        // Preserve existing currencies and their default status
        // Ensure at least one currency remains as default
        const updatedCurrencies = supportedCurrencies.map((c: any) => ({
            currency_code: c.currency_code,
            is_default: c.is_default ?? false,
        }));

        // Add CAD as non-default
        updatedCurrencies.push({ currency_code: "cad", is_default: false });

        // If no default exists, set the first one as default
        const hasDefault = updatedCurrencies.some((c: any) => c.is_default === true);
        if (!hasDefault && updatedCurrencies.length > 0) {
            updatedCurrencies[0].is_default = true;
        }

        await updateStoresWorkflowInstance.run({
            input: {
                selector: { id: storeId },
                update: {
                    supported_currencies: updatedCurrencies,
                },
            },
        });
        console.log("CAD currency added successfully");
    } else {
        console.log("CAD currency already supported");
    }
}

export default async function importProducts({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER);
    const storeModuleService = container.resolve(Modules.STORE);
    const fulfillmentModuleService = container.resolve(Modules.FULFILLMENT);
    const productModuleService = container.resolve(Modules.PRODUCT);

    try {
        // Get store ID
        const [store] = await storeModuleService.listStores();
        if (!store) {
            throw new Error("No store found. Please run seed script first.");
        }

        // Ensure CAD currency is supported
        await ensureCADCurrency(
            storeModuleService,
            updateStoresWorkflow(container),
            store.id
        );

        // Get or create default shipping profile
        let shippingProfiles = await fulfillmentModuleService.listShippingProfiles({
            type: "default",
        });
        let shippingProfile = shippingProfiles.length ? shippingProfiles[0] : null;

        if (!shippingProfile) {
            const { result } = await createShippingProfilesWorkflow(container).run({
                input: {
                    data: [
                        {
                            name: "Default Shipping Profile",
                            type: "default",
                        },
                    ],
                },
            });
            shippingProfile = result[0];
            logger.info("Created default shipping profile");
        }

        // Parse CSV file
        // CSV is in docs/ at workspace root, but script runs from nick-a-deal-shop/
        // Go up one directory to reach workspace root
        const csvPath = join(
            process.cwd(),
            "..",
            "docs",
            "product medusaJS nick a deal - Sheet7 (1).csv"
        );
        logger.info(`Reading CSV from: ${csvPath}`);

        const csvProducts = parseCSV(csvPath);
        logger.info(`Parsed ${csvProducts.length} products from CSV`);

        if (csvProducts.length === 0) {
            throw new Error("No valid products found in CSV");
        }

        // Check for existing products by handle
        const existingProducts = await productModuleService.listProducts({});
        const existingHandles = new Set(
            existingProducts.map((p: any) => p.handle)
        );

        // Filter out products that already exist
        const newProducts = csvProducts.filter(
            (p) => !existingHandles.has(p.handle)
        );

        if (newProducts.length === 0) {
            logger.info("All products from CSV already exist in database");
            return;
        }

        logger.info(
            `Found ${newProducts.length} new products to import (${csvProducts.length - newProducts.length} already exist)`
        );

        // Transform CSV products to MedusaJS format
        const productsToCreate = newProducts.map((csvProduct) => {
            // Generate SKU from handle
            const sku = csvProduct.handle.toUpperCase().replace(/-/g, "_");

            return {
                title: csvProduct.title,
                handle: csvProduct.handle,
                subtitle: csvProduct.subtitle || undefined,
                description: csvProduct.description || undefined,
                weight: csvProduct.weight || undefined,
                length: csvProduct.length || undefined,
                width: csvProduct.width || undefined,
                height: csvProduct.height || undefined,
                status: ProductStatus.PUBLISHED,
                shipping_profile_id: shippingProfile.id,
                images: csvProduct.image
                    ? [
                        {
                            url: csvProduct.image,
                        },
                    ]
                    : [],
                // Product options are required when variants exist
                // Create a default option for single-variant products
                options: [
                    {
                        title: "Default",
                        values: ["Standard"],
                    },
                ],
                // Create a single default variant for each product
                variants: [
                    {
                        title: csvProduct.title,
                        sku: sku,
                        // Variant must reference the option
                        options: {
                            Default: "Standard",
                        },
                        prices: [
                            // Prices are in smallest currency unit (cents)
                            // Convert CAD dollars to cents
                            ...(csvProduct.cad > 0
                                ? [
                                    {
                                        amount: Math.round(csvProduct.cad * 100),
                                        currency_code: "cad",
                                    },
                                ]
                                : []),
                            // Convert USD dollars to cents
                            ...(csvProduct.usd > 0
                                ? [
                                    {
                                        amount: Math.round(csvProduct.usd * 100),
                                        currency_code: "usd",
                                    },
                                ]
                                : []),
                        ],
                        // Use product dimensions for variant
                        weight: csvProduct.weight || undefined,
                        length: csvProduct.length || undefined,
                        width: csvProduct.width || undefined,
                        height: csvProduct.height || undefined,
                    },
                ],
            };
        });

        // Create products using workflow
        logger.info(`Creating ${productsToCreate.length} products...`);

        const { result, errors } = await createProductsWorkflow(container).run({
            input: {
                products: productsToCreate,
            },
        });

        if (errors && errors.length > 0) {
            // TransactionStepError[] needs to be serialized for logging
            const errorMessages = errors.map((err: any) =>
                err.message || err.error?.message || String(err)
            ).join("; ");
            logger.error("Errors during product creation: " + errorMessages);
            throw new Error(`Failed to create some products: ${errorMessages}`);
        }

        logger.info(`Successfully imported ${result?.length || productsToCreate.length} products`);
        logger.info("Import completed successfully!");

        // Log created product handles
        if (result) {
            const createdHandles = result.map((p: any) => p.handle).join(", ");
            logger.info(`Created products: ${createdHandles}`);
        }
    } catch (error) {
        logger.error("Error importing products:", error);
        throw error;
    }
}

