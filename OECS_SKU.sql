
/*
===========================================================
 OECS V2 - FINAL PRODUCT CATALOG MIGRATION
 SQL SERVER 2022

 CHAY DUOC NHIEU LAN - KHONG DROP DATABASE
 KHONG XOA PRODUCT, SKU, CART, ORDER

 9 BANG PRODUCT CATALOG + INVENTORY_MOVEMENT:
 1. CATEGORY
 2. BRAND
 3. PRODUCT
 4. ATTRIBUTE
 5. CATEGORY_ATTRIBUTE
 6. PRODUCT_SPECIFICATION
 7. PRODUCT_SKU
 8. SKU_ATTRIBUTE_VALUE
 9. PRODUCT_IMAGES
 10. INVENTORY_MOVEMENT (LICH SU TON KHO)

 LUON CHAY TREN BAN SAO LUU TRUOC.
===========================================================
*/

USE OECS;
GO

SET XACT_ABORT ON;
GO

/* =========================================================
   PHAN 1 - THEM COT CON THIEU
   MOI LENH ALTER DUOC TACH BATCH DE TRANH MSG 207
========================================================= */

/* 1. CATEGORY */

IF COL_LENGTH('dbo.CATEGORY', 'description') IS NULL
BEGIN
    ALTER TABLE dbo.CATEGORY
    ADD description NVARCHAR(500) NULL;
END;
GO

IF COL_LENGTH('dbo.CATEGORY', 'is_active') IS NULL
BEGIN
    ALTER TABLE dbo.CATEGORY
    ADD is_active BIT NOT NULL
        CONSTRAINT DF_CATEGORY_IsActive DEFAULT (1);
END;
GO


/* 2. BRAND */

IF COL_LENGTH('dbo.BRAND', 'is_active') IS NULL
BEGIN
    ALTER TABLE dbo.BRAND
    ADD is_active BIT NOT NULL
        CONSTRAINT DF_BRAND_IsActive DEFAULT (1);
END;
GO


/* 3. PRODUCT */

IF COL_LENGTH('dbo.PRODUCT', 'model_code') IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT
    ADD model_code VARCHAR(100) NULL;
END;
GO

IF COL_LENGTH('dbo.PRODUCT', 'is_active') IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT
    ADD is_active BIT NOT NULL
        CONSTRAINT DF_PRODUCT_IsActive DEFAULT (1);
END;
GO

IF COL_LENGTH('dbo.PRODUCT', 'updated_at') IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT
    ADD updated_at DATETIME2 NULL;
END;
GO


/* 4. ATTRIBUTE */

IF COL_LENGTH('dbo.ATTRIBUTE', 'data_type') IS NULL
BEGIN
    ALTER TABLE dbo.ATTRIBUTE
    ADD data_type VARCHAR(20) NOT NULL
        CONSTRAINT DF_ATTRIBUTE_DataType DEFAULT ('TEXT');
END;
GO

IF COL_LENGTH('dbo.ATTRIBUTE', 'unit') IS NULL
BEGIN
    ALTER TABLE dbo.ATTRIBUTE
    ADD unit NVARCHAR(30) NULL;
END;
GO

IF COL_LENGTH('dbo.ATTRIBUTE', 'is_active') IS NULL
BEGIN
    ALTER TABLE dbo.ATTRIBUTE
    ADD is_active BIT NOT NULL
        CONSTRAINT DF_ATTRIBUTE_IsActive DEFAULT (1);
END;
GO


/* 5. PRODUCT_SPECIFICATION */

IF COL_LENGTH(
    'dbo.PRODUCT_SPECIFICATION', 'numeric_value'
) IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT_SPECIFICATION
    ADD numeric_value DECIMAL(18,4) NULL;
END;
GO

IF COL_LENGTH(
    'dbo.PRODUCT_SPECIFICATION', 'boolean_value'
) IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT_SPECIFICATION
    ADD boolean_value BIT NULL;
END;
GO


/* 6. PRODUCT_SKU */

IF COL_LENGTH('dbo.PRODUCT_SKU', 'original_price') IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT_SKU
    ADD original_price DECIMAL(18,2) NULL;
END;
GO

IF COL_LENGTH('dbo.PRODUCT_SKU', 'is_active') IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT_SKU
    ADD is_active BIT NOT NULL
        CONSTRAINT DF_SKU_IsActive DEFAULT (1);
END;
GO

IF COL_LENGTH('dbo.PRODUCT_SKU', 'variant_key') IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT_SKU
    ADD variant_key VARBINARY(32) NULL;
END;
GO


/* 7. PRODUCT_IMAGES */

IF COL_LENGTH('dbo.PRODUCT_IMAGES', 'sku_id') IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT_IMAGES
    ADD sku_id INT NULL;
END;
GO

IF COL_LENGTH('dbo.PRODUCT_IMAGES', 'is_primary') IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT_IMAGES
    ADD is_primary BIT NOT NULL
        CONSTRAINT DF_PI_Primary DEFAULT (0);
END;
GO

IF COL_LENGTH('dbo.PRODUCT_IMAGES', 'display_order') IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT_IMAGES
    ADD display_order INT NOT NULL
        CONSTRAINT DF_PI_Order DEFAULT (0);
END;
GO

IF COL_LENGTH('dbo.PRODUCT_IMAGES', 'alt_text') IS NULL
BEGIN
    ALTER TABLE dbo.PRODUCT_IMAGES
    ADD alt_text NVARCHAR(255) NULL;
