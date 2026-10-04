package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;
import model.CartItem;
import model.OrderModel;
import config.DBConnect_24162138;

public class OrderDao {

    // 1. THANH TOÁN ĐƠN HÀNG (Transaction)
    public boolean checkoutOrder(int userId, String address, String phone, Map<Integer, CartItem> cart, BigDecimal totalAmount) {
        Connection conn = null;
        try {
            conn = DBConnect_24162138.getConnection();
            conn.setAutoCommit(false);

            String sqlOrder = "INSERT INTO orders (user_id, total_amount, shipping_address, receiver_phone, status) VALUES (?, ?, ?, ?, 1)";
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

            String sqlDetail = "INSERT INTO order_details (order_id, bookid, quantity, price) VALUES (?, ?, ?, ?)";
            String sqlUpdateStock = "UPDATE books SET quantity = quantity - ? WHERE bookid = ?";
            
            PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
            PreparedStatement psStock = conn.prepareStatement(sqlUpdateStock);

            for (CartItem item : cart.values()) {
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, item.getBookid());
                psDetail.setInt(3, item.getQuantity());
                psDetail.setBigDecimal(4, item.getPrice());
                psDetail.executeUpdate();

                psStock.setInt(1, item.getQuantity());
                psStock.setInt(2, item.getBookid());
                psStock.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { }
        }
    }

    // 2. LẤY ĐƠN HÀNG (Nếu userId = 0: lấy tất cả cho Admin, status = 0: lấy tất cả trạng thái)
    public List<OrderModel> getOrders(int userId, int status) {
        List<OrderModel> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM orders WHERE 1=1");
        
        if (userId > 0) {
            sql.append(" AND user_id = ?");
        }
        if (status > 0) {
            sql.append(" AND status = ?");
        }
        sql.append(" ORDER BY order_date DESC");

        try (Connection conn = DBConnect_24162138.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            int paramIndex = 1;
            if (userId > 0) {
                ps.setInt(paramIndex++, userId);
            }
            if (status > 0) {
                ps.setInt(paramIndex++, status);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderModel order = new OrderModel();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                
                Timestamp orderDate = rs.getTimestamp("order_date");
                if (orderDate != null) {
                    order.setOrderDate(orderDate);
                }
                
                order.setStatus(rs.getInt("status"));
                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}