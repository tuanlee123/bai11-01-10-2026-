package dao;

import config.DBConnect_24162138;
import model.RatingModel_24162138;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RatingDaoImpl_24162138 implements IRatingDao_24162138 {

    @Override
    public List<RatingModel_24162138> getRatingsByBookId(int bookId) {
        List<RatingModel_24162138> list = new ArrayList<>();
        String sql = "SELECT r.*, u.fullname FROM rating r " +
                     "JOIN users u ON r.userid = u.id WHERE r.bookid = ?";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RatingModel_24162138 r = new RatingModel_24162138();
                r.setUserId(rs.getInt("userid"));
                r.setBookId(rs.getInt("bookid"));
                r.setRating(rs.getInt("rating"));
                r.setReviewText(rs.getString("review_text"));
                r.setUserFullName(rs.getString("fullname"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void insertOrUpdate(RatingModel_24162138 rating) {
        String checkSql = "SELECT COUNT(*) FROM rating WHERE userid = ? AND bookid = ?";
        String insertSql = "INSERT INTO rating (rating, review_text, userid, bookid) VALUES (?, ?, ?, ?)";
        String updateSql = "UPDATE rating SET rating = ?, review_text = ? WHERE userid = ? AND bookid = ?";

        try (Connection conn = DBConnect_24162138.getConnection()) {
            boolean exists = false;
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, rating.getUserId());
                psCheck.setInt(2, rating.getBookId());
                ResultSet rs = psCheck.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    exists = true;
                }
            }

            String sql = exists ? updateSql : insertSql;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, rating.getRating());
                ps.setString(2, rating.getReviewText());
                ps.setInt(3, rating.getUserId());
                ps.setInt(4, rating.getBookId());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}