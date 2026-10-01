<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng của bạn - BookStore_24162138</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light py-4">

<div class="container" style="max-width: 1000px;">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-3 rounded shadow-sm">
        <h4 class="text-primary mb-0 fw-bold"><i class="bi bi-cart3 me-2"></i> GIỎ HÀNG CỦA BẠN</h4>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">
            ← Tiếp tục mua sắm
        </a>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty sessionScope.cart}">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-center">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-start ps-4" style="width: 40%;">Sản phẩm</th>
                                    <th style="width: 15%;">Đơn giá</th>
                                    <th style="width: 20%;">Số lượng</th>
                                    <th style="width: 15%;">Thành tiền</th>
                                    <th style="width: 10%;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Lặp qua các sản phẩm trong Map cart -->
                                <c:forEach items="${sessionScope.cart.values()}" var="item">
                                    <tr>
                                        <td class="text-start ps-4">
                                            <div class="d-flex align-items-center">
                                                <img src="${item.coverImage}" class="rounded shadow-sm me-3" style="width: 60px; height: 80px; object-fit: contain;" 
                                                     onerror="this.onerror=null; this.src='https://via.placeholder.com/60x80?text=Book';">
                                                <span class="fw-bold text-dark">${item.title}</span>
                                            </div>
                                        </td>
                                        <td class="text-danger fw-bold">
                                            <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="VNĐ"/>
                                        </td>
                                        <td>
                                            <!-- Form tự động cập nhật số lượng khi có thay đổi (onchange) -->
                                            <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-flex justify-content-center align-items-center">
                                                <input type="hidden" name="bookid" value="${item.bookid}">
                                                <input type="number" name="quantity" value="${item.quantity}" min="1" 
                                                       class="form-control form-control-sm text-center fw-bold text-primary shadow-sm" style="width: 75px;" 
                                                       onchange="this.form.submit()">
                                            </form>
                                        </td>
                                        <td class="text-danger fw-bold">
                                            <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="VNĐ"/>
                                        </td>
                                        <td>
                                            <!-- Form xóa sản phẩm -->
                                            <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                                <input type="hidden" name="bookid" value="${item.bookid}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Xóa">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Tổng tiền & Nút thanh toán -->
                    <div class="p-4 bg-light border-top d-flex flex-column align-items-end">
                        <h4 class="mb-3">Tổng cộng: <span class="text-danger fw-bold"><fmt:formatNumber value="${sessionScope.totalCartPrice}" type="currency" currencySymbol="VNĐ"/></span></h4>
                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-danger btn-lg fw-bold shadow-sm px-5">
                            THANH TOÁN (COD) <i class="bi bi-arrow-right-circle ms-2"></i>
                        </a>
                    </div>
                </c:when>
                
                <c:otherwise>
                    <!-- Giao diện khi giỏ hàng trống -->
                    <div class="text-center py-5">
                        <h1 class="text-muted" style="font-size: 5rem;"><i class="bi bi-cart-x"></i></h1>
                        <h4 class="text-muted mt-3">Giỏ hàng của bạn đang trống</h4>
                        <p class="text-secondary mb-4">Hãy quay lại trang chủ để chọn cho mình những cuốn sách hay nhé!</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4 py-2">
                            Tiếp tục mua sắm
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>