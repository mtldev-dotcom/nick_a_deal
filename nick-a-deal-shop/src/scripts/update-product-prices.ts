import { ExecArgs } from "@medusajs/framework/types";
import {
    ContainerRegistrationKeys,
    Modules,
} from "@medusajs/framework/utils";
import { updateProductsWorkflow } from "@medusajs/medusa/core-flows";
import { readFileSync } from "fs";
import { join } from "path";

interface CSVProduct {
    handle: string;
    cad: number;
    usd: number;
}

/**
 * Parses CSV file and returns array of product price data
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
    const cadIndex = getIndex("CAD");
    const usdIndex = getIndex("USD");

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
                cad: parseFloat(row[cadIndex]?.trim() || "0"),
                usd: parseFloat(row[usdIndex]?.trim() || "0"),
            });
        } catch (error) {
            console.warn(`Error parsing row ${i + 1}:`, error);
            continue;
        }
    }

    return products.filter((p) => p.handle && (p.cad > 0 || p.usd > 0));
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

export default async function updateProductPrices({ container }: ExecArgs) {
    const logger = container.resolve(ContainerRegistrationKeys.LOGGER);
    const productModuleService = container.resolve(Modules.PRODUCT);

    try {
        // Parse CSV file
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

        let updatedCount = 0;
        let notFoundCount = 0;
        let errorCount = 0;

        // Process each product
        for (const csvProduct of csvProducts) {
            try {
                // Find product by handle
                const products = await productModuleService.listProducts({
                    handle: csvProduct.handle,
                });

                if (!products || products.length === 0) {
                    logger.warn(
                        `Product not found with handle: ${csvProduct.handle}`
                    );
                    notFoundCount++;
                    continue;
                }

                const product = products[0];

                // Get product variants
                const variants = await productModuleService.listProductVariants({
                    product_id: product.id,
                });

                if (!variants || variants.length === 0) {
                    logger.warn(
                        `No variants found for product: ${product.handle}`
                    );
                    continue;
                }

                // Prepare new prices
                const newPrices: Array<{
                    amount: number;
                    currency_code: string;
                }> = [];

                if (csvProduct.cad > 0) {
                    newPrices.push({
                        amount: Math.round(csvProduct.cad),
                        currency_code: "cad",
                    });
                }

                if (csvProduct.usd > 0) {
                    newPrices.push({
                        amount: Math.round(csvProduct.usd),
                        currency_code: "usd",
                    });
                }

                if (newPrices.length === 0) {
                    logger.warn(
                        `No valid prices found for product: ${product.handle}`
                    );
                    continue;
                }

                // Update all variants with new prices
                const updatedVariants = variants.map((variant) => ({
                    id: variant.id,
                    prices: newPrices,
                }));

                // Use updateProductsWorkflow to update variant prices
                // The workflow expects selector and update, not an array
                await updateProductsWorkflow(container).run({
                    input: {
                        selector: {
                            id: product.id,
                        },
                        update: {
                            variants: updatedVariants,
                        },
                    },
                });

                logger.info(
                    `Updated prices for ${product.handle}: CAD $${csvProduct.cad}, USD $${csvProduct.usd} (${variants.length} variants)`
                );
                updatedCount += variants.length;
            } catch (productError: any) {
                logger.error(
                    `Error processing product ${csvProduct.handle}:`,
                    productError.message || productError
                );
                errorCount++;
            }
        }

        logger.info("Price update completed!");
        logger.info(`Successfully updated: ${updatedCount} variants`);
        logger.info(`Products not found: ${notFoundCount}`);
        logger.info(`Errors: ${errorCount}`);
    } catch (error) {
        logger.error("Error updating product prices:", error);
        throw error;
    }
}

