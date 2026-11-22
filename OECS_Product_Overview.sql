/* OECS V2 - OVERVIEW CONTENT FOR 39 PRODUCTS
   SQL SERVER 2022 | ADDITIVE, REPEATABLE | NO PRODUCT / SKU DELETE
   3 EDITORIAL SECTIONS PER PRODUCT (117). Product names matched exactly.
   No product image URLs are invented. Add licensed/owned images later.
   Some component specifications are based on OECS demo records; confirm
   exact model/MTM before real-world commerce. Test on database backup.
*/
USE OECS;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF OBJECT_ID(N'dbo.PRODUCT',N'U') IS NULL
    THROW 57001,N'Missing dbo.PRODUCT. Initialize OECS first.',1;
GO

IF OBJECT_ID(N'dbo.PRODUCT_CONTENT_SECTION',N'U') IS NULL
BEGIN
  CREATE TABLE dbo.PRODUCT_CONTENT_SECTION (
    section_id INT IDENTITY(1,1) NOT NULL
      CONSTRAINT PK_PRODUCT_CONTENT_SECTION PRIMARY KEY,
    product_id INT NOT NULL,
    section_key VARCHAR(40) NOT NULL,
    section_title NVARCHAR(160) NOT NULL,
    section_content NVARCHAR(1500) NOT NULL,
    image_url NVARCHAR(500) NULL,
    image_alt NVARCHAR(200) NULL,
    display_order INT NOT NULL
      CONSTRAINT DF_PRODUCT_CONTENT_ORDER DEFAULT (0),
    is_active BIT NOT NULL
      CONSTRAINT DF_PRODUCT_CONTENT_ACTIVE DEFAULT (1),
    created_at DATETIME2(3) NOT NULL
      CONSTRAINT DF_PRODUCT_CONTENT_CREATED DEFAULT SYSDATETIME(),
    updated_at DATETIME2(3) NULL,
    CONSTRAINT FK_PRODUCT_CONTENT_PRODUCT
      FOREIGN KEY (product_id) REFERENCES dbo.PRODUCT(product_id),
    CONSTRAINT UQ_PRODUCT_CONTENT_KEY UNIQUE(product_id,section_key),
    CONSTRAINT CK_PRODUCT_CONTENT_ORDER CHECK (display_order>=0),
    CONSTRAINT CK_PRODUCT_CONTENT_TITLE CHECK(LEN(LTRIM(RTRIM(section_title)))>0),
    CONSTRAINT CK_PRODUCT_CONTENT_BODY CHECK(LEN(LTRIM(RTRIM(section_content)))>0)
  );
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE object_id=OBJECT_ID(N'dbo.PRODUCT_CONTENT_SECTION')
      AND name=N'IX_PRODUCT_CONTENT_ACTIVE_ORDER'
)
  CREATE INDEX IX_PRODUCT_CONTENT_ACTIVE_ORDER
  ON dbo.PRODUCT_CONTENT_SECTION(product_id,is_active,display_order,section_id);
GO

CREATE TABLE #OverviewSeed(
  product_name NVARCHAR(255) NOT NULL,
  section_key VARCHAR(40) NOT NULL,
  section_title NVARCHAR(160) NOT NULL,
  section_content NVARCHAR(1500) NOT NULL,
  display_order INT NOT NULL,
  CONSTRAINT PK_OverviewSeed PRIMARY KEY(product_name,section_key)
);

