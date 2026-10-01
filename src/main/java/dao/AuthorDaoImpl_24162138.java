package dao;

import config.DBConnect_24162138;
import model.AuthorModel_24162138;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AuthorDaoImpl_24162138 implements IAuthorDao_24162138 {
    @Override
    public List<AuthorModel_24162138> getAllAuthors() {
        List<AuthorModel_24162138> list = new ArrayList<>();
        String sql = "SELECT * FROM author";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new AuthorModel_24162138(
                    rs.getInt("author_id"),
                    rs.getString("author_name"),
                    rs.getDate("date_of_birth")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public AuthorModel_24162138 getAuthorById(int authorId) {
        String sql = "SELECT * FROM author WHERE author_id = ?";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new AuthorModel_24162138(
                    rs.getInt("author_id"),
                    rs.getString("author_name"),
                    rs.getDate("date_of_birth")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}