END;
GO


/* =========================================================
   PHAN 2 - TAO 2 BANG MOI
========================================================= */

/* CATEGORY_ATTRIBUTE */

IF OBJECT_ID('dbo.CATEGORY_ATTRIBUTE', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CATEGORY_ATTRIBUTE (
        category_id INT NOT NULL,
        attribute_id INT NOT NULL,

        group_name NVARCHAR(100) NOT NULL
            CONSTRAINT DF_CA_Group
            DEFAULT (N'Thông số khác'),

        attribute_type VARCHAR(20) NOT NULL
            CONSTRAINT DF_CA_Type
            DEFAULT ('SPECIFICATION'),

        is_required BIT NOT NULL
            CONSTRAINT DF_CA_Required DEFAULT (0),

        is_filterable BIT NOT NULL
            CONSTRAINT DF_CA_Filterable DEFAULT (0),

        display_order INT NOT NULL
            CONSTRAINT DF_CA_Order DEFAULT (0),

        CONSTRAINT PK_CATEGORY_ATTRIBUTE
            PRIMARY KEY (category_id, attribute_id),

        CONSTRAINT FK_CA_Category
            FOREIGN KEY (category_id)
            REFERENCES dbo.CATEGORY(category_id),

        CONSTRAINT FK_CA_Attribute
            FOREIGN KEY (attribute_id)
            REFERENCES dbo.ATTRIBUTE(attribute_id),

        CONSTRAINT CK_CA_Type
            CHECK (
                attribute_type IN (
                    'SPECIFICATION',
                    'VARIANT',
                    'BOTH'
                )
            ),

        CONSTRAINT CK_CA_Order
            CHECK (display_order >= 0)
    );
END;
GO


/* SKU_ATTRIBUTE_VALUE */

IF OBJECT_ID('dbo.SKU_ATTRIBUTE_VALUE', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SKU_ATTRIBUTE_VALUE (
        sku_id INT NOT NULL,
        attribute_id INT NOT NULL,

        text_value NVARCHAR(255) NULL,
        numeric_value DECIMAL(18,4) NULL,
        boolean_value BIT NULL,

        CONSTRAINT PK_SKU_ATTRIBUTE_VALUE
            PRIMARY KEY (sku_id, attribute_id),

        CONSTRAINT FK_SAV_SKU
            FOREIGN KEY (sku_id)
            REFERENCES dbo.PRODUCT_SKU(sku_id)
            ON DELETE CASCADE,

        CONSTRAINT FK_SAV_Attribute
            FOREIGN KEY (attribute_id)
            REFERENCES dbo.ATTRIBUTE(attribute_id),

        CONSTRAINT CK_SAV_OneValue
            CHECK (
                (CASE WHEN text_value IS NOT NULL
                    THEN 1 ELSE 0 END)
              + (CASE WHEN numeric_value IS NOT NULL
                    THEN 1 ELSE 0 END)
              + (CASE WHEN boolean_value IS NOT NULL
                    THEN 1 ELSE 0 END)
                = 1
            ),

        CONSTRAINT CK_SAV_NonEmpty
            CHECK (
                text_value IS NULL
                OR LEN(LTRIM(RTRIM(text_value))) > 0
            )
    );
END;
GO


/* =========================================================
   PHAN 3 - THEM RANG BUOC
========================================================= */

/* ATTRIBUTE */

IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_ATTRIBUTE_DataType'
      AND parent_object_id = OBJECT_ID('dbo.ATTRIBUTE')
)
BEGIN
    ALTER TABLE dbo.ATTRIBUTE
    ADD CONSTRAINT CK_ATTRIBUTE_DataType
    CHECK (data_type IN ('TEXT', 'NUMBER', 'BOOLEAN'));
END;
GO


/* CATEGORY_ATTRIBUTE: NANG CAP NEU BANG DA CO */

IF OBJECT_ID('dbo.CATEGORY_ATTRIBUTE', 'U') IS NOT NULL
AND COL_LENGTH(
    'dbo.CATEGORY_ATTRIBUTE', 'display_order'
) IS NULL
BEGIN
    ALTER TABLE dbo.CATEGORY_ATTRIBUTE
    ADD display_order INT NOT NULL
        CONSTRAINT DF_CA_DisplayOrderV2 DEFAULT (0);
END;
GO


/* PRODUCT_SKU */

IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_SKU_Price'
      AND parent_object_id = OBJECT_ID('dbo.PRODUCT_SKU')
)
BEGIN
    ALTER TABLE dbo.PRODUCT_SKU
    ADD CONSTRAINT CK_SKU_Price
    CHECK (price >= 0);
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_SKU_OriginalPrice'
      AND parent_object_id = OBJECT_ID('dbo.PRODUCT_SKU')
)
BEGIN
    ALTER TABLE dbo.PRODUCT_SKU
    ADD CONSTRAINT CK_SKU_OriginalPrice
    CHECK (
        original_price IS NULL
        OR original_price >= 0
    );
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_SKU_Stock'
      AND parent_object_id = OBJECT_ID('dbo.PRODUCT_SKU')
)
BEGIN
    ALTER TABLE dbo.PRODUCT_SKU
    ADD CONSTRAINT CK_SKU_Stock
    CHECK (
        stock_quantity IS NULL
        OR stock_quantity >= 0
    );
END;
GO


/* SKU_ATTRIBUTE_VALUE */