INSERT INTO #OverviewSeed(product_name,section_key,section_title,section_content,display_order)
VALUES
  (N'iPhone 15 Pro', 'display', N'Màn hình mượt và rõ nét', N'iPhone 15 Pro sử dụng Super Retina XDR OLED, phù hợp cho việc xem nội dung, đọc tài liệu và sử dụng ứng dụng hằng ngày. Tần số quét ProMotion thích ứng đến 120 Hz giúp các thao tác cuộn và chuyển cảnh mượt mà.', 10),
  (N'iPhone 15 Pro', 'camera', N'Camera cho nhiều khoảnh khắc', N'Cụm camera của máy gồm 48 MP chính + 12 MP siêu rộng + 12 MP tele. Người dùng có thể chuyển giữa các góc chụp phù hợp với chân dung, phong cảnh và nhu cầu ghi lại hoạt động thường ngày.', 20),
  (N'iPhone 15 Pro', 'daily', N'Kết nối và trải nghiệm', N'Thiết bị hỗ trợ kết nối 5G cùng các chuẩn không dây hiện đại. Thông tin pin: Lên đến 23 giờ (theo Apple). Dung lượng bộ nhớ và màu sắc thay đổi theo SKU bạn lựa chọn ở phía trên.', 30),
  (N'iPhone 15 Pro Max', 'display', N'Màn hình mượt và rõ nét', N'iPhone 15 Pro Max sử dụng Super Retina XDR OLED, phù hợp cho việc xem nội dung, đọc tài liệu và sử dụng ứng dụng hằng ngày. Tần số quét ProMotion thích ứng đến 120 Hz giúp các thao tác cuộn và chuyển cảnh mượt mà.', 10),
  (N'iPhone 15 Pro Max', 'camera', N'Camera cho nhiều khoảnh khắc', N'Cụm camera của máy gồm 48 MP chính + 12 MP siêu rộng + 12 MP tele. Người dùng có thể chuyển giữa các góc chụp phù hợp với chân dung, phong cảnh và nhu cầu ghi lại hoạt động thường ngày.', 20),
  (N'iPhone 15 Pro Max', 'daily', N'Kết nối và trải nghiệm', N'Thiết bị hỗ trợ kết nối 5G cùng các chuẩn không dây hiện đại. Thông tin pin: Lên đến 29 giờ (theo Apple). Dung lượng bộ nhớ và màu sắc thay đổi theo SKU bạn lựa chọn ở phía trên.', 30),
  (N'iPhone 16 Pro', 'display', N'Màn hình mượt và rõ nét', N'iPhone 16 Pro sử dụng Super Retina XDR OLED, phù hợp cho việc xem nội dung, đọc tài liệu và sử dụng ứng dụng hằng ngày. Tần số quét ProMotion thích ứng đến 120 Hz giúp các thao tác cuộn và chuyển cảnh mượt mà.', 10),
  (N'iPhone 16 Pro', 'camera', N'Camera cho nhiều khoảnh khắc', N'Cụm camera của máy gồm 48 MP chính + 48 MP siêu rộng + 12 MP tele. Người dùng có thể chuyển giữa các góc chụp phù hợp với chân dung, phong cảnh và nhu cầu ghi lại hoạt động thường ngày.', 20),
  (N'iPhone 16 Pro', 'daily', N'Kết nối và trải nghiệm', N'Thiết bị hỗ trợ kết nối 5G cùng các chuẩn không dây hiện đại. Thông tin pin: Lên đến 27 giờ (theo Apple). Dung lượng bộ nhớ và màu sắc thay đổi theo SKU bạn lựa chọn ở phía trên.', 30),
  (N'iPhone 16 Pro Max', 'display', N'Màn hình mượt và rõ nét', N'iPhone 16 Pro Max sử dụng Super Retina XDR OLED, phù hợp cho việc xem nội dung, đọc tài liệu và sử dụng ứng dụng hằng ngày. Tần số quét ProMotion thích ứng đến 120 Hz giúp các thao tác cuộn và chuyển cảnh mượt mà.', 10),
  (N'iPhone 16 Pro Max', 'camera', N'Camera cho nhiều khoảnh khắc', N'Cụm camera của máy gồm 48 MP chính + 48 MP siêu rộng + 12 MP tele. Người dùng có thể chuyển giữa các góc chụp phù hợp với chân dung, phong cảnh và nhu cầu ghi lại hoạt động thường ngày.', 20),
  (N'iPhone 16 Pro Max', 'daily', N'Kết nối và trải nghiệm', N'Thiết bị hỗ trợ kết nối 5G cùng các chuẩn không dây hiện đại. Thông tin pin: Lên đến 33 giờ (theo Apple). Dung lượng bộ nhớ và màu sắc thay đổi theo SKU bạn lựa chọn ở phía trên.', 30),
  (N'Samsung Galaxy S24 Ultra', 'display', N'Màn hình mượt và rõ nét', N'Samsung Galaxy S24 Ultra sử dụng Dynamic AMOLED 2X, phù hợp cho việc xem nội dung, đọc tài liệu và sử dụng ứng dụng hằng ngày. Tần số quét Lên đến 120 Hz giúp các thao tác cuộn và chuyển cảnh mượt mà.', 10),
  (N'Samsung Galaxy S24 Ultra', 'camera', N'Camera cho nhiều khoảnh khắc', N'Cụm camera của máy gồm 200 MP chính + 12 MP siêu rộng + 50 MP tele 5x + 10 MP tele 3x. Người dùng có thể chuyển giữa các góc chụp phù hợp với chân dung, phong cảnh và nhu cầu ghi lại hoạt động thường ngày.', 20),
  (N'Samsung Galaxy S24 Ultra', 'daily', N'Kết nối và trải nghiệm', N'Thiết bị hỗ trợ kết nối 5G cùng các chuẩn không dây hiện đại. Thông tin pin: 5.000 mAh. Dung lượng bộ nhớ và màu sắc thay đổi theo SKU bạn lựa chọn ở phía trên.', 30),
  (N'Samsung Galaxy S24 Plus', 'display', N'Màn hình mượt và rõ nét', N'Samsung Galaxy S24 Plus sử dụng Dynamic AMOLED 2X, phù hợp cho việc xem nội dung, đọc tài liệu và sử dụng ứng dụng hằng ngày. Tần số quét Lên đến 120 Hz giúp các thao tác cuộn và chuyển cảnh mượt mà.', 10),
  (N'Samsung Galaxy S24 Plus', 'camera', N'Camera cho nhiều khoảnh khắc', N'Cụm camera của máy gồm 50 MP chính + 12 MP siêu rộng + 10 MP tele. Người dùng có thể chuyển giữa các góc chụp phù hợp với chân dung, phong cảnh và nhu cầu ghi lại hoạt động thường ngày.', 20),
  (N'Samsung Galaxy S24 Plus', 'daily', N'Kết nối và trải nghiệm', N'Thiết bị hỗ trợ kết nối 5G cùng các chuẩn không dây hiện đại. Thông tin pin: 4.900 mAh. Dung lượng bộ nhớ và màu sắc thay đổi theo SKU bạn lựa chọn ở phía trên.', 30),
  (N'Samsung Galaxy A55 5G', 'display', N'Màn hình mượt và rõ nét', N'Samsung Galaxy A55 5G sử dụng Super AMOLED, phù hợp cho việc xem nội dung, đọc tài liệu và sử dụng ứng dụng hằng ngày. Tần số quét Lên đến 120 Hz giúp các thao tác cuộn và chuyển cảnh mượt mà.', 10),
  (N'Samsung Galaxy A55 5G', 'camera', N'Camera cho nhiều khoảnh khắc', N'Cụm camera của máy gồm 50 MP chính + 12 MP siêu rộng + 5 MP macro. Người dùng có thể chuyển giữa các góc chụp phù hợp với chân dung, phong cảnh và nhu cầu ghi lại hoạt động thường ngày.', 20),
  (N'Samsung Galaxy A55 5G', 'daily', N'Kết nối và trải nghiệm', N'Thiết bị hỗ trợ kết nối 5G cùng các chuẩn không dây hiện đại. Thông tin pin: 5.000 mAh. Dung lượng bộ nhớ và màu sắc thay đổi theo SKU bạn lựa chọn ở phía trên.', 30),
  (N'Samsung Galaxy A35 5G', 'display', N'Màn hình mượt và rõ nét', N'Samsung Galaxy A35 5G sử dụng Super AMOLED, phù hợp cho việc xem nội dung, đọc tài liệu và sử dụng ứng dụng hằng ngày. Tần số quét Lên đến 120 Hz giúp các thao tác cuộn và chuyển cảnh mượt mà.', 10),
  (N'Samsung Galaxy A35 5G', 'camera', N'Camera cho nhiều khoảnh khắc', N'Cụm camera của máy gồm 50 MP chính + 8 MP siêu rộng + 5 MP macro. Người dùng có thể chuyển giữa các góc chụp phù hợp với chân dung, phong cảnh và nhu cầu ghi lại hoạt động thường ngày.', 20),
  (N'Samsung Galaxy A35 5G', 'daily', N'Kết nối và trải nghiệm', N'Thiết bị hỗ trợ kết nối 5G cùng các chuẩn không dây hiện đại. Thông tin pin: 5.000 mAh. Dung lượng bộ nhớ và màu sắc thay đổi theo SKU bạn lựa chọn ở phía trên.', 30),
  (N'AirPods Pro 2', 'audio', N'Trải nghiệm âm thanh', N'AirPods Pro 2 phục vụ nhu cầu nghe nhạc, xem phim và gọi điện. Hỗ trợ chống ồn chủ động: Có (ANC). Chất lượng âm thanh thực tế còn phụ thuộc nguồn phát và cách đeo.', 10),
  (N'AirPods Pro 2', 'connect', N'Kết nối tiện lợi', N'Kết nối chính: Bluetooth. Thiết kế và thao tác điều khiển được tối ưu cho việc sử dụng cùng thiết bị tương thích trong sinh hoạt hằng ngày.', 20),
  (N'AirPods Pro 2', 'battery', N'Pin và sử dụng', N'Thông tin thời lượng: Lên đến 6 giờ mỗi lần sạc (ANC bật). Khi lựa chọn phiên bản, hãy lưu ý khác biệt về chống ồn hoặc phụ kiện đi kèm nếu có.', 30),
  (N'AirPods 4', 'audio', N'Trải nghiệm âm thanh', N'AirPods 4 phục vụ nhu cầu nghe nhạc, xem phim và gọi điện. Hỗ trợ chống ồn chủ động: Tùy SKU: bản thường hoặc bản ANC. Chất lượng âm thanh thực tế còn phụ thuộc nguồn phát và cách đeo.', 10),
  (N'AirPods 4', 'connect', N'Kết nối tiện lợi', N'Kết nối chính: Bluetooth. Thiết kế và thao tác điều khiển được tối ưu cho việc sử dụng cùng thiết bị tương thích trong sinh hoạt hằng ngày.', 20),
  (N'AirPods 4', 'battery', N'Pin và sử dụng', N'Thông tin thời lượng: Lên đến 5 giờ/bản thường; bản ANC tùy chế độ. Khi lựa chọn phiên bản, hãy lưu ý khác biệt về chống ồn hoặc phụ kiện đi kèm nếu có.', 30),
  (N'Samsung Galaxy Buds3 Pro', 'audio', N'Trải nghiệm âm thanh', N'Samsung Galaxy Buds3 Pro phục vụ nhu cầu nghe nhạc, xem phim và gọi điện. Hỗ trợ chống ồn chủ động: Có (ANC). Chất lượng âm thanh thực tế còn phụ thuộc nguồn phát và cách đeo.', 10),
  (N'Samsung Galaxy Buds3 Pro', 'connect', N'Kết nối tiện lợi', N'Kết nối chính: Bluetooth. Thiết kế và thao tác điều khiển được tối ưu cho việc sử dụng cùng thiết bị tương thích trong sinh hoạt hằng ngày.', 20),
  (N'Samsung Galaxy Buds3 Pro', 'battery', N'Pin và sử dụng', N'Thông tin thời lượng: Lên đến 6 giờ (bật ANC, tùy điều kiện). Khi lựa chọn phiên bản, hãy lưu ý khác biệt về chống ồn hoặc phụ kiện đi kèm nếu có.', 30),
  (N'Samsung Galaxy Buds FE', 'audio', N'Trải nghiệm âm thanh', N'Samsung Galaxy Buds FE phục vụ nhu cầu nghe nhạc, xem phim và gọi điện. Hỗ trợ chống ồn chủ động: Có (ANC). Chất lượng âm thanh thực tế còn phụ thuộc nguồn phát và cách đeo.', 10),
  (N'Samsung Galaxy Buds FE', 'connect', N'Kết nối tiện lợi', N'Kết nối chính: Bluetooth. Thiết kế và thao tác điều khiển được tối ưu cho việc sử dụng cùng thiết bị tương thích trong sinh hoạt hằng ngày.', 20),
  (N'Samsung Galaxy Buds FE', 'battery', N'Pin và sử dụng', N'Thông tin thời lượng: Lên đến 6 giờ (bật ANC, tùy điều kiện). Khi lựa chọn phiên bản, hãy lưu ý khác biệt về chống ồn hoặc phụ kiện đi kèm nếu có.', 30),
  (N'Apple USB-C 20W Power Adapter', 'power', N'Nguồn điện phù hợp', N'Apple USB-C 20W Power Adapter là bộ tiếp hợp nguồn với công suất tối đa 20 W, hỗ trợ USB Power Delivery (PD). Tốc độ sạc thực tế được quyết định bởi cả thiết bị, dây cáp và bộ sạc.', 10),
  (N'Apple USB-C 20W Power Adapter', 'connect', N'Một cổng USB-C tiện dụng', N'Thiết kế một cổng USB-C giúp kết nối nhanh với dây cáp tương thích. Trước khi dùng, cần kiểm tra thiết bị nhận nguồn và chuẩn sạc được hỗ trợ.', 20),
  (N'Apple USB-C 20W Power Adapter', 'daily', N'Sử dụng hằng ngày', N'Thích hợp đặt tại bàn học, bàn làm việc hoặc mang theo. Hãy sử dụng cáp đạt chuẩn và tránh môi trường ẩm ướt để duy trì độ ổn định.', 30),
  (N'Samsung 25W USB-C Fast Charger', 'power', N'Nguồn điện phù hợp', N'Samsung 25W USB-C Fast Charger là bộ tiếp hợp nguồn với công suất tối đa 25 W, hỗ trợ USB PD PPS / Samsung Super Fast Charging. Tốc độ sạc thực tế được quyết định bởi cả thiết bị, dây cáp và bộ sạc.', 10),
  (N'Samsung 25W USB-C Fast Charger', 'connect', N'Một cổng USB-C tiện dụng', N'Thiết kế một cổng USB-C giúp kết nối nhanh với dây cáp tương thích. Trước khi dùng, cần kiểm tra thiết bị nhận nguồn và chuẩn sạc được hỗ trợ.', 20),
  (N'Samsung 25W USB-C Fast Charger', 'daily', N'Sử dụng hằng ngày', N'Thích hợp đặt tại bàn học, bàn làm việc hoặc mang theo. Hãy sử dụng cáp đạt chuẩn và tránh môi trường ẩm ướt để duy trì độ ổn định.', 30),
  (N'Apple USB-C Charge Cable 1m', 'connect', N'Chuẩn đầu nối rõ ràng', N'Apple USB-C Charge Cable 1m sử dụng đầu nối USB-C sang USB-C. Kiểm tra cổng thiết bị và bộ sạc trước khi chọn để tránh mua nhầm loại cáp.', 10),
  (N'Apple USB-C Charge Cable 1m', 'daily', N'Sạc và truyền dữ liệu', N'Dây cáp hỗ trợ kết nối thiết bị với bộ sạc hoặc máy tính phù hợp. Công suất và tốc độ truyền có thể bị giới hạn bởi chuẩn thiết bị, bộ sạc hoặc phiên bản cáp.', 20),
  (N'Apple USB-C Charge Cable 1m', 'design', N'Tiện dụng khi mang theo', N'Thiết kế dây cáp phù hợp nhu cầu sinh hoạt, học tập và làm việc. Tránh bẻ gập mạnh tại hai đầu nối và hạn chế kéo căng trong khi sử dụng.', 30),
  (N'Apple USB-C to Lightning Cable', 'connect', N'Chuẩn đầu nối rõ ràng', N'Apple USB-C to Lightning Cable sử dụng đầu nối USB-C sang Lightning. Kiểm tra cổng thiết bị và bộ sạc trước khi chọn để tránh mua nhầm loại cáp.', 10),
  (N'Apple USB-C to Lightning Cable', 'daily', N'Sạc và truyền dữ liệu', N'Dây cáp hỗ trợ kết nối thiết bị với bộ sạc hoặc máy tính phù hợp. Công suất và tốc độ truyền có thể bị giới hạn bởi chuẩn thiết bị, bộ sạc hoặc phiên bản cáp.', 20),
  (N'Apple USB-C to Lightning Cable', 'design', N'Tiện dụng khi mang theo', N'Thiết kế dây cáp phù hợp nhu cầu sinh hoạt, học tập và làm việc. Tránh bẻ gập mạnh tại hai đầu nối và hạn chế kéo căng trong khi sử dụng.', 30),
  (N'Samsung USB-C Cable 1m', 'connect', N'Chuẩn đầu nối rõ ràng', N'Samsung USB-C Cable 1m sử dụng đầu nối USB-C sang USB-C. Kiểm tra cổng thiết bị và bộ sạc trước khi chọn để tránh mua nhầm loại cáp.', 10),
  (N'Samsung USB-C Cable 1m', 'daily', N'Sạc và truyền dữ liệu', N'Dây cáp hỗ trợ kết nối thiết bị với bộ sạc hoặc máy tính phù hợp. Công suất và tốc độ truyền có thể bị giới hạn bởi chuẩn thiết bị, bộ sạc hoặc phiên bản cáp.', 20),
  (N'Samsung USB-C Cable 1m', 'design', N'Tiện dụng khi mang theo', N'Thiết kế dây cáp phù hợp nhu cầu sinh hoạt, học tập và làm việc. Tránh bẻ gập mạnh tại hai đầu nối và hạn chế kéo căng trong khi sử dụng.', 30),
  (N'Lenovo IdeaPad Slim 3', 'display', N'Không gian hiển thị', N'Màn hình 15.6 inch với độ phân giải Full HD giúp quan sát nội dung thuận tiện khi làm việc hay giải trí.', 10),
  (N'Lenovo IdeaPad Slim 3', 'performance', N'Hiệu năng theo cấu hình', N'Lenovo IdeaPad Slim 3 phù hợp với nhu cầu học tập, công việc văn phòng và các tác vụ hàng ngày. CPU tham khảo của cấu hình demo: Intel Core i3-1315U (theo cấu hình demo). RAM và SSD cần xem theo SKU thực tế, không mặc định mọi phiên bản có cùng cấu hình.', 20),
  (N'Lenovo IdeaPad Slim 3', 'connect', N'Kết nối và tính tiện dụng', N'Máy có webcam, loa và microphone tích hợp. Các cổng USB/HDMI, chuẩn Wi-Fi và Bluetooth phụ thuộc phiên bản máy; khi chọn mua nên đối chiếu mã cấu hình chính xác.', 30),
  (N'Lenovo ThinkBook 14', 'display', N'Không gian hiển thị', N'Màn hình 14 inch với độ phân giải WUXGA giúp quan sát nội dung thuận tiện khi làm việc hay giải trí.', 10),
  (N'Lenovo ThinkBook 14', 'performance', N'Hiệu năng theo cấu hình', N'Lenovo ThinkBook 14 phù hợp với nhu cầu học tập, công việc văn phòng và các tác vụ hàng ngày. CPU tham khảo của cấu hình demo: Intel Core i5-1335U (theo cấu hình demo). RAM và SSD cần xem theo SKU thực tế, không mặc định mọi phiên bản có cùng cấu hình.', 20),
  (N'Lenovo ThinkBook 14', 'connect', N'Kết nối và tính tiện dụng', N'Máy có webcam, loa và microphone tích hợp. Các cổng USB/HDMI, chuẩn Wi-Fi và Bluetooth phụ thuộc phiên bản máy; khi chọn mua nên đối chiếu mã cấu hình chính xác.', 30),
  (N'Lenovo IdeaPad 5', 'display', N'Không gian hiển thị', N'Màn hình 15.6 inch với độ phân giải Full HD giúp quan sát nội dung thuận tiện khi làm việc hay giải trí.', 10),
  (N'Lenovo IdeaPad 5', 'performance', N'Hiệu năng theo cấu hình', N'Lenovo IdeaPad 5 phù hợp với nhu cầu học tập, công việc văn phòng và các tác vụ hàng ngày. CPU tham khảo của cấu hình demo: AMD Ryzen 5 7530U (theo cấu hình demo). RAM và SSD cần xem theo SKU thực tế, không mặc định mọi phiên bản có cùng cấu hình.', 20),
  (N'Lenovo IdeaPad 5', 'connect', N'Kết nối và tính tiện dụng', N'Máy có webcam, loa và microphone tích hợp. Các cổng USB/HDMI, chuẩn Wi-Fi và Bluetooth phụ thuộc phiên bản máy; khi chọn mua nên đối chiếu mã cấu hình chính xác.', 30),
  (N'Lenovo LOQ 15', 'display', N'Không gian hiển thị', N'Màn hình 15.6 inch với độ phân giải Full HD, tần số quét 144 Hz giúp quan sát nội dung thuận tiện khi làm việc hay giải trí.', 10),
  (N'Lenovo LOQ 15', 'performance', N'Hiệu năng theo cấu hình', N'Lenovo LOQ 15 phù hợp với nhu cầu chơi game, giải trí và xử lý công việc nặng. CPU tham khảo của cấu hình demo: Intel Core i5-13420H (theo cấu hình demo). GPU tham khảo: NVIDIA GeForce RTX 4050 6 GB (cấu hình demo). RAM và SSD cần xem theo SKU thực tế, không mặc định mọi phiên bản có cùng cấu hình.', 20),
  (N'Lenovo LOQ 15', 'connect', N'Kết nối và tính tiện dụng', N'Máy có webcam, loa và microphone tích hợp. Các cổng USB/HDMI, chuẩn Wi-Fi và Bluetooth phụ thuộc phiên bản máy; khi chọn mua nên đối chiếu mã cấu hình chính xác.', 30),
  (N'Lenovo Legion 5', 'display', N'Không gian hiển thị', N'Màn hình 15.6 inch với độ phân giải WQHD, tần số quét 165 Hz giúp quan sát nội dung thuận tiện khi làm việc hay giải trí.', 10),
  (N'Lenovo Legion 5', 'performance', N'Hiệu năng theo cấu hình', N'Lenovo Legion 5 phù hợp với nhu cầu chơi game, giải trí và xử lý công việc nặng. CPU tham khảo của cấu hình demo: AMD Ryzen 7 7735HS (theo cấu hình demo). GPU tham khảo: NVIDIA GeForce RTX 4060 8 GB (cấu hình demo). RAM và SSD cần xem theo SKU thực tế, không mặc định mọi phiên bản có cùng cấu hình.', 20),
  (N'Lenovo Legion 5', 'connect', N'Kết nối và tính tiện dụng', N'Máy có webcam, loa và microphone tích hợp. Các cổng USB/HDMI, chuẩn Wi-Fi và Bluetooth phụ thuộc phiên bản máy; khi chọn mua nên đối chiếu mã cấu hình chính xác.', 30),
  (N'Lenovo Legion Pro 5', 'display', N'Không gian hiển thị', N'Màn hình 16 inch với độ phân giải WQXGA, tần số quét 240 Hz giúp quan sát nội dung thuận tiện khi làm việc hay giải trí.', 10),
  (N'Lenovo Legion Pro 5', 'performance', N'Hiệu năng theo cấu hình', N'Lenovo Legion Pro 5 phù hợp với nhu cầu chơi game, giải trí và xử lý công việc nặng. CPU tham khảo của cấu hình demo: Intel Core i9-14900HX (theo cấu hình demo). GPU tham khảo: NVIDIA GeForce RTX 4070 8 GB (cấu hình demo). RAM và SSD cần xem theo SKU thực tế, không mặc định mọi phiên bản có cùng cấu hình.', 20),
  (N'Lenovo Legion Pro 5', 'connect', N'Kết nối và tính tiện dụng', N'Máy có webcam, loa và microphone tích hợp. Các cổng USB/HDMI, chuẩn Wi-Fi và Bluetooth phụ thuộc phiên bản máy; khi chọn mua nên đối chiếu mã cấu hình chính xác.', 30),
  (N'Lenovo Legion M300 RGB', 'design', N'Thiết kế phục vụ thao tác', N'Lenovo Legion M300 RGB được thiết kế cho thao tác với máy tính và laptop. Bố trí và kiểu dáng phù hợp loại thiết bị, hỗ trợ công việc hoặc giải trí hằng ngày.', 10),
  (N'Lenovo Legion M300 RGB', 'performance', N'Khả năng điều khiển', N'Thông số nổi bật: 8.000 DPI (theo dữ liệu mẫu). Hãy chọn phiên bản theo nhu cầu và môi trường sử dụng.', 20),
  (N'Lenovo Legion M300 RGB', 'connect', N'Kết nối với máy tính', N'Kiểu kết nối: Có dây. Đối chiếu hệ điều hành, bộ thu hoặc cổng kết nối trước khi mua để bảo đảm tương thích.', 30),
  (N'Lenovo Legion M600 Wireless', 'design', N'Thiết kế phục vụ thao tác', N'Lenovo Legion M600 Wireless được thiết kế cho thao tác với máy tính và laptop. Bố trí và kiểu dáng phù hợp loại thiết bị, hỗ trợ công việc hoặc giải trí hằng ngày.', 10),
  (N'Lenovo Legion M600 Wireless', 'performance', N'Khả năng điều khiển', N'Thông số nổi bật: 16.000 DPI (theo dữ liệu mẫu). Hãy chọn phiên bản theo nhu cầu và môi trường sử dụng.', 20),
  (N'Lenovo Legion M600 Wireless', 'connect', N'Kết nối với máy tính', N'Kiểu kết nối: Không dây. Đối chiếu hệ điều hành, bộ thu hoặc cổng kết nối trước khi mua để bảo đảm tương thích.', 30),
  (N'Lenovo Legion K300 RGB', 'design', N'Thiết kế phục vụ thao tác', N'Lenovo Legion K300 RGB được thiết kế cho thao tác với máy tính và laptop. Bố trí và kiểu dáng phù hợp loại thiết bị, hỗ trợ công việc hoặc giải trí hằng ngày.', 10),
  (N'Lenovo Legion K300 RGB', 'performance', N'Khả năng điều khiển', N'Thông số nổi bật: RGB (5 vùng theo dữ liệu mẫu). Hãy chọn phiên bản theo nhu cầu và môi trường sử dụng.', 20),
  (N'Lenovo Legion K300 RGB', 'connect', N'Kết nối với máy tính', N'Kiểu kết nối: Có dây. Đối chiếu hệ điều hành, bộ thu hoặc cổng kết nối trước khi mua để bảo đảm tương thích.', 30),
  (N'Lenovo Go Wireless Split Keyboard', 'design', N'Thiết kế phục vụ thao tác', N'Lenovo Go Wireless Split Keyboard được thiết kế cho thao tác với máy tính và laptop. Bố trí và kiểu dáng phù hợp loại thiết bị, hỗ trợ công việc hoặc giải trí hằng ngày.', 10),
  (N'Lenovo Go Wireless Split Keyboard', 'performance', N'Khả năng điều khiển', N'Các tính năng điều khiển đáp ứng nhu cầu nhập liệu hoặc sử dụng chuột thường ngày. Hãy chọn phiên bản theo nhu cầu và môi trường sử dụng.', 20),
  (N'Lenovo Go Wireless Split Keyboard', 'connect', N'Kết nối với máy tính', N'Kiểu kết nối: Không dây. Đối chiếu hệ điều hành, bộ thu hoặc cổng kết nối trước khi mua để bảo đảm tương thích.', 30),
  (N'Lenovo 300 FHD Webcam', 'video', N'Hình ảnh rõ nét cho hội họp', N'Lenovo 300 FHD Webcam hỗ trợ độ phân giải 1920 × 1080 (Full HD), phù hợp các cuộc gọi video, học trực tuyến và họp từ xa khi có ánh sáng thích hợp.', 10),
  (N'Lenovo 300 FHD Webcam', 'audio', N'Microphone tích hợp', N'Webcam hỗ trợ thu tiếng phục vụ giao tiếp trực tuyến. Chất lượng ghi âm phụ thuộc vị trí đặt máy, độ ồn môi trường và cài đặt phần mềm.', 20),
  (N'Lenovo 300 FHD Webcam', 'connect', N'Lắp đặt linh hoạt', N'Thiết bị có chân đế để gắn lên màn hình hoặc bố trí ở vị trí thích hợp. Kiểm tra cổng USB và khả năng tương thích ứng dụng trước khi kết nối.', 30),
  (N'Lenovo Performance FHD Webcam', 'video', N'Hình ảnh rõ nét cho hội họp', N'Lenovo Performance FHD Webcam hỗ trợ độ phân giải 1920 × 1080 (Full HD), phù hợp các cuộc gọi video, học trực tuyến và họp từ xa khi có ánh sáng thích hợp.', 10),
  (N'Lenovo Performance FHD Webcam', 'audio', N'Microphone tích hợp', N'Webcam hỗ trợ thu tiếng phục vụ giao tiếp trực tuyến. Chất lượng ghi âm phụ thuộc vị trí đặt máy, độ ồn môi trường và cài đặt phần mềm.', 20),
  (N'Lenovo Performance FHD Webcam', 'connect', N'Lắp đặt linh hoạt', N'Thiết bị có chân đế để gắn lên màn hình hoặc bố trí ở vị trí thích hợp. Kiểm tra cổng USB và khả năng tương thích ứng dụng trước khi kết nối.', 30),
  (N'Lenovo Laptop Backpack 15.6"', 'design', N'Bố cục ngăn chứa thiết thực', N'Lenovo Laptop Backpack 15.6" có ngăn chính dành cho máy tính cùng không gian đựng phụ kiện. Thiết kế hai quai vai phù hợp đi học, đi làm và di chuyển hằng ngày.', 10),
  (N'Lenovo Laptop Backpack 15.6"', 'protect', N'Mang theo laptop và phụ kiện', N'Kích thước laptop tham khảo: Tối đa 15.6 inch (theo dữ liệu demo). Ngăn riêng hỗ trợ hạn chế cọ xát thông thường, không thay thế túi chống sốc chuyên dụng.', 20),
  (N'Lenovo Laptop Backpack 15.6"', 'daily', N'Lưu ý khi sử dụng', N'Sắp xếp đồ nặng sát lưng và tránh để thiết bị tiếp xúc trực tiếp với nước. Khả năng chống thấm phụ thuộc chất liệu và điều kiện sử dụng thực tế.', 30),
  (N'Lenovo Legion Gaming Backpack', 'design', N'Bố cục ngăn chứa thiết thực', N'Lenovo Legion Gaming Backpack có ngăn chính dành cho máy tính cùng không gian đựng phụ kiện. Thiết kế hai quai vai phù hợp đi học, đi làm và di chuyển hằng ngày.', 10),
  (N'Lenovo Legion Gaming Backpack', 'protect', N'Mang theo laptop và phụ kiện', N'Kích thước laptop tham khảo: Tối đa 17 inch (theo dữ liệu demo). Ngăn riêng hỗ trợ hạn chế cọ xát thông thường, không thay thế túi chống sốc chuyên dụng.', 20),
  (N'Lenovo Legion Gaming Backpack', 'daily', N'Lưu ý khi sử dụng', N'Sắp xếp đồ nặng sát lưng và tránh để thiết bị tiếp xúc trực tiếp với nước. Khả năng chống thấm phụ thuộc chất liệu và điều kiện sử dụng thực tế.', 30),
  (N'Apple Watch SE 2', 'display', N'Màn hình thuận tiện quan sát', N'Apple Watch SE 2 sử dụng Retina OLED, giúp theo dõi thời gian, thông báo và các chỉ số cần thiết.', 10),
  (N'Apple Watch SE 2', 'health', N'Đồng hành cùng hoạt động thể chất', N'Có các chức năng theo dõi nhịp tim, giấc ngủ và vận động. Các dữ liệu đo chỉ mang tính hỗ trợ theo dõi sức khỏe, không thay thế thiết bị hoặc đánh giá y tế.', 20),
  (N'Apple Watch SE 2', 'daily', N'Kết nối, định vị và pin', N'Đồng hồ hỗ trợ GPS và đồng bộ với ứng dụng trên điện thoại tương thích. Thời lượng tham khảo: Tối đa khoảng 18 giờ (theo Apple). ', 30),
  (N'Samsung Galaxy Watch7', 'display', N'Màn hình thuận tiện quan sát', N'Samsung Galaxy Watch7 sử dụng Super AMOLED, giúp theo dõi thời gian, thông báo và các chỉ số cần thiết.', 10),
  (N'Samsung Galaxy Watch7', 'health', N'Đồng hành cùng hoạt động thể chất', N'Có các chức năng theo dõi nhịp tim, giấc ngủ và vận động. Các dữ liệu đo chỉ mang tính hỗ trợ theo dõi sức khỏe, không thay thế thiết bị hoặc đánh giá y tế.', 20),
  (N'Samsung Galaxy Watch7', 'daily', N'Kết nối, định vị và pin', N'Đồng hồ hỗ trợ GPS và đồng bộ với ứng dụng trên điện thoại tương thích. Thời lượng thực tế thay đổi theo cường độ sử dụng.', 30),
  (N'Garmin Forerunner 165', 'display', N'Màn hình thuận tiện quan sát', N'Garmin Forerunner 165 sử dụng AMOLED, giúp theo dõi thời gian, thông báo và các chỉ số cần thiết.', 10),
  (N'Garmin Forerunner 165', 'health', N'Đồng hành cùng hoạt động thể chất', N'Có các chức năng theo dõi nhịp tim, giấc ngủ và vận động. Các dữ liệu đo chỉ mang tính hỗ trợ theo dõi sức khỏe, không thay thế thiết bị hoặc đánh giá y tế.', 20),
  (N'Garmin Forerunner 165', 'daily', N'Kết nối, định vị và pin', N'Đồng hồ hỗ trợ GPS và đồng bộ với ứng dụng trên điện thoại tương thích. Thời lượng tham khảo: Tối đa 11 ngày ở chế độ đồng hồ thông minh (theo Garmin). ', 30),
  (N'Sony WH-1000XM5', 'audio', N'Trải nghiệm âm thanh', N'Sony WH-1000XM5 phục vụ nhu cầu nghe nhạc, xem phim và gọi điện. Hỗ trợ chống ồn chủ động: Có (ANC). Chất lượng âm thanh thực tế còn phụ thuộc nguồn phát và cách đeo.', 10),
  (N'Sony WH-1000XM5', 'connect', N'Kết nối tiện lợi', N'Kết nối chính: Bluetooth. Thiết kế và thao tác điều khiển được tối ưu cho việc sử dụng cùng thiết bị tương thích trong sinh hoạt hằng ngày.', 20),
  (N'Sony WH-1000XM5', 'battery', N'Pin và sử dụng', N'Thông tin thời lượng: Tối đa 30 giờ (bật ANC). Khi lựa chọn phiên bản, hãy lưu ý khác biệt về chống ồn hoặc phụ kiện đi kèm nếu có.', 30),
  (N'JBL Tune 770NC', 'audio', N'Trải nghiệm âm thanh', N'JBL Tune 770NC phục vụ nhu cầu nghe nhạc, xem phim và gọi điện. Hỗ trợ chống ồn chủ động: Có (ANC). Chất lượng âm thanh thực tế còn phụ thuộc nguồn phát và cách đeo.', 10),
  (N'JBL Tune 770NC', 'connect', N'Kết nối tiện lợi', N'Kết nối chính: Bluetooth. Thiết kế và thao tác điều khiển được tối ưu cho việc sử dụng cùng thiết bị tương thích trong sinh hoạt hằng ngày.', 20),
  (N'JBL Tune 770NC', 'battery', N'Pin và sử dụng', N'Thông tin thời lượng: Tối đa 70 giờ khi tắt ANC. Khi lựa chọn phiên bản, hãy lưu ý khác biệt về chống ồn hoặc phụ kiện đi kèm nếu có.', 30),
  (N'Canon EOS R50', 'image', N'Chất lượng hình ảnh linh hoạt', N'Canon EOS R50 sử dụng cảm biến APS-C độ phân giải 24.2 MP, hỗ trợ chụp ảnh JPEG và RAW để điều chỉnh hậu kỳ theo nhu cầu.', 10),
  (N'Canon EOS R50', 'video', N'Ghi hình và lấy nét', N'Khả năng ghi hình 4K UHD. Các tính năng lấy nét đáp ứng nhiều tình huống chụp và quay; hãy xem bảng thông số để biết giới hạn từng chế độ.', 20),
  (N'Canon EOS R50', 'lens', N'Linh hoạt với hệ ống kính', N'Ngàm Canon RF / RF-S. Sản phẩm có thể bán dạng thân máy hoặc bộ kit theo SKU; cần kiểm tra bộ ống kính đi kèm trước khi mua.', 30),
  (N'Sony Alpha A6400', 'image', N'Chất lượng hình ảnh linh hoạt', N'Sony Alpha A6400 sử dụng cảm biến APS-C độ phân giải 24.2 MP, hỗ trợ chụp ảnh JPEG và RAW để điều chỉnh hậu kỳ theo nhu cầu.', 10),
  (N'Sony Alpha A6400', 'video', N'Ghi hình và lấy nét', N'Khả năng ghi hình 4K. Các tính năng lấy nét đáp ứng nhiều tình huống chụp và quay; hãy xem bảng thông số để biết giới hạn từng chế độ.', 20),
  (N'Sony Alpha A6400', 'lens', N'Linh hoạt với hệ ống kính', N'Ngàm Sony E-mount. Sản phẩm có thể bán dạng thân máy hoặc bộ kit theo SKU; cần kiểm tra bộ ống kính đi kèm trước khi mua.', 30),
  (N'Fujifilm X-S20', 'image', N'Chất lượng hình ảnh linh hoạt', N'Fujifilm X-S20 sử dụng cảm biến APS-C độ phân giải 26.1 MP, hỗ trợ chụp ảnh JPEG và RAW để điều chỉnh hậu kỳ theo nhu cầu.', 10),
  (N'Fujifilm X-S20', 'video', N'Ghi hình và lấy nét', N'Khả năng ghi hình Tối đa 6.2K 30p. Các tính năng lấy nét đáp ứng nhiều tình huống chụp và quay; hãy xem bảng thông số để biết giới hạn từng chế độ.', 20),
  (N'Fujifilm X-S20', 'lens', N'Linh hoạt với hệ ống kính', N'Ngàm Fujifilm X-mount. Sản phẩm có thể bán dạng thân máy hoặc bộ kit theo SKU; cần kiểm tra bộ ống kính đi kèm trước khi mua.', 30);
