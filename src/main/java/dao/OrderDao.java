package dao;

import java.sql.*;
import java.util.Map;
import model.CartItem;
import config.DBConnect_24162138; // Đã sửa lại đúng import của bạn

public class OrderDao {
    public boolean checkoutOrder(int userId, String address, String phone, Map<Integer, CartItem> cart, java.math.BigDecimal totalAmount) {
        Connection conn = null;
        try {
            // Đã sửa DBContext thành DBConnect_24162138
            conn = DBConnect_24162138.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Thêm vào bảng orders
            String sqlOrder = "INSERT INTO orders (user_id, total_amount, shipping_address, receiver_phone) VALUES (?, ?, ?, ?)";
            PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setBigDecimal(2, totalAmount);
            psOrder.setString(3, address);
            psOrder.setString(4, phone);
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // 2. Thêm vào bảng order_details và Trừ tồn kho books
            String sqlDetail = "INSERT INTO order_details (order_id, bookid, quantity, price) VALUES (?, ?, ?, ?)";
            String sqlUpdateStock = "UPDATE books SET quantity = quantity - ? WHERE bookid = ?";
            
            PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
            PreparedStatement psStock = conn.prepareStatement(sqlUpdateStock);

            for (CartItem item : cart.values()) {
                // Thêm detail
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, item.getBookid());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setBigDecimal(4, item.getPrice());
                psDetail.executeUpdate();

                // Trừ tồn kho
                psStock.setInt(1, item.getQuantity());
                psStock.setInt(2, item.getBookid());
                psStock.executeUpdate();
            }

            conn.commit(); // Thành công 100% thì Commit
            return true;

        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { } // Lỗi thì Rollback
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { }
        }
    }
}