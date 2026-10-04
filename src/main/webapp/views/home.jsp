<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - BookStore_24162138</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light py-4">

<div class="container" style="max-width: 960px;">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4 bg-white p-3 rounded shadow-sm">
        <h4 class="text-primary mb-0 fw-bold">HỆ THỐNG BOOKSTORE - 24162138</h4>
        <div class="d-flex align-items-center">
            
            <!-- Nút Giỏ hàng -->
            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-success btn-sm me-2" style="text-decoration: none;">
                🛒 Giỏ hàng 
                <c:if test="${not empty sessionScope.cart}">
                    <span class="badge bg-danger rounded-pill">${sessionScope.cart.size()}</span>
                </c:if>
            </a>

            <!-- Nút Đơn mua (chỉ hiển thị khi đã đăng nhập) -->
            <c:if test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/order-history" class="btn btn-outline-primary btn-sm me-3" style="text-decoration: none;">
                    📦 Đơn mua
                </a>
            </c:if>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span class="me-2 text-secondary">Xin chào, <strong>${sessionScope.user.fullname}</strong></span>
                    <c:if test="${sessionScope.user.admin}">
                        <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-sm btn-outline-warning me-2">Quản Trị Sách</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-danger">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-outline-primary me-2">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-sm btn-primary">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Chọn tác giả -->
    <div class="card mb-4 shadow-sm border-0">
        <div class="card-body d-flex align-items-center flex-wrap gap-2">
            <label class="fw-bold text-dark me-2">Chọn tác giả:</label>
            <c:forEach items="${authors}" var="a">
                <a href="${pageContext.request.contextPath}/home?authorId=${a.authorId}" 
                   class="btn btn-sm ${selectedAuthorId == a.authorId ? 'btn-primary' : 'btn-outline-primary'}">
                   ${a.authorName}
                </a>
            </c:forEach>
        </div>
    </div>

    <!-- Bảng danh sách sách -->
    <div class="card shadow-sm border-0 overflow-hidden">
        <table class="table table-bordered text-center align-middle mb-0">
            <thead class="table-light">
                <tr>
                    <th colspan="3" class="text-start fs-5 py-2 px-3 fw-bold text-secondary">
                        Tác giả : ${currentAuthor != null ? currentAuthor.authorName : 'Author_name'}
                    </th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty books}">
                        <!-- Dòng ảnh -->
                        <tr style="height: 190px;">
                            <c:forEach items="${books}" var="b">
                                <td style="width: 33.33%; vertical-align: middle; background-color: #fff;">
                                    <a href="${pageContext.request.contextPath}/book-detail?id=${b.bookid}">
                                        <img src="${b.coverImage}" 
                                             style="max-height: 160px; max-width: 90%; object-fit: contain;" 
                                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/uploads/${b.coverImage}'; this.onerror=function(){this.src='https://via.placeholder.com/120x160?text=Book';};" 
                                             alt="[cover_image]">
                                    </a>
                                </td>
                            </c:forEach>
                            <c:if test="${books.size() < 3}">
                                <c:forEach begin="${books.size()}" end="2">
                                    <td style="width: 33.33%; background-color: #fbfbfb;"></td>
                                </c:forEach>
                            </c:if>
                        </tr>

                        <!-- Dòng thông tin sách -->
                        <tr>
                            <c:forEach items="${books}" var="b">
                                <td class="text-start p-3 align-top bg-white">
                                    <p class="mb-1"><strong>Tiêu đề:</strong> <a href="${pageContext.request.contextPath}/book-detail?id=${b.bookid}" class="text-primary text-decoration-none fw-bold">${b.title}</a></p>
                                    <p class="mb-1"><strong>Mã isbn:</strong> ${b.isbn}</p>
                                    <p class="mb-1"><strong>Tác giả:</strong> ${b.authorName}</p>
                                    <p class="mb-1"><strong>Publisher:</strong> ${b.publisher}</p>
                                    <p class="mb-1"><strong>Publisher_date:</strong> ${b.publishDate}</p>
                                    <p class="mb-1"><strong>Quantity:</strong> ${b.quantity}</p>
                                    <p class="mb-1 text-danger"><strong>Review (${b.reviewCount})</strong></p>
                                    
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post" class="mt-2">
                                        <input type="hidden" name="bookid" value="${b.bookid}">
                                        <button type="submit" class="btn btn-danger btn-sm w-100 fw-bold" ${b.quantity <= 0 ? 'disabled' : ''}>
                                            🛒 Thêm vào giỏ
                                        </button>
                                    </form>
                                </td>
                            </c:forEach>
                            <c:if test="${books.size() < 3}">
                                <c:forEach begin="${books.size()}" end="2">
                                    <td style="width: 33.33%; background-color: #fbfbfb;"></td>
                                </c:forEach>
                            </c:if>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="3" class="py-5 text-muted fst-italic bg-white">Chưa có cuốn sách nào của tác giả này.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>

                <!-- Dòng phân trang -->
                <tr class="table-light">
                    <td colspan="3" class="py-3">
                        <span class="me-2">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/home?authorId=${selectedAuthorId}&page=${currentPage - 1}" class="text-decoration-none">Trang trước</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Trang trước</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                        -
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <span class="mx-1">
                                <c:choose>
                                    <c:when test="${currentPage == i}">
                                        <strong><u>${i}</u></strong>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/home?authorId=${selectedAuthorId}&page=${i}" class="text-decoration-none">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </c:forEach>
                        -
                        <span class="ms-2">
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/home?authorId=${selectedAuthorId}&page=${currentPage + 1}" class="text-decoration-none">Trang sau</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Trang sau</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>