IF COL_LENGTH(
    'dbo.SKU_ATTRIBUTE_VALUE', 'boolean_value'
) IS NULL
BEGIN
    ALTER TABLE dbo.SKU_ATTRIBUTE_VALUE
    ADD boolean_value BIT NULL;
END;
GO

IF COL_LENGTH(
    'dbo.SKU_ATTRIBUTE_VALUE', 'numeric_value'
) IS NULL
BEGIN
    ALTER TABLE dbo.SKU_ATTRIBUTE_VALUE
    ADD numeric_value DECIMAL(18,4) NULL;
END;
GO

IF COL_LENGTH(
    'dbo.SKU_ATTRIBUTE_VALUE', 'text_value'
) IS NULL
BEGIN
    ALTER TABLE dbo.SKU_ATTRIBUTE_VALUE
    ADD text_value NVARCHAR(255) NULL;
END;
GO


/* PRODUCT_IMAGES: FK KEP SKU + PRODUCT */

IF NOT EXISTS (
    SELECT 1 FROM sys.key_constraints
    WHERE name = 'UQ_SKU_IdProduct'
      AND parent_object_id = OBJECT_ID('dbo.PRODUCT_SKU')
)
BEGIN
    ALTER TABLE dbo.PRODUCT_SKU
    ADD CONSTRAINT UQ_SKU_IdProduct
    UNIQUE (sku_id, product_id);
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = 'FK_PI_SKU_Product'
      AND parent_object_id = OBJECT_ID('dbo.PRODUCT_IMAGES')
)
BEGIN
    ALTER TABLE dbo.PRODUCT_IMAGES
    ADD CONSTRAINT FK_PI_SKU_Product
    FOREIGN KEY (sku_id, product_id)
    REFERENCES dbo.PRODUCT_SKU(sku_id, product_id);
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_PI_DisplayOrder'
      AND parent_object_id = OBJECT_ID('dbo.PRODUCT_IMAGES')
)
BEGIN
    ALTER TABLE dbo.PRODUCT_IMAGES
    ADD CONSTRAINT CK_PI_DisplayOrder
    CHECK (display_order >= 0);
END;
GO


/* =========================================================
   PHAN 4 - BO SUNG THUOC TINH CONG NGHE
   KHONG INSERT TRUNG
========================================================= */

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.ATTRIBUTE (attribute_name)
    SELECT v.attribute_name
    FROM (VALUES
        (N'Camera'),
        (N'Tần số quét'),
        (N'Loại màn hình'),
        (N'Công suất sạc'),
        (N'Chống nước'),
        (N'Chống ồn'),
        (N'Dung lượng pin'),
        (N'Chất liệu'),
        (N'Kích thước mặt đồng hồ'),
        (N'Cảm biến máy ảnh')
    ) v(attribute_name)
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.ATTRIBUTE a
        WHERE a.attribute_name = v.attribute_name
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO


/* =========================================================
   PHAN 5 - CAU HINH THONG SO THEO DANH MUC
========================================================= */

BEGIN TRY
    BEGIN TRANSACTION;

    /*
       Lay du lieu PRODUCT_SPECIFICATION hien co
       de cau hinh CATEGORY_ATTRIBUTE.

       Moi danh muc co bo thuoc tinh rieng.
    */

    INSERT INTO dbo.CATEGORY_ATTRIBUTE (
        category_id,
        attribute_id,
        group_name,
        attribute_type,
        is_required,
        is_filterable,
        display_order
    )
    SELECT DISTINCT
        p.category_id,
        ps.attribute_id,

        CASE
            WHEN a.attribute_name IN (
                N'Màn hình',
                N'Độ phân giải',
                N'Tần số quét',
                N'Loại màn hình'
            ) THEN N'Màn hình'

            WHEN a.attribute_name IN (
                N'RAM',
                N'Dung lượng lưu trữ',
                N'Chip xử lý (CPU)',
                N'Card đồ họa (GPU)'
            ) THEN N'Hiệu năng và bộ nhớ'

            WHEN a.attribute_name IN (
                N'Pin',
                N'Dung lượng pin',
                N'Công suất sạc'
            ) THEN N'Pin và sạc'

            WHEN a.attribute_name IN (
                N'Kết nối',
                N'Loại kết nối'
            ) THEN N'Kết nối'

            WHEN a.attribute_name IN (
                N'Kích thước',
                N'Trọng lượng',
                N'Chất liệu',
                N'Màu sắc'
            ) THEN N'Thiết kế'

            ELSE N'Tính năng và thông số khác'
        END,

        CASE
            WHEN a.attribute_name = N'RAM'
             AND c.category_name IN (
                N'Laptop Văn Phòng',
                N'Laptop Gaming'
             )
            THEN 'BOTH'
            ELSE 'SPECIFICATION'
        END,

        0,

        CASE
            WHEN a.attribute_name IN (
                N'RAM',
                N'Dung lượng lưu trữ',
                N'Chip xử lý (CPU)',
                N'Màn hình',
                N'Card đồ họa (GPU)'
            ) THEN 1
            ELSE 0
        END,

        a.attribute_id

    FROM dbo.PRODUCT_SPECIFICATION ps
    JOIN dbo.PRODUCT p
        ON p.product_id = ps.product_id
    JOIN dbo.CATEGORY c
        ON c.category_id = p.category_id
    JOIN dbo.ATTRIBUTE a
        ON a.attribute_id = ps.attribute_id

    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.CATEGORY_ATTRIBUTE ca
        WHERE ca.category_id = p.category_id
          AND ca.attribute_id = ps.attribute_id
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO


