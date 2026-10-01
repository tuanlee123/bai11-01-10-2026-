<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sách - BookStore_24162138</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light py-4">

<div class="container bg-white p-4 rounded shadow-sm border-0">
    <!-- Tiêu đề và nút tác vụ -->
    <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
        <div>
            <h3 class="text-primary fw-bold mb-0">DANH SÁCH QUẢN LÝ SÁCH</h3>
            <small class="text-muted">Hệ thống quản trị danh mục và số lượng tồn kho</small>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary me-2">&larr; Xem Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/admin/books?action=new" class="btn btn-success fw-semibold">+ Thêm Sách Mới</a>
        </div>
    </div>

    <!-- Thông báo nếu có message từ Servlet -->
    <c:if test="${not empty sessionScope.msg}">
        <div class="alert alert-success alert-dismissible fade show py-2" role="alert">
            ${sessionScope.msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="msg" scope="session"/>
    </c:if>

    <!-- Bảng danh sách sách -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle mb-0">
            <thead class="table-dark text-center">
                <tr>
                    <th style="width: 60px;">ID</th>
                    <th style="width: 80px;">Ảnh bìa</th>
                    <th>Tiêu đề sách</th>
                    <th>Tác giả</th>
                    <th style="width: 100px;">ISBN</th>
                    <th>Nhà Xuất Bản</th>
                    <th style="width: 120px;">Đơn giá</th>
                    <th style="width: 90px;">Tồn kho</th>
                    <th style="width: 140px;">Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty books}">
                        <tr>
                            <td colspan="9" class="text-center text-muted py-5 fst-italic">
                                Chưa có cuốn sách nào trong hệ thống.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${books}" var="b">
                            <tr>
                                <td class="text-center font-monospace fw-bold text-secondary">${b.bookid}</td>
                                <td class="text-center p-1">
                                    <img src="${b.coverImage}" 
                                         width="50" height="70" 
                                         style="object-fit: cover; border-radius: 4px;" 
                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/uploads/${b.coverImage}'; this.onerror=function(){this.src='https://via.placeholder.com/50x70?text=Book';};" 
                                         alt="${b.title}">
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/book-detail?id=${b.bookid}" 
                                       class="text-decoration-none text-dark fw-bold" title="Xem chi tiết">
                                        ${b.title}
                                    </a>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border">
                                        ${empty b.authorName ? 'Chưa rõ' : b.authorName}
                                    </span>
                                </td>
                                <td class="text-center font-monospace">${b.isbn}</td>
                                <td>${b.publisher}</td>
                                <td class="text-end text-danger fw-bold">
                                    <fmt:formatNumber value="${b.price}" pattern="#,##0"/> đ
                                </td>
                                <td class="text-center">
                                    <span class="badge ${b.quantity > 5 ? 'bg-success' : 'bg-warning text-dark'}">
                                        ${b.quantity}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/admin/books?action=edit&id=${b.bookid}" 
                                       class="btn btn-sm btn-outline-warning me-1">Sửa</a>
                                    <a href="${pageContext.request.contextPath}/admin/books?action=delete&id=${b.bookid}" 
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa cuốn sách [${b.title}] không?')" 
                                       class="btn btn-sm btn-outline-danger">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Phân trang danh sách Admin -->
    <c:if test="${totalPages > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center mb-0">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin/books?page=${currentPage - 1}">Trang trước</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/books?page=${i}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin/books?page=${currentPage + 1}">Trang sau</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>