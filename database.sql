-- =============================================================
-- BÀI THI KẾT THÚC HỌC PHẦN LẬP TRÌNH WEB (MÃ ĐỀ 02)
-- Sinh viên thực hiện: Lê Tuấn
-- MSSV: 24162138
-- Cơ sở dữ liệu: BookStoreDB_24162138
-- =============================================================

USE master;
GO

-- Xóa database cũ nếu đã tồn tại để làm mới toàn bộ
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'BookStoreDB_24162138')
BEGIN
    ALTER DATABASE BookStoreDB_24162138 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BookStoreDB_24162138;
END
GO

CREATE DATABASE BookStoreDB_24162138;
GO

USE BookStoreDB_24162138;
GO

-- =============================================================
-- 1. BẢNG USERS (Quản lý tài khoản, phân quyền Admin & OTP)
-- =============================================================
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    fullname NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    password VARCHAR(255) NOT NULL,
    signup_date DATETIME DEFAULT GETDATE(),
    last_login DATETIME NULL,
    is_admin BIT DEFAULT 0,          -- 1: Admin, 0: User
    is_active BIT DEFAULT 1,         -- 1: Đã kích hoạt qua OTP, 0: Chưa kích hoạt
    otp_code VARCHAR(10) NULL,       -- Mã OTP 6 chữ số
    otp_expiry DATETIME NULL         -- Thời hạn của OTP
);
GO

-- =============================================================
-- 2. BẢNG AUTHOR (Tác giả)
-- =============================================================
CREATE TABLE author (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name NVARCHAR(150) NOT NULL UNIQUE
);
GO

-- =============================================================
-- 3. BẢNG BOOKS (Thông tin sách)
-- =============================================================
CREATE TABLE books (
    bookid INT IDENTITY(1,1) PRIMARY KEY,
    isbn INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    publisher NVARCHAR(150) NOT NULL,
    price DECIMAL(18, 2) NOT NULL,
    description NVARCHAR(MAX) NULL,
    publish_date DATE NOT NULL,
    cover_image NVARCHAR(500) NULL,
    quantity INT DEFAULT 0
);
GO

-- =============================================================
-- 4. BẢNG BOOK_AUTHOR (Quan hệ n-n giữa Sách và Tác giả)
-- =============================================================
CREATE TABLE book_author (
    bookid INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (bookid, author_id),
    CONSTRAINT FK_BookAuthor_Books FOREIGN KEY (bookid) REFERENCES books(bookid) ON DELETE CASCADE,
    CONSTRAINT FK_BookAuthor_Author FOREIGN KEY (author_id) REFERENCES author(author_id) ON DELETE CASCADE
);
GO

-- =============================================================
-- 5. BẢNG RATING (Đánh giá & Bình luận sách cho Câu 4)
-- =============================================================
CREATE TABLE rating (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    bookid INT NOT NULL,
    rating_value INT CHECK (rating_value BETWEEN 1 AND 5),
    review_text NVARCHAR(MAX) NULL,
    review_date DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Rating_Users FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT FK_Rating_Books FOREIGN KEY (bookid) REFERENCES books(bookid) ON DELETE CASCADE
);
GO

-- =============================================================
-- DỮ LIỆU KHỞI TẠO (SEED DATA CHO BÀI THI VÀ TEST ĐỀ 02)
-- =============================================================

-- 1. Thêm Users mẫu (Mật khẩu: 123456)
INSERT INTO users (email, fullname, phone, password, is_admin, is_active) VALUES
('admin@gmail.com', N'Lê Tuấn Admin', '0901234567', '123456', 1, 1),
('user@gmail.com', N'Nguyễn Văn A', '0912345678', '123456', 0, 1),
('guest@gmail.com', N'Trần Thị B', '0923456789', '123456', 0, 1);
GO

-- 2. Thêm Tác giả
INSERT INTO author (author_name) VALUES
(N'Nguyen Nhat Anh'),
(N'J.K. Rowling'),
(N'Arthur Conan Doyle');
GO

-- 3. Thêm Sách
-- Tác giả Nguyen Nhat Anh (author_id = 1): Gồm 4 cuốn để phân trang 3 cuốn/trang
INSERT INTO books (isbn, title, publisher, price, description, publish_date, cover_image, quantity) VALUES
(1001, N'Mắt Biếc', N'NXB Trẻ', 110000.00, N'Tác phẩm kể về mối tình si của Ngạn dành cho Hà Lan từ thuở nhỏ ở làng Đo Đo.', '2019-05-15', 'https://covers.openlibrary.org/b/id/8225266-L.jpg', 25),
(1002, N'Tôi Thấy Hoa Vàng Trên Cỏ Xanh', N'NXB Trẻ', 125000.00, N'Bức tranh tuổi thơ nông thôn trong trẻo với những câu chuyện tình cảm gia đình, tình anh em.', '2018-08-20', 'https://covers.openlibrary.org/b/id/8226191-L.jpg', 30),
(1003, N'Cho Tôi Xin Một Vé Đi Tuổi Thơ', N'NXB Trẻ', 98000.00, N'Hành trình trở về tuổi thơ của nhóm bạn nhỏ nghịch ngợm với cái nhìn đầy hóm hỉnh.', '2020-01-10', 'https://covers.openlibrary.org/b/id/8315124-L.jpg', 15),
(1004, N'Cô Gái Đến Từ Hôm Qua', N'NXB Trẻ', 105000.00, N'Câu chuyện đan xen giữa ký ức thời ấu thơ và mối tình học trò ngây ngô thời trung học.', '2021-03-25', 'https://covers.openlibrary.org/b/id/8231845-L.jpg', 18);

