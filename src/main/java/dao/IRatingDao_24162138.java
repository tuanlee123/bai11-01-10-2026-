package dao;

import model.RatingModel_24162138;
import java.util.List;

public interface IRatingDao_24162138 {
    List<RatingModel_24162138> getRatingsByBookId(int bookId);
    void insertOrUpdate(RatingModel_24162138 rating);
}