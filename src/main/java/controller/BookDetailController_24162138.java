package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.BookModel_24162138;
import model.RatingModel_24162138;
import model.UserModel_24162138;
import service.BookServiceImpl_24162138;
import service.IBookService_24162138;
import service.IRatingService_24162138;
import service.RatingServiceImpl_24162138;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookDetailController_24162138", urlPatterns = {"/book-detail"})
public class BookDetailController_24162138 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IBookService_24162138 bookService = new BookServiceImpl_24162138();
    private IRatingService_24162138 ratingService = new RatingServiceImpl_24162138();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            // Không có id thì quay về home tránh văng lỗi trắng màn hình
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {
            int bookId = Integer.parseInt(idParam.trim());
            BookModel_24162138 book = bookService.getBookById(bookId);

            if (book == null) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            // Lấy danh sách reviews qua tầng Service
            List<RatingModel_24162138> reviews = ratingService.getRatingsByBookId(bookId);

            req.setAttribute("book", book);
            req.setAttribute("reviews", reviews);
            req.getRequestDispatcher("/views/book-detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/home");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Chống lỗi font Tiếng Việt có dấu khi lưu review vào database
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        UserModel_24162138 user = (session != null) ? (UserModel_24162138) session.getAttribute("user") : null;

        // Bắt buộc đăng nhập mới được viết review
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String bookIdParam = req.getParameter("bookid");
        String reviewText = req.getParameter("review_text");
        String ratingScoreParam = req.getParameter("rating");

        if (bookIdParam != null && !bookIdParam.trim().isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdParam.trim());
                int ratingScore = 5; // Mặc định 5 sao
                if (ratingScoreParam != null && !ratingScoreParam.trim().isEmpty()) {
                    ratingScore = Integer.parseInt(ratingScoreParam.trim());
                }

                RatingModel_24162138 rating = new RatingModel_24162138(
                    user.getId(), 
                    bookId, 
                    ratingScore, 
                    reviewText != null ? reviewText.trim() : ""
                );

                // Lưu hoặc cập nhật review qua tầng Service
                ratingService.insertOrUpdate(rating);

                // Chuyển hướng lại chính trang chi tiết để xem review vừa tạo
                resp.sendRedirect(req.getContextPath() + "/book-detail?id=" + bookId);
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        resp.sendRedirect(req.getContextPath() + "/home");
    }
}