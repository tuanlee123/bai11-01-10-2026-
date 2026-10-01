<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh Toán An Toàn - BookStore_24162138</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f8; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .checkout-container { max-width: 1150px; margin: 30px auto; }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 20px; background: #fff; }
        .section-title { font-size: 1.1rem; font-weight: 700; color: #2c3e50; margin-bottom: 1.2rem; padding-bottom: 10px; border-bottom: 2px solid #f0f2f5; }
        .form-control { border-radius: 8px; padding: 12px 15px; border: 1px solid #ced4da; }
        .form-control:focus { border-color: #0d6efd; box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.15); }
        .payment-method { border: 2px solid #e9ecef; border-radius: 10px; padding: 16px; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; gap: 15px; background: #fff; }
        .payment-method:hover { border-color: #0d6efd; background-color: #f8fbff; }
        .product-img { width: 65px; height: 85px; object-fit: cover; border-radius: 6px; border: 1px solid #dee2e6; }
        .btn-order { background-color: #ee4d2d; border: none; color: white; padding: 15px; font-size: 1.15rem; border-radius: 8px; font-weight: bold; width: 100%; transition: background 0.2s; box-shadow: 0 4px 12px rgba(238,77,45,0.3); }
        .btn-order:hover { background-color: #d73211; color: white; }
        .summary-row { display: flex; justify-content: middle; justify-content: space-between; margin-bottom: 12px; color: #555; font-size: 0.95rem; }
        .summary-total { display: flex; justify-content: space-between; align-items: center; margin-top: 15px; padding-top: 15px; border-top: 2px dashed #e9ecef; }
    </style>
</head>
<body>

<div class="checkout-container">
    <!-- Header -->
    <div class="d-flex align-items-center mb-4 bg-white p-4 rounded-4 shadow-sm">
        <h3 class="mb-0 fw-bold text-dark"><i class="bi bi-shield-check text-success me-2"></i>Thanh Toán An Toàn & Bảo Mật</h3>
    </div>

    <!-- Mensahe ti biddut -->
    <c:if test="${not empty message}">
        <div class="alert alert-danger shadow-sm rounded-3"><i class="bi bi-exclamation-circle-fill me-2"></i>${message}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/checkout" method="post">
        <div class="row">
            <!-- KANIGID: IMPORMASYON TI PANAG-DELIVER -->
            <div class="col-lg-7">
                
                <!-- Sukat 1: Address -->
                <div class="card card-custom p-4">
                    <h5 class="section-title"><i class="bi bi-geo-alt-fill me-2 text-danger"></i>Địa chỉ nhận hàng</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-muted small fw-bold">Họ và tên</label>
                            <input type="text" class="form-control bg-light" name="fullname" value="${sessionScope.user.fullname}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small fw-bold">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="phone" value="${sessionScope.user.phone}" placeholder="Nhập số điện thoại..." required>
                        </div>
                        <div class="col-12">
                            <label class="form-label text-muted small fw-bold">Địa chỉ chi tiết <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="address" rows="3" placeholder="Số nhà, Tên đường, Phường/Xã, Quận/Huyện, Tỉnh/Thành phố..." required></textarea>
                        </div>
                    </div>
                </div>

                <!-- Sukat 2: Payment method -->
                <div class="card card-custom p-4">
                    <h5 class="section-title"><i class="bi bi-credit-card-2-front-fill me-2 text-primary"></i>Phương thức thanh toán</h5>
                    
                    <label class="payment-method mb-2" style="border-color: #ee4d2d; background-color: #fffefb;">
                        <input type="radio" name="payment" value="COD" checked class="form-check-input mt-0" style="transform: scale(1.2);">
                        <i class="bi bi-cash-coin fs-3 text-success"></i>
                        <div>
                            <div class="fw-bold text-dark">Thanh toán tiền mặt khi nhận hàng (COD)</div>
                            <div class="text-muted small">Thanh toán bằng tiền mặt khi shipper giao hàng tận nơi.</div>
                        </div>
                    </label>
                </div>
            </div>

            <!-- KANIGANAWAN: SUMMARY TI PRODUKTO -->
            <div class="col-lg-5">
                <div class="card card-custom p-4 sticky-top" style="top: 20px;">
                    <h5 class="section-title d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-box-seam me-2 text-warning"></i>Sản phẩm đặt mua</span>
                        <a href="${pageContext.request.contextPath}/cart" class="text-decoration-none small text-primary">Sửa giỏ hàng</a>
                    </h5>
                    
                    <!-- Lista dagiti produkto nga adda scrollbar no adu -->
                    <div style="max-height: 320px; overflow-y: auto; padding-right: 5px;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.cart and sessionScope.cart.size() > 0}">
                                <c:forEach items="${sessionScope.cart.values()}" var="item">
                                    <div class="d-flex mb-3 align-items-center pb-3 border-bottom">
                                        <div class="position-relative me-3">
                                            <img src="${item.coverImage}" class="product-img" alt="Cover"
                                                 onerror="this.onerror=null; this.src='https://via.placeholder.com/65x85?text=Book';">
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="fw-bold text-dark text-truncate" style="max-width: 190px;" title="${item.title}">${item.title}</div>
                                            <div class="text-muted small mt-1">Số lượng: <strong class="text-dark">${item.quantity}</strong></div>
                                            <div class="text-danger fw-bold mt-1">
                                                <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫"/>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <i class="bi bi-cart-x fs-1 text-muted mb-2"></i>
                                    <p class="text-muted mb-0">Giỏ hàng trống</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Kalkulasion ti kuarta -->
                    <div class="mt-3 pt-2">
                        <div class="summary-row">
                            <span>Tạm tính</span>
                            <span class="fw-bold text-dark"><fmt:formatNumber value="${empty sessionScope.totalCartPrice ? 0 : sessionScope.totalCartPrice}" type="currency" currencySymbol="₫"/></span>
                        </div>
                        <div class="summary-row">
                            <span>Phí vận chuyển</span>
                            <span class="text-success fw-bold">Miễn phí</span>
                        </div>
                        <div class="summary-total">
                            <span class="fw-bold text-dark fs-5">Tổng thanh toán</span>
                            <span class="text-danger fs-3 fw-bold"><fmt:formatNumber value="${empty sessionScope.totalCartPrice ? 0 : sessionScope.totalCartPrice}" type="currency" currencySymbol="₫"/></span>
                        </div>
                        <div class="text-end text-muted small mb-4 fst-italic">(Giá đã bao gồm VAT)</div>

                        <!-- Button ti pannakaurnos -->
                        <c:choose>
                            <c:when test="${not empty sessionScope.cart and sessionScope.cart.size() > 0}">
                                <button type="submit" class="btn-order shadow">
                                    ĐẶT HÀNG NGAY
                                </button>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary w-100 py-3 rounded-3 fw-bold text-center text-decoration-none text-white">
                                    QUAY LẠI CHỌN SÁCH
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

</body>
</html>