
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<style>
    /* ======================================
       OECS V2 - PRODUCT SPECIFICATIONS
       ====================================== */

    .oecs-spec-section {
        margin: 24px 0 40px;
    }

    .oecs-spec-heading {
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 16px;
        margin-bottom: 22px;
    }

    .oecs-spec-heading h2 {
        color: #172033;
        font-size: 26px;
        font-weight: 750;
        margin: 0;
    }

    .oecs-spec-show-all {
        border: 1px solid #d0d5dd;
        color: #344054;
        border-radius: 30px;
        background: #fff;
        padding: 11px 20px;
        font-weight: 600;
        transition: background .2s;
    }

    .oecs-spec-show-all:hover {
        color: #0d6efd;
        border-color: #0d6efd;
        background: #f5f9ff;
    }

    /* ======================================
       THÔNG SỐ NỔI BẬT
       ====================================== */

    .oecs-spec-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        border: 1px solid #e2e8f0;
        border-radius: 16px;
        overflow: hidden;
        background: #fff;
    }

    .oecs-spec-card {
        min-width: 0;
        display: flex;
        align-items: flex-start;
        gap: 13px;
        padding: 24px 18px;
        border-bottom: 1px solid #edf0f4;
    }

    .oecs-spec-card:nth-child(n+4) {
        background: #f8fafc;
    }

    .oecs-spec-icon {
        flex: 0 0 38px;
        width: 38px;
        color: #667085;
        font-size: 28px;
        line-height: 1.3;
        text-align: center;
    }

    .oecs-spec-label {
        font-size: 14px;
        line-height: 1.5;
        color: #667085;
        margin-bottom: 5px;
    }

    .oecs-spec-value {
        color: #101828;
        font-size: 17px;
        line-height: 1.5;
        font-weight: 700;
        overflow-wrap: anywhere;
        white-space: pre-line;
    }

    /* ======================================
       MODAL THÔNG SỐ
       ====================================== */

    .oecs-spec-modal .modal-dialog {
        max-width: 900px;
    }

    .oecs-spec-modal .modal-content {
        border: 0;
        border-radius: 18px;
        overflow: hidden;
    }

    .oecs-spec-modal .modal-header {
        padding: 22px 26px;
        border-bottom: 1px solid #e5e7eb;
    }

    .oecs-spec-modal .modal-title {
        font-size: 22px;
        color: #172033;
        font-weight: 750;
    }

    .oecs-spec-modal .modal-body {
        padding: 26px;
    }

    .oecs-spec-product-name {
        font-size: 19px;
        font-weight: 700;
        color: #172033;
        margin-bottom: 5px;
    }

    .oecs-spec-product-brand {
        font-size: 13px;
        color: #667085;
        margin-bottom: 25px;
    }

    .oecs-spec-group-title {
        font-size: 19px;
        font-weight: 750;
        color: #172033;
        margin-bottom: 15px;
        padding-bottom: 12px;
        border-bottom: 2px solid #edf0f4;
    }

    .oecs-spec-detail-row {
        display: grid;
        grid-template-columns: minmax(0, 40%) minmax(0, 60%);
        gap: 18px;
        padding: 15px 8px;
        border-bottom: 1px dashed #e2e8f0;
    }

    .oecs-spec-detail-name {
        color: #667085;
        font-size: 14px;
        line-height: 1.6;
    }

    .oecs-spec-detail-value {
        color: #172033;
        font-size: 14px;
        font-weight: 500;
        line-height: 1.6;
        overflow-wrap: anywhere;
        white-space: pre-line;
    }

    .oecs-spec-empty {
        grid-column: 1 / -1;
        text-align: center;
        padding: 30px;
        color: #667085;
    }

    @media (max-width: 767.98px) {
        .oecs-spec-grid {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .oecs-spec-heading h2 {
            font-size: 21px;
        }

        .oecs-spec-show-all {
            font-size: 13px;
            padding: 9px 14px;
        }

        .oecs-spec-card {
            padding: 16px 12px;
            gap: 9px;
        }

        .oecs-spec-card:nth-child(n+4) {
            background: #fff;
        }

        .oecs-spec-icon {
            flex-basis: 28px;
            width: 28px;
            font-size: 22px;
        }

        .oecs-spec-label {
            font-size: 12px;
        }

        .oecs-spec-value {
            font-size: 14px;
        }

        .oecs-spec-modal .modal-dialog {
            margin: 0;
            max-width: none;
            height: 100%;
        }

        .oecs-spec-modal .modal-content {
            height: 100%;
            border-radius: 0;
        }

        .oecs-spec-modal .modal-header,
        .oecs-spec-modal .modal-body {
            padding: 18px;
        }

        .oecs-spec-detail-row {
            grid-template-columns: minmax(0, 42%) minmax(0, 58%);
            gap: 12px;
        }
    }
</style>

<!-- ====================================== -->
<!-- 1. THÔNG SỐ NỔI BẬT                  -->
<!-- ====================================== -->

<section class="oecs-spec-section"
         id="productSpecifications"
         aria-labelledby="oecsSpecHeading">

    <div class="oecs-spec-heading">

        <h2 id="oecsSpecHeading">
            Thông số nổi bật
        </h2>

        <button type="button"
                class="oecs-spec-show-all"
                data-bs-toggle="modal"
                data-bs-target="#oecsAllSpecsModal">

            Xem tất cả thông số

            <i class="bi bi-arrow-right ms-1"></i>

        </button>

    </div>

    <div class="oecs-spec-grid">

        <c:choose>

            <c:when test="${not empty specs}">

                <c:forEach items="${specs}"
                           var="spec"
                           varStatus="st">

                    <c:if test="${st.index lt 6}">

                        <div class="oecs-spec-card">

                            <div class="oecs-spec-icon"
                                 aria-hidden="true">

                                <i class="bi bi-sliders"></i>

                            </div>

                            <div>

                                <div class="oecs-spec-label">

                                    <c:out value="${spec.attributeName}"/>

                                </div>

                                <div class="oecs-spec-value">

                                    <c:out value="${spec.value}"/>

                                </div>

                            </div>

                        </div>

                    </c:if>

                </c:forEach>

            </c:when>

            <c:otherwise>

                <div class="oecs-spec-empty">

                    <i class="bi bi-info-circle me-1"></i>

                    Thông số kỹ thuật đang được cập nhật.

                </div>

            </c:otherwise>

        </c:choose>

    </div>

</section>

<!-- ====================================== -->
<!-- 2. MODAL TẤT CẢ THÔNG SỐ              -->
<!-- ====================================== -->

<div class="modal fade oecs-spec-modal"
     id="oecsAllSpecsModal"
     tabindex="-1"
     aria-labelledby="oecsAllSpecsTitle"
     aria-hidden="true">

    <div class="modal-dialog
         modal-xl
         modal-dialog-centered
         modal-dialog-scrollable">

        <div class="modal-content">

            <!-- HEADER -->

            <div class="modal-header">

                <h2 class="modal-title"
                    id="oecsAllSpecsTitle">

                    Thông số kỹ thuật

                </h2>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Đóng">
                </button>

            </div>

            <!-- BODY -->

            <div class="modal-body">

                <div class="oecs-spec-product-name">

                    <c:out value="${product.productName}"/>

                </div>

                <div class="oecs-spec-product-brand">

                    <c:out value="${product.brand.brandName}"/>

                </div>

                <c:choose>

                    <c:when test="${not empty specs}">

                        <h3 class="oecs-spec-group-title">

                            Thông số sản phẩm

                        </h3>

                        <div>

                            <c:forEach items="${specs}"
                                       var="spec">

                                <div class="oecs-spec-detail-row">

                                    <div class="oecs-spec-detail-name">

                                        <c:out value="${spec.attributeName}"/>

                                    </div>

                                    <div class="oecs-spec-detail-value">

                                        <c:out value="${spec.value}"/>

                                    </div>

                                </div>

                            </c:forEach>

                        </div>

                    </c:when>

                    <c:otherwise>

                        <div class="alert alert-light text-center">

                            Chưa có thông số kỹ thuật
                            cho sản phẩm này.

                        </div>

                    </c:otherwise>

                </c:choose>

            </div>

            <!-- FOOTER -->

            <div class="modal-footer">

                <button type="button"
                        class="btn btn-outline-secondary"
                        data-bs-dismiss="modal">

                    Đóng

                </button>

            </div>

        </div>

    </div>

</div>
