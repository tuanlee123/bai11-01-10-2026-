package service;

import model.BookModel_24162138;
import java.util.List;

public interface IBookService_24162138 {
    List<BookModel_24162138> getBooksByAuthorPaging(int authorId, int page, int pageSize);
    int countBooksByAuthor(int authorId);
    List<BookModel_24162138> getAllBooksPaging(int page, int pageSize);
    int countAllBooks();
    BookModel_24162138 getBookById(int bookId);
    void insert(BookModel_24162138 book);
    void update(BookModel_24162138 book);
    void delete(int bookId);
}