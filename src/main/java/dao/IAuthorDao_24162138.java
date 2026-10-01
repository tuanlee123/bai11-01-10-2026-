package dao;

import java.util.List;
import model.AuthorModel_24162138;

public interface IAuthorDao_24162138 {
    List<AuthorModel_24162138> getAllAuthors();
    AuthorModel_24162138 getAuthorById(int authorId);
}