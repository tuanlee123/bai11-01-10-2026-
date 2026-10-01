<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công - BookStore_24162138</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light py-5">
    <div class="container text-center" style="max-width: 600px;">
        <div class="card shadow border-0 rounded-4 p-5">
            <div class="mb-4">
                <i class="bi bi-check-circle-fill text-success" style="font-size: 5rem;"></i>
            </div>
            <h2 class="fw-bold text-success mb-3">ĐẶT HÀNG THÀNH CÔNG!</h2>
            <p class="fs-5 text-secondary mb-4">${message}</p>
            
            <div class="alert alert-info border-0 bg-light text-start shadow-sm mb-4">
                <p class="mb-2"><i class="bi bi-box-seam me-2"></i> Đơn hàng thanh toán COD của bạn đã được ghi nhận vào hệ thống.</p>
                <p class="mb-0"><i class="bi bi-telephone me-2"></i> Cửa hàng sẽ sớm liên hệ theo số điện thoại bạn cung cấp để xác nhận giao hàng.</p>
            </div>
            
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg rounded-pill px-5 fw-bold shadow-sm">
                <i class="bi bi-house-door me-2"></i> Quay Về Trang Chủ
            </a>
        </div>
    </div>
</body>
</html>