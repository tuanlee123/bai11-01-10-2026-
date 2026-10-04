package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import dao.OrderDao;
import model.OrderModel;
import model.UserModel_24162138;

@WebServlet("/order-history")
public class OrderHistoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserModel_24162138 user = (session != null) ? (UserModel_24162138) session.getAttribute("user") : null;

        // Nếu chưa đăng nhập thì chuyển hướng sang login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy status lọc
        String statusParam = request.getParameter("status");
        int status = 0;
        if (statusParam != null && !statusParam.trim().isEmpty()) {
            try {
                status = Integer.parseInt(statusParam);
            } catch (NumberFormatException e) {
                status = 0;
            }
        }

        // Lấy danh sách đơn hàng
        List<OrderModel> orders = orderDao.getOrders(user.getId(), status);

        request.setAttribute("orders", orders);
        request.setAttribute("currentStatus", status);

        // Forward y chang cú pháp của CartController
        request.getRequestDispatcher("/views/user/order-history.jsp").forward(request, response);
    }
}