/* =========================================================
   PHAN 6 - CAU HINH BIEN THE SKU THEO DANH MUC
========================================================= */

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @VariantConfig TABLE (
        category_name NVARCHAR(100),
        attribute_name NVARCHAR(100),
        group_name NVARCHAR(100),
        attribute_type VARCHAR(20),
        display_order INT
    );

    INSERT INTO @VariantConfig VALUES
        (N'Smartphone',
         N'Dung lượng lưu trữ',
         N'Phiên bản', 'VARIANT', 10),

        (N'Smartphone',
         N'Màu sắc',
         N'Phiên bản', 'VARIANT', 20),

        (N'Laptop Văn Phòng',
         N'RAM',
         N'Cấu hình', 'BOTH', 10),

        (N'Laptop Văn Phòng',
         N'Dung lượng lưu trữ',
         N'Cấu hình', 'VARIANT', 20),

        (N'Laptop Văn Phòng',
         N'Màu sắc',
         N'Cấu hình', 'VARIANT', 30),

        (N'Laptop Gaming',
         N'RAM',
         N'Cấu hình', 'BOTH', 10),

        (N'Laptop Gaming',
         N'Dung lượng lưu trữ',
         N'Cấu hình', 'VARIANT', 20),

        (N'Laptop Gaming',
         N'Màu sắc',
         N'Cấu hình', 'VARIANT', 30),

        (N'Tai nghe',
         N'Màu sắc',
         N'Phiên bản', 'VARIANT', 10),

        (N'Chuột',
         N'Màu sắc',
         N'Phiên bản', 'VARIANT', 10),

        (N'Bàn phím',
         N'Màu sắc',
         N'Phiên bản', 'VARIANT', 10),

        (N'Webcam',
         N'Màu sắc',
         N'Phiên bản', 'VARIANT', 10),

        (N'Balo Laptop',
         N'Màu sắc',
         N'Phiên bản', 'VARIANT', 10);


    /* Update cấu hình cũ */

    UPDATE ca
    SET
        ca.group_name = v.group_name,
        ca.attribute_type = v.attribute_type,
        ca.is_filterable = 1,
        ca.display_order = v.display_order
    FROM dbo.CATEGORY_ATTRIBUTE ca
    JOIN dbo.CATEGORY c
        ON c.category_id = ca.category_id
    JOIN dbo.ATTRIBUTE a
        ON a.attribute_id = ca.attribute_id
    JOIN @VariantConfig v
        ON v.category_name = c.category_name
       AND v.attribute_name = a.attribute_name;


    /* Insert cấu hình chưa có */

    INSERT INTO dbo.CATEGORY_ATTRIBUTE (
        category_id,
        attribute_id,
        group_name,
        attribute_type,
        is_required,
        is_filterable,
        display_order
    )
    SELECT
        c.category_id,
        a.attribute_id,
        v.group_name,
        v.attribute_type,
        0,
        1,
        v.display_order
    FROM @VariantConfig v
    JOIN dbo.CATEGORY c
        ON c.category_name = v.category_name
    JOIN dbo.ATTRIBUTE a
        ON a.attribute_name = v.attribute_name
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.CATEGORY_ATTRIBUTE ca
        WHERE ca.category_id = c.category_id
          AND ca.attribute_id = a.attribute_id
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO


/* =========================================================
   PHAN 7 - CHUYEN DU LIEU DIEN THOAI SANG SKU ATTRIBUTE
========================================================= */

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @PhoneVariants TABLE (
        sku_code VARCHAR(100),
        attribute_name NVARCHAR(100),
        attribute_value NVARCHAR(255)
    );

    /*
       Gia tri lay tu quy uoc SKU trong SQL mau.
       Can kiem tra lai mau thuc te neu su dung that.
    */

    INSERT INTO @PhoneVariants VALUES
        ('IP15P-128-BLK', N'Dung lượng lưu trữ', N'128GB'),
        ('IP15P-128-BLK', N'Màu sắc', N'Đen'),

        ('IP15P-256-SLV', N'Dung lượng lưu trữ', N'256GB'),
        ('IP15P-256-SLV', N'Màu sắc', N'Bạc'),

        ('SS-S24U-256-GRY', N'Dung lượng lưu trữ', N'256GB'),
        ('SS-S24U-256-GRY', N'Màu sắc', N'Xám'),

        ('IP15PM-256-NAT', N'Dung lượng lưu trữ', N'256GB'),
        ('IP15PM-256-NAT', N'Màu sắc', N'Titan tự nhiên'),

        ('IP16P-128-BLK', N'Dung lượng lưu trữ', N'128GB'),
        ('IP16P-128-BLK', N'Màu sắc', N'Đen'),

        ('IP16PM-256-DES', N'Dung lượng lưu trữ', N'256GB'),
        ('IP16PM-256-DES', N'Màu sắc', N'Titan sa mạc'),

        ('SS-S24P-256-BLK', N'Dung lượng lưu trữ', N'256GB'),
        ('SS-S24P-256-BLK', N'Màu sắc', N'Đen'),

        ('SS-A55-128-BLU', N'Dung lượng lưu trữ', N'128GB'),
        ('SS-A55-128-BLU', N'Màu sắc', N'Xanh'),

        ('SS-A35-128-YLW', N'Dung lượng lưu trữ', N'128GB'),
        ('SS-A35-128-YLW', N'Màu sắc', N'Vàng');


    INSERT INTO dbo.SKU_ATTRIBUTE_VALUE (
        sku_id, attribute_id, text_value
    )
    SELECT
        s.sku_id,
        a.attribute_id,
        v.attribute_value
    FROM @PhoneVariants v
    JOIN dbo.PRODUCT_SKU s
        ON s.sku_code = v.sku_code
    JOIN dbo.ATTRIBUTE a
        ON a.attribute_name = v.attribute_name
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.SKU_ATTRIBUTE_VALUE sav
        WHERE sav.sku_id = s.sku_id
          AND sav.attribute_id = a.attribute_id
    );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO


