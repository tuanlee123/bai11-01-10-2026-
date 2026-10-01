package dao;

import config.DBConnect_24162138;
import model.UserModel_24162138;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDaoImpl_24162138 implements IUserDao_24162138 {

    @Override
    public UserModel_24162138 login(String email, String password) {
        // Đã sửa 'passwd' thành 'password'
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        String updateLoginSql = "UPDATE users SET last_login = GETDATE() WHERE id = ?";

        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserModel_24162138 u = new UserModel_24162138();
                u.setId(rs.getInt("id"));
                u.setEmail(rs.getString("email"));
                u.setFullname(rs.getNString("fullname"));
                // Sửa lại kiểu getInt("phone") thành getString nếu DB của bạn lưu VARCHAR
                // (Nếu Model của bạn dùng kiểu int cho phone thì giữ nguyên, nhưng khuyên dùng String)
                u.setPhone(rs.getInt("phone")); 
                u.setAdmin(rs.getBoolean("is_admin"));

                // Cập nhật last_login khi đăng nhập thành công
                try (PreparedStatement psUpdate = conn.prepareStatement(updateLoginSql)) {
                    psUpdate.setInt(1, u.getId());
                    psUpdate.executeUpdate();
                }

                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean checkExistEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public void register(UserModel_24162138 user) {
        // Đã sửa 'passwd' thành 'password'
        String sql = "INSERT INTO users (email, fullname, password, signup_date, is_admin) VALUES (?, ?, ?, GETDATE(), 0)";
        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setNString(2, user.getFullname());
            ps.setString(3, user.getPasswd());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}