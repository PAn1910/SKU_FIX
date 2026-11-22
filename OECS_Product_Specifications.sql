/* ============================================================================
   OECS V2 - 39 PRODUCTS / EXTENDED TECHNICAL SPECIFICATIONS
   SQL Server 2022 - additive, repeatable seed. NO DROP/DELETE/UPDATE of existing specs.
   Source: OECS seed schema/data + model-level public specifications where certain.
   IMPORTANT: laptop CPU/GPU configurations and some accessories come from OECS DEMO.
   Generic Lenovo model names lack exact MTM/part numbers; verify before real sales.
   SKU-VARIANT FIELDS (RAM, storage, color, kit) are not frozen at Product level.
   This seeds approx. 9-17 new spec fields per product; existing specs are preserved.
   Always backup and use a TEST copy of OECS first.
   ============================================================================ */
USE OECS;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF OBJECT_ID(N'dbo.PRODUCT',N'U') IS NULL OR
   OBJECT_ID(N'dbo.ATTRIBUTE',N'U') IS NULL OR
   OBJECT_ID(N'dbo.PRODUCT_SPECIFICATION',N'U') IS NULL OR
   OBJECT_ID(N'dbo.CATEGORY_ATTRIBUTE',N'U') IS NULL
BEGIN
    THROW 56001, N'Can chay OECS V2 Catalog Migration truoc.', 1;
END;
GO

CREATE TABLE #SpecSeed (
  product_name NVARCHAR(255) NOT NULL,
  group_name NVARCHAR(100) NOT NULL,
  attribute_name NVARCHAR(100) NOT NULL,
  spec_value NVARCHAR(255) NOT NULL,
  display_order INT NOT NULL,
  PRIMARY KEY(product_name, attribute_name)
);

