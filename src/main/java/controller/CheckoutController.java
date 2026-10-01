package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;
import model.CartItem;
// Import UserModel và OrderDao...

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private dao.OrderDao orderDao = new dao.OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/views/user/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        // Giả sử Session user lưu bằng UserModel
        Object userObj = session.getAttribute("user"); 
        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Móc ID User (Sửa lại kiểu casting tuỳ model của bạn)
        // UserModel user = (UserModel) userObj;
        int userId = 1; // Hardcode ví dụ: user.getId(); 

        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        BigDecimal totalCartPrice = (BigDecimal) session.getAttribute("totalCartPrice");

        if (cart != null && !cart.isEmpty()) {
            boolean success = orderDao.checkoutOrder(userId, address, phone, cart, totalCartPrice);
            if (success) {
                session.removeAttribute("cart"); // Xóa giỏ hàng
                session.removeAttribute("totalCartPrice");
                request.setAttribute("message", "Đặt hàng thành công! Vui lòng thanh toán tiền mặt khi nhận hàng (COD).");
                request.getRequestDispatcher("/views/user/checkout-success.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
                request.getRequestDispatcher("/views/user/checkout.jsp").forward(request, response);
            }
        }
    }
}