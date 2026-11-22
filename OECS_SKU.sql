-- ============================================================================
-- OECS V2 / SQL Server 2022
-- FULL DEMO SKU VARIANTS FOR ALL 39 PRODUCTS - FIXED NUMERIC/TEXT OPTIONS
-- ============================================================================
-- PREREQUISITE: Run OECS_V2_Catalog_Inventory_Complete.sql first.
-- This script is a NON-DESTRUCTIVE DATA SEED. It does NOT drop tables,
-- delete existing SKUs, change historical SKU prices, or increase existing stock.
-- New prices and stock levels are DEMO DATA, NOT OFFICIAL RETAIL INFORMATION.
-- Color/configuration options are illustrative and must be checked against
-- your actual manufacturer variants / goods before any real sale.
-- Existing SKUs are preserved; missing variant attributes are added when safe.
-- Existing attribute values are authoritative: never overwrite them.
-- Numeric attributes (such as 128.0000 GB) are normalized to numeric_value.
 -- This fixes the old 55108 false conflict for numeric vs text representation.
-- If an unlisted SKU already represents a seeded variant combination,
-- that new demo SKU is skipped to avoid duplicate purchasable variants.
-- Requires unique index/product_variant and stored proc from catalog migration.
-- Inventory trigger will record OPENING for newly inserted SKUs automatically.
-- ALWAYS BACK UP DB and TEST on a copy first. Can be re-run (idempotent).
-- ============================================================================

