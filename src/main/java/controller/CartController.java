package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import model.CartItem;
import model.BookModel_24162138;
import dao.BookDaoImpl_24162138;

@WebServlet({"/cart", "/cart/add", "/cart/update", "/cart/remove"})
public class CartController extends HttpServlet {
    
    // Khởi tạo DAO để lấy dữ liệu sách từ Database
    private BookDaoImpl_24162138 bookDao = new BookDaoImpl_24162138();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/user/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        HttpSession session = request.getSession();
        
        // Lấy giỏ hàng từ Session, nếu chưa có thì tạo mới
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        try {
            int bookid = Integer.parseInt(request.getParameter("bookid"));

            if ("/cart/add".equals(action)) {
                // Lấy thông tin sách thực tế từ Database
                BookModel_24162138 book = bookDao.getBookById(bookid);
                
                if (book != null) {
                    if (cart.containsKey(bookid)) {
                        CartItem item = cart.get(bookid);
                        // Chỉ tăng số lượng nếu chưa vượt quá số lượng tồn kho
                        if (item.getQuantity() < item.getStockQuantity()) {
                            item.setQuantity(item.getQuantity() + 1);
                        }
                    } else {
                        // Thêm món mới vào giỏ với số lượng ban đầu là 1
                        cart.put(bookid, new CartItem(
                            book.getBookid(), 
                            book.getTitle(), 
                            book.getCoverImage(), 
                            book.getPrice(), 
                            1, 
                            book.getQuantity()
                        ));
                    }
                }
                
            } else if ("/cart/update".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                if (cart.containsKey(bookid)) {
                    CartItem item = cart.get(bookid);
                    // Ràng buộc giới hạn số lượng kho: lớn hơn 0 và không vượt quá tồn kho
                    if (quantity > 0 && quantity <= item.getStockQuantity()) {
                        item.setQuantity(quantity);
                    }
                }
            } else if ("/cart/remove".equals(action)) {
                cart.remove(bookid);
            }

            // Cập nhật lại tổng tiền giỏ hàng sau khi có thay đổi
            BigDecimal totalCartPrice = BigDecimal.ZERO;
            for (CartItem item : cart.values()) {
                totalCartPrice = totalCartPrice.add(item.getTotalPrice());
            }
            
            session.setAttribute("cart", cart);
            session.setAttribute("totalCartPrice", totalCartPrice);
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Dù thêm, sửa hay xóa thì cuối cùng vẫn điều hướng về trang giỏ hàng
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}