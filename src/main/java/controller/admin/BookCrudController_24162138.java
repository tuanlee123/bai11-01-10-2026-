package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.BookModel_24162138;
import model.UserModel_24162138;
import service.BookServiceImpl_24162138;
import service.IBookService_24162138;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "BookCrudController_24162138", urlPatterns = {"/admin/books"})
public class BookCrudController_24162138 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IBookService_24162138 bookService = new BookServiceImpl_24162138();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra xác thực và phân quyền Admin theo Câu 1
        HttpSession session = req.getSession(false);
        UserModel_24162138 user = (session != null) ? (UserModel_24162138) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "new":
                req.getRequestDispatcher("/views/admin/book-form.jsp").forward(req, resp);
                break;

            case "edit":
                try {
                    int idEdit = Integer.parseInt(req.getParameter("id"));
                    BookModel_24162138 book = bookService.getBookById(idEdit);
                    req.setAttribute("book", book);
                    req.getRequestDispatcher("/views/admin/book-form.jsp").forward(req, resp);
                } catch (Exception e) {
                    resp.sendRedirect(req.getContextPath() + "/admin/books");
                }
                break;

            case "delete":
                try {
                    int idDel = Integer.parseInt(req.getParameter("id"));
                    bookService.delete(idDel);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                resp.sendRedirect(req.getContextPath() + "/admin/books");
                break;

            default: // "list" - Xem danh sách có phân trang
                int page = 1;
                int pageSize = 5; // Hiển thị 5 cuốn/trang trong admin
                if (req.getParameter("page") != null && !req.getParameter("page").trim().isEmpty()) {
                    try {
                        page = Integer.parseInt(req.getParameter("page").trim());
                    } catch (NumberFormatException ignored) {}
                }

                int totalBooks = bookService.countAllBooks();
                int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
                if (totalPages == 0) totalPages = 1;

                List<BookModel_24162138> books = bookService.getAllBooksPaging(page, pageSize);
                req.setAttribute("books", books);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.getRequestDispatcher("/views/admin/book-list.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Kiểm tra phân quyền Admin
        HttpSession session = req.getSession(false);
        UserModel_24162138 user = (session != null) ? (UserModel_24162138) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String bookIdStr = req.getParameter("bookid");
            String isbnStr = req.getParameter("isbn");
            String title = req.getParameter("title");
            String publisher = req.getParameter("publisher");
            String priceStr = req.getParameter("price");
            String description = req.getParameter("description");
            String publishDateStr = req.getParameter("publish_date");
            String coverImage = req.getParameter("cover_image");
            String quantityStr = req.getParameter("quantity");

            BookModel_24162138 book = new BookModel_24162138();
            book.setIsbn((isbnStr != null && !isbnStr.trim().isEmpty()) ? Integer.parseInt(isbnStr.trim()) : 0);
            book.setTitle(title != null ? title.trim() : "");
            book.setPublisher(publisher != null ? publisher.trim() : "");
            book.setPrice((priceStr != null && !priceStr.trim().isEmpty()) ? new BigDecimal(priceStr.trim()) : BigDecimal.ZERO);
            book.setDescription(description != null ? description.trim() : "");

            if (publishDateStr != null && !publishDateStr.trim().isEmpty()) {
                book.setPublishDate(Date.valueOf(publishDateStr.trim()));
            } else {
                book.setPublishDate(new Date(System.currentTimeMillis()));
            }

            book.setCoverImage(coverImage != null ? coverImage.trim() : "default.jpg");
            book.setQuantity((quantityStr != null && !quantityStr.trim().isEmpty()) ? Integer.parseInt(quantityStr.trim()) : 0);

            // Kiểm tra Thêm mới hay Cập nhật
            if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
                bookService.insert(book);
            } else {
                book.setBookid(Integer.parseInt(bookIdStr.trim()));
                bookService.update(book);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin/books");
    }
}