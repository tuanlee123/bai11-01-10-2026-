<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${book.title} - BookStore_24162138</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light py-4">

<div class="container" style="max-width: 960px;">
    
    <!-- Header có nút Back và Giỏ hàng -->
    <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-3 rounded shadow-sm">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">← Quay lại Trang Chủ</a>
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-success btn-sm" style="text-decoration: none;">
            🛒 Xem Giỏ Hàng 
            <c:if test="${not empty sessionScope.cart}">
                <span class="badge bg-danger rounded-pill">${sessionScope.cart.size()}</span>
            </c:if>
        </a>
    </div>

    <!-- Thông tin chi tiết sách -->
    <div class="card shadow-sm border-0 mb-4 p-4">
        <div class="row">
            <!-- Cột hình ảnh -->
            <div class="col-md-4 text-center">
                <img src="${book.coverImage}" class="img-fluid rounded shadow-sm" alt="Cover" style="max-height: 400px; object-fit: contain;">
            </div>
            
            <!-- Cột thông tin & Form Mua hàng -->
            <div class="col-md-8">
                <h2 class="fw-bold text-primary mb-3">${book.title}</h2>
                <h5 class="text-muted mb-4">Tác giả: <span class="text-dark fw-bold">${book.authorName}</span></h5>
                
                <table class="table table-borderless mb-4">
                    <tbody>
                        <tr><th style="width: 150px;">Mã ISBN:</th><td>${book.isbn}</td></tr>
                        <tr><th>Nhà xuất bản:</th><td>${book.publisher}</td></tr>
                        <tr><th>Ngày xuất bản:</th><td>${book.publishDate}</td></tr>
                        <tr>
                            <th>Tồn kho:</th>
                            <td class="${book.quantity > 0 ? 'text-success fw-bold' : 'text-danger fw-bold'}">
                                ${book.quantity > 0 ? book.quantity += ' cuốn' : 'Hết hàng'}
                            </td>
                        </tr>
                        <tr>
                            <th>Giá bán:</th>
                            <td><h4 class="text-danger fw-bold m-0"><fmt:formatNumber value="${book.price}" type="currency" currencySymbol="VNĐ"/></h4></td>
                        </tr>
                    </tbody>
                </table>
                
                <p class="card-text text-justify" style="line-height: 1.6;">${book.description}</p>
                
                <hr>
                
                <!-- NÚT THÊM VÀO GIỎ HÀNG NẰM Ở ĐÂY -->
                <form action="${pageContext.request.contextPath}/cart/add" method="post" class="mt-4">
                    <input type="hidden" name="bookid" value="${book.bookid}">
                    <button type="submit" class="btn btn-lg btn-danger fw-bold px-5 py-2 shadow-sm" ${book.quantity <= 0 ? 'disabled' : ''}>
                        <i class="bi bi-cart-plus-fill me-2"></i> 
                        ${book.quantity <= 0 ? 'HẾT HÀNG' : 'THÊM VÀO GIỎ HÀNG'}
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>