/* =========================================================
   PHAN 8 - CHUYEN RAM LAPTOP SANG SKU ATTRIBUTE
========================================================= */

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.SKU_ATTRIBUTE_VALUE (
        sku_id,
        attribute_id,
        text_value
    )
    SELECT
        s.sku_id,
        ps.attribute_id,
        ps.value
    FROM dbo.PRODUCT_SKU s
    JOIN dbo.PRODUCT p
        ON p.product_id = s.product_id
    JOIN dbo.CATEGORY c
        ON c.category_id = p.category_id
    JOIN dbo.PRODUCT_SPECIFICATION ps
        ON ps.product_id = p.product_id
    JOIN dbo.ATTRIBUTE a
        ON a.attribute_id = ps.attribute_id
    WHERE c.category_name IN (
        N'Laptop Văn Phòng',
        N'Laptop Gaming'
    )
      AND a.attribute_name = N'RAM'
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.SKU_ATTRIBUTE_VALUE sav
          WHERE sav.sku_id = s.sku_id
            AND sav.attribute_id = ps.attribute_id
      );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO


/* =========================================================
   PHAN 9 - SSD LENOVO LOQ
========================================================= */

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.SKU_ATTRIBUTE_VALUE (
        sku_id,
        attribute_id,
        text_value
    )
    SELECT
        s.sku_id,
        a.attribute_id,
        N'512GB'
    FROM dbo.PRODUCT_SKU s
    JOIN dbo.ATTRIBUTE a
        ON a.attribute_name = N'Dung lượng lưu trữ'
    WHERE s.sku_code = 'LOQ-15-16GB-512GB'
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.SKU_ATTRIBUTE_VALUE sav
          WHERE sav.sku_id = s.sku_id
            AND sav.attribute_id = a.attribute_id
      );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO


/* =========================================================
   PHAN 10 - CHUYEN ANH DAI DIEN CU
========================================================= */

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.PRODUCT_IMAGES (
        product_id,
        sku_id,
        image_url,
        is_primary,
        display_order,
        alt_text
    )
    SELECT
        p.product_id,
        NULL,
        p.image_url,
        0,
        0,
        p.product_name
    FROM dbo.PRODUCT p
    WHERE p.image_url IS NOT NULL
      AND LEN(LTRIM(RTRIM(p.image_url))) > 0
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.PRODUCT_IMAGES pi
          WHERE pi.product_id = p.product_id
            AND pi.sku_id IS NULL
            AND pi.image_url = p.image_url
      );

    /*
       Moi product toi da 1 anh chinh chung.
       Moi SKU toi da 1 anh chinh rieng.
    */

    ;WITH RankedImages AS (
        SELECT
            image_id,
            is_primary,
            ROW_NUMBER() OVER (
                PARTITION BY product_id, sku_id
                ORDER BY
                    is_primary DESC,
                    display_order ASC,
                    image_id ASC
            ) AS rn
        FROM dbo.PRODUCT_IMAGES
    )
    UPDATE RankedImages
    SET is_primary =
        CASE WHEN rn = 1 THEN 1 ELSE 0 END;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO


/* =========================================================
   PHAN 11 - INDEX
========================================================= */

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.PRODUCT')
      AND name = 'IX_PRODUCT_CategoryBrand'
)
BEGIN
    CREATE INDEX IX_PRODUCT_CategoryBrand
    ON dbo.PRODUCT (
        category_id,
        brand_id,
        is_active
    );
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.PRODUCT_SKU')
      AND name = 'IX_SKU_ProductActive'
)
BEGIN
    CREATE INDEX IX_SKU_ProductActive
    ON dbo.PRODUCT_SKU (
        product_id,
        is_active
    )
    INCLUDE (price, stock_quantity);
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.CATEGORY_ATTRIBUTE')
      AND name = 'IX_CA_Display'
)
BEGIN
    CREATE INDEX IX_CA_Display
    ON dbo.CATEGORY_ATTRIBUTE (
        category_id,
        group_name,
        display_order
    );
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.SKU_ATTRIBUTE_VALUE')
      AND name = 'IX_SAV_Attribute'
)
BEGIN
    CREATE INDEX IX_SAV_Attribute
    ON dbo.SKU_ATTRIBUTE_VALUE (
        attribute_id,
        text_value
    )
    INCLUDE (sku_id);
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.PRODUCT_IMAGES')
      AND name = 'IX_PI_ProductSku'
)
BEGIN
    CREATE INDEX IX_PI_ProductSku
    ON dbo.PRODUCT_IMAGES (
        product_id,
        sku_id,
        display_order
    );
END;
GO


/* 1 anh chinh chung cho moi product */

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.PRODUCT_IMAGES')
      AND name = 'UX_PI_PrimaryProduct'
)
BEGIN
    CREATE UNIQUE INDEX UX_PI_PrimaryProduct
    ON dbo.PRODUCT_IMAGES(product_id)
    WHERE sku_id IS NULL
      AND is_primary = 1;
