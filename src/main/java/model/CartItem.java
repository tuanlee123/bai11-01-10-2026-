package model;
import java.math.BigDecimal;

public class CartItem {
    private int bookid;
    private String title;
    private String coverImage;
    private BigDecimal price;
    private int quantity;
    private int stockQuantity; // Tồn kho tối đa (giới hạn số lượng)

    public CartItem() {}

    public CartItem(int bookid, String title, String coverImage, BigDecimal price, int quantity, int stockQuantity) {
        this.bookid = bookid;
        this.title = title;
        this.coverImage = coverImage;
        this.price = price;
        this.quantity = quantity;
        this.stockQuantity = stockQuantity;
    }

    // Tính thành tiền của món này
    public BigDecimal getTotalPrice() {
        return price.multiply(new BigDecimal(quantity));
    }

    // Getters và Setters
    public int getBookid() { return bookid; }
    public void setBookid(int bookid) { this.bookid = bookid; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
}