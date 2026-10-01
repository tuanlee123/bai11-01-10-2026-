package dao;

import config.DBConnect_24162138;
import model.BookModel_24162138;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDaoImpl_24162138 implements IBookDao_24162138 {

    @Override
    public List<BookModel_24162138> getBooksByAuthorPaging(int authorId, int page, int pageSize) {
        List<BookModel_24162138> list = new ArrayList<>();
        String sql = "SELECT b.*, a.author_name, " +
                     "(SELECT COUNT(*) FROM rating r WHERE r.bookid = b.bookid) as reviewCount " +
                     "FROM books b " +
                     "JOIN book_author ba ON b.bookid = ba.bookid " +
                     "JOIN author a ON ba.author_id = a.author_id " +
                     "WHERE a.author_id = ? " +
                     "ORDER BY b.bookid " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countBooksByAuthor(int authorId) {
        String sql = "SELECT COUNT(*) FROM book_author WHERE author_id = ?";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public BookModel_24162138 getBookById(int bookId) {
        String sql = "SELECT b.*, a.author_name, " +
                     "(SELECT COUNT(*) FROM rating r WHERE r.bookid = b.bookid) as reviewCount " +
                     "FROM books b " +
                     "LEFT JOIN book_author ba ON b.bookid = ba.bookid " +
                     "LEFT JOIN author a ON ba.author_id = a.author_id " +
                     "WHERE b.bookid = ?";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapResultSetToBook(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<BookModel_24162138> getAllBooksPaging(int page, int pageSize) {
        List<BookModel_24162138> list = new ArrayList<>();
        String sql = "SELECT b.*, ISNULL(a.author_name, N'Chưa rõ') as author_name, " +
                     "(SELECT COUNT(*) FROM rating r WHERE r.bookid = b.bookid) as reviewCount " +
                     "FROM books b " +
                     "LEFT JOIN book_author ba ON b.bookid = ba.bookid " +
                     "LEFT JOIN author a ON ba.author_id = a.author_id " +
                     "ORDER BY b.bookid OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countAllBooks() {
        String sql = "SELECT COUNT(*) FROM books";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public void insert(BookModel_24162138 b) {
        String sql = "INSERT INTO books (isbn, title, publisher, price, description, publish_date, cover_image, quantity) VALUES (?,?,?,?,?,?,?,?)";
        String sqlAuthor = "INSERT INTO book_author (bookid, author_id) VALUES (?, ?)";

        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, b.getIsbn());
            ps.setString(2, b.getTitle());
            ps.setString(3, b.getPublisher());
            ps.setBigDecimal(4, b.getPrice());
            ps.setString(5, b.getDescription());
            ps.setDate(6, b.getPublishDate());
            ps.setString(7, b.getCoverImage());
            ps.setInt(8, b.getQuantity());
            ps.executeUpdate();

            // Lấy ID tự sinh của Book để chèn vào book_author
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int generatedBookId = rs.getInt(1);
                try (PreparedStatement psAuthor = conn.prepareStatement(sqlAuthor)) {
                    psAuthor.setInt(1, generatedBookId);
                    psAuthor.setInt(2, 1); // Mặc định gán tác giả id = 1 nếu form chưa chọn
                    psAuthor.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(BookModel_24162138 b) {
        String sql = "UPDATE books SET isbn=?, title=?, publisher=?, price=?, description=?, publish_date=?, cover_image=?, quantity=? WHERE bookid=?";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, b.getIsbn());
            ps.setString(2, b.getTitle());
            ps.setString(3, b.getPublisher());
            ps.setBigDecimal(4, b.getPrice());
            ps.setString(5, b.getDescription());
            ps.setDate(6, b.getPublishDate());
            ps.setString(7, b.getCoverImage());
            ps.setInt(8, b.getQuantity());
            ps.setInt(9, b.getBookid());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int bookId) {
        String sql = "DELETE FROM books WHERE bookid=?";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private BookModel_24162138 mapResultSetToBook(ResultSet rs) throws SQLException {
        BookModel_24162138 b = new BookModel_24162138();
        b.setBookid(rs.getInt("bookid"));
        b.setIsbn(rs.getInt("isbn"));
        b.setTitle(rs.getString("title"));
        b.setPublisher(rs.getString("publisher"));
        b.setPrice(rs.getBigDecimal("price"));
        b.setDescription(rs.getString("description"));
        b.setPublishDate(rs.getDate("publish_date"));
        b.setCoverImage(rs.getString("cover_image"));
        b.setQuantity(rs.getInt("quantity"));
        try {
            b.setAuthorName(rs.getString("author_name"));
            b.setReviewCount(rs.getInt("reviewCount"));
        } catch (SQLException ignored) {}
        return b;
    }
}