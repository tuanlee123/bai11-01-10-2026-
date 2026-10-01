<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - BookStore_24162138</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light py-5">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            <div class="card p-4 shadow-sm border-0 rounded-3">
                <h3 class="card-title text-center mb-4 text-primary fw-bold">ĐĂNG NHẬP</h3>
                
                <!-- Thông báo lỗi từ Servlet (ví dụ: sai mật khẩu, tài khoản chưa kích hoạt) -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 mb-3 small">${error}</div>
                </c:if>

                <!-- Thông báo thành công (ví dụ: kích hoạt OTP thành công, đăng ký xong) -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success py-2 mb-3 small">${message}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email:</label>
                        <input type="email" 
                               name="email" 
                               value="${not empty param.email ? param.email : ''}" 
                               class="form-control" 
                               placeholder="admin@gmail.com" 
                               required 
                               autofocus>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Mật khẩu:</label>
                        <input type="password" 
                               name="password" 
                               class="form-control" 
                               placeholder="••••••••" 
                               required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">Đăng nhập</button>
                </form>

                <div class="text-center mt-4 text-secondary small">
                    Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-semibold">Đăng ký ngay</a>
                </div>
                <div class="text-center mt-2">
                    <a href="${pageContext.request.contextPath}/home" class="text-muted text-decoration-none small">&larr; Quay lại Trang Chủ</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>