END;
GO


/* 1 anh chinh rieng cho moi SKU */

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.PRODUCT_IMAGES')
      AND name = 'UX_PI_PrimarySKU'
)
BEGIN
    CREATE UNIQUE INDEX UX_PI_PrimarySKU
    ON dbo.PRODUCT_IMAGES(sku_id)
    WHERE sku_id IS NOT NULL
      AND is_primary = 1;
END;
GO


/* =========================================================
   PHAN 12 - PROCEDURE TAO VARIANT KEY
========================================================= */

CREATE OR ALTER PROCEDURE dbo.usp_OECS_RefreshSkuVariantKey
    @sku_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @product_id INT;
    DECLARE @category_id INT;
    DECLARE @variant_text NVARCHAR(MAX);

    SELECT
        @product_id = s.product_id,
        @category_id = p.category_id
    FROM dbo.PRODUCT_SKU s
    JOIN dbo.PRODUCT p
        ON p.product_id = s.product_id
    WHERE s.sku_id = @sku_id;

    IF @product_id IS NULL
    BEGIN
        THROW 51001, 'SKU does not exist.', 1;
    END;


    /* Kiem tra attribute hop le */

    IF EXISTS (
        SELECT 1
        FROM dbo.SKU_ATTRIBUTE_VALUE sav
        LEFT JOIN dbo.CATEGORY_ATTRIBUTE ca
            ON ca.category_id = @category_id
           AND ca.attribute_id = sav.attribute_id
        WHERE sav.sku_id = @sku_id
          AND (
              ca.attribute_id IS NULL
              OR ca.attribute_type NOT IN (
                  'VARIANT', 'BOTH'
              )
          )
    )
    BEGIN
        THROW 51002,
            'SKU attribute must be VARIANT or BOTH.',
            1;
    END;


    /* Kiem tra attribute bat buoc */

    IF EXISTS (
        SELECT 1
        FROM dbo.CATEGORY_ATTRIBUTE ca
        WHERE ca.category_id = @category_id
          AND ca.attribute_type IN ('VARIANT', 'BOTH')
          AND ca.is_required = 1
          AND NOT EXISTS (
              SELECT 1
              FROM dbo.SKU_ATTRIBUTE_VALUE sav
              WHERE sav.sku_id = @sku_id
                AND sav.attribute_id = ca.attribute_id
          )
    )
    BEGIN
        THROW 51004,
            'Required SKU attribute is missing.',
            1;
    END;


    /* Chuan hoa thuoc tinh theo attribute_id */

    SELECT
        @variant_text = STRING_AGG(
            CAST(
                CONCAT(
                    sav.attribute_id,
                    N'=',
                    CASE
                        WHEN sav.text_value IS NOT NULL
                        THEN N'T:' +
                            UPPER(
                                LTRIM(RTRIM(sav.text_value))
                            )

                        WHEN sav.numeric_value IS NOT NULL
                        THEN N'N:' +
                            CONVERT(
                                NVARCHAR(60),
                                sav.numeric_value
                            )

                        ELSE N'B:' +
                            CONVERT(
                                NVARCHAR(1),
                                sav.boolean_value
                            )
                    END
                )
                AS NVARCHAR(MAX)
            ),
            N'|'
        ) WITHIN GROUP (
            ORDER BY sav.attribute_id
        )
    FROM dbo.SKU_ATTRIBUTE_VALUE sav
    WHERE sav.sku_id = @sku_id;


    /* Tao variant_key */

    UPDATE dbo.PRODUCT_SKU
    SET variant_key =
        CASE
            WHEN @variant_text IS NULL THEN NULL
            ELSE HASHBYTES(
                'SHA2_256', @variant_text
            )
        END
    WHERE sku_id = @sku_id;
END;
GO


/* =========================================================
   PHAN 13 - CAP NHAT VARIANT KEY CHO SKU HIEN TAI
========================================================= */

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @current_sku_id INT;

    DECLARE sku_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT s.sku_id
    FROM dbo.PRODUCT_SKU s;

    OPEN sku_cursor;

    FETCH NEXT FROM sku_cursor INTO @current_sku_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.usp_OECS_RefreshSkuVariantKey
            @sku_id = @current_sku_id;

        FETCH NEXT FROM sku_cursor INTO @current_sku_id;
    END;

    CLOSE sku_cursor;
    DEALLOCATE sku_cursor;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF CURSOR_STATUS('local', 'sku_cursor') >= 0
        CLOSE sku_cursor;

    IF CURSOR_STATUS('local', 'sku_cursor') >= -1
        DEALLOCATE sku_cursor;

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO


/* =========================================================
   PHAN 14 - KIEM TRA TRUNG TO HOP SKU
========================================================= */

IF EXISTS (
    SELECT 1
    FROM dbo.PRODUCT_SKU
    WHERE variant_key IS NOT NULL
    GROUP BY product_id, variant_key
    HAVING COUNT(*) > 1
)
BEGIN
    THROW 51003,
        'Duplicate SKU variant combinations detected.',
        1;
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.PRODUCT_SKU')
      AND name = 'UX_SKU_ProductVariant'
)
BEGIN
    CREATE UNIQUE INDEX UX_SKU_ProductVariant
    ON dbo.PRODUCT_SKU (
        product_id,
        variant_key
    )
    WHERE variant_key IS NOT NULL;
END;
GO


