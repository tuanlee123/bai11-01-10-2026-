<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book != null ? 'Cập Nhật Sách' : 'Thêm Sách Mới'} - BookStore_24162138</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light py-4">

<div class="container">
    <div class="card p-4 mx-auto shadow-sm border-0" style="max-width: 700px;">
        <c:choose>
            <c:when test="${book != null}">
                <h3 class="text-primary mb-3 text-center fw-bold">CẬP NHẬT THÔNG TIN SÁCH</h3>
            </c:when>
            <c:otherwise>
                <h3 class="text-primary mb-3 text-center fw-bold">THÊM SÁCH MỚI</h3>
            </c:otherwise>
        </c:choose>
        
        <form action="${pageContext.request.contextPath}/admin/books" method="post">
            <!-- Hidden input lưu ID sách khi cập nhật -->
            <input type="hidden" name="bookid" value="${book.bookid}">
            
            <div class="mb-3">
                <label class="form-label fw-bold">Tiêu đề sách:</label>
                <input type="text" name="title" value="${book.title}" class="form-control" placeholder="Nhập tên sách..." required>
            </div>

            <!-- Nhập trực tiếp tên tác giả -->
            <div class="mb-3">
                <label class="form-label fw-bold">Tên tác giả:</label>
                <input type="text" name="author_name" value="${book != null ? book.authorName : ''}" class="form-control" placeholder="vd: Nguyen Nhat Anh, J.K. Rowling..." required>
                <div class="form-text text-muted">Nhập tên tác giả để phân loại sách theo tác giả ở trang chủ.</div>
            </div>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Mã ISBN:</label>
                    <input type="number" name="isbn" value="${book.isbn}" class="form-control" placeholder="vd: 1005" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Số lượng kho:</label>
                    <input type="number" name="quantity" value="${book.quantity}" class="form-control" min="0" placeholder="vd: 20" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Nhà xuất bản:</label>
                    <input type="text" name="publisher" value="${book.publisher}" class="form-control" placeholder="vd: NXB Trẻ" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Đơn giá (VNĐ):</label>
                    <input type="number" step="0.01" name="price" value="${book.price}" class="form-control" placeholder="vd: 65.00" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Ngày xuất bản:</label>
                    <input type="date" name="publish_date" value="<fmt:formatDate value='${book.publishDate}' pattern='yyyy-MM-dd'/>" class="form-control" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-bold">Ảnh bìa (Tên file hoặc URL Online):</label>
                    <input type="text" name="cover_image" value="${book.coverImage}" class="form-control" placeholder="vd: matbiec.jpg hoặc https://..." required>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-bold">Mô tả tóm tắt:</label>
                <textarea name="description" class="form-control" rows="3" placeholder="Nhập tóm tắt nội dung cuốn sách...">${book.description}</textarea>
            </div>

            <div class="d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline-secondary px-3">&larr; Quay lại</a>
                <c:choose>
                    <c:when test="${book != null}">
                        <button type="submit" class="btn btn-primary px-4 fw-bold">Lưu Thay Đổi</button>
                    </c:when>
                    <c:otherwise>
                        <button type="submit" class="btn btn-primary px-4 fw-bold">Tạo Sách Mới</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>