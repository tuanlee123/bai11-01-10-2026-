package model;

public class RatingModel_24162138 {
    private int userId;
    private int bookId;
    private int rating;
    private String reviewText;
    private String userFullName;

    public RatingModel_24162138() {}

    public RatingModel_24162138(int userId, int bookId, int rating, String reviewText) {
        this.userId = userId;
        this.bookId = bookId;
        this.rating = rating;
        this.reviewText = reviewText;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }

    public String getUserFullName() { return userFullName; }
    public void setUserFullName(String userFullName) { this.userFullName = userFullName; }
}