package controller;

import dao.ShopDAO;
import dao.ProductReviewDAO;
import db.DBContext;

import model.Category;
import model.Product;
import model.ProductSku;
import model.ProductSpec;
import model.ProductReview;
import model.ProductImage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(
        name = "ShopServlet",
        urlPatterns = {"/shop"}
)
public class ShopServlet extends HttpServlet {

    private static final Logger LOGGER
            = Logger.getLogger(ShopServlet.class.getName());

    private static final String CATALOG_JSP
            = "/WEB-INF/shop/catalog.jsp";

    private static final String DETAIL_JSP
            = "/WEB-INF/shop/detail.jsp";

    // ========================================
    // 1. ĐIỀU HƯỚNG GET
    // ========================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action
                = request.getParameter("action");

        if ("detail".equals(action)) {

            showProductDetail(request, response);

        } else {

            showCatalog(request, response);
        }
    }

    // ========================================
    // 2. TRANG DANH SÁCH SẢN PHẨM
    // ========================================
    private void showCatalog(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        ShopDAO shopDAO = new ShopDAO();

        String keyword
                = request.getParameter("keyword");

        String[] categoryIds
                = request.getParameterValues("categoryId");

        String priceRange
                = request.getParameter("priceRange");

        String minRating
                = request.getParameter("minRating");

        String sort
                = request.getParameter("sort");

        /*
         * Giữ nguyên bộ lọc Catalog V2:
         *
         * - Sản phẩm đang hoạt động
         * - Giá từ SKU đang kinh doanh
         * - Tìm kiếm theo từ khóa
         * - Danh mục
         * - Khoảng giá
         * - Đánh giá
         * - Sắp xếp
         */
        List<Product> catalog
                = shopDAO.getFilteredCatalog(
                        keyword,
                        categoryIds,
                        priceRange,
                        minRating,
                        sort
                );

        // ====================================
        // 2.1. DANH MỤC ĐỘNG
        // ====================================
        List<Category> filterCategories;

        try {

            filterCategories
                    = new CategoryFilterReader()
                            .getActiveCategories();

        } catch (SQLException ex) {

            LOGGER.log(
                    Level.SEVERE,
                    "Không thể tải danh mục sản phẩm",
                    ex
            );

            throw new ServletException(
                    "Không thể tải danh mục sản phẩm.",
                    ex
            );
        }

        // ====================================
        // 2.2. TRUYỀN DỮ LIỆU XUỐNG CATALOG
        // ====================================
        request.setAttribute(
                "catalog",
                catalog == null
                        ? Collections.emptyList()
                        : catalog
        );

        request.setAttribute(
                "filterCategories",
                filterCategories
        );

        request.setAttribute(
                "searchKeyword",
                keyword
        );

        request.setAttribute(
                "selectedCats",
                categoryIds == null
                        ? Collections.emptyList()
                        : Arrays.asList(categoryIds)
        );

        request.setAttribute(
                "selectedPrice",
                priceRange
        );

        request.setAttribute(
                "selectedRating",
                minRating
        );

        request.setAttribute(
                "selectedSort",
                sort
        );

        request.getRequestDispatcher(
                CATALOG_JSP
        ).forward(request, response);
    }

    // ========================================
    // 3. TRANG CHI TIẾT SẢN PHẨM
    // ========================================
    private void showProductDetail(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Integer productId
                = parsePositiveInt(
                        request.getParameter("id")
                );

        if (productId == null) {

            response.sendRedirect(
                    request.getContextPath() + "/shop"
            );

            return;
        }

        ShopDAO shopDAO = new ShopDAO();

        // ====================================
        // 3.1. THÔNG TIN SẢN PHẨM
        // ====================================
        Product product
                = shopDAO.getProductDetail(productId);

        if (product == null) {

            response.sendRedirect(
                    request.getContextPath() + "/shop"
            );

            return;
        }

        // ====================================
        // 3.2. GALLERY CHUNG
        // ====================================
        List<ProductImage> galleryImages
                = shopDAO.getProductImages(productId);

        if (galleryImages == null) {

            galleryImages
                    = Collections.emptyList();
        }

        product.setGalleryImages(galleryImages);

        // ====================================
        // 3.3. DANH SÁCH SKU
        // ====================================
        List<ProductSku> skus
                = shopDAO.getProductSkus(productId);

        if (skus == null) {

            skus
                    = Collections.emptyList();
        }

        // ====================================
        // 3.4. SKU MẶC ĐỊNH
        // ====================================
        ProductSku selectedSku
                = chooseDefaultSku(skus);

        Integer selectedSkuId
                = selectedSku == null
                        ? null
                        : selectedSku.getSkuId();

        boolean hasAvailableSku
                = hasAvailableSku(skus);

        // ====================================
        // 3.5. ẢNH RIÊNG THEO SKU
        // ====================================
        Map<Integer, List<ProductImage>> skuImagesBySkuId
                = shopDAO.getSkuImagesByProduct(
                        productId
                );

        // ====================================
        // 3.6. THÔNG SỐ KỸ THUẬT
        // ====================================

        /*
         * Giữ đúng attribute "specs".
         *
         * specifications.jsp hiện đang
         * sử dụng dữ liệu này và đã chạy
         * ổn định trên project.
         */
        List<ProductSpec> specs
                = shopDAO.getProductSpecs(productId);

        if (specs == null) {

            specs
                    = Collections.emptyList();
        }

        // ====================================
        // 3.7. ĐÁNH GIÁ VÀ LƯỢT MUA
        // ====================================
        ProductReviewDAO reviewDAO
                = new ProductReviewDAO();

        List<ProductReview> reviews
                = reviewDAO.getReviewsByProductId(
                        productId
                );

        if (reviews == null) {

            reviews
                    = Collections.emptyList();
        }

        int purchaseCount
                = reviewDAO.getPurchaseCountByProductId(
                        productId
                );

        int totalReviews = reviews.size();

        long ratingSum = 0;

        for (ProductReview review : reviews) {

            if (review != null) {

                ratingSum += review.getRating();
            }
        }

        double averageRating
                = totalReviews > 0
                        ? (double) ratingSum / totalReviews
                        : 0.0;

        // ====================================
        // 3.8. SẢN PHẨM TƯƠNG TỰ - MỚI
        // ====================================

        /*
         * Chỉ lấy sản phẩm cùng category_id.
         *
         * ShopDAO.getRelatedProducts():
         *
         * - Không lấy chính sản phẩm đang xem.
         * - Chỉ lấy PRODUCT.is_active = 1.
         * - Giá từ SKU đang kinh doanh.
         * - Ưu tiên sản phẩm còn hàng.
         * - Tối đa 8 sản phẩm.
         */
        List<Product> relatedProducts
                = shopDAO.getRelatedProducts(
                        productId,
                        product.getCategoryId()
                );

        if (relatedProducts == null) {

            relatedProducts
                    = Collections.emptyList();
        }

        // ====================================
        // 3.9. TOKEN BÁO CÁO ĐÁNH GIÁ
        // ====================================
        HttpSession session
                = request.getSession();

        if (session.getAttribute(
                "reviewCsrfToken") == null) {

            session.setAttribute(
                    "reviewCsrfToken",
                    UUID.randomUUID().toString()
            );
        }

        // ====================================
        // 3.10. DỮ LIỆU CŨ CỦA DETAIL JSP
        // ====================================
        request.setAttribute(
                "product",
                product
        );

        request.setAttribute(
                "skus",
                skus
        );

        request.setAttribute(
                "specs",
                specs
        );

        request.setAttribute(
                "reviews",
                reviews
        );

        request.setAttribute(
                "purchaseCount",
                purchaseCount
        );

        request.setAttribute(
                "totalReviews",
                totalReviews
        );

        request.setAttribute(
                "averageRating",
                averageRating
        );

        // ====================================
        // 3.11. DỮ LIỆU SKU V2
        // ====================================
        request.setAttribute(
                "selectedSku",
                selectedSku
        );

        request.setAttribute(
                "selectedSkuId",
                selectedSkuId
        );

        request.setAttribute(
                "hasAvailableSku",
                hasAvailableSku
        );

        request.setAttribute(
                "skuImagesBySkuId",
                skuImagesBySkuId
        );

        // ====================================
        // 3.12. SẢN PHẨM TƯƠNG TỰ - MỚI
        // ====================================

        /*
         * detail.jsp sẽ truy cập:
         *
         * ${relatedProducts}
         *
         * Mỗi phần tử là model.Product.
         */
        request.setAttribute(
                "relatedProducts",
                relatedProducts
        );

        // ====================================
        // 3.13. FORWARD JSP
        // ====================================
        request.getRequestDispatcher(
                DETAIL_JSP
        ).forward(request, response);
    }

    // ========================================
    // 4. CHỌN SKU MẶC ĐỊNH
    // ========================================
    private ProductSku chooseDefaultSku(
            List<ProductSku> skus) {

        if (skus == null
                || skus.isEmpty()) {

            return null;
        }

        /*
         * Ưu tiên SKU còn hàng.
         */
        for (ProductSku sku : skus) {

            if (sku != null
                    && sku.isActive()
                    && sku.getStockQuantity() > 0) {

                return sku;
            }
        }

        /*
         * Nếu tất cả hết hàng,
         * dùng SKU đầu tiên để hiển thị giá.
         */
        return skus.get(0);
    }

    // ========================================
    // 5. KIỂM TRA SKU CÒN HÀNG
    // ========================================
    private boolean hasAvailableSku(
            List<ProductSku> skus) {

        if (skus == null) {
            return false;
        }

        for (ProductSku sku : skus) {

            if (sku != null
                    && sku.isActive()
                    && sku.getStockQuantity() > 0) {

                return true;
            }
        }

        return false;
    }

    // ========================================
    // 6. PARSE PRODUCT ID
    // ========================================
    private Integer parsePositiveInt(
            String input) {

        if (input == null
                || input.trim().isEmpty()) {

            return null;
        }

        try {

            int id
                    = Integer.parseInt(input.trim());

            return id > 0 ? id : null;

        } catch (NumberFormatException ex) {

            return null;
        }
    }

    // ========================================
    // 7. LẤY DANH MỤC ĐỘNG CHO CATALOG
    // ========================================
    private static class CategoryFilterReader
            extends DBContext {

        public List<Category> getActiveCategories()
                throws SQLException {

            List<Category> categories
                    = new ArrayList<>();

            String sql
                    = "SELECT "
                    + "category_id, "
                    + "category_name "
                    + "FROM CATEGORY "
                    + "WHERE is_active = 1 "
                    + "ORDER BY category_name ASC, "
                    + "category_id ASC";

            try (Connection conn = getConnection(); PreparedStatement ps
                    = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Category category
                            = new Category(
                                    rs.getInt("category_id"),
                                    rs.getString("category_name"),
                                    null
                            );

                    categories.add(category);
                }
            }

            return categories;
        }
    }
}
