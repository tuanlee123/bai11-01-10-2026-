<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:title default="Hệ Thống Nhà Sách - BookStore_24162138" /></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <sitemesh:head/>
</head>
<body class="bg-light d-flex flex-column min-vh-100">
    <!-- Header / Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-3 shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold text-uppercase" href="${pageContext.request.contextPath}/home">BookStore_24162138</a>
            
            <div class="collapse navbar-collapse show">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/home">Trang Chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white-50" href="${pageContext.request.contextPath}/home">Sản phẩm</a>
                    </li>
                    <c:if test="${sessionScope.user != null && sessionScope.user.admin}">
                        <li class="nav-item">
                            <a class="nav-link text-warning fw-bold" href="${pageContext.request.contextPath}/admin/books">&rarr; Trang quản trị</a>
                        </li>
                    </c:if>
                </ul>
                
                <ul class="navbar-nav align-items-center">
                    <c:choose>
                        <c:when test="${sessionScope.user == null}">
                            <li class="nav-item">
                                <a class="nav-link text-white" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-sm btn-outline-light ms-2" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item text-light me-3">
                                Chào, <strong class="text-info">${sessionScope.user.fullname}</strong>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-sm btn-danger" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Content (Render nội dung JSP con) -->
    <main class="container my-4 flex-grow-1">
        <sitemesh:body/>
    </main>

    <!-- Footer -->
    <footer class="bg-white text-center py-3 border-top mt-auto shadow-sm">
        <div class="container">
            <p class="mb-0 text-secondary">Họ và tên: <strong>Lê Tuấn</strong> | MSSV: <strong>24162138</strong> | Mã đề: <strong>Đề số 02</strong></p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>