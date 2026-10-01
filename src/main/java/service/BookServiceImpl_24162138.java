package service;

import dao.BookDaoImpl_24162138;
import dao.IBookDao_24162138;
import model.BookModel_24162138;
import java.util.List;

public class BookServiceImpl_24162138 implements IBookService_24162138 {
    private IBookDao_24162138 bookDao = new BookDaoImpl_24162138();

    @Override
    public List<BookModel_24162138> getBooksByAuthorPaging(int authorId, int page, int pageSize) {
        return bookDao.getBooksByAuthorPaging(authorId, page, pageSize);
    }

    @Override
    public int countBooksByAuthor(int authorId) {
        return bookDao.countBooksByAuthor(authorId);
    }

    @Override
    public List<BookModel_24162138> getAllBooksPaging(int page, int pageSize) {
        return bookDao.getAllBooksPaging(page, pageSize);
    }

    @Override
    public int countAllBooks() {
        return bookDao.countAllBooks();
    }

    @Override
    public BookModel_24162138 getBookById(int bookId) {
        return bookDao.getBookById(bookId);
    }

    @Override
    public void insert(BookModel_24162138 book) {
        bookDao.insert(book);
    }

    @Override
    public void update(BookModel_24162138 book) {
        bookDao.update(book);
    }

    @Override
    public void delete(int bookId) {
        bookDao.delete(bookId);
    }
}