package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect_24162138 {
    // Nếu bạn dùng SQL Server Instance (SQLEXPRESS) hoặc cổng mặc định 1433
    private static final String SERVER = "localhost";
    private static final String PORT = "1433";
    private static final String DB_NAME = "BookStoreDB_24162138";
    private static final String USER = "sa";
    private static final String PASS = "12345"; // ĐỔI THÀNH MẬT KHẨU SA TRÊN MÁY BẠN

    public static Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://" + SERVER + ":" + PORT + ";databaseName=" + DB_NAME 
                       + ";encrypt=false;trustServerCertificate=true;characterEncoding=UTF-8";
            return DriverManager.getConnection(url, USER, PASS);
        } catch (Exception e) {
            System.err.println("Lỗi kết nối CSDL: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    // Hàm test nhanh kết nối trực tiếp không cần bật Tomcat
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println(" KẾT NỐI DATABASE THÀNH CÔNG RỒI NHÉ!");
        } else {
            System.out.println(" KẾT NỐI THẤT BẠI! Kiểm tra lại mật khẩu 'sa' hoặc dịch vụ SQL Server.");
        }
    }
}