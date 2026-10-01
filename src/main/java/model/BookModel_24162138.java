package model;

import java.math.BigDecimal;
import java.sql.Date;

public class BookModel_24162138 {
    private int bookid;
    private int isbn;
    private String title;
    private String publisher;
    private BigDecimal price;
    private String description;
    private Date publishDate;
    private String coverImage;
    private int quantity;
    private String authorName;
    private int reviewCount;

    // Getters and Setters
    public int getBookid() { return bookid; }
    public void setBookid(int bookid) { this.bookid = bookid; }
    public int getIsbn() { return isbn; }
    public void setIsbn(int isbn) { this.isbn = isbn; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Date getPublishDate() { return publishDate; }
    public void setPublishDate(Date publishDate) { this.publishDate = publishDate; }
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
}