/* =========================================================
   PHAN 15 - QUAN LY TON KHO (INVENTORY MANAGEMENT)
   - Dung ton hien tai: PRODUCT_SKU.stock_quantity
   - Bang lich su: INVENTORY_MOVEMENT
   - Trigger ghi nhan moi bien dong ton kho, ke ca code cu
   - Chi ghi snapshot OPENING, khong suy dien lich su cu
   - Cho phep chay lai ma khong tao trung OPENING
   - Khong tu thay doi stock_quantity cua bat ky SKU nao
   LUU Y: SAO LUU DATABASE VA KIEM TRA SKU TON NULL/AM
   TRUOC KHI CHAY. Script can dbo.[USER] va dbo.PRODUCT_SKU.
========================================================= */

IF OBJECT_ID(N'dbo.PRODUCT_SKU', N'U') IS NULL
   OR OBJECT_ID(N'dbo.PRODUCT', N'U') IS NULL
   OR OBJECT_ID(N'dbo.[USER]', N'U') IS NULL
    THROW 53000, N'OECS thieu PRODUCT_SKU, PRODUCT hoac USER.', 1;
GO

IF COL_LENGTH(N'dbo.PRODUCT_SKU', N'is_active') IS NULL
   OR COL_LENGTH(N'dbo.PRODUCT', N'is_active') IS NULL
    THROW 53001, N'Hay chay migration PRODUCT/SKU V2 truoc.', 1;
GO

IF EXISTS (SELECT 1 FROM dbo.PRODUCT_SKU WHERE stock_quantity IS NULL OR stock_quantity < 0)
    THROW 53002, N'Co SKU co ton kho NULL hoac am. Can xu ly truoc khi bat lich su.', 1;
GO

-- Prevent future NULL/negative stock, even from legacy order/SKU code.
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE parent_object_id = OBJECT_ID(N'dbo.PRODUCT_SKU')
      AND name = N'CK_OECS_Inventory_StockValid'
)
    ALTER TABLE dbo.PRODUCT_SKU WITH CHECK
    ADD CONSTRAINT CK_OECS_Inventory_StockValid
    CHECK (stock_quantity IS NOT NULL AND stock_quantity >= 0);
GO

IF OBJECT_ID(N'dbo.INVENTORY_MOVEMENT', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.INVENTORY_MOVEMENT (
        movement_id BIGINT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_INVENTORY_MOVEMENT PRIMARY KEY,
        sku_id INT NOT NULL,
        movement_type VARCHAR(12) NOT NULL,
        quantity_delta INT NOT NULL,
        quantity_before INT NOT NULL,
        quantity_after INT NOT NULL,
        note NVARCHAR(500) NULL,
        actor_user_id INT NULL,
        created_at DATETIME2(3) NOT NULL
            CONSTRAINT DF_INVENTORY_MOVEMENT_created_at DEFAULT SYSDATETIME(),
        CONSTRAINT FK_INVENTORY_MOVEMENT_SKU FOREIGN KEY (sku_id)
            REFERENCES dbo.PRODUCT_SKU(sku_id),
        CONSTRAINT FK_INVENTORY_MOVEMENT_USER FOREIGN KEY (actor_user_id)
            REFERENCES dbo.[USER](user_id),
        CONSTRAINT CK_INVENTORY_MOVEMENT_type CHECK
            (movement_type IN ('OPENING', 'IN', 'OUT', 'SET', 'SYSTEM')),
        CONSTRAINT CK_INVENTORY_MOVEMENT_balances CHECK
            (quantity_before >= 0 AND quantity_after >= 0
             AND quantity_delta = quantity_after - quantity_before)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_INVENTORY_MOVEMENT_sku_time'
               AND object_id = OBJECT_ID(N'dbo.INVENTORY_MOVEMENT'))
    CREATE INDEX IX_INVENTORY_MOVEMENT_sku_time
    ON dbo.INVENTORY_MOVEMENT(sku_id, movement_id DESC);
GO

-- One current-balance snapshot for older SKUs. This is NOT a reconstructed
-- history of prior purchases, sales or stock movements.
INSERT INTO dbo.INVENTORY_MOVEMENT
    (sku_id, movement_type, quantity_delta, quantity_before,
     quantity_after, note, actor_user_id)
SELECT s.sku_id, 'OPENING', s.stock_quantity, 0,
       s.stock_quantity, N'Số dư tại thời điểm kích hoạt quản lý kho', NULL
FROM dbo.PRODUCT_SKU AS s
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.INVENTORY_MOVEMENT AS m WHERE m.sku_id = s.sku_id
);
GO

