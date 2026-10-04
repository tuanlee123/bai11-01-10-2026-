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

import dao.OrderDao;
import model.CartItem;
import model.UserModel_24162138;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/views/user/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        
        UserModel_24162138 user = (session != null) ? (UserModel_24162138) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy đúng ID thực tế của tài khoản đang đăng nhập
        int userId = user.getId();

        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        BigDecimal totalCartPrice = (BigDecimal) session.getAttribute("totalCartPrice");

        if (cart != null && !cart.isEmpty()) {
            boolean success = orderDao.checkoutOrder(userId, address, phone, cart, totalCartPrice);
            if (success) {
                session.removeAttribute("cart");
                session.removeAttribute("totalCartPrice");
                request.setAttribute("message", "Đặt hàng thành công! Vui lòng thanh toán tiền mặt khi nhận hàng (COD).");
                request.getRequestDispatcher("/views/user/checkout-success.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra trong quá trình tạo đơn hàng, vui lòng thử lại.");
                request.getRequestDispatcher("/views/user/checkout.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}