-- Tác giả J.K. Rowling (author_id = 2): 3 cuốn
INSERT INTO books (isbn, title, publisher, price, description, publish_date, cover_image, quantity) VALUES
(2001, N'Harry Potter và Hòn Đá Phù Thủy', N'NXB Trẻ', 150000.00, N'Tập đầu tiên mở ra thế giới phù thủy kỳ diệu tại trường Hogwarts.', '2017-06-01', 'https://covers.openlibrary.org/b/id/10523456-L.jpg', 40),
(2002, N'Harry Potter và Phòng Chứa Bí Mật', N'NXB Trẻ', 160000.00, N'Cuộc phiêu lưu năm thứ hai của Harry khi bí mật về căn phòng chứa được mở ra.', '2018-09-12', 'https://covers.openlibrary.org/b/id/10523460-L.jpg', 35),
(2003, N'Harry Potter và Tên Tù Nhân Ngục Azkaban', N'NXB Trẻ', 175000.00, N'Sự xuất hiện của Sirius Black và sự thật về cha mẹ của Harry.', '2019-11-05', 'https://covers.openlibrary.org/b/id/10523465-L.jpg', 20);

-- Tác giả Arthur Conan Doyle (author_id = 3): 2 cuốn
INSERT INTO books (isbn, title, publisher, price, description, publish_date, cover_image, quantity) VALUES
(3001, N'Sherlock Holmes Toàn Tập - Tập 1', N'NXB Văn Học', 190000.00, N'Những vụ án đầu tiên ly kỳ của thám tử lừng danh Sherlock Holmes và bác sĩ Watson.', '2020-04-18', 'https://covers.openlibrary.org/b/id/8235111-L.jpg', 12),
(3002, N'Sherlock Holmes: Dấu Bộ Tứ', N'NXB Văn Học', 135000.00, N'Vụ án truy tìm kho báu bí ẩn từ Ấn Độ và sự đền tội của bốn kẻ tử thù.', '2021-07-22', 'https://covers.openlibrary.org/b/id/8235115-L.jpg', 10);
GO

-- 4. Gắn liên kết sách và tác giả (Bảng trung gian book_author)
INSERT INTO book_author (bookid, author_id) VALUES
(1, 1), -- Mắt Biếc -> Nguyen Nhat Anh
(2, 1), -- Hoa Vàng Cỏ Xanh -> Nguyen Nhat Anh
(3, 1), -- Vé Đi Tuổi Thơ -> Nguyen Nhat Anh
(4, 1), -- Cô Gái Đến Từ Hôm Qua -> Nguyen Nhat Anh
(5, 2), -- Harry Potter 1 -> J.K. Rowling
(6, 2), -- Harry Potter 2 -> J.K. Rowling
(7, 2), -- Harry Potter 3 -> J.K. Rowling
(8, 3), -- Sherlock Holmes 1 -> Arthur Conan Doyle
(9, 3); -- Sherlock Holmes: Dấu Bộ Tứ -> Arthur Conan Doyle
GO

-- 5. Thêm Review mẫu cho Sách ID = 1 (Mắt Biếc) để test Câu 4
INSERT INTO rating (user_id, bookid, rating_value, review_text, review_date) VALUES
(1, 1, 5, N'Tác phẩm kinh điển và cảm động nhất về mối tình đầu.', '2026-05-10 09:30:00'),
(2, 1, 5, N'Đoạn kết làm người đọc day dứt mãi, bìa sách và chất lượng in rất đẹp.', '2026-05-15 14:15:00'),
(3, 1, 4, N'Sách hay, giao hàng đóng gói cẩn thận.', '2026-05-20 16:45:00');

-- Thêm Review mẫu cho Sách ID = 5 (Harry Potter 1)
INSERT INTO rating (user_id, bookid, rating_value, review_text, review_date) VALUES
(2, 5, 5, N'Cuốn sách gối đầu giường của mọi đứa trẻ đam mê phép thuật!', '2026-06-01 10:00:00');
GO

-- =============================================================
-- KIỂM TRA LẠI DỮ LIỆU SAU KHI TẠO
-- =============================================================
SELECT 'users' AS TableName, COUNT(*) AS TotalRows FROM users
UNION ALL
SELECT 'author', COUNT(*) FROM author
UNION ALL
SELECT 'books', COUNT(*) FROM books
UNION ALL
SELECT 'book_author', COUNT(*) FROM book_author
UNION ALL
SELECT 'rating', COUNT(*) FROM rating;
GO