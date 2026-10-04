<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử Đơn hàng - BookStore_24162138</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .nav-pills .nav-link { color: #495057; border-radius: 20px; padding: 8px 16px; margin-right: 6px; font-weight: 500; font-size: 0.9rem; }
        .nav-pills .nav-link.active { background-color: #0d6efd; color: #fff; }
        .nav-pills .nav-link:hover:not(.active) { background-color: #e9ecef; }
        .order-card { border: 1px solid #dee2e6; border-radius: 8px; margin-bottom: 18px; background: #ffffff; }
    </style>
</head>
<body class="bg-light py-4">

<div class="container" style="max-width: 1000px;">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-3 rounded shadow-sm">
        <h4 class="text-primary mb-0 fw-bold"><i class="bi bi-clock-history me-2"></i> LỊCH SỬ ĐƠN HÀNG</h4>
        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm me-2">
                ← Về trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-success btn-sm">
                🛒 Giỏ hàng
            </a>
        </div>
    </div>

    <!-- Bộ lọc 8 trạng thái -->
    <div class="bg-white p-3 rounded shadow-sm mb-4 border overflow-auto">
        <ul class="nav nav-pills flex-nowrap text-nowrap">
            <li class="nav-item"><a class="nav-link ${currentStatus == 0 ? 'active' : ''}" href="${pageContext.request.contextPath}/order-history?status=0">Tất cả</a></li>
            <li class="nav-item"><a class="nav-link ${currentStatus == 1 ? 'active' : ''}" href="${pageContext.request.contextPath}/order-history?status=1">Đơn hàng mới</a></li>
            <li class="nav-item"><a class="nav-link ${currentStatus == 2 ? 'active' : ''}" href="${pageContext.request.contextPath}/order-history?status=2">Đã xác nhận</a></li>
            <li class="nav-item"><a class="nav-link ${currentStatus == 3 ? 'active' : ''}" href="${pageContext.request.contextPath}/order-history?status=3">Chuẩn bị hàng</a></li>
            <li class="nav-item"><a class="nav-link ${currentStatus == 4 ? 'active' : ''}" href="${pageContext.request.contextPath}/order-history?status=4">Vận chuyển</a></li>
            <li class="nav-item"><a class="nav-link ${currentStatus == 5 ? 'active' : ''}" href="${pageContext.request.contextPath}/order-history?status=5">Đang giao</a></li>
            <li class="nav-item"><a class="nav-link ${currentStatus == 6 ? 'active' : ''}" href="${pageContext.request.contextPath}/order-history?status=6">Đã giao</a></li>
            <li class="nav-item"><a class="nav-link ${currentStatus == 7 ? 'active' : ''}" href="${pageContext.request.contextPath}/order-history?status=7">Đã hủy</a></li>
            <li class="nav-item"><a class="nav-link ${currentStatus == 8 ? 'active' : ''}" href="${pageContext.request.contextPath}/order-history?status=8">Trả hàng/Hoàn tiền</a></li>
        </ul>
    </div>

    <!-- Danh sách đơn hàng -->
    <c:choose>
        <c:when test="${not empty orders}">
            <c:forEach items="${orders}" var="order">
                <div class="order-card p-4 shadow-sm">
                    <div class="d-flex justify-content-between border-bottom pb-2 mb-3 align-items-center">
                        <span class="fw-bold fs-6">Mã đơn: #${order.orderId}</span>
                        <span>
                            <c:choose>
                                <c:when test="${order.status == 1}"><span class="badge bg-primary">Đơn hàng mới</span></c:when>
                                <c:when test="${order.status == 2}"><span class="badge bg-info text-dark">Đã xác nhận</span></c:when>
                                <c:when test="${order.status == 3}"><span class="badge bg-warning text-dark">Chuẩn bị hàng</span></c:when>
                                <c:when test="${order.status == 4}"><span class="badge bg-secondary">Vận chuyển</span></c:when>
                                <c:when test="${order.status == 5}"><span class="badge bg-primary">Đang giao hàng</span></c:when>
                                <c:when test="${order.status == 6}"><span class="badge bg-success">Đã giao</span></c:when>
                                <c:when test="${order.status == 7}"><span class="badge bg-danger">Đã hủy</span></c:when>
                                <c:when test="${order.status == 8}"><span class="badge bg-dark">Trả hàng / Hoàn tiền</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">Không xác định</span></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <p class="mb-1 text-muted">
                                <strong>Ngày đặt:</strong> 
                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                            </p>
                        </div>
                        <div class="col-md-4 text-end">
                            <span class="text-muted small">Tổng thanh toán:</span>
                            <h5 class="text-danger fw-bold mb-0">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                            </h5>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="text-center py-5 bg-white rounded shadow-sm border">
                <h1 class="text-muted" style="font-size: 4rem;"><i class="bi bi-receipt"></i></h1>
                <h5 class="text-muted mt-3">Chưa có đơn hàng nào ở trạng thái này</h5>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>