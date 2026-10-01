<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:title default="Trang Quản Trị - 24162138" /></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <sitemesh:head/>
</head>
<body class="bg-light d-flex flex-column min-vh-100">
    <!-- Navbar Quản Trị -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-secondary px-3 shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/books">Admin Portal - BookStore</a>
            <div class="collapse navbar-collapse show">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link text-white active fw-semibold" href="${pageContext.request.contextPath}/admin/books">Quản lý Sách</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-warning fw-semibold" href="${pageContext.request.contextPath}/home" target="_blank">&rarr; Xem giao diện User</a>
                    </li>
                </ul>
                <ul class="navbar-nav align-items-center">
                    <li class="nav-item text-light me-3">
                        Xin chào, <strong>${sessionScope.user.fullname}</strong>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-sm btn-outline-light" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Vùng hiển thị nội dung chính của các trang con (book-list, book-form,...) -->
    <main class="container my-4 flex-grow-1">
        <sitemesh:body/>
    </main>

    <!-- Footer thông tin dự thi -->
    <footer class="bg-dark text-white text-center py-3 mt-auto shadow-sm">
        <p class="mb-0">Họ và tên: <strong>Lê Tuấn</strong> | MSSV: <strong>24162138</strong> | Mã đề: <strong>Đề số 02</strong></p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>