-- SQL script to update image URLs in remote database
-- Replaces: http://localhost:9000/static/
-- With:     https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/
-- 
-- Usage: psql -h 5.161.238.111 -p 5433 -U postgres -d nick_deal_db -f update-remote-urls.sql

-- Start transaction for safety
BEGIN;

-- Step 1: Update image table URLs
UPDATE public.image
SET url = REPLACE(url, 'http://localhost:9000/static/', 'https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/')
WHERE url LIKE 'http://localhost:9000/static/%';

-- Step 2: Update product thumbnail URLs
UPDATE public.product
SET thumbnail = REPLACE(thumbnail, 'http://localhost:9000/static/', 'https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/')
WHERE thumbnail LIKE 'http://localhost:9000/static/%';

-- Step 3: Update cart line item thumbnail URLs (if exists)
UPDATE public.cart_line_item
SET thumbnail = REPLACE(thumbnail, 'http://localhost:9000/static/', 'https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/')
WHERE thumbnail LIKE 'http://localhost:9000/static/%';

-- Step 4: Update order line item thumbnail URLs (if exists)
UPDATE public.order_line_item
SET thumbnail = REPLACE(thumbnail, 'http://localhost:9000/static/', 'https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/')
WHERE thumbnail LIKE 'http://localhost:9000/static/%';

-- Step 5: Verify counts
SELECT 
    'image' as table_name,
    COUNT(*) as total_rows,
    COUNT(*) FILTER (WHERE url LIKE 'https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/%') as updated_count,
    COUNT(*) FILTER (WHERE url LIKE 'http://localhost:9000/static/%') as remaining_old_urls
FROM public.image
UNION ALL
SELECT 
    'product' as table_name,
    COUNT(*) as total_rows,
    COUNT(*) FILTER (WHERE thumbnail LIKE 'https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/%') as updated_count,
    COUNT(*) FILTER (WHERE thumbnail LIKE 'http://localhost:9000/static/%') as remaining_old_urls
FROM public.product
WHERE thumbnail IS NOT NULL;

-- Commit transaction (change to ROLLBACK if you want to test first)
COMMIT;

-- Show a sample of updated URLs for verification
SELECT 'Sample updated image URLs:' as info;
SELECT id, url 
FROM public.image 
WHERE url LIKE 'https://pub-0e79c5d9c3514966abd6173d388518b2.r2.dev/product-demo-image/%'
LIMIT 5;