-- Tracks ALL future stock changes, even when Cart/Checkout/ProductSkuDAO
-- updates stock_quantity without calling the Inventory module.
-- For other subsystems, movement_type=SYSTEM and actor is unknown.
CREATE OR ALTER TRIGGER dbo.trg_OECS_Inventory_TrackStock
ON dbo.PRODUCT_SKU
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.INVENTORY_MOVEMENT
        (sku_id, movement_type, quantity_delta, quantity_before,
         quantity_after, note, actor_user_id)
    SELECT
        i.sku_id,
        CASE
            WHEN d.sku_id IS NULL THEN 'OPENING'
            WHEN CONVERT(VARCHAR(12), SESSION_CONTEXT(N'oecs_inventory_action'))
                 IN ('IN', 'OUT', 'SET')
                THEN CONVERT(VARCHAR(12), SESSION_CONTEXT(N'oecs_inventory_action'))
            ELSE 'SYSTEM'
        END,
        i.stock_quantity - COALESCE(d.stock_quantity, 0),
        COALESCE(d.stock_quantity, 0),
        i.stock_quantity,
        CASE
            WHEN d.sku_id IS NULL THEN N'Tạo SKU với số dư ban đầu'
            WHEN CONVERT(VARCHAR(12), SESSION_CONTEXT(N'oecs_inventory_action'))
                 IN ('IN', 'OUT', 'SET')
                THEN CONVERT(NVARCHAR(500), SESSION_CONTEXT(N'oecs_inventory_note'))
            ELSE N'Thay đổi tồn kho từ nghiệp vụ khác'
        END,
        CASE
            WHEN d.sku_id IS NOT NULL
             AND CONVERT(VARCHAR(12), SESSION_CONTEXT(N'oecs_inventory_action'))
                 IN ('IN', 'OUT', 'SET')
                THEN TRY_CONVERT(INT, SESSION_CONTEXT(N'oecs_inventory_user_id'))
            ELSE NULL
        END
    FROM inserted AS i
    LEFT JOIN deleted AS d ON d.sku_id = i.sku_id
    WHERE d.sku_id IS NULL OR i.stock_quantity <> d.stock_quantity;
END;
GO

/* =========================================================
   PHAN 16 - KIEM TRA KET QUA
========================================================= */

/* 16.1. Danh sach 9 bang */

SELECT
    t.name AS table_name,
    SUM(p.rows) AS row_count
FROM sys.tables t
JOIN sys.partitions p
    ON p.object_id = t.object_id
WHERE p.index_id IN (0, 1)
  AND t.name IN (
      'CATEGORY',
      'BRAND',
      'PRODUCT',
      'ATTRIBUTE',
      'CATEGORY_ATTRIBUTE',
      'PRODUCT_SPECIFICATION',
      'PRODUCT_SKU',
      'SKU_ATTRIBUTE_VALUE',
      'PRODUCT_IMAGES'
  )
GROUP BY t.name
ORDER BY t.name;
GO


/* 16.2. Kiem tra SKU */

SELECT
    p.product_id,
    p.product_name,
    s.sku_id,
    s.sku_code,
    s.price,
    s.original_price,
    s.stock_quantity,
    s.is_active,
    s.variant_key
FROM dbo.PRODUCT_SKU s
JOIN dbo.PRODUCT p
    ON p.product_id = s.product_id
ORDER BY p.product_id, s.sku_id;
GO


/* 16.3. Kiem tra bien the */

SELECT
    p.product_name,
    s.sku_code,
    a.attribute_name,

    COALESCE(
        sav.text_value,
        CONVERT(
            NVARCHAR(60), sav.numeric_value
        ),
        CASE sav.boolean_value
            WHEN 1 THEN N'Có'
            WHEN 0 THEN N'Không'
        END
    ) AS attribute_value

FROM dbo.SKU_ATTRIBUTE_VALUE sav
JOIN dbo.PRODUCT_SKU s
    ON s.sku_id = sav.sku_id
JOIN dbo.PRODUCT p
    ON p.product_id = s.product_id
JOIN dbo.ATTRIBUTE a
    ON a.attribute_id = sav.attribute_id
ORDER BY
    p.product_name,
    s.sku_code,
    a.attribute_id;
GO


/* 16.4. Kiem tra thuoc tinh theo danh muc */

SELECT
    c.category_name,
    a.attribute_name,
    ca.group_name,
    ca.attribute_type,
    ca.is_required,
    ca.is_filterable,
    ca.display_order
FROM dbo.CATEGORY_ATTRIBUTE ca
JOIN dbo.CATEGORY c
    ON c.category_id = ca.category_id
JOIN dbo.ATTRIBUTE a
    ON a.attribute_id = ca.attribute_id
ORDER BY
    c.category_name,
    ca.group_name,
    ca.display_order;
GO


/* 16.5. Kiem tra anh */

SELECT
    p.product_name,
    s.sku_code,
    pi.image_url,
    pi.is_primary,
    pi.display_order
FROM dbo.PRODUCT_IMAGES pi
JOIN dbo.PRODUCT p
    ON p.product_id = pi.product_id
LEFT JOIN dbo.PRODUCT_SKU s
    ON s.sku_id = pi.sku_id
ORDER BY
    p.product_id,
    pi.sku_id,
    pi.display_order;
GO


/* 16.6. SKU chua co bien the */

SELECT
    p.product_name,
    s.sku_id,
    s.sku_code
FROM dbo.PRODUCT_SKU s
JOIN dbo.PRODUCT p
    ON p.product_id = s.product_id
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.SKU_ATTRIBUTE_VALUE sav
    WHERE sav.sku_id = s.sku_id
)
ORDER BY p.product_name, s.sku_code;
GO


/* 16.7. Kiem tra ton kho va so dong lich su */
SELECT
    COUNT_BIG(*) AS total_sku,
    SUM(CASE WHEN stock_quantity = 0 THEN 1 ELSE 0 END) AS out_of_stock_sku,
    SUM(CONVERT(BIGINT, stock_quantity)) AS total_units_in_stock
FROM dbo.PRODUCT_SKU;
GO

SELECT
    movement_type,
    COUNT_BIG(*) AS movement_count
FROM dbo.INVENTORY_MOVEMENT
GROUP BY movement_type
ORDER BY movement_type;
GO

PRINT N'========================================';
PRINT N'OECS V2 CATALOG + INVENTORY SCRIPT COMPLETED';
PRINT N'========================================';
GO
