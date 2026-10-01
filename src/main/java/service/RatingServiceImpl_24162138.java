package service;

import dao.IRatingDao_24162138;
import dao.RatingDaoImpl_24162138;
import model.RatingModel_24162138;

import java.util.List;

public class RatingServiceImpl_24162138 implements IRatingService_24162138 {
    private IRatingDao_24162138 ratingDao = new RatingDaoImpl_24162138();

    @Override
    public List<RatingModel_24162138> getRatingsByBookId(int bookId) {
        return ratingDao.getRatingsByBookId(bookId);
    }

    @Override
    public void insertOrUpdate(RatingModel_24162138 rating) {
        ratingDao.insertOrUpdate(rating);
    }
}