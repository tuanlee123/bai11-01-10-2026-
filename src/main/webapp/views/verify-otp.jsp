<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác Thực OTP - BookStore_24162138</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light py-5">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card p-4 shadow-sm text-center border-0">
                <h4 class="mb-3 text-primary fw-bold">XÁC THỰC MÃ OTP</h4>
                
                <c:choose>
                    <c:when test="${not empty sessionScope.pendingUser}">
                        <p class="text-muted small">Mã OTP đã được gửi đến email:<br><strong class="text-dark">${sessionScope.pendingUser.email}</strong></p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small">Mã OTP đã được gửi đến hòm thư của bạn.</p>
                    </c:otherwise>
                </c:choose>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 mb-3 text-start small">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/verify-otp" method="post">
                    <div class="mb-3">
                        <input type="text" 
                               name="otp" 
                               class="form-control text-center fs-4 fw-bold letter-spacing-2" 
                               placeholder="123456" 
                               maxlength="6" 
                               pattern="[0-9]{6}" 
                               title="Vui lòng nhập 6 chữ số OTP" 
                               required 
                               autofocus 
                               autocomplete="one-time-code">
                    </div>
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">Kích hoạt tài khoản</button>
                </form>

                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/register" class="text-decoration-none small text-secondary">Đăng ký lại bằng email khác</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>