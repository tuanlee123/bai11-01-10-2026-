package controller;

import dao.AuthorDaoImpl_24162138;
import dao.IAuthorDao_24162138;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AuthorModel_24162138;
import model.BookModel_24162138;
import service.BookServiceImpl_24162138;
import service.IBookService_24162138;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController_24162138", urlPatterns = {"/home", "/"})
public class HomeController_24162138 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IBookService_24162138 bookService = new BookServiceImpl_24162138();
    private IAuthorDao_24162138 authorDao = new AuthorDaoImpl_24162138();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try {
            List<AuthorModel_24162138> authorList = authorDao.getAllAuthors();
            req.setAttribute("authors", authorList);

            int authorId = 1;
            if (req.getParameter("authorId") != null && !req.getParameter("authorId").isEmpty()) {
                authorId = Integer.parseInt(req.getParameter("authorId"));
            } else if (authorList != null && !authorList.isEmpty()) {
                authorId = authorList.get(0).getAuthorId();
            }

            int page = 1;
            int pageSize = 3; // Đúng yêu cầu 03sp/trang
            if (req.getParameter("page") != null && !req.getParameter("page").isEmpty()) {
                page = Integer.parseInt(req.getParameter("page"));
            }

            int totalBooks = bookService.countBooksByAuthor(authorId);
            int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
            if (totalPages == 0) totalPages = 1;

            List<BookModel_24162138> books = bookService.getBooksByAuthorPaging(authorId, page, pageSize);
            AuthorModel_24162138 currentAuthor = authorDao.getAuthorById(authorId);

            req.setAttribute("books", books);
            req.setAttribute("currentAuthor", currentAuthor);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("selectedAuthorId", authorId);

            req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Lỗi xử lý Controller: " + e.getMessage());
        }
    }
}