USE OECS;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    IF OBJECT_ID(N'dbo.CATEGORY_ATTRIBUTE', N'U') IS NULL
       OR OBJECT_ID(N'dbo.SKU_ATTRIBUTE_VALUE', N'U') IS NULL
       OR OBJECT_ID(N'dbo.PRODUCT_SKU', N'U') IS NULL
       OR OBJECT_ID(N'dbo.PRODUCT', N'U') IS NULL
       OR OBJECT_ID(N'dbo.ATTRIBUTE', N'U') IS NULL
       OR OBJECT_ID(N'dbo.usp_OECS_RefreshSkuVariantKey', N'P') IS NULL
        THROW 55100, N'Chua chay OECS V2 Catalog migration day du.', 1;

    DECLARE @SkuBefore BIGINT = (SELECT COUNT_BIG(*) FROM dbo.PRODUCT_SKU);
    DECLARE @Inserted BIGINT = 0;
    DECLARE @AddedAttributeRows BIGINT = 0;

    DECLARE @Seed TABLE (
        product_name NVARCHAR(255) NOT NULL,
        sku_code VARCHAR(100) NOT NULL PRIMARY KEY,
        price DECIMAL(18,2) NOT NULL,
        initial_stock INT NOT NULL,
        attr1 NVARCHAR(100) NULL, val1 NVARCHAR(255) NULL,
        attr2 NVARCHAR(100) NULL, val2 NVARCHAR(255) NULL,
        attr3 NVARCHAR(100) NULL, val3 NVARCHAR(255) NULL
    );

    -- SECTION A: 39 products, rich SKU choices per category.
    -- For existing SKU codes, seed prices and stock are ignored; only new SKUs
    -- receive the price/stock defined here.
    INSERT INTO @Seed (
        product_name, sku_code, price, initial_stock,
        attr1, val1, attr2, val2, attr3, val3
    ) VALUES
        -- iPhone 15 Pro (6 SKU choices)
    (N'iPhone 15 Pro', 'IP15P-128-BLK', 27990000, 15, N'Dung lượng lưu trữ', N'128GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'iPhone 15 Pro', 'IP15P-128-SLV', 27990000, 18, N'Dung lượng lưu trữ', N'128GB', N'Màu sắc', N'Bạc', NULL, NULL),
    (N'iPhone 15 Pro', 'IP15P-256-BLK', 30990000, 16, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'iPhone 15 Pro', 'IP15P-256-SLV', 30990000, 10, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Bạc', NULL, NULL),
    (N'iPhone 15 Pro', 'IP15P-512-BLK', 34490000, 12, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'iPhone 15 Pro', 'IP15P-512-SLV', 34490000, 10, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Bạc', NULL, NULL),

        -- iPhone 15 Pro Max (6 SKU choices)
    (N'iPhone 15 Pro Max', 'IP15PM-256-NAT', 33990000, 12, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Titan tự nhiên', NULL, NULL),
    (N'iPhone 15 Pro Max', 'IP15PM-256-BLK', 33990000, 18, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Titan đen', NULL, NULL),
    (N'iPhone 15 Pro Max', 'IP15PM-512-NAT', 36990000, 16, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Titan tự nhiên', NULL, NULL),
    (N'iPhone 15 Pro Max', 'IP15PM-512-BLK', 36990000, 14, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Titan đen', NULL, NULL),
    (N'iPhone 15 Pro Max', 'IP15PM-1T-NAT', 40990000, 12, N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Titan tự nhiên', NULL, NULL),
    (N'iPhone 15 Pro Max', 'IP15PM-1T-BLK', 40990000, 10, N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Titan đen', NULL, NULL),

        -- iPhone 16 Pro (6 SKU choices)
    (N'iPhone 16 Pro', 'IP16P-128-BLK', 28990000, 20, N'Dung lượng lưu trữ', N'128GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'iPhone 16 Pro', 'IP16P-128-WHT', 28990000, 18, N'Dung lượng lưu trữ', N'128GB', N'Màu sắc', N'Trắng', NULL, NULL),
    (N'iPhone 16 Pro', 'IP16P-256-BLK', 32990000, 16, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'iPhone 16 Pro', 'IP16P-256-WHT', 32990000, 14, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Trắng', NULL, NULL),
    (N'iPhone 16 Pro', 'IP16P-512-BLK', 36990000, 12, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'iPhone 16 Pro', 'IP16P-512-WHT', 36990000, 10, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Trắng', NULL, NULL),

        -- iPhone 16 Pro Max (6 SKU choices)
    (N'iPhone 16 Pro Max', 'IP16PM-256-DES', 34990000, 25, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Titan sa mạc', NULL, NULL),
    (N'iPhone 16 Pro Max', 'IP16PM-256-BLK', 34990000, 18, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Titan đen', NULL, NULL),
    (N'iPhone 16 Pro Max', 'IP16PM-512-DES', 38990000, 16, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Titan sa mạc', NULL, NULL),
    (N'iPhone 16 Pro Max', 'IP16PM-512-BLK', 38990000, 14, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Titan đen', NULL, NULL),
    (N'iPhone 16 Pro Max', 'IP16PM-1T-DES', 42990000, 12, N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Titan sa mạc', NULL, NULL),
    (N'iPhone 16 Pro Max', 'IP16PM-1T-BLK', 42990000, 10, N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Titan đen', NULL, NULL),

        -- Samsung Galaxy S24 Ultra (6 SKU choices)
    (N'Samsung Galaxy S24 Ultra', 'SS-S24U-256-GRY', 29990000, 20, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Xám', NULL, NULL),
    (N'Samsung Galaxy S24 Ultra', 'SS-S24U-256-BLK', 29990000, 18, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'Samsung Galaxy S24 Ultra', 'SS-S24U-512-GRY', 33490000, 16, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám', NULL, NULL),
    (N'Samsung Galaxy S24 Ultra', 'SS-S24U-512-BLK', 33490000, 14, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'Samsung Galaxy S24 Ultra', 'SS-S24U-1T-GRY', 37990000, 12, N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám', NULL, NULL),
    (N'Samsung Galaxy S24 Ultra', 'SS-S24U-1T-BLK', 37990000, 10, N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Đen', NULL, NULL),

        -- Samsung Galaxy S24 Plus (4 SKU choices)
    (N'Samsung Galaxy S24 Plus', 'SS-S24P-256-BLK', 25990000, 15, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'Samsung Galaxy S24 Plus', 'SS-S24P-256-VIO', 25990000, 18, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Tím', NULL, NULL),
    (N'Samsung Galaxy S24 Plus', 'SS-S24P-512-BLK', 28990000, 16, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'Samsung Galaxy S24 Plus', 'SS-S24P-512-VIO', 28990000, 14, N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Tím', NULL, NULL),

        -- Samsung Galaxy A55 5G (4 SKU choices)
    (N'Samsung Galaxy A55 5G', 'SS-A55-128-BLU', 9990000, 30, N'Dung lượng lưu trữ', N'128GB', N'Màu sắc', N'Xanh', NULL, NULL),
    (N'Samsung Galaxy A55 5G', 'SS-A55-128-BLK', 9990000, 18, N'Dung lượng lưu trữ', N'128GB', N'Màu sắc', N'Đen', NULL, NULL),
    (N'Samsung Galaxy A55 5G', 'SS-A55-256-BLU', 10990000, 16, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Xanh', NULL, NULL),
    (N'Samsung Galaxy A55 5G', 'SS-A55-256-BLK', 10990000, 14, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Đen', NULL, NULL),

        -- Samsung Galaxy A35 5G (4 SKU choices)
    (N'Samsung Galaxy A35 5G', 'SS-A35-128-YLW', 8290000, 35, N'Dung lượng lưu trữ', N'128GB', N'Màu sắc', N'Vàng', NULL, NULL),
    (N'Samsung Galaxy A35 5G', 'SS-A35-128-BLU', 8290000, 18, N'Dung lượng lưu trữ', N'128GB', N'Màu sắc', N'Xanh', NULL, NULL),
    (N'Samsung Galaxy A35 5G', 'SS-A35-256-YLW', 9290000, 16, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Vàng', NULL, NULL),
    (N'Samsung Galaxy A35 5G', 'SS-A35-256-BLU', 9290000, 14, N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Xanh', NULL, NULL),

        -- AirPods Pro 2 (2 SKU choices)
    (N'AirPods Pro 2', 'APP-AP2-WHT', 5990000, 50, N'Phiên bản', N'Hộp Lightning', N'Màu sắc', N'Trắng', NULL, NULL),
    (N'AirPods Pro 2', 'APP-AP2-USBC', 6390000, 18, N'Phiên bản', N'Hộp USB-C', N'Màu sắc', N'Trắng', NULL, NULL),

        -- AirPods 4 (2 SKU choices)
    (N'AirPods 4', 'APP-AP4-WHT', 3490000, 45, N'Phiên bản', N'Tiêu chuẩn', N'Màu sắc', N'Trắng', NULL, NULL),
    (N'AirPods 4', 'APP-AP4-ANC', 4490000, 24, N'Phiên bản', N'Chống ồn ANC', N'Màu sắc', N'Trắng', NULL, NULL),

        -- Samsung Galaxy Buds3 Pro (2 SKU choices)
    (N'Samsung Galaxy Buds3 Pro', 'SS-B3P-SLV', 4990000, 40, N'Màu sắc', N'Bạc', NULL, NULL, NULL, NULL),
    (N'Samsung Galaxy Buds3 Pro', 'SS-BUDS3-PRO', 4990000, 20, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Samsung Galaxy Buds FE (2 SKU choices)
    (N'Samsung Galaxy Buds FE', 'SS-BFE-BLK', 1990000, 60, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Samsung Galaxy Buds FE', 'SS-BFE-WHT', 1990000, 25, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Sony WH-1000XM5 (2 SKU choices)
    (N'Sony WH-1000XM5', 'SONY-WH1000XM5', 6990000, 15, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Sony WH-1000XM5', 'SONY-WH1000XM5-SLV', 6990000, 12, N'Màu sắc', N'Bạc', NULL, NULL, NULL, NULL),

        -- JBL Tune 770NC (2 SKU choices)
    (N'JBL Tune 770NC', 'JBL-T770NC', 2490000, 25, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'JBL Tune 770NC', 'JBL-T770NC-WHT', 2490000, 18, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Apple USB-C 20W Power Adapter (2 SKU choices)
    (N'Apple USB-C 20W Power Adapter', 'APP-20W-WHT', 550000, 100, N'Gói bán', N'1 củ sạc', NULL, NULL, NULL, NULL),
    (N'Apple USB-C 20W Power Adapter', 'APP-20W-2PACK', 1050000, 20, N'Gói bán', N'Bộ 2 củ sạc', NULL, NULL, NULL, NULL),

        -- Samsung 25W USB-C Fast Charger (2 SKU choices)
    (N'Samsung 25W USB-C Fast Charger', 'SS-25W-BLK', 390000, 100, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Samsung 25W USB-C Fast Charger', 'SS-25W-WHT', 390000, 32, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Apple USB-C Charge Cable 1m (2 SKU choices)
    (N'Apple USB-C Charge Cable 1m', 'APP-C2C-1M', 450000, 80, N'Gói bán', N'1 dây', NULL, NULL, NULL, NULL),
    (N'Apple USB-C Charge Cable 1m', 'APP-C2C-1M-2PK', 850000, 25, N'Gói bán', N'Bộ 2 dây', NULL, NULL, NULL, NULL),

        -- Apple USB-C to Lightning Cable (2 SKU choices)
    (N'Apple USB-C to Lightning Cable', 'APP-C2L-1M', 490000, 80, N'Chiều dài', N'1m', NULL, NULL, NULL, NULL),
    (N'Apple USB-C to Lightning Cable', 'APP-C2L-2M', 790000, 15, N'Chiều dài', N'2m', NULL, NULL, NULL, NULL),

        -- Samsung USB-C Cable 1m (2 SKU choices)
    (N'Samsung USB-C Cable 1m', 'SS-C2C-1M', 250000, 90, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Samsung USB-C Cable 1m', 'SS-C2C-1M-WHT', 250000, 45, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Lenovo IdeaPad Slim 3 (4 SKU choices)
    (N'Lenovo IdeaPad Slim 3', 'LEN-IDP3-I3', 10490000, 12, N'RAM', N'8GB DDR4', N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Xám'),
    (N'Lenovo IdeaPad Slim 3', 'LEN-IDP3-8GB-512GB', 11590000, 8, N'RAM', N'8GB DDR4', N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám'),
    (N'Lenovo IdeaPad Slim 3', 'LEN-IDP3-16GB-256GB', 11990000, 7, N'RAM', N'16GB DDR4', N'Dung lượng lưu trữ', N'256GB', N'Màu sắc', N'Xám'),
    (N'Lenovo IdeaPad Slim 3', 'LEN-IDP3-16GB-512GB', 13090000, 6, N'RAM', N'16GB DDR4', N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám'),

        -- Lenovo ThinkBook 14 (4 SKU choices)
    (N'Lenovo ThinkBook 14', 'LEN-TB14-I5', 16990000, 12, N'RAM', N'16GB DDR5', N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám'),
    (N'Lenovo ThinkBook 14', 'LEN-TB14-16GB-1TB', 18990000, 8, N'RAM', N'16GB DDR5', N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám'),
    (N'Lenovo ThinkBook 14', 'LEN-TB14-32GB-512GB', 20990000, 7, N'RAM', N'32GB DDR5', N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám'),
    (N'Lenovo ThinkBook 14', 'LEN-TB14-32GB-1TB', 22990000, 6, N'RAM', N'32GB DDR5', N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám'),

        -- Lenovo IdeaPad 5 (4 SKU choices)
    (N'Lenovo IdeaPad 5', 'LEN-IDP5-R5', 14490000, 12, N'RAM', N'16GB DDR4', N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám'),
    (N'Lenovo IdeaPad 5', 'LEN-IDP5-16GB-1TB', 16490000, 8, N'RAM', N'16GB DDR4', N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám'),
    (N'Lenovo IdeaPad 5', 'LEN-IDP5-32GB-512GB', 18490000, 7, N'RAM', N'32GB DDR4', N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám'),
    (N'Lenovo IdeaPad 5', 'LEN-IDP5-32GB-1TB', 20490000, 6, N'RAM', N'32GB DDR4', N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám'),

        -- Lenovo LOQ 15 (4 SKU choices)
    (N'Lenovo LOQ 15', 'LOQ-15-16GB-512GB', 21490000, 12, N'RAM', N'16GB DDR5', N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám'),
    (N'Lenovo LOQ 15', 'LOQ-15-16GB-1TB', 24490000, 8, N'RAM', N'16GB DDR5', N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám'),
    (N'Lenovo LOQ 15', 'LOQ-15-32GB-512GB', 25490000, 7, N'RAM', N'32GB DDR5', N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám'),
    (N'Lenovo LOQ 15', 'LOQ-15-32GB-1TB', 28490000, 6, N'RAM', N'32GB DDR5', N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám'),

        -- Lenovo Legion 5 (4 SKU choices)
    (N'Lenovo Legion 5', 'LEN-LEG5-R7', 32990000, 12, N'RAM', N'16GB DDR5', N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám'),
    (N'Lenovo Legion 5', 'LEN-LEG5-16GB-1TB', 35990000, 8, N'RAM', N'16GB DDR5', N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám'),
    (N'Lenovo Legion 5', 'LEN-LEG5-32GB-512GB', 36990000, 7, N'RAM', N'32GB DDR5', N'Dung lượng lưu trữ', N'512GB', N'Màu sắc', N'Xám'),
    (N'Lenovo Legion 5', 'LEN-LEG5-32GB-1TB', 39990000, 6, N'RAM', N'32GB DDR5', N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám'),

        -- Lenovo Legion Pro 5 (4 SKU choices)
    (N'Lenovo Legion Pro 5', 'LEN-LEG5P-I9', 45990000, 12, N'RAM', N'32GB DDR5', N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám'),
    (N'Lenovo Legion Pro 5', 'LEN-LEG5P-32GB-2TB', 50990000, 8, N'RAM', N'32GB DDR5', N'Dung lượng lưu trữ', N'2TB', N'Màu sắc', N'Xám'),
    (N'Lenovo Legion Pro 5', 'LEN-LEG5P-64GB-1TB', 51990000, 7, N'RAM', N'64GB DDR5', N'Dung lượng lưu trữ', N'1TB', N'Màu sắc', N'Xám'),
    (N'Lenovo Legion Pro 5', 'LEN-LEG5P-64GB-2TB', 56990000, 6, N'RAM', N'64GB DDR5', N'Dung lượng lưu trữ', N'2TB', N'Màu sắc', N'Xám'),

        -- Lenovo Legion M300 RGB (2 SKU choices)
    (N'Lenovo Legion M300 RGB', 'LEN-M300-BLK', 690000, 30, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Lenovo Legion M300 RGB', 'LEN-M300-WHT', 690000, 14, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Lenovo Legion M600 Wireless (2 SKU choices)
    (N'Lenovo Legion M600 Wireless', 'LEN-M600-BLK', 1490000, 30, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Lenovo Legion M600 Wireless', 'LEN-M600-WHT', 1490000, 14, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Lenovo Legion K300 RGB (2 SKU choices)
    (N'Lenovo Legion K300 RGB', 'LEN-K300-BLK', 890000, 30, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Lenovo Legion K300 RGB', 'LEN-K300-WHT', 890000, 14, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Lenovo Go Wireless Split Keyboard (2 SKU choices)
    (N'Lenovo Go Wireless Split Keyboard', 'LEN-GOW-GRY', 1990000, 30, N'Màu sắc', N'Xám', NULL, NULL, NULL, NULL),
    (N'Lenovo Go Wireless Split Keyboard', 'LEN-GOW-BLK', 1990000, 14, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),

        -- Lenovo 300 FHD Webcam (2 SKU choices)
    (N'Lenovo 300 FHD Webcam', 'LEN-W300-BLK', 750000, 30, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Lenovo 300 FHD Webcam', 'LEN-W300-WHT', 750000, 14, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Lenovo Performance FHD Webcam (2 SKU choices)
    (N'Lenovo Performance FHD Webcam', 'LEN-WPF-BLK', 1250000, 30, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Lenovo Performance FHD Webcam', 'LEN-WPF-WHT', 1250000, 14, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Lenovo Laptop Backpack 15.6" (2 SKU choices)
    (N'Lenovo Laptop Backpack 15.6"', 'LEN-BP15-BLK', 450000, 30, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Lenovo Laptop Backpack 15.6"', 'LEN-BP15-BLU', 450000, 14, N'Màu sắc', N'Xanh', NULL, NULL, NULL, NULL),

        -- Lenovo Legion Gaming Backpack (2 SKU choices)
    (N'Lenovo Legion Gaming Backpack', 'LEN-BPG17-BLK', 890000, 30, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Lenovo Legion Gaming Backpack', 'LEN-BPG17-GRY', 890000, 14, N'Màu sắc', N'Xám', NULL, NULL, NULL, NULL),

        -- Apple Watch SE 2 (4 SKU choices)
    (N'Apple Watch SE 2', 'WATCH-SE2-40', 5990000, 20, N'Kích thước vỏ', N'40mm', N'Màu sắc', N'Đen', NULL, NULL),
    (N'Apple Watch SE 2', 'WATCH-SE2-40-SLV', 5990000, 9, N'Kích thước vỏ', N'40mm', N'Màu sắc', N'Bạc', NULL, NULL),
    (N'Apple Watch SE 2', 'WATCH-SE2-44-BLK', 6490000, 13, N'Kích thước vỏ', N'44mm', N'Màu sắc', N'Đen', NULL, NULL),
    (N'Apple Watch SE 2', 'WATCH-SE2-44-SLV', 6490000, 8, N'Kích thước vỏ', N'44mm', N'Màu sắc', N'Bạc', NULL, NULL),

        -- Samsung Galaxy Watch7 (4 SKU choices)
    (N'Samsung Galaxy Watch7', 'WATCH-GW7-44', 6990000, 15, N'Kích thước vỏ', N'44mm', N'Màu sắc', N'Bạc', NULL, NULL),
    (N'Samsung Galaxy Watch7', 'WATCH-GW7-40-SLV', 6490000, 12, N'Kích thước vỏ', N'40mm', N'Màu sắc', N'Bạc', NULL, NULL),
    (N'Samsung Galaxy Watch7', 'WATCH-GW7-40-GRN', 6490000, 9, N'Kích thước vỏ', N'40mm', N'Màu sắc', N'Xanh', NULL, NULL),
    (N'Samsung Galaxy Watch7', 'WATCH-GW7-44-GRN', 6990000, 10, N'Kích thước vỏ', N'44mm', N'Màu sắc', N'Xanh', NULL, NULL),

        -- Garmin Forerunner 165 (2 SKU choices)
    (N'Garmin Forerunner 165', 'WATCH-GARMIN-165', 6490000, 12, N'Màu sắc', N'Đen', NULL, NULL, NULL, NULL),
    (N'Garmin Forerunner 165', 'WATCH-GARMIN-165-WHT', 6490000, 7, N'Màu sắc', N'Trắng', NULL, NULL, NULL, NULL),

        -- Canon EOS R50 (2 SKU choices)
    (N'Canon EOS R50', 'CAM-CANON-R50', 18990000, 8, N'Bộ sản phẩm', N'Thân máy', NULL, NULL, NULL, NULL),
    (N'Canon EOS R50', 'CAM-CANON-R50-KIT1845', 21990000, 5, N'Bộ sản phẩm', N'Kit RF-S 18-45mm', NULL, NULL, NULL, NULL),

        -- Sony Alpha A6400 (2 SKU choices)
    (N'Sony Alpha A6400', 'CAM-SONY-A6400', 16990000, 6, N'Bộ sản phẩm', N'Thân máy', NULL, NULL, NULL, NULL),
    (N'Sony Alpha A6400', 'CAM-SONY-A6400-KIT1650', 19990000, 4, N'Bộ sản phẩm', N'Kit E PZ 16-50mm', NULL, NULL, NULL, NULL),

        -- Fujifilm X-S20 (2 SKU choices)
    (N'Fujifilm X-S20', 'CAM-FUJI-XS20', 28990000, 5, N'Bộ sản phẩm', N'Thân máy', NULL, NULL, NULL, NULL),
    (N'Fujifilm X-S20', 'CAM-FUJI-XS20-KIT1545', 31990000, 4, N'Bộ sản phẩm', N'Kit XC 15-45mm', NULL, NULL, NULL, NULL);

    -- SECTION B: Preflight validation. Stop if any of the 39 names differ
    -- from the OECS dataset, if SKU codes belong to the wrong products,
    -- or if demo combinations are duplicated.
    IF (SELECT COUNT(DISTINCT product_name) FROM @Seed) <> 39
        THROW 55101, N'Du lieu seed khong du 39 san pham.', 1;

    IF EXISTS (
        SELECT 1 FROM @Seed AS v
        LEFT JOIN dbo.PRODUCT AS p ON p.product_name = v.product_name
        WHERE p.product_id IS NULL
    )
        THROW 55102, N'Co ten san pham seed khong ton tai trong dbo.PRODUCT. Xem danh sach 39 san pham.', 1;

    IF EXISTS (
        SELECT v.product_name
        FROM @Seed AS v JOIN dbo.PRODUCT p ON p.product_name = v.product_name
        GROUP BY v.product_name HAVING COUNT(DISTINCT p.product_id) > 1
    )
        THROW 55103, N'Ten san pham khong duy nhat. Khong the tu ghep SKU an toan.', 1;

    IF EXISTS (
        SELECT 1 FROM @Seed v
        JOIN dbo.PRODUCT_SKU s ON s.sku_code = v.sku_code
        JOIN dbo.PRODUCT p ON p.product_id = s.product_id
        WHERE p.product_name <> v.product_name
    )
        THROW 55104, N'Ma SKU da duoc dung boi san pham khac.', 1;

    IF EXISTS (SELECT 1 FROM @Seed WHERE price <= 0 OR initial_stock < 0)
        THROW 55105, N'Gia SKU phai duong va ton kho khong am.', 1;

    -- SECTION C: Create missing attribute definitions for variant options.
    INSERT INTO dbo.ATTRIBUTE (attribute_name)
    SELECT DISTINCT option_name FROM @Seed AS v
    CROSS APPLY (VALUES (v.attr1), (v.attr2), (v.attr3)) AS x(option_name)
    WHERE x.option_name IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM dbo.ATTRIBUTE a
          WHERE a.attribute_name = x.option_name
      );

    IF EXISTS (
        SELECT a.attribute_name
        FROM dbo.ATTRIBUTE AS a
        WHERE a.attribute_name IN (
            SELECT option_name FROM @Seed v
            CROSS APPLY (VALUES (v.attr1), (v.attr2), (v.attr3)) AS x(option_name)
            WHERE x.option_name IS NOT NULL
        )
        GROUP BY a.attribute_name HAVING COUNT(*) > 1
    )
        THROW 55106, N'Trung ten ATTRIBUTE trong database. Can xu ly thu cong.', 1;

    -- Build options with the SAME storage types used by existing data.
    -- For existing (SKU, attribute) rows, preserve the real stored values.
    -- For new SKUs, numeric options use numeric_value if the ATTRIBUTE is
    -- NUMBER or any older SKU uses a numeric representation for that attribute.
    -- TEXT values (color, configuration, packages) stay in text_value.
    DECLARE @Options TABLE (
        sku_code VARCHAR(100) NOT NULL,
        attribute_id INT NOT NULL,
        attribute_value NVARCHAR(255) NOT NULL,
        text_value NVARCHAR(255) NULL,
        numeric_value DECIMAL(18,4) NULL,
        boolean_value BIT NULL,
        PRIMARY KEY (sku_code, attribute_id)
    );

    INSERT INTO @Options (
        sku_code, attribute_id, attribute_value,
        text_value, numeric_value, boolean_value
    )
    SELECT
        v.sku_code, a.attribute_id, x.option_value,
        CASE
            WHEN oldval.sku_id IS NOT NULL THEN oldval.text_value
            WHEN numeric_mode.use_numeric = 1 THEN NULL
            ELSE x.option_value
        END,
        CASE
            WHEN oldval.sku_id IS NOT NULL THEN oldval.numeric_value
            WHEN numeric_mode.use_numeric = 1 THEN parsed.numeric_number
            ELSE NULL
        END,
        CASE
            WHEN oldval.sku_id IS NOT NULL THEN oldval.boolean_value
            ELSE NULL
        END
    FROM @Seed AS v
    CROSS APPLY (VALUES
        (v.attr1, v.val1),
        (v.attr2, v.val2),
        (v.attr3, v.val3)
    ) AS x(option_name, option_value)
    JOIN dbo.ATTRIBUTE AS a ON a.attribute_name = x.option_name
    LEFT JOIN dbo.PRODUCT_SKU AS oldsku
        ON oldsku.sku_code = v.sku_code
    LEFT JOIN dbo.SKU_ATTRIBUTE_VALUE AS oldval
        ON oldval.sku_id = oldsku.sku_id
       AND oldval.attribute_id = a.attribute_id
    CROSS APPLY (
        SELECT LTRIM(RTRIM(x.option_value)) AS cleaned
    ) AS cleaned
    CROSS APPLY (
        SELECT TRY_CONVERT(DECIMAL(18,4),
            LEFT(cleaned.cleaned,
                PATINDEX('%[^0-9.]%', cleaned.cleaned + N'X') - 1)
        ) AS leading_number
    ) AS leading
    CROSS APPLY (
        SELECT CAST(
          CASE
            WHEN a.attribute_name = N'Dung lượng lưu trữ'
             AND UPPER(cleaned.cleaned) LIKE N'%TB'
             AND UPPER(COALESCE(a.unit, N'GB')) <> N'TB'
            THEN leading.leading_number * 1024
            ELSE leading.leading_number
          END AS DECIMAL(18,4)
        ) AS numeric_number
    ) AS parsed
    CROSS APPLY (
        SELECT CASE
            WHEN parsed.numeric_number IS NOT NULL AND (
               a.data_type = 'NUMBER'
               OR EXISTS (
                   SELECT 1 FROM dbo.SKU_ATTRIBUTE_VALUE AS oldnumeric
                   WHERE oldnumeric.attribute_id = a.attribute_id
                     AND oldnumeric.numeric_value IS NOT NULL
               )
            ) THEN 1 ELSE 0
        END AS use_numeric
    ) AS numeric_mode
    WHERE x.option_name IS NOT NULL;

    -- All prepared options must result in precisely one stored value.
    IF EXISTS (
        SELECT 1 FROM @Options
        WHERE (CASE WHEN text_value IS NOT NULL THEN 1 ELSE 0 END)
            + (CASE WHEN numeric_value IS NOT NULL THEN 1 ELSE 0 END)
            + (CASE WHEN boolean_value IS NOT NULL THEN 1 ELSE 0 END) <> 1
    )
        THROW 55111, N'Khong the chuan hoa mot gia tri bien the.', 1;

    -- Every combination must have at least one meaningful option.
    IF EXISTS (
        SELECT 1 FROM @Seed v
        WHERE NOT EXISTS (SELECT 1 FROM @Options o WHERE o.sku_code=v.sku_code)
    )
        THROW 55107, N'Mot SKU khong co thuoc tinh bien the.', 1;

    -- CATEGORY_ATTRIBUTE: enable appropriate variant attributes for all
    -- relevant categories. Do not turn existing specification attrs off;
    -- promote SPECIFICATION -> BOTH when necessary.
    DECLARE @CategoryOptions TABLE (
        category_id INT NOT NULL,
        attribute_id INT NOT NULL,
        PRIMARY KEY (category_id, attribute_id)
    );

    INSERT INTO @CategoryOptions
    SELECT DISTINCT p.category_id, o.attribute_id
    FROM @Options AS o
    JOIN @Seed v ON v.sku_code = o.sku_code
    JOIN dbo.PRODUCT p ON p.product_name = v.product_name;

    UPDATE ca
    SET attribute_type = CASE WHEN ca.attribute_type='SPECIFICATION' THEN 'BOTH'
                              ELSE ca.attribute_type END,
        is_filterable = 1
    FROM dbo.CATEGORY_ATTRIBUTE ca
    JOIN @CategoryOptions x
        ON x.category_id=ca.category_id AND x.attribute_id=ca.attribute_id;

    INSERT INTO dbo.CATEGORY_ATTRIBUTE (
        category_id, attribute_id, group_name, attribute_type,
        is_required, is_filterable, display_order
    )
    SELECT x.category_id, x.attribute_id,
           CASE WHEN a.attribute_name IN (N'RAM',N'Dung lượng lưu trữ')
                THEN N'Cấu hình'
                WHEN a.attribute_name IN (N'Màu sắc') THEN N'Màu sắc'
                WHEN a.attribute_name IN (N'Kích thước vỏ') THEN N'Kích cỡ'
                ELSE N'Phiên bản' END,
           'VARIANT', 0, 1, 100 + a.attribute_id
    FROM @CategoryOptions x
    JOIN dbo.ATTRIBUTE a ON a.attribute_id=x.attribute_id
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.CATEGORY_ATTRIBUTE ca
        WHERE ca.category_id=x.category_id AND ca.attribute_id=x.attribute_id
    );

    -- SECTION D: Preserve existing SKU values; add only attributes not yet set.
    -- Numeric values such as 128.0000 remain numeric (not overwritten as TEXT).
    INSERT INTO dbo.SKU_ATTRIBUTE_VALUE (
        sku_id, attribute_id, text_value, numeric_value, boolean_value
    )
    SELECT s.sku_id, o.attribute_id,
           o.text_value, o.numeric_value, o.boolean_value
    FROM dbo.PRODUCT_SKU s
    JOIN @Options o ON o.sku_code=s.sku_code
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.SKU_ATTRIBUTE_VALUE sav
        WHERE sav.sku_id=s.sku_id AND sav.attribute_id=o.attribute_id
    );
    SET @AddedAttributeRows = @@ROWCOUNT;

    -- Refresh keys for known existing SKUs before considering insertion.
    DECLARE @CurrentSkuId INT;
    DECLARE sku_existing_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT s.sku_id FROM dbo.PRODUCT_SKU s
        JOIN @Seed v ON v.sku_code=s.sku_code;
    OPEN sku_existing_cursor;
    FETCH NEXT FROM sku_existing_cursor INTO @CurrentSkuId;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.usp_OECS_RefreshSkuVariantKey @sku_id=@CurrentSkuId;
        FETCH NEXT FROM sku_existing_cursor INTO @CurrentSkuId;
    END;
    CLOSE sku_existing_cursor;
    DEALLOCATE sku_existing_cursor;

    -- SECTION E: Compute exactly the SHA2_256 key used by OECS's stored
    -- procedure, to skip any variant already represented by an old SKU
    -- with a different code.
    DECLARE @Expected TABLE (
        sku_code VARCHAR(100) NOT NULL PRIMARY KEY,
        product_id INT NOT NULL,
        expected_key VARBINARY(32) NOT NULL
    );

    INSERT INTO @Expected (sku_code, product_id, expected_key)
    SELECT v.sku_code, p.product_id,
           HASHBYTES('SHA2_256', x.variant_text)
    FROM @Seed v
    JOIN dbo.PRODUCT p ON p.product_name=v.product_name
    CROSS APPLY (
        SELECT STRING_AGG(
            CAST(CONCAT(o.attribute_id, N'=',
                CASE
                    WHEN o.text_value IS NOT NULL
                      THEN N'T:' + UPPER(LTRIM(RTRIM(o.text_value)))
                    WHEN o.numeric_value IS NOT NULL
                      THEN N'N:' + CONVERT(NVARCHAR(60),o.numeric_value)
                    ELSE N'B:' + CONVERT(NVARCHAR(1),o.boolean_value)
                END
            ) AS NVARCHAR(MAX)), N'|')
            WITHIN GROUP (ORDER BY o.attribute_id) AS variant_text
        FROM @Options o
        WHERE o.sku_code=v.sku_code
    ) x;

    IF EXISTS (
        SELECT 1 FROM @Expected
        GROUP BY product_id, expected_key HAVING COUNT(*) > 1
    )
        THROW 55109, N'Bo seed co hai SKU cung to hop bien the.', 1;

    DECLARE @SkippedVariants TABLE (
        proposed_code VARCHAR(100) NOT NULL,
        existing_code VARCHAR(100) NOT NULL,
        product_id INT NOT NULL
    );

    INSERT INTO @SkippedVariants (proposed_code, existing_code, product_id)
    SELECT e.sku_code, existing_sku.sku_code, e.product_id
    FROM @Expected e
    JOIN dbo.PRODUCT_SKU existing_sku
      ON existing_sku.product_id=e.product_id
     AND existing_sku.variant_key=e.expected_key
     AND existing_sku.sku_code<>e.sku_code
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.PRODUCT_SKU s WHERE s.sku_code=e.sku_code
    );

    -- New SKU rows only. Existing price and stock are NEVER modified.
    INSERT INTO dbo.PRODUCT_SKU (
        product_id, sku_code, price, stock_quantity, original_price, is_active
    )
    SELECT e.product_id, v.sku_code, v.price, v.initial_stock, NULL, 1
    FROM @Seed v
    JOIN @Expected e ON e.sku_code=v.sku_code
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.PRODUCT_SKU s WHERE s.sku_code=v.sku_code
    )
      AND NOT EXISTS (
        SELECT 1 FROM @SkippedVariants x WHERE x.proposed_code=v.sku_code
    );
    SET @Inserted = @@ROWCOUNT;

    -- Add attributes to newly inserted SKUs. Old values are left intact.
    INSERT INTO dbo.SKU_ATTRIBUTE_VALUE (
        sku_id, attribute_id, text_value, numeric_value, boolean_value
    )
    SELECT s.sku_id, o.attribute_id,
           o.text_value, o.numeric_value, o.boolean_value
    FROM dbo.PRODUCT_SKU s
    JOIN @Options o ON o.sku_code=s.sku_code
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.SKU_ATTRIBUTE_VALUE sav
        WHERE sav.sku_id=s.sku_id AND sav.attribute_id=o.attribute_id
    );

    -- Refresh calculated variant_key on inserted/new matched SKUs.
    DECLARE sku_new_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT s.sku_id FROM dbo.PRODUCT_SKU s
        JOIN @Seed v ON v.sku_code=s.sku_code;
    OPEN sku_new_cursor;
    FETCH NEXT FROM sku_new_cursor INTO @CurrentSkuId;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.usp_OECS_RefreshSkuVariantKey @sku_id=@CurrentSkuId;
        FETCH NEXT FROM sku_new_cursor INTO @CurrentSkuId;
    END;
    CLOSE sku_new_cursor;
    DEALLOCATE sku_new_cursor;

    -- Safety: all 39 listed products must have at least two sellable SKUs,
    -- and each active variant must have a unique key if one was assigned.
    IF EXISTS (
        SELECT 1 FROM (SELECT DISTINCT product_name FROM @Seed) v
        JOIN dbo.PRODUCT p ON p.product_name=v.product_name
        OUTER APPLY (
            SELECT COUNT(*) AS variants FROM dbo.PRODUCT_SKU s
            WHERE s.product_id=p.product_id AND s.is_active=1
        ) x
        WHERE x.variants < 2
    )
        THROW 55110, N'Mot trong 39 san pham co duoi 2 SKU dang kinh doanh.', 1;

    COMMIT TRANSACTION;

    -- SECTION F: Read-only results after successful commit.
    SELECT
        (SELECT COUNT(*) FROM dbo.CATEGORY) AS total_categories,
        (SELECT COUNT(*) FROM dbo.PRODUCT) AS total_products,
        @SkuBefore AS total_skus_before,
        (SELECT COUNT(*) FROM dbo.PRODUCT_SKU) AS total_skus_after,
        @Inserted AS new_skus_inserted,
        @AddedAttributeRows AS legacy_sku_attributes_added,
        (SELECT COUNT(*) FROM @SkippedVariants) AS skipped_duplicate_variants;

    SELECT p.product_id, p.product_name,
           COUNT(s.sku_id) AS sku_count,
           SUM(CASE WHEN s.is_active=1 THEN 1 ELSE 0 END) AS active_sku_count,
           SUM(COALESCE(s.stock_quantity,0)) AS stock_total
    FROM dbo.PRODUCT p
    JOIN (SELECT DISTINCT product_name FROM @Seed) v ON v.product_name=p.product_name
    LEFT JOIN dbo.PRODUCT_SKU s ON s.product_id=p.product_id
    GROUP BY p.product_id,p.product_name
    ORDER BY p.product_id;

    -- Detail-level report for Product Detail option rendering / SQL verification.
    SELECT p.product_name, s.sku_code,
           s.price, s.stock_quantity, s.is_active,
           x.variant_description
    FROM dbo.PRODUCT_SKU s
    JOIN dbo.PRODUCT p ON p.product_id=s.product_id
    JOIN (SELECT DISTINCT product_name FROM @Seed) v
      ON v.product_name=p.product_name
    OUTER APPLY (
        SELECT STRING_AGG(
            CAST(CONCAT(a.attribute_name, N': ',
                COALESCE(sav.text_value,
                    CONVERT(NVARCHAR(80),sav.numeric_value),
                    CASE sav.boolean_value WHEN 1 THEN N'Có' WHEN 0 THEN N'Không' END)
            ) AS NVARCHAR(MAX)), N' | ')
            WITHIN GROUP (ORDER BY a.attribute_id) AS variant_description
        FROM dbo.SKU_ATTRIBUTE_VALUE sav
        JOIN dbo.ATTRIBUTE a ON a.attribute_id=sav.attribute_id
        WHERE sav.sku_id=s.sku_id
    ) x
    ORDER BY p.product_name, s.price, s.sku_code;

    -- Any planned demo variant that was already represented by another SKU code:
    SELECT * FROM @SkippedVariants ORDER BY product_id, proposed_code;

    PRINT N'OECS SKU migration FIXED completed; demo variants available for all 39 products.';
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('local','sku_existing_cursor') >= 0 CLOSE sku_existing_cursor;
    IF CURSOR_STATUS('local','sku_existing_cursor') >= -1 DEALLOCATE sku_existing_cursor;
    IF CURSOR_STATUS('local','sku_new_cursor') >= 0 CLOSE sku_new_cursor;
    IF CURSOR_STATUS('local','sku_new_cursor') >= -1 DEALLOCATE sku_new_cursor;
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