GO

-- Fail explicitly for renamed/missing/duplicate products.
IF (SELECT COUNT(DISTINCT product_name) FROM #OverviewSeed) <> 39
  THROW 57002,N'Expected 39 products in overview seed.',1;
IF EXISTS(
  SELECT 1 FROM (SELECT DISTINCT product_name FROM #OverviewSeed) x
  OUTER APPLY(SELECT COUNT(*) AS n FROM dbo.PRODUCT p WHERE p.product_name=x.product_name) chk
  WHERE chk.n<>1
)
BEGIN
  SELECT x.product_name, COUNT(p.product_id) AS matching_products
  FROM (SELECT DISTINCT product_name FROM #OverviewSeed) x
  LEFT JOIN dbo.PRODUCT p ON p.product_name=x.product_name
  GROUP BY x.product_name HAVING COUNT(p.product_id)<>1;
  THROW 57003,N'Missing or duplicate product names. No data inserted.',1;
END;
GO

BEGIN TRY
  BEGIN TRANSACTION;

  -- Insert only NEW sections. Re-running preserves edited content and image URLs.
  INSERT INTO dbo.PRODUCT_CONTENT_SECTION
    (product_id,section_key,section_title,section_content,image_url,image_alt,display_order)
  SELECT p.product_id,s.section_key,s.section_title,s.section_content,
         NULL,NULL,s.display_order
  FROM #OverviewSeed AS s
  JOIN dbo.PRODUCT AS p ON p.product_name=s.product_name
  WHERE NOT EXISTS(
    SELECT 1 FROM dbo.PRODUCT_CONTENT_SECTION x WITH (UPDLOCK,HOLDLOCK)
    WHERE x.product_id=p.product_id AND x.section_key=s.section_key
  );

  COMMIT TRANSACTION;
END TRY
BEGIN CATCH
  IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
  THROW;
END CATCH;
GO

-- Verify 39 products have 3 sections each and list those with missing content.
SELECT p.product_id,p.product_name,COUNT(s.section_id) AS overview_sections,
       SUM(CASE WHEN NULLIF(LTRIM(RTRIM(s.image_url)),N'') IS NOT NULL THEN 1 ELSE 0 END) AS sections_with_images
FROM dbo.PRODUCT p
LEFT JOIN dbo.PRODUCT_CONTENT_SECTION s ON s.product_id=p.product_id AND s.is_active=1
GROUP BY p.product_id,p.product_name ORDER BY p.product_id;
GO

SELECT COUNT(*) AS total_overview_sections,
       COUNT(DISTINCT product_id) AS total_products_with_overview
FROM dbo.PRODUCT_CONTENT_SECTION;
GO

/* OPTIONAL: after uploading an OWNED or LICENSED image to the app's static public path:
   UPDATE dbo.PRODUCT_CONTENT_SECTION
   SET image_url=N'uploads/product-overview/1/display.webp',
       image_alt=N'Man hinh iPhone 15 Pro',updated_at=SYSDATETIME()
   WHERE product_id=1 AND section_key='display';
   -- Do not insert FPT Shop's photographs without rights.
*/