INSERT INTO #SpecSeed(product_name,group_name,attribute_name,spec_value,display_order)
VALUES
    (N'iPhone 15 Pro', N'Màn hình', N'Tần số quét', N'ProMotion thích ứng đến 120 Hz', 10),
    (N'iPhone 15 Pro', N'Màn hình', N'Công nghệ màn hình', N'Super Retina XDR OLED', 20),
    (N'iPhone 15 Pro', N'Màn hình', N'Tính năng màn hình', N'Dynamic Island, Always-On Display', 30),
    (N'iPhone 15 Pro', N'Camera', N'Camera trước', N'TrueDepth 12 MP', 40),
    (N'iPhone 15 Pro', N'Camera', N'Tính năng camera', N'Chế độ Chân dung, Night mode, Photographic Styles', 50),
    (N'iPhone 15 Pro', N'Pin và sạc', N'Cổng sạc', N'USB-C', 60),
    (N'iPhone 15 Pro', N'Pin và sạc', N'Sạc không dây', N'MagSafe và Qi', 70),
    (N'iPhone 15 Pro', N'Kết nối', N'Mạng di động', N'5G', 80),
    (N'iPhone 15 Pro', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth, NFC', 90),
    (N'iPhone 15 Pro', N'Thiết kế', N'Chống nước và bụi', N'IP68', 100),
    (N'iPhone 15 Pro', N'Thiết kế', N'Chất liệu khung', N'Titan', 110),
    (N'iPhone 15 Pro', N'Bảo mật và phần mềm', N'Bảo mật', N'Face ID', 120),
    (N'iPhone 15 Pro', N'Camera', N'Camera sau', N'48 MP chính + 12 MP siêu rộng + 12 MP tele', 130),
    (N'iPhone 15 Pro', N'Camera', N'Zoom quang học', N'3x', 140),
    (N'iPhone 15 Pro', N'Pin và sạc', N'Thời lượng video', N'Lên đến 23 giờ (theo Apple)', 150),
    (N'iPhone 15 Pro', N'Bảo mật và phần mềm', N'Hệ điều hành khi ra mắt', N'iOS 17', 160),
    (N'iPhone 15 Pro Max', N'Màn hình', N'Tần số quét', N'ProMotion thích ứng đến 120 Hz', 10),
    (N'iPhone 15 Pro Max', N'Màn hình', N'Công nghệ màn hình', N'Super Retina XDR OLED', 20),
    (N'iPhone 15 Pro Max', N'Màn hình', N'Tính năng màn hình', N'Dynamic Island, Always-On Display', 30),
    (N'iPhone 15 Pro Max', N'Camera', N'Camera trước', N'TrueDepth 12 MP', 40),
    (N'iPhone 15 Pro Max', N'Camera', N'Tính năng camera', N'Chế độ Chân dung, Night mode, Photographic Styles', 50),
    (N'iPhone 15 Pro Max', N'Pin và sạc', N'Cổng sạc', N'USB-C', 60),
    (N'iPhone 15 Pro Max', N'Pin và sạc', N'Sạc không dây', N'MagSafe và Qi', 70),
    (N'iPhone 15 Pro Max', N'Kết nối', N'Mạng di động', N'5G', 80),
    (N'iPhone 15 Pro Max', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth, NFC', 90),
    (N'iPhone 15 Pro Max', N'Thiết kế', N'Chống nước và bụi', N'IP68', 100),
    (N'iPhone 15 Pro Max', N'Thiết kế', N'Chất liệu khung', N'Titan', 110),
    (N'iPhone 15 Pro Max', N'Bảo mật và phần mềm', N'Bảo mật', N'Face ID', 120),
    (N'iPhone 15 Pro Max', N'Camera', N'Camera sau', N'48 MP chính + 12 MP siêu rộng + 12 MP tele', 130),
    (N'iPhone 15 Pro Max', N'Camera', N'Zoom quang học', N'5x', 140),
    (N'iPhone 15 Pro Max', N'Pin và sạc', N'Thời lượng video', N'Lên đến 29 giờ (theo Apple)', 150),
    (N'iPhone 15 Pro Max', N'Bảo mật và phần mềm', N'Hệ điều hành khi ra mắt', N'iOS 17', 160),
    (N'iPhone 16 Pro', N'Màn hình', N'Tần số quét', N'ProMotion thích ứng đến 120 Hz', 10),
    (N'iPhone 16 Pro', N'Màn hình', N'Công nghệ màn hình', N'Super Retina XDR OLED', 20),
    (N'iPhone 16 Pro', N'Màn hình', N'Tính năng màn hình', N'Dynamic Island, Always-On Display', 30),
    (N'iPhone 16 Pro', N'Camera', N'Camera trước', N'TrueDepth 12 MP', 40),
    (N'iPhone 16 Pro', N'Camera', N'Tính năng camera', N'Chế độ Chân dung, Night mode, Photographic Styles', 50),
    (N'iPhone 16 Pro', N'Pin và sạc', N'Cổng sạc', N'USB-C', 60),
    (N'iPhone 16 Pro', N'Pin và sạc', N'Sạc không dây', N'MagSafe và Qi', 70),
    (N'iPhone 16 Pro', N'Kết nối', N'Mạng di động', N'5G', 80),
    (N'iPhone 16 Pro', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth, NFC', 90),
    (N'iPhone 16 Pro', N'Thiết kế', N'Chống nước và bụi', N'IP68', 100),
    (N'iPhone 16 Pro', N'Thiết kế', N'Chất liệu khung', N'Titan', 110),
    (N'iPhone 16 Pro', N'Bảo mật và phần mềm', N'Bảo mật', N'Face ID', 120),
    (N'iPhone 16 Pro', N'Camera', N'Camera sau', N'48 MP chính + 48 MP siêu rộng + 12 MP tele', 130),
    (N'iPhone 16 Pro', N'Camera', N'Zoom quang học', N'5x', 140),
    (N'iPhone 16 Pro', N'Pin và sạc', N'Thời lượng video', N'Lên đến 27 giờ (theo Apple)', 150),
    (N'iPhone 16 Pro', N'Bảo mật và phần mềm', N'Hệ điều hành khi ra mắt', N'iOS 18', 160),
    (N'iPhone 16 Pro Max', N'Màn hình', N'Tần số quét', N'ProMotion thích ứng đến 120 Hz', 10),
    (N'iPhone 16 Pro Max', N'Màn hình', N'Công nghệ màn hình', N'Super Retina XDR OLED', 20),
    (N'iPhone 16 Pro Max', N'Màn hình', N'Tính năng màn hình', N'Dynamic Island, Always-On Display', 30),
    (N'iPhone 16 Pro Max', N'Camera', N'Camera trước', N'TrueDepth 12 MP', 40),
    (N'iPhone 16 Pro Max', N'Camera', N'Tính năng camera', N'Chế độ Chân dung, Night mode, Photographic Styles', 50),
    (N'iPhone 16 Pro Max', N'Pin và sạc', N'Cổng sạc', N'USB-C', 60),
    (N'iPhone 16 Pro Max', N'Pin và sạc', N'Sạc không dây', N'MagSafe và Qi', 70),
    (N'iPhone 16 Pro Max', N'Kết nối', N'Mạng di động', N'5G', 80),
    (N'iPhone 16 Pro Max', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth, NFC', 90),
    (N'iPhone 16 Pro Max', N'Thiết kế', N'Chống nước và bụi', N'IP68', 100),
    (N'iPhone 16 Pro Max', N'Thiết kế', N'Chất liệu khung', N'Titan', 110),
    (N'iPhone 16 Pro Max', N'Bảo mật và phần mềm', N'Bảo mật', N'Face ID', 120),
    (N'iPhone 16 Pro Max', N'Camera', N'Camera sau', N'48 MP chính + 48 MP siêu rộng + 12 MP tele', 130),
    (N'iPhone 16 Pro Max', N'Camera', N'Zoom quang học', N'5x', 140),
    (N'iPhone 16 Pro Max', N'Pin và sạc', N'Thời lượng video', N'Lên đến 33 giờ (theo Apple)', 150),
    (N'iPhone 16 Pro Max', N'Bảo mật và phần mềm', N'Hệ điều hành khi ra mắt', N'iOS 18', 160),
    (N'Samsung Galaxy S24 Ultra', N'Màn hình', N'Tần số quét', N'Lên đến 120 Hz', 10),
    (N'Samsung Galaxy S24 Ultra', N'Màn hình', N'Công nghệ màn hình', N'Dynamic AMOLED 2X', 20),
    (N'Samsung Galaxy S24 Ultra', N'Kết nối', N'Mạng di động', N'5G', 80),
    (N'Samsung Galaxy S24 Ultra', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth, NFC', 90),
    (N'Samsung Galaxy S24 Ultra', N'Kết nối', N'Cổng kết nối', N'USB-C', 170),
    (N'Samsung Galaxy S24 Ultra', N'Bảo mật và phần mềm', N'Bảo mật', N'Cảm biến vân tay trên màn hình', 120),
    (N'Samsung Galaxy S24 Ultra', N'Bảo mật và phần mềm', N'Hệ điều hành khi ra mắt', N'Android 14, One UI 6.1', 160),
    (N'Samsung Galaxy S24 Ultra', N'Camera', N'Camera sau', N'200 MP chính + 12 MP siêu rộng + 50 MP tele 5x + 10 MP tele 3x', 130),
    (N'Samsung Galaxy S24 Ultra', N'Camera', N'Camera trước', N'12 MP', 40),
    (N'Samsung Galaxy S24 Ultra', N'Camera', N'Zoom quang học', N'3x và 5x', 140),
    (N'Samsung Galaxy S24 Ultra', N'Pin và sạc', N'Dung lượng pin', N'5.000 mAh', 180),
    (N'Samsung Galaxy S24 Ultra', N'Pin và sạc', N'Sạc có dây', N'Tối đa 45 W', 190),
    (N'Samsung Galaxy S24 Ultra', N'Pin và sạc', N'Sạc không dây', N'Có', 70),
    (N'Samsung Galaxy S24 Ultra', N'Thiết kế', N'Chống nước và bụi', N'IP68', 100),
    (N'Samsung Galaxy S24 Ultra', N'Thiết kế', N'Chất liệu khung', N'Titan', 110),
    (N'Samsung Galaxy S24 Ultra', N'Thiết kế', N'Bút S Pen', N'Tích hợp', 200),
    (N'Samsung Galaxy S24 Plus', N'Màn hình', N'Tần số quét', N'Lên đến 120 Hz', 10),
    (N'Samsung Galaxy S24 Plus', N'Màn hình', N'Công nghệ màn hình', N'Dynamic AMOLED 2X', 20),
    (N'Samsung Galaxy S24 Plus', N'Kết nối', N'Mạng di động', N'5G', 80),
    (N'Samsung Galaxy S24 Plus', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth, NFC', 90),
    (N'Samsung Galaxy S24 Plus', N'Kết nối', N'Cổng kết nối', N'USB-C', 170),
    (N'Samsung Galaxy S24 Plus', N'Bảo mật và phần mềm', N'Bảo mật', N'Cảm biến vân tay trên màn hình', 120),
    (N'Samsung Galaxy S24 Plus', N'Bảo mật và phần mềm', N'Hệ điều hành khi ra mắt', N'Android 14, One UI 6.1', 160),
    (N'Samsung Galaxy S24 Plus', N'Camera', N'Camera sau', N'50 MP chính + 12 MP siêu rộng + 10 MP tele', 130),
    (N'Samsung Galaxy S24 Plus', N'Camera', N'Camera trước', N'12 MP', 40),
    (N'Samsung Galaxy S24 Plus', N'Camera', N'Zoom quang học', N'3x', 140),
    (N'Samsung Galaxy S24 Plus', N'Pin và sạc', N'Dung lượng pin', N'4.900 mAh', 180),
    (N'Samsung Galaxy S24 Plus', N'Pin và sạc', N'Sạc có dây', N'Tối đa 45 W', 190),
    (N'Samsung Galaxy S24 Plus', N'Pin và sạc', N'Sạc không dây', N'Có', 70),
    (N'Samsung Galaxy S24 Plus', N'Thiết kế', N'Chống nước và bụi', N'IP68', 100),
    (N'Samsung Galaxy A55 5G', N'Màn hình', N'Tần số quét', N'Lên đến 120 Hz', 10),
    (N'Samsung Galaxy A55 5G', N'Màn hình', N'Công nghệ màn hình', N'Super AMOLED', 20),
    (N'Samsung Galaxy A55 5G', N'Kết nối', N'Mạng di động', N'5G', 80),
    (N'Samsung Galaxy A55 5G', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth, NFC', 90),
    (N'Samsung Galaxy A55 5G', N'Kết nối', N'Cổng kết nối', N'USB-C', 170),
    (N'Samsung Galaxy A55 5G', N'Bảo mật và phần mềm', N'Bảo mật', N'Cảm biến vân tay trên màn hình', 120),
    (N'Samsung Galaxy A55 5G', N'Bảo mật và phần mềm', N'Hệ điều hành khi ra mắt', N'Android 14, One UI 6.1', 160),
    (N'Samsung Galaxy A55 5G', N'Pin và sạc', N'Dung lượng pin', N'5.000 mAh', 180),
    (N'Samsung Galaxy A55 5G', N'Pin và sạc', N'Sạc có dây', N'Tối đa 25 W', 190),
    (N'Samsung Galaxy A55 5G', N'Thiết kế', N'Chống nước và bụi', N'IP67', 100),
    (N'Samsung Galaxy A55 5G', N'Màn hình', N'Độ phân giải màn hình', N'FHD+', 210),
    (N'Samsung Galaxy A55 5G', N'Camera', N'Camera sau', N'50 MP chính + 12 MP siêu rộng + 5 MP macro', 130),
    (N'Samsung Galaxy A55 5G', N'Camera', N'Camera trước', N'32 MP', 40),
    (N'Samsung Galaxy A35 5G', N'Màn hình', N'Tần số quét', N'Lên đến 120 Hz', 10),
    (N'Samsung Galaxy A35 5G', N'Màn hình', N'Công nghệ màn hình', N'Super AMOLED', 20),
    (N'Samsung Galaxy A35 5G', N'Kết nối', N'Mạng di động', N'5G', 80),
    (N'Samsung Galaxy A35 5G', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth, NFC', 90),
    (N'Samsung Galaxy A35 5G', N'Kết nối', N'Cổng kết nối', N'USB-C', 170),
    (N'Samsung Galaxy A35 5G', N'Bảo mật và phần mềm', N'Bảo mật', N'Cảm biến vân tay trên màn hình', 120),
    (N'Samsung Galaxy A35 5G', N'Bảo mật và phần mềm', N'Hệ điều hành khi ra mắt', N'Android 14, One UI 6.1', 160),
    (N'Samsung Galaxy A35 5G', N'Pin và sạc', N'Dung lượng pin', N'5.000 mAh', 180),
    (N'Samsung Galaxy A35 5G', N'Pin và sạc', N'Sạc có dây', N'Tối đa 25 W', 190),
    (N'Samsung Galaxy A35 5G', N'Thiết kế', N'Chống nước và bụi', N'IP67', 100),
    (N'Samsung Galaxy A35 5G', N'Màn hình', N'Độ phân giải màn hình', N'FHD+', 210),
    (N'Samsung Galaxy A35 5G', N'Camera', N'Camera sau', N'50 MP chính + 8 MP siêu rộng + 5 MP macro', 130),
    (N'Samsung Galaxy A35 5G', N'Camera', N'Camera trước', N'13 MP', 40),
    (N'AirPods Pro 2', N'Thiết kế', N'Kiểu tai nghe', N'True wireless (TWS)', 10),
    (N'AirPods Pro 2', N'Kết nối', N'Kết nối chính', N'Bluetooth', 20),
    (N'AirPods Pro 2', N'Pin và sạc', N'Phương thức sạc', N'Qua hộp sạc', 30),
    (N'AirPods Pro 2', N'Âm thanh', N'Microphone', N'Có, hỗ trợ đàm thoại', 40),
    (N'AirPods Pro 2', N'Điều khiển', N'Điều khiển', N'Cảm ứng / thao tác trên tai nghe', 50),
    (N'AirPods Pro 2', N'Âm thanh', N'Chống ồn chủ động', N'Có (ANC)', 60),
    (N'AirPods Pro 2', N'Âm thanh', N'Âm thanh không gian', N'Có, theo dõi chuyển động đầu', 70),
    (N'AirPods Pro 2', N'Âm thanh', N'Chế độ xuyên âm', N'Có, Adaptive Transparency', 80),
    (N'AirPods Pro 2', N'Kết nối', N'Bluetooth', N'5.3', 90),
    (N'AirPods Pro 2', N'Pin và sạc', N'Thời gian nghe', N'Lên đến 6 giờ mỗi lần sạc (ANC bật)', 100),
    (N'AirPods Pro 2', N'Pin và sạc', N'Cổng sạc hộp', N'USB-C (phiên bản hộp USB-C)', 110),
    (N'AirPods Pro 2', N'Thiết kế', N'Chống bụi và nước', N'IP54 (phiên bản USB-C)', 120),
    (N'AirPods 4', N'Thiết kế', N'Kiểu tai nghe', N'True wireless (TWS)', 10),
    (N'AirPods 4', N'Kết nối', N'Kết nối chính', N'Bluetooth', 20),
    (N'AirPods 4', N'Pin và sạc', N'Phương thức sạc', N'Qua hộp sạc', 30),
    (N'AirPods 4', N'Âm thanh', N'Microphone', N'Có, hỗ trợ đàm thoại', 40),
    (N'AirPods 4', N'Điều khiển', N'Điều khiển', N'Cảm ứng / thao tác trên tai nghe', 50),
    (N'AirPods 4', N'Âm thanh', N'Chống ồn chủ động', N'Tùy SKU: bản thường hoặc bản ANC', 60),
    (N'AirPods 4', N'Âm thanh', N'Âm thanh không gian', N'Có', 70),
    (N'AirPods 4', N'Kết nối', N'Bluetooth', N'5.3', 90),
    (N'AirPods 4', N'Pin và sạc', N'Thời gian nghe', N'Lên đến 5 giờ/bản thường; bản ANC tùy chế độ', 100),
    (N'AirPods 4', N'Pin và sạc', N'Cổng sạc hộp', N'USB-C', 110),
    (N'AirPods 4', N'Thiết kế', N'Chống bụi và nước', N'IP54', 120),
    (N'Samsung Galaxy Buds3 Pro', N'Thiết kế', N'Kiểu tai nghe', N'True wireless (TWS)', 10),
    (N'Samsung Galaxy Buds3 Pro', N'Kết nối', N'Kết nối chính', N'Bluetooth', 20),
    (N'Samsung Galaxy Buds3 Pro', N'Pin và sạc', N'Phương thức sạc', N'Qua hộp sạc', 30),
    (N'Samsung Galaxy Buds3 Pro', N'Âm thanh', N'Microphone', N'Có, hỗ trợ đàm thoại', 40),
    (N'Samsung Galaxy Buds3 Pro', N'Điều khiển', N'Điều khiển', N'Cảm ứng / thao tác trên tai nghe', 50),
    (N'Samsung Galaxy Buds3 Pro', N'Âm thanh', N'Chống ồn chủ động', N'Có (ANC)', 60),
    (N'Samsung Galaxy Buds3 Pro', N'Âm thanh', N'Chế độ âm thanh', N'Adaptive Noise Control', 130),
    (N'Samsung Galaxy Buds3 Pro', N'Âm thanh', N'Kiểu đeo', N'In-ear', 140),
    (N'Samsung Galaxy Buds3 Pro', N'Kết nối', N'Bluetooth', N'5.4', 90),
    (N'Samsung Galaxy Buds3 Pro', N'Pin và sạc', N'Cổng sạc hộp', N'USB-C', 110),
    (N'Samsung Galaxy Buds3 Pro', N'Pin và sạc', N'Thời gian nghe', N'Lên đến 6 giờ (bật ANC, tùy điều kiện)', 100),
    (N'Samsung Galaxy Buds3 Pro', N'Thiết kế', N'Chống nước', N'IP57 (tai nghe)', 150),
    (N'Samsung Galaxy Buds FE', N'Thiết kế', N'Kiểu tai nghe', N'True wireless (TWS)', 10),
    (N'Samsung Galaxy Buds FE', N'Kết nối', N'Kết nối chính', N'Bluetooth', 20),
    (N'Samsung Galaxy Buds FE', N'Pin và sạc', N'Phương thức sạc', N'Qua hộp sạc', 30),
    (N'Samsung Galaxy Buds FE', N'Âm thanh', N'Microphone', N'Có, hỗ trợ đàm thoại', 40),
    (N'Samsung Galaxy Buds FE', N'Điều khiển', N'Điều khiển', N'Cảm ứng / thao tác trên tai nghe', 50),
    (N'Samsung Galaxy Buds FE', N'Âm thanh', N'Chống ồn chủ động', N'Có (ANC)', 60),
    (N'Samsung Galaxy Buds FE', N'Âm thanh', N'Kiểu đeo', N'In-ear, có wingtip', 140),
    (N'Samsung Galaxy Buds FE', N'Kết nối', N'Bluetooth', N'5.2', 90),
    (N'Samsung Galaxy Buds FE', N'Pin và sạc', N'Cổng sạc hộp', N'USB-C', 110),
    (N'Samsung Galaxy Buds FE', N'Pin và sạc', N'Thời gian nghe', N'Lên đến 6 giờ (bật ANC, tùy điều kiện)', 100),
    (N'Samsung Galaxy Buds FE', N'Thiết kế', N'Chống nước', N'IPX2 (tai nghe)', 150),
    (N'Apple USB-C 20W Power Adapter', N'Thông tin chung', N'Loại sản phẩm', N'Củ sạc / bộ tiếp hợp nguồn', 10),
    (N'Apple USB-C 20W Power Adapter', N'Thông tin chung', N'Cổng đầu ra', N'USB-C', 20),
    (N'Apple USB-C 20W Power Adapter', N'Thông tin chung', N'Nguồn điện đầu vào', N'Điện lưới AC', 30),
    (N'Apple USB-C 20W Power Adapter', N'Thông tin chung', N'Phạm vi sử dụng', N'Sạc thiết bị tương thích qua USB-C', 40),
    (N'Apple USB-C 20W Power Adapter', N'Thông tin chung', N'Cáp sạc kèm theo', N'Phụ thuộc gói bán và bộ đóng gói', 50),
    (N'Apple USB-C 20W Power Adapter', N'Kết nối & tương thích', N'Tương thích', N'Điện thoại và thiết bị hỗ trợ sạc qua USB-C', 60),
    (N'Apple USB-C 20W Power Adapter', N'Kết nối & tương thích', N'Chức năng', N'Cấp nguồn và sạc pin', 70),
    (N'Apple USB-C 20W Power Adapter', N'Kết nối & tương thích', N'Số cổng sạc', N'1 cổng USB-C', 80),
    (N'Apple USB-C 20W Power Adapter', N'Nguồn & sạc', N'Công suất tối đa', N'20 W', 90),
    (N'Apple USB-C 20W Power Adapter', N'Nguồn & sạc', N'Chuẩn sạc', N'USB Power Delivery (PD)', 100),
    (N'Samsung 25W USB-C Fast Charger', N'Thông tin chung', N'Loại sản phẩm', N'Củ sạc / bộ tiếp hợp nguồn', 10),
    (N'Samsung 25W USB-C Fast Charger', N'Thông tin chung', N'Cổng đầu ra', N'USB-C', 20),
    (N'Samsung 25W USB-C Fast Charger', N'Thông tin chung', N'Nguồn điện đầu vào', N'Điện lưới AC', 30),
    (N'Samsung 25W USB-C Fast Charger', N'Thông tin chung', N'Phạm vi sử dụng', N'Sạc thiết bị tương thích qua USB-C', 40),
    (N'Samsung 25W USB-C Fast Charger', N'Thông tin chung', N'Cáp sạc kèm theo', N'Phụ thuộc gói bán và bộ đóng gói', 50),
    (N'Samsung 25W USB-C Fast Charger', N'Kết nối & tương thích', N'Tương thích', N'Điện thoại và thiết bị hỗ trợ sạc qua USB-C', 60),
    (N'Samsung 25W USB-C Fast Charger', N'Kết nối & tương thích', N'Chức năng', N'Cấp nguồn và sạc pin', 70),
    (N'Samsung 25W USB-C Fast Charger', N'Kết nối & tương thích', N'Số cổng sạc', N'1 cổng USB-C', 80),
    (N'Samsung 25W USB-C Fast Charger', N'Nguồn & sạc', N'Công suất tối đa', N'25 W', 90),
    (N'Samsung 25W USB-C Fast Charger', N'Nguồn & sạc', N'Chuẩn sạc', N'USB PD PPS / Samsung Super Fast Charging', 100),
    (N'Apple USB-C Charge Cable 1m', N'Thông tin chung', N'Loại sản phẩm', N'Cáp sạc và truyền dữ liệu', 10),
    (N'Apple USB-C Charge Cable 1m', N'Thông tin chung', N'Chức năng', N'Sạc và đồng bộ dữ liệu', 20),
    (N'Apple USB-C Charge Cable 1m', N'Thông tin chung', N'Chiều dài danh nghĩa', N'1 m', 30),
    (N'Apple USB-C Charge Cable 1m', N'Thông tin chung', N'Nguồn cấp', N'Sử dụng bộ sạc/thiết bị tương thích', 40),
    (N'Apple USB-C Charge Cable 1m', N'Kết nối', N'Tương thích', N'Tùy loại cổng của thiết bị', 50),
    (N'Apple USB-C Charge Cable 1m', N'Kết nối', N'Loại kết nối', N'Có dây', 60),
    (N'Apple USB-C Charge Cable 1m', N'Kết nối', N'Cách sử dụng', N'Kết nối thiết bị và bộ sạc hoặc máy tính', 70),
    (N'Apple USB-C Charge Cable 1m', N'Kết nối', N'Đầu cáp 1', N'USB-C', 80),
    (N'Apple USB-C Charge Cable 1m', N'Kết nối', N'Đầu cáp 2', N'USB-C', 90),
    (N'Apple USB-C Charge Cable 1m', N'Thông tin chung', N'Dòng cáp', N'Apple USB-C Charge Cable', 100),
    (N'Apple USB-C to Lightning Cable', N'Thông tin chung', N'Loại sản phẩm', N'Cáp sạc và truyền dữ liệu', 10),
    (N'Apple USB-C to Lightning Cable', N'Thông tin chung', N'Chức năng', N'Sạc và đồng bộ dữ liệu', 20),
    (N'Apple USB-C to Lightning Cable', N'Thông tin chung', N'Chiều dài danh nghĩa', N'1 m', 30),
    (N'Apple USB-C to Lightning Cable', N'Thông tin chung', N'Nguồn cấp', N'Sử dụng bộ sạc/thiết bị tương thích', 40),
    (N'Apple USB-C to Lightning Cable', N'Kết nối', N'Tương thích', N'Tùy loại cổng của thiết bị', 50),
    (N'Apple USB-C to Lightning Cable', N'Kết nối', N'Loại kết nối', N'Có dây', 60),
    (N'Apple USB-C to Lightning Cable', N'Kết nối', N'Cách sử dụng', N'Kết nối thiết bị và bộ sạc hoặc máy tính', 70),
    (N'Apple USB-C to Lightning Cable', N'Kết nối', N'Đầu cáp 1', N'USB-C', 80),
    (N'Apple USB-C to Lightning Cable', N'Kết nối', N'Đầu cáp 2', N'Lightning', 90),
    (N'Apple USB-C to Lightning Cable', N'Thông tin chung', N'Dòng cáp', N'Apple USB-C to Lightning', 100),
    (N'Samsung USB-C Cable 1m', N'Thông tin chung', N'Loại sản phẩm', N'Cáp sạc và truyền dữ liệu', 10),
    (N'Samsung USB-C Cable 1m', N'Thông tin chung', N'Chức năng', N'Sạc và đồng bộ dữ liệu', 20),
    (N'Samsung USB-C Cable 1m', N'Thông tin chung', N'Chiều dài danh nghĩa', N'1 m', 30),
    (N'Samsung USB-C Cable 1m', N'Thông tin chung', N'Nguồn cấp', N'Sử dụng bộ sạc/thiết bị tương thích', 40),
    (N'Samsung USB-C Cable 1m', N'Kết nối', N'Tương thích', N'Tùy loại cổng của thiết bị', 50),
    (N'Samsung USB-C Cable 1m', N'Kết nối', N'Loại kết nối', N'Có dây', 60),
    (N'Samsung USB-C Cable 1m', N'Kết nối', N'Cách sử dụng', N'Kết nối thiết bị và bộ sạc hoặc máy tính', 70),
    (N'Samsung USB-C Cable 1m', N'Kết nối', N'Đầu cáp 1', N'USB-C', 80),
    (N'Samsung USB-C Cable 1m', N'Kết nối', N'Đầu cáp 2', N'USB-C', 90),
    (N'Samsung USB-C Cable 1m', N'Thông tin chung', N'Dòng cáp', N'Samsung USB-C Cable', 100),
    (N'Lenovo IdeaPad Slim 3', N'Bộ nhớ & lưu trữ', N'Loại ổ cứng', N'SSD (dung lượng theo SKU)', 10),
    (N'Lenovo IdeaPad Slim 3', N'Bộ nhớ & lưu trữ', N'Cấu hình RAM', N'Dung lượng theo SKU, xem mục chọn phiên bản', 20),
    (N'Lenovo IdeaPad Slim 3', N'Kết nối', N'Kết nối không dây', N'Wi-Fi và Bluetooth (chuẩn tùy cấu hình)', 30),
    (N'Lenovo IdeaPad Slim 3', N'Kết nối', N'Cổng kết nối phổ biến', N'USB-A, USB-C, HDMI (tùy máy)', 40),
    (N'Lenovo IdeaPad Slim 3', N'Đa phương tiện', N'Webcam', N'Tích hợp trên màn hình', 50),
    (N'Lenovo IdeaPad Slim 3', N'Đa phương tiện', N'Âm thanh', N'Loa và microphone tích hợp', 60),
    (N'Lenovo IdeaPad Slim 3', N'Thông tin khác', N'Nhu cầu sử dụng', N'Học tập, làm việc và giải trí', 70),
    (N'Lenovo IdeaPad Slim 3', N'Thông tin khác', N'Hệ điều hành', N'Tùy cấu hình xuất xưởng / cài đặt thực tế', 80),
    (N'Lenovo IdeaPad Slim 3', N'Thiết kế', N'Kiểu máy', N'Laptop đa dụng / văn phòng', 90),
    (N'Lenovo IdeaPad Slim 3', N'Thiết kế', N'Bàn phím', N'Bàn phím laptop tích hợp', 100),
    (N'Lenovo IdeaPad Slim 3', N'Màn hình', N'Kích thước màn hình', N'15.6 inch', 110),
    (N'Lenovo IdeaPad Slim 3', N'Màn hình', N'Độ phân giải màn hình', N'Full HD', 120),
    (N'Lenovo IdeaPad Slim 3', N'Bộ xử lý', N'Dòng CPU', N'Intel Core i3-1315U (theo cấu hình demo)', 130),
    (N'Lenovo ThinkBook 14', N'Bộ nhớ & lưu trữ', N'Loại ổ cứng', N'SSD (dung lượng theo SKU)', 10),
    (N'Lenovo ThinkBook 14', N'Bộ nhớ & lưu trữ', N'Cấu hình RAM', N'Dung lượng theo SKU, xem mục chọn phiên bản', 20),
    (N'Lenovo ThinkBook 14', N'Kết nối', N'Kết nối không dây', N'Wi-Fi và Bluetooth (chuẩn tùy cấu hình)', 30),
    (N'Lenovo ThinkBook 14', N'Kết nối', N'Cổng kết nối phổ biến', N'USB-A, USB-C, HDMI (tùy máy)', 40),
    (N'Lenovo ThinkBook 14', N'Đa phương tiện', N'Webcam', N'Tích hợp trên màn hình', 50),
    (N'Lenovo ThinkBook 14', N'Đa phương tiện', N'Âm thanh', N'Loa và microphone tích hợp', 60),
    (N'Lenovo ThinkBook 14', N'Thông tin khác', N'Nhu cầu sử dụng', N'Học tập, làm việc và giải trí', 70),
    (N'Lenovo ThinkBook 14', N'Thông tin khác', N'Hệ điều hành', N'Tùy cấu hình xuất xưởng / cài đặt thực tế', 80),
    (N'Lenovo ThinkBook 14', N'Thiết kế', N'Kiểu máy', N'Laptop đa dụng / văn phòng', 90),
    (N'Lenovo ThinkBook 14', N'Thiết kế', N'Bàn phím', N'Bàn phím laptop tích hợp', 100),
    (N'Lenovo ThinkBook 14', N'Màn hình', N'Kích thước màn hình', N'14 inch', 110),
    (N'Lenovo ThinkBook 14', N'Màn hình', N'Độ phân giải màn hình', N'WUXGA', 120),
    (N'Lenovo ThinkBook 14', N'Bộ xử lý', N'Dòng CPU', N'Intel Core i5-1335U (theo cấu hình demo)', 130),
    (N'Lenovo IdeaPad 5', N'Bộ nhớ & lưu trữ', N'Loại ổ cứng', N'SSD (dung lượng theo SKU)', 10),
    (N'Lenovo IdeaPad 5', N'Bộ nhớ & lưu trữ', N'Cấu hình RAM', N'Dung lượng theo SKU, xem mục chọn phiên bản', 20),
    (N'Lenovo IdeaPad 5', N'Kết nối', N'Kết nối không dây', N'Wi-Fi và Bluetooth (chuẩn tùy cấu hình)', 30),
    (N'Lenovo IdeaPad 5', N'Kết nối', N'Cổng kết nối phổ biến', N'USB-A, USB-C, HDMI (tùy máy)', 40),
    (N'Lenovo IdeaPad 5', N'Đa phương tiện', N'Webcam', N'Tích hợp trên màn hình', 50),
    (N'Lenovo IdeaPad 5', N'Đa phương tiện', N'Âm thanh', N'Loa và microphone tích hợp', 60),
    (N'Lenovo IdeaPad 5', N'Thông tin khác', N'Nhu cầu sử dụng', N'Học tập, làm việc và giải trí', 70),
    (N'Lenovo IdeaPad 5', N'Thông tin khác', N'Hệ điều hành', N'Tùy cấu hình xuất xưởng / cài đặt thực tế', 80),
    (N'Lenovo IdeaPad 5', N'Thiết kế', N'Kiểu máy', N'Laptop đa dụng / văn phòng', 90),
    (N'Lenovo IdeaPad 5', N'Thiết kế', N'Bàn phím', N'Bàn phím laptop tích hợp', 100),
    (N'Lenovo IdeaPad 5', N'Màn hình', N'Kích thước màn hình', N'15.6 inch', 110),
    (N'Lenovo IdeaPad 5', N'Màn hình', N'Độ phân giải màn hình', N'Full HD', 120),
    (N'Lenovo IdeaPad 5', N'Bộ xử lý', N'Dòng CPU', N'AMD Ryzen 5 7530U (theo cấu hình demo)', 130),
    (N'Lenovo LOQ 15', N'Bộ nhớ & lưu trữ', N'Loại ổ cứng', N'SSD (dung lượng theo SKU)', 10),
    (N'Lenovo LOQ 15', N'Bộ nhớ & lưu trữ', N'Cấu hình RAM', N'Dung lượng theo SKU, xem mục chọn phiên bản', 20),
    (N'Lenovo LOQ 15', N'Kết nối', N'Kết nối không dây', N'Wi-Fi và Bluetooth (chuẩn tùy cấu hình)', 30),
    (N'Lenovo LOQ 15', N'Kết nối', N'Cổng kết nối phổ biến', N'USB-A, USB-C, HDMI (tùy máy)', 40),
    (N'Lenovo LOQ 15', N'Đa phương tiện', N'Webcam', N'Tích hợp trên màn hình', 50),
    (N'Lenovo LOQ 15', N'Đa phương tiện', N'Âm thanh', N'Loa và microphone tích hợp', 60),
    (N'Lenovo LOQ 15', N'Thông tin khác', N'Nhu cầu sử dụng', N'Học tập, làm việc và giải trí', 70),
    (N'Lenovo LOQ 15', N'Thông tin khác', N'Hệ điều hành', N'Tùy cấu hình xuất xưởng / cài đặt thực tế', 80),
    (N'Lenovo LOQ 15', N'Thiết kế', N'Kiểu máy', N'Laptop gaming', 90),
    (N'Lenovo LOQ 15', N'Thiết kế', N'Bàn phím', N'Bàn phím gaming tích hợp', 100),
    (N'Lenovo LOQ 15', N'Màn hình', N'Kích thước màn hình', N'15.6 inch', 110),
    (N'Lenovo LOQ 15', N'Màn hình', N'Độ phân giải màn hình', N'Full HD', 120),
    (N'Lenovo LOQ 15', N'Màn hình', N'Tần số quét', N'144 Hz', 130),
    (N'Lenovo LOQ 15', N'Bộ xử lý', N'Dòng CPU', N'Intel Core i5-13420H (theo cấu hình demo)', 140),
    (N'Lenovo LOQ 15', N'Bộ xử lý', N'GPU rời', N'NVIDIA GeForce RTX 4050 6 GB (cấu hình demo)', 150),
    (N'Lenovo Legion 5', N'Bộ nhớ & lưu trữ', N'Loại ổ cứng', N'SSD (dung lượng theo SKU)', 10),
    (N'Lenovo Legion 5', N'Bộ nhớ & lưu trữ', N'Cấu hình RAM', N'Dung lượng theo SKU, xem mục chọn phiên bản', 20),
    (N'Lenovo Legion 5', N'Kết nối', N'Kết nối không dây', N'Wi-Fi và Bluetooth (chuẩn tùy cấu hình)', 30),
    (N'Lenovo Legion 5', N'Kết nối', N'Cổng kết nối phổ biến', N'USB-A, USB-C, HDMI (tùy máy)', 40),
    (N'Lenovo Legion 5', N'Đa phương tiện', N'Webcam', N'Tích hợp trên màn hình', 50),
    (N'Lenovo Legion 5', N'Đa phương tiện', N'Âm thanh', N'Loa và microphone tích hợp', 60),
    (N'Lenovo Legion 5', N'Thông tin khác', N'Nhu cầu sử dụng', N'Học tập, làm việc và giải trí', 70),
    (N'Lenovo Legion 5', N'Thông tin khác', N'Hệ điều hành', N'Tùy cấu hình xuất xưởng / cài đặt thực tế', 80),
    (N'Lenovo Legion 5', N'Thiết kế', N'Kiểu máy', N'Laptop gaming', 90),
    (N'Lenovo Legion 5', N'Thiết kế', N'Bàn phím', N'Bàn phím gaming tích hợp', 100),
    (N'Lenovo Legion 5', N'Màn hình', N'Kích thước màn hình', N'15.6 inch', 110),
    (N'Lenovo Legion 5', N'Màn hình', N'Độ phân giải màn hình', N'WQHD', 120),
    (N'Lenovo Legion 5', N'Màn hình', N'Tần số quét', N'165 Hz', 130),
    (N'Lenovo Legion 5', N'Bộ xử lý', N'Dòng CPU', N'AMD Ryzen 7 7735HS (theo cấu hình demo)', 140),
    (N'Lenovo Legion 5', N'Bộ xử lý', N'GPU rời', N'NVIDIA GeForce RTX 4060 8 GB (cấu hình demo)', 150),
    (N'Lenovo Legion Pro 5', N'Bộ nhớ & lưu trữ', N'Loại ổ cứng', N'SSD (dung lượng theo SKU)', 10),
    (N'Lenovo Legion Pro 5', N'Bộ nhớ & lưu trữ', N'Cấu hình RAM', N'Dung lượng theo SKU, xem mục chọn phiên bản', 20),
    (N'Lenovo Legion Pro 5', N'Kết nối', N'Kết nối không dây', N'Wi-Fi và Bluetooth (chuẩn tùy cấu hình)', 30),
    (N'Lenovo Legion Pro 5', N'Kết nối', N'Cổng kết nối phổ biến', N'USB-A, USB-C, HDMI (tùy máy)', 40),
    (N'Lenovo Legion Pro 5', N'Đa phương tiện', N'Webcam', N'Tích hợp trên màn hình', 50),
    (N'Lenovo Legion Pro 5', N'Đa phương tiện', N'Âm thanh', N'Loa và microphone tích hợp', 60),
    (N'Lenovo Legion Pro 5', N'Thông tin khác', N'Nhu cầu sử dụng', N'Học tập, làm việc và giải trí', 70),
    (N'Lenovo Legion Pro 5', N'Thông tin khác', N'Hệ điều hành', N'Tùy cấu hình xuất xưởng / cài đặt thực tế', 80),
    (N'Lenovo Legion Pro 5', N'Thiết kế', N'Kiểu máy', N'Laptop gaming', 90),
    (N'Lenovo Legion Pro 5', N'Thiết kế', N'Bàn phím', N'Bàn phím gaming tích hợp', 100),
    (N'Lenovo Legion Pro 5', N'Màn hình', N'Kích thước màn hình', N'16 inch', 110),
    (N'Lenovo Legion Pro 5', N'Màn hình', N'Độ phân giải màn hình', N'WQXGA', 120),
    (N'Lenovo Legion Pro 5', N'Màn hình', N'Tần số quét', N'240 Hz', 130),
    (N'Lenovo Legion Pro 5', N'Bộ xử lý', N'Dòng CPU', N'Intel Core i9-14900HX (theo cấu hình demo)', 140),
    (N'Lenovo Legion Pro 5', N'Bộ xử lý', N'GPU rời', N'NVIDIA GeForce RTX 4070 8 GB (cấu hình demo)', 150),
    (N'Lenovo Legion M300 RGB', N'Thông tin chung', N'Loại sản phẩm', N'Chuột máy tính / gaming', 10),
    (N'Lenovo Legion M300 RGB', N'Thông tin chung', N'Cảm biến', N'Cảm biến quang học', 20),
    (N'Lenovo Legion M300 RGB', N'Thông tin chung', N'Thiết kế', N'Chuột cho người dùng PC/laptop', 30),
    (N'Lenovo Legion M300 RGB', N'Thông tin chung', N'Chức năng', N'Điều khiển con trỏ, thao tác và chơi game', 40),
    (N'Lenovo Legion M300 RGB', N'Tương thích', N'Thiết bị hỗ trợ', N'Máy tính/laptop có kết nối phù hợp', 50),
    (N'Lenovo Legion M300 RGB', N'Tương thích', N'Hệ điều hành', N'Tương thích phụ thuộc driver và cổng kết nối', 60),
    (N'Lenovo Legion M300 RGB', N'Hiệu năng', N'DPI tối đa', N'8.000 DPI (theo dữ liệu mẫu)', 70),
    (N'Lenovo Legion M300 RGB', N'Hiệu năng', N'Đèn LED', N'RGB', 80),
    (N'Lenovo Legion M300 RGB', N'Kết nối', N'Kiểu kết nối', N'Có dây', 90),
    (N'Lenovo Legion M300 RGB', N'Kết nối', N'Giao tiếp', N'USB-A', 100),
    (N'Lenovo Legion M600 Wireless', N'Thông tin chung', N'Loại sản phẩm', N'Chuột máy tính / gaming', 10),
    (N'Lenovo Legion M600 Wireless', N'Thông tin chung', N'Cảm biến', N'Cảm biến quang học', 20),
    (N'Lenovo Legion M600 Wireless', N'Thông tin chung', N'Thiết kế', N'Chuột cho người dùng PC/laptop', 30),
    (N'Lenovo Legion M600 Wireless', N'Thông tin chung', N'Chức năng', N'Điều khiển con trỏ, thao tác và chơi game', 40),
    (N'Lenovo Legion M600 Wireless', N'Tương thích', N'Thiết bị hỗ trợ', N'Máy tính/laptop có kết nối phù hợp', 50),
    (N'Lenovo Legion M600 Wireless', N'Tương thích', N'Hệ điều hành', N'Tương thích phụ thuộc driver và cổng kết nối', 60),
    (N'Lenovo Legion M600 Wireless', N'Hiệu năng', N'DPI tối đa', N'16.000 DPI (theo dữ liệu mẫu)', 70),
    (N'Lenovo Legion M600 Wireless', N'Hiệu năng', N'Tùy chỉnh độ nhạy', N'Có', 110),
    (N'Lenovo Legion M600 Wireless', N'Kết nối', N'Kiểu kết nối', N'Không dây', 90),
    (N'Lenovo Legion M600 Wireless', N'Kết nối', N'Giao tiếp', N'Bluetooth / bộ thu không dây (tùy chế độ)', 100),
    (N'Lenovo Legion K300 RGB', N'Thông tin chung', N'Loại sản phẩm', N'Bàn phím máy tính', 10),
    (N'Lenovo Legion K300 RGB', N'Thông tin chung', N'Bố cục', N'Bàn phím vật lý', 20),
    (N'Lenovo Legion K300 RGB', N'Thông tin chung', N'Mục đích', N'Nhập liệu và điều khiển máy tính', 30),
    (N'Lenovo Legion K300 RGB', N'Thông tin chung', N'Phím chức năng', N'Có các phím điều khiển và phím tắt', 40),
    (N'Lenovo Legion K300 RGB', N'Tương thích', N'Thiết bị hỗ trợ', N'PC và laptop tương thích', 50),
    (N'Lenovo Legion K300 RGB', N'Tương thích', N'Cài đặt', N'Kết nối với máy tính qua giao tiếp hỗ trợ', 60),
    (N'Lenovo Legion K300 RGB', N'Thiết kế', N'Loại bàn phím', N'Bàn phím gaming', 70),
    (N'Lenovo Legion K300 RGB', N'Thiết kế', N'Đèn nền', N'RGB (5 vùng theo dữ liệu mẫu)', 80),
    (N'Lenovo Legion K300 RGB', N'Kết nối', N'Kiểu kết nối', N'Có dây', 90),
    (N'Lenovo Legion K300 RGB', N'Kết nối', N'Giao tiếp', N'USB-A', 100),
    (N'Lenovo Go Wireless Split Keyboard', N'Thông tin chung', N'Loại sản phẩm', N'Bàn phím máy tính', 10),
    (N'Lenovo Go Wireless Split Keyboard', N'Thông tin chung', N'Bố cục', N'Bàn phím vật lý', 20),
    (N'Lenovo Go Wireless Split Keyboard', N'Thông tin chung', N'Mục đích', N'Nhập liệu và điều khiển máy tính', 30),
    (N'Lenovo Go Wireless Split Keyboard', N'Thông tin chung', N'Phím chức năng', N'Có các phím điều khiển và phím tắt', 40),
    (N'Lenovo Go Wireless Split Keyboard', N'Tương thích', N'Thiết bị hỗ trợ', N'PC và laptop tương thích', 50),
    (N'Lenovo Go Wireless Split Keyboard', N'Tương thích', N'Cài đặt', N'Kết nối với máy tính qua giao tiếp hỗ trợ', 60),
    (N'Lenovo Go Wireless Split Keyboard', N'Thiết kế', N'Loại bàn phím', N'Bàn phím công thái học chia đôi', 70),
    (N'Lenovo Go Wireless Split Keyboard', N'Thiết kế', N'Kiểu thiết kế', N'Split / ergonomic', 110),
    (N'Lenovo Go Wireless Split Keyboard', N'Kết nối', N'Kiểu kết nối', N'Không dây', 90),
    (N'Lenovo Go Wireless Split Keyboard', N'Kết nối', N'Nguồn điện', N'Pin hoặc nguồn phù hợp với phiên bản thiết bị', 120),
    (N'Lenovo 300 FHD Webcam', N'Hình ảnh & video', N'Độ phân giải', N'1920 × 1080 (Full HD)', 10),
    (N'Lenovo 300 FHD Webcam', N'Hình ảnh & video', N'Loại thiết bị', N'Webcam rời', 20),
    (N'Lenovo 300 FHD Webcam', N'Hình ảnh & video', N'Mục đích', N'Họp trực tuyến, học tập và gọi video', 30),
    (N'Lenovo 300 FHD Webcam', N'Tính năng', N'Microphone', N'Tích hợp', 40),
    (N'Lenovo 300 FHD Webcam', N'Tính năng', N'Chân đế', N'Gắn trên màn hình hoặc vị trí phù hợp', 50),
    (N'Lenovo 300 FHD Webcam', N'Tính năng', N'Lấy nét', N'Cơ chế lấy nét tùy mẫu', 60),
    (N'Lenovo 300 FHD Webcam', N'Tương thích', N'Thiết bị hỗ trợ', N'PC/laptop có cổng kết nối phù hợp', 70),
    (N'Lenovo 300 FHD Webcam', N'Tương thích', N'Phần mềm', N'Ứng dụng họp và gọi video hỗ trợ webcam', 80),
    (N'Lenovo 300 FHD Webcam', N'Kết nối', N'Cổng kết nối', N'USB-A (theo dữ liệu mẫu)', 90),
    (N'Lenovo Performance FHD Webcam', N'Hình ảnh & video', N'Độ phân giải', N'1920 × 1080 (Full HD)', 10),
    (N'Lenovo Performance FHD Webcam', N'Hình ảnh & video', N'Loại thiết bị', N'Webcam rời', 20),
    (N'Lenovo Performance FHD Webcam', N'Hình ảnh & video', N'Mục đích', N'Họp trực tuyến, học tập và gọi video', 30),
    (N'Lenovo Performance FHD Webcam', N'Tính năng', N'Microphone', N'Tích hợp', 40),
    (N'Lenovo Performance FHD Webcam', N'Tính năng', N'Chân đế', N'Gắn trên màn hình hoặc vị trí phù hợp', 50),
    (N'Lenovo Performance FHD Webcam', N'Tính năng', N'Lấy nét', N'Cơ chế lấy nét tùy mẫu', 60),
    (N'Lenovo Performance FHD Webcam', N'Tương thích', N'Thiết bị hỗ trợ', N'PC/laptop có cổng kết nối phù hợp', 70),
    (N'Lenovo Performance FHD Webcam', N'Tương thích', N'Phần mềm', N'Ứng dụng họp và gọi video hỗ trợ webcam', 80),
    (N'Lenovo Performance FHD Webcam', N'Kết nối', N'Cổng kết nối', N'USB-C (theo dữ liệu mẫu)', 90),
    (N'Lenovo Laptop Backpack 15.6"', N'Thiết kế', N'Loại sản phẩm', N'Balo đựng laptop', 10),
    (N'Lenovo Laptop Backpack 15.6"', N'Thiết kế', N'Kiểu đeo', N'Hai quai đeo vai', 20),
    (N'Lenovo Laptop Backpack 15.6"', N'Thiết kế', N'Ngăn chứa', N'Ngăn laptop và ngăn phụ kiện', 30),
    (N'Lenovo Laptop Backpack 15.6"', N'Thiết kế', N'Kiểu sử dụng', N'Di chuyển, đi học, đi làm', 40),
    (N'Lenovo Laptop Backpack 15.6"', N'Khả năng sử dụng', N'Bảo vệ thiết bị', N'Ngăn đựng máy tính riêng', 50),
    (N'Lenovo Laptop Backpack 15.6"', N'Khả năng sử dụng', N'Phụ kiện phù hợp', N'Chuột, sạc, cáp và vật dụng cá nhân', 60),
    (N'Lenovo Laptop Backpack 15.6"', N'Khả năng sử dụng', N'Chống nước', N'Khả năng hạn chế thấm tùy vật liệu, không ngâm nước', 70),
    (N'Lenovo Laptop Backpack 15.6"', N'Kích thước & tương thích', N'Kích thước laptop', N'Tối đa 15.6 inch (theo dữ liệu demo)', 80),
    (N'Lenovo Laptop Backpack 15.6"', N'Kích thước & tương thích', N'Khối lượng', N'Khoảng 0.5 kg (theo dữ liệu demo)', 90),
    (N'Lenovo Legion Gaming Backpack', N'Thiết kế', N'Loại sản phẩm', N'Balo đựng laptop', 10),
    (N'Lenovo Legion Gaming Backpack', N'Thiết kế', N'Kiểu đeo', N'Hai quai đeo vai', 20),
    (N'Lenovo Legion Gaming Backpack', N'Thiết kế', N'Ngăn chứa', N'Ngăn laptop và ngăn phụ kiện', 30),
    (N'Lenovo Legion Gaming Backpack', N'Thiết kế', N'Kiểu sử dụng', N'Di chuyển, đi học, đi làm', 40),
    (N'Lenovo Legion Gaming Backpack', N'Khả năng sử dụng', N'Bảo vệ thiết bị', N'Ngăn đựng máy tính riêng', 50),
    (N'Lenovo Legion Gaming Backpack', N'Khả năng sử dụng', N'Phụ kiện phù hợp', N'Chuột, sạc, cáp và vật dụng cá nhân', 60),
    (N'Lenovo Legion Gaming Backpack', N'Khả năng sử dụng', N'Chống nước', N'Khả năng hạn chế thấm tùy vật liệu, không ngâm nước', 70),
    (N'Lenovo Legion Gaming Backpack', N'Kích thước & tương thích', N'Kích thước laptop', N'Tối đa 17 inch (theo dữ liệu demo)', 80),
    (N'Lenovo Legion Gaming Backpack', N'Kích thước & tương thích', N'Khối lượng', N'Khoảng 0.8 kg (theo dữ liệu demo)', 90),
    (N'Apple Watch SE 2', N'Theo dõi sức khỏe', N'Theo dõi nhịp tim', N'Có', 10),
    (N'Apple Watch SE 2', N'Theo dõi sức khỏe', N'Theo dõi vận động', N'Bước chân, bài tập và mức vận động', 20),
    (N'Apple Watch SE 2', N'Theo dõi sức khỏe', N'Theo dõi giấc ngủ', N'Có', 30),
    (N'Apple Watch SE 2', N'Kết nối', N'Định vị', N'GPS', 40),
    (N'Apple Watch SE 2', N'Kết nối', N'Kết nối không dây', N'Bluetooth (và Wi-Fi tùy mẫu)', 50),
    (N'Apple Watch SE 2', N'Kết nối', N'Đồng bộ', N'Thông qua ứng dụng tương thích trên điện thoại', 60),
    (N'Apple Watch SE 2', N'Thiết kế', N'Loại thiết bị', N'Đồng hồ thông minh', 70),
    (N'Apple Watch SE 2', N'Thiết kế', N'Kháng nước', N'Có, theo giới hạn công bố của hãng', 80),
    (N'Apple Watch SE 2', N'Màn hình', N'Công nghệ màn hình', N'Retina OLED', 90),
    (N'Apple Watch SE 2', N'Màn hình', N'Kích thước vỏ', N'40/44 mm (tùy SKU)', 100),
    (N'Apple Watch SE 2', N'Phần mềm', N'Hệ điều hành', N'watchOS', 110),
    (N'Apple Watch SE 2', N'Phần mềm', N'Tương thích', N'iPhone tương thích', 120),
    (N'Apple Watch SE 2', N'Pin và sạc', N'Thời lượng pin', N'Tối đa khoảng 18 giờ (theo Apple)', 130),
    (N'Samsung Galaxy Watch7', N'Theo dõi sức khỏe', N'Theo dõi nhịp tim', N'Có', 10),
    (N'Samsung Galaxy Watch7', N'Theo dõi sức khỏe', N'Theo dõi vận động', N'Bước chân, bài tập và mức vận động', 20),
    (N'Samsung Galaxy Watch7', N'Theo dõi sức khỏe', N'Theo dõi giấc ngủ', N'Có', 30),
    (N'Samsung Galaxy Watch7', N'Kết nối', N'Định vị', N'GPS', 40),
    (N'Samsung Galaxy Watch7', N'Kết nối', N'Kết nối không dây', N'Bluetooth (và Wi-Fi tùy mẫu)', 50),
    (N'Samsung Galaxy Watch7', N'Kết nối', N'Đồng bộ', N'Thông qua ứng dụng tương thích trên điện thoại', 60),
    (N'Samsung Galaxy Watch7', N'Thiết kế', N'Loại thiết bị', N'Đồng hồ thông minh', 70),
    (N'Samsung Galaxy Watch7', N'Thiết kế', N'Kháng nước', N'Có, theo giới hạn công bố của hãng', 80),
    (N'Samsung Galaxy Watch7', N'Màn hình', N'Công nghệ màn hình', N'Super AMOLED', 90),
    (N'Samsung Galaxy Watch7', N'Màn hình', N'Kích thước vỏ', N'40/44 mm (tùy SKU)', 100),
    (N'Samsung Galaxy Watch7', N'Phần mềm', N'Hệ điều hành', N'Wear OS / One UI Watch', 110),
    (N'Samsung Galaxy Watch7', N'Phần mềm', N'Tương thích', N'Điện thoại Android tương thích', 120),
    (N'Samsung Galaxy Watch7', N'Pin và sạc', N'Sạc', N'Sạc không dây', 140),
    (N'Garmin Forerunner 165', N'Theo dõi sức khỏe', N'Theo dõi nhịp tim', N'Có', 10),
    (N'Garmin Forerunner 165', N'Theo dõi sức khỏe', N'Theo dõi vận động', N'Bước chân, bài tập và mức vận động', 20),
    (N'Garmin Forerunner 165', N'Theo dõi sức khỏe', N'Theo dõi giấc ngủ', N'Có', 30),
    (N'Garmin Forerunner 165', N'Kết nối', N'Định vị', N'GPS', 40),
    (N'Garmin Forerunner 165', N'Kết nối', N'Kết nối không dây', N'Bluetooth (và Wi-Fi tùy mẫu)', 50),
    (N'Garmin Forerunner 165', N'Kết nối', N'Đồng bộ', N'Thông qua ứng dụng tương thích trên điện thoại', 60),
    (N'Garmin Forerunner 165', N'Thiết kế', N'Loại thiết bị', N'Đồng hồ thông minh', 70),
    (N'Garmin Forerunner 165', N'Thiết kế', N'Kháng nước', N'Có, theo giới hạn công bố của hãng', 80),
    (N'Garmin Forerunner 165', N'Màn hình', N'Công nghệ màn hình', N'AMOLED', 90),
    (N'Garmin Forerunner 165', N'Màn hình', N'Kích thước màn hình', N'1.2 inch', 150),
    (N'Garmin Forerunner 165', N'Phần mềm', N'Chế độ tập luyện', N'Theo dõi chạy bộ, bài tập gợi ý', 160),
    (N'Garmin Forerunner 165', N'Phần mềm', N'Tương thích', N'Garmin Connect trên điện thoại tương thích', 120),
    (N'Garmin Forerunner 165', N'Pin và sạc', N'Thời lượng pin', N'Tối đa 11 ngày ở chế độ đồng hồ thông minh (theo Garmin)', 130),
    (N'Sony WH-1000XM5', N'Thiết kế', N'Kiểu tai nghe', N'Chụp tai (over-ear)', 10),
    (N'Sony WH-1000XM5', N'Thiết kế', N'Thiết kế', N'Có thể điều chỉnh phần đệm và vòng đầu', 160),
    (N'Sony WH-1000XM5', N'Âm thanh', N'Chống ồn chủ động', N'Có (ANC)', 60),
    (N'Sony WH-1000XM5', N'Âm thanh', N'Microphone', N'Tích hợp, hỗ trợ đàm thoại', 40),
    (N'Sony WH-1000XM5', N'Âm thanh', N'Dải âm', N'Âm thanh stereo', 170),
    (N'Sony WH-1000XM5', N'Kết nối', N'Kết nối chính', N'Bluetooth', 20),
    (N'Sony WH-1000XM5', N'Kết nối', N'Kết nối có dây', N'Cáp âm thanh 3.5 mm', 180),
    (N'Sony WH-1000XM5', N'Kết nối', N'Cổng sạc', N'USB-C', 190),
    (N'Sony WH-1000XM5', N'Điều khiển', N'Chức năng', N'Nghe nhạc, gọi điện, điều chỉnh âm lượng', 200),
    (N'Sony WH-1000XM5', N'Âm thanh', N'Driver', N'30 mm', 210),
    (N'Sony WH-1000XM5', N'Âm thanh', N'Công nghệ chống ồn', N'HD Noise Cancelling Processor QN1, Integrated Processor V1', 220),
    (N'Sony WH-1000XM5', N'Pin và sạc', N'Thời lượng pin', N'Tối đa 30 giờ (bật ANC)', 230),
    (N'Sony WH-1000XM5', N'Kết nối', N'Bluetooth', N'5.2', 90),
    (N'JBL Tune 770NC', N'Thiết kế', N'Kiểu tai nghe', N'Chụp tai (over-ear)', 10),
    (N'JBL Tune 770NC', N'Thiết kế', N'Thiết kế', N'Có thể điều chỉnh phần đệm và vòng đầu', 160),
    (N'JBL Tune 770NC', N'Âm thanh', N'Chống ồn chủ động', N'Có (ANC)', 60),
    (N'JBL Tune 770NC', N'Âm thanh', N'Microphone', N'Tích hợp, hỗ trợ đàm thoại', 40),
    (N'JBL Tune 770NC', N'Âm thanh', N'Dải âm', N'Âm thanh stereo', 170),
    (N'JBL Tune 770NC', N'Kết nối', N'Kết nối chính', N'Bluetooth', 20),
    (N'JBL Tune 770NC', N'Kết nối', N'Kết nối có dây', N'Cáp âm thanh 3.5 mm', 180),
    (N'JBL Tune 770NC', N'Kết nối', N'Cổng sạc', N'USB-C', 190),
    (N'JBL Tune 770NC', N'Điều khiển', N'Chức năng', N'Nghe nhạc, gọi điện, điều chỉnh âm lượng', 200),
    (N'JBL Tune 770NC', N'Âm thanh', N'Công nghệ âm thanh', N'JBL Pure Bass Sound', 240),
    (N'JBL Tune 770NC', N'Âm thanh', N'Chế độ chống ồn', N'Adaptive Noise Cancelling', 250),
    (N'JBL Tune 770NC', N'Kết nối', N'Bluetooth', N'5.3', 90),
    (N'JBL Tune 770NC', N'Kết nối', N'Kết nối đa điểm', N'Có', 260),
    (N'JBL Tune 770NC', N'Pin và sạc', N'Thời lượng pin', N'Tối đa 70 giờ khi tắt ANC', 230),
    (N'JBL Tune 770NC', N'Pin và sạc', N'Sạc nhanh', N'5 phút cho khoảng 3 giờ nghe', 270),
    (N'Canon EOS R50', N'Cảm biến & ảnh', N'Loại máy', N'Máy ảnh mirrorless, ống kính rời', 10),
    (N'Canon EOS R50', N'Cảm biến & ảnh', N'Kích thước cảm biến', N'APS-C', 20),
    (N'Canon EOS R50', N'Cảm biến & ảnh', N'Định dạng ảnh', N'JPEG / RAW', 30),
    (N'Canon EOS R50', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth', 40),
    (N'Canon EOS R50', N'Kết nối', N'Chức năng kết nối', N'Truyền ảnh và điều khiển từ thiết bị tương thích', 50),
    (N'Canon EOS R50', N'Quay video', N'Quay video', N'Có hỗ trợ video độ phân giải cao', 60),
    (N'Canon EOS R50', N'Quay video', N'Microphone', N'Có hỗ trợ ghi âm khi quay video', 70),
    (N'Canon EOS R50', N'Ống kính', N'Bộ ống kính', N'Body hoặc bộ kit theo SKU đã chọn', 80),
    (N'Canon EOS R50', N'Cảm biến & ảnh', N'Độ phân giải hữu dụng', N'24.2 MP', 90),
    (N'Canon EOS R50', N'Cảm biến & ảnh', N'Ngàm ống kính', N'Canon RF / RF-S', 100),
    (N'Canon EOS R50', N'Quay video', N'Độ phân giải video', N'4K UHD', 110),
    (N'Canon EOS R50', N'Lấy nét & chống rung', N'Lấy nét tự động', N'Dual Pixel CMOS AF II', 120),
    (N'Canon EOS R50', N'Lấy nét & chống rung', N'Chống rung', N'Phụ thuộc ống kính và chế độ quay video', 130),
    (N'Sony Alpha A6400', N'Cảm biến & ảnh', N'Loại máy', N'Máy ảnh mirrorless, ống kính rời', 10),
    (N'Sony Alpha A6400', N'Cảm biến & ảnh', N'Kích thước cảm biến', N'APS-C', 20),
    (N'Sony Alpha A6400', N'Cảm biến & ảnh', N'Định dạng ảnh', N'JPEG / RAW', 30),
    (N'Sony Alpha A6400', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth', 40),
    (N'Sony Alpha A6400', N'Kết nối', N'Chức năng kết nối', N'Truyền ảnh và điều khiển từ thiết bị tương thích', 50),
    (N'Sony Alpha A6400', N'Quay video', N'Quay video', N'Có hỗ trợ video độ phân giải cao', 60),
    (N'Sony Alpha A6400', N'Quay video', N'Microphone', N'Có hỗ trợ ghi âm khi quay video', 70),
    (N'Sony Alpha A6400', N'Ống kính', N'Bộ ống kính', N'Body hoặc bộ kit theo SKU đã chọn', 80),
    (N'Sony Alpha A6400', N'Cảm biến & ảnh', N'Độ phân giải hữu dụng', N'24.2 MP', 90),
    (N'Sony Alpha A6400', N'Cảm biến & ảnh', N'Ngàm ống kính', N'Sony E-mount', 100),
    (N'Sony Alpha A6400', N'Quay video', N'Độ phân giải video', N'4K', 110),
    (N'Sony Alpha A6400', N'Lấy nét & chống rung', N'Lấy nét tự động', N'Real-time Tracking / Eye AF', 120),
    (N'Sony Alpha A6400', N'Lấy nét & chống rung', N'Chống rung', N'Không có IBIS trong thân máy', 130),
    (N'Fujifilm X-S20', N'Cảm biến & ảnh', N'Loại máy', N'Máy ảnh mirrorless, ống kính rời', 10),
    (N'Fujifilm X-S20', N'Cảm biến & ảnh', N'Kích thước cảm biến', N'APS-C', 20),
    (N'Fujifilm X-S20', N'Cảm biến & ảnh', N'Định dạng ảnh', N'JPEG / RAW', 30),
    (N'Fujifilm X-S20', N'Kết nối', N'Kết nối không dây', N'Wi-Fi, Bluetooth', 40),
    (N'Fujifilm X-S20', N'Kết nối', N'Chức năng kết nối', N'Truyền ảnh và điều khiển từ thiết bị tương thích', 50),
    (N'Fujifilm X-S20', N'Quay video', N'Quay video', N'Có hỗ trợ video độ phân giải cao', 60),
    (N'Fujifilm X-S20', N'Quay video', N'Microphone', N'Có hỗ trợ ghi âm khi quay video', 70),
    (N'Fujifilm X-S20', N'Ống kính', N'Bộ ống kính', N'Body hoặc bộ kit theo SKU đã chọn', 80),
    (N'Fujifilm X-S20', N'Cảm biến & ảnh', N'Độ phân giải hữu dụng', N'26.1 MP', 90),
    (N'Fujifilm X-S20', N'Cảm biến & ảnh', N'Loại cảm biến', N'X-Trans CMOS 4', 140),
    (N'Fujifilm X-S20', N'Cảm biến & ảnh', N'Ngàm ống kính', N'Fujifilm X-mount', 100),
    (N'Fujifilm X-S20', N'Quay video', N'Độ phân giải video', N'Tối đa 6.2K 30p', 110),
    (N'Fujifilm X-S20', N'Lấy nét & chống rung', N'Chống rung', N'IBIS trong thân máy', 130),
    (N'Fujifilm X-S20', N'Lấy nét & chống rung', N'Lấy nét tự động', N'Lấy nét tự động nhận diện chủ thể', 120);
GO

-- Validation: fail clearly instead of silently doing an incomplete 39-product seed.
BEGIN TRY
IF (SELECT COUNT(DISTINCT product_name) FROM #SpecSeed) <> 39
    THROW 56002, N'Seed phai du 39 product_name.', 1;
IF EXISTS (
    SELECT 1 FROM (SELECT DISTINCT product_name FROM #SpecSeed) s
    OUTER APPLY (SELECT COUNT(*) n FROM dbo.PRODUCT p WHERE p.product_name = s.product_name) c
    WHERE c.n <> 1
)
    THROW 56003, N'Product khong ton tai hoac trung ten. Kiem tra bang PRODUCT.', 1;
IF EXISTS (
    SELECT 1 FROM (SELECT DISTINCT attribute_name FROM #SpecSeed) s
    OUTER APPLY (SELECT COUNT(*) n FROM dbo.ATTRIBUTE a WHERE a.attribute_name = s.attribute_name) c
    WHERE c.n > 1
)
    THROW 56004, N'Bang ATTRIBUTE co ten thuoc tinh trung. Can xu ly truoc.', 1;
IF EXISTS (
    SELECT 1 FROM dbo.PRODUCT p JOIN #SpecSeed x ON x.product_name = p.product_name
    GROUP BY p.category_id, x.attribute_name
    HAVING COUNT(DISTINCT x.group_name) > 1
)
    THROW 56005, N'Mot category/attribute duoc gan nhieu group_name.', 1;

 BEGIN TRANSACTION;

 -- 1. Register new spec attributes only; existing Attribute rows are retained.
 INSERT INTO dbo.ATTRIBUTE(attribute_name)
 SELECT DISTINCT x.attribute_name FROM #SpecSeed x
 WHERE NOT EXISTS (
     SELECT 1 FROM dbo.ATTRIBUTE a WITH (UPDLOCK, HOLDLOCK)
     WHERE a.attribute_name = x.attribute_name
 );

 -- 2. Register category-specific display groups. Do not change VARIANT/BOTH configs.
 ;WITH need_config AS (
   SELECT p.category_id, a.attribute_id,
          MIN(x.group_name) AS group_name,
          MIN(x.display_order) AS display_order
   FROM #SpecSeed x
   JOIN dbo.PRODUCT p ON p.product_name = x.product_name
   JOIN dbo.ATTRIBUTE a ON a.attribute_name = x.attribute_name
   GROUP BY p.category_id,a.attribute_id
 )
 INSERT INTO dbo.CATEGORY_ATTRIBUTE
   (category_id,attribute_id,group_name,attribute_type,is_required,is_filterable,display_order)
 SELECT k.category_id,k.attribute_id,k.group_name,'SPECIFICATION',0,0,k.display_order
 FROM need_config k
 WHERE NOT EXISTS (
    SELECT 1 FROM dbo.CATEGORY_ATTRIBUTE ca WITH (UPDLOCK,HOLDLOCK)
    WHERE ca.category_id=k.category_id AND ca.attribute_id=k.attribute_id
 );

 -- 3. Add only missing product specifications. All current values are preserved.
 INSERT INTO dbo.PRODUCT_SPECIFICATION(product_id,attribute_id,value)
 SELECT p.product_id,a.attribute_id,x.spec_value
 FROM #SpecSeed x
 JOIN dbo.PRODUCT p ON p.product_name=x.product_name
 JOIN dbo.ATTRIBUTE a ON a.attribute_name=x.attribute_name
 WHERE NOT EXISTS (
   SELECT 1 FROM dbo.PRODUCT_SPECIFICATION ps WITH (UPDLOCK,HOLDLOCK)
   WHERE ps.product_id=p.product_id AND ps.attribute_id=a.attribute_id
 );

 COMMIT TRANSACTION;
END TRY
BEGIN CATCH
 IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
 THROW;
END CATCH;
GO

-- 39 product report (includes specs already present before this script)
SELECT p.product_id,p.product_name,c.category_name,
       COUNT(ps.attribute_id) AS specification_count
FROM dbo.PRODUCT p
JOIN dbo.CATEGORY c ON c.category_id=p.category_id
LEFT JOIN dbo.PRODUCT_SPECIFICATION ps ON ps.product_id=p.product_id
WHERE p.product_name IN (SELECT DISTINCT product_name FROM #SpecSeed)
GROUP BY p.product_id,p.product_name,c.category_name
ORDER BY p.product_id;
GO

SELECT COUNT(*) AS products_covered,
       MIN(n.spec_count) AS min_specs,
       MAX(n.spec_count) AS max_specs,
       SUM(n.spec_count) AS all_product_specs
FROM (
 SELECT p.product_id,COUNT(ps.attribute_id) AS spec_count
 FROM dbo.PRODUCT p
 JOIN (SELECT DISTINCT product_name FROM #SpecSeed) x ON x.product_name=p.product_name
 LEFT JOIN dbo.PRODUCT_SPECIFICATION ps ON ps.product_id=p.product_id
 GROUP BY p.product_id
) n;
GO

DROP TABLE #SpecSeed;
GO
PRINT N'OECS - specifications seed for 39 products completed.';
GO
