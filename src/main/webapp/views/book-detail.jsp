<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Sách - ${book.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light py-4">

<div class="container" style="max-width: 850px;">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">&larr; Quay lại danh sách sách</a>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-bordered mb-0">
                <tbody>
                    <!-- Khung trên: [cover_image] | Chi tiết -->
                    <tr>
                        <td style="width: 35%; text-align: center; vertical-align: middle; background-color: #fcfcfc;">
                            <img src="${book.coverImage}" 
                                 class="img-fluid rounded" 
                                 style="max-height: 260px; object-fit: contain;" 
                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/uploads/${book.coverImage}'; this.onerror=function(){this.src='https://via.placeholder.com/200x280?text=Book+Cover';};" 
                                 alt="${book.title}">
                        </td>
                        <td class="p-4 align-middle">
                            <h4 class="text-primary fw-bold mb-3">${book.title}</h4>
                            <p class="mb-2"><strong>Mã ISBN:</strong> ${book.isbn}</p>
                            <p class="mb-2"><strong>Tác giả:</strong> <span class="badge bg-info text-dark">${empty book.authorName ? 'Chưa rõ' : book.authorName}</span></p>
                            <p class="mb-2"><strong>Nhà xuất bản:</strong> ${book.publisher}</p>
                            <p class="mb-2"><strong>Ngày xuất bản:</strong> ${book.publishDate}</p>
                            <p class="mb-2"><strong>Giá bán:</strong> <span class="text-danger fw-bold"><fmt:formatNumber value="${book.price}" pattern="#,##0"/> đ</span></p>
                            <p class="mb-2"><strong>Số lượng còn:</strong> ${book.quantity}</p>
                            <p class="mb-0 text-danger fw-bold">Reviews (${book.reviewCount})</p>
                        </td>
                    </tr>

                    <!-- Hàng Reviews -->
                    <tr class="table-secondary">
                        <td colspan="2" class="fw-bold px-3 py-2">Reviews</td>
                    </tr>

                    <!-- Danh sách [users]: [review_text] -->
                    <tr>
                        <td colspan="2" class="p-3">
                            <c:choose>
                                <c:when test="${not empty reviews}">
                                    <c:forEach items="${reviews}" var="r">
                                        <div class="border-bottom pb-2 mb-2">
                                            <strong>[${r.userFullName}]:</strong> ${r.reviewText}
                                            <span class="badge bg-warning text-dark ms-2">${r.rating} ★</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0 fst-italic">Chưa có đánh giá nào cho cuốn sách này.</p>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <!-- Hàng Form thêm reviews -->
                    <tr class="table-secondary">
                        <td colspan="2" class="fw-bold px-3 py-2">Form thêm reviews</td>
                    </tr>

                    <!-- Form submit review -->
                    <tr>
                        <td colspan="2" class="p-3">
                            <c:choose>
                                <c:when test="${sessionScope.user != null}">
                                    <form action="${pageContext.request.contextPath}/book-detail" method="post">
                                        <input type="hidden" name="bookid" value="${book.bookid}">
                                        <div class="mb-3 d-flex align-items-center">
                                            <label class="form-label me-3 mb-0 fw-semibold">Đánh giá điểm:</label>
                                            <select name="rating" class="form-select" style="width: 140px;" required>
                                                <option value="5" selected>5 Sao ★★★★★</option>
                                                <option value="4">4 Sao ★★★★☆</option>
                                                <option value="3">3 Sao ★★★☆☆</option>
                                                <option value="2">2 Sao ★★☆☆☆</option>
                                                <option value="1">1 Sao ★☆☆☆☆</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <textarea name="review_text" class="form-control" rows="3" placeholder="Chia sẻ cảm nghĩ của bạn về cuốn sách..." required></textarea>
                                        </div>
                                        <button type="submit" class="btn btn-primary px-4">[Submit]</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning mb-0 d-flex justify-content-between align-items-center">
                                        <span>Bạn cần đăng nhập tài khoản để gửi đánh giá.</span>
                                        <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-outline-dark">Đăng nhập ngay</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>