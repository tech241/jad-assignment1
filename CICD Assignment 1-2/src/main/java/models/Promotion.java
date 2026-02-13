package models;

import java.sql.Date;

public class Promotion {
    private int promoId;
    private String title;
    private String description;
    private String themeTag;
    private String imagePath;

    private boolean isActive;
    private Date startDate;
    private Date endDate;

    private boolean showHome;
    private boolean showServices;
    private boolean showCheckout;

    private String code; // can be null
    private String discountType; // fixed or percent type
    private double discountValue;
    private double minSpend;
    private Double maxDiscount; // can also be null

    // --- getters/setters ---
    public int getPromoId() { return promoId; }
    public void setPromoId(int promoId) { this.promoId = promoId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getThemeTag() { return themeTag; }
    public void setThemeTag(String themeTag) { this.themeTag = themeTag; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public boolean isShowHome() { return showHome; }
    public void setShowHome(boolean showHome) { this.showHome = showHome; }

    public boolean isShowServices() { return showServices; }
    public void setShowServices(boolean showServices) { this.showServices = showServices; }

    public boolean isShowCheckout() { return showCheckout; }
    public void setShowCheckout(boolean showCheckout) { this.showCheckout = showCheckout; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }

    public double getMinSpend() { return minSpend; }
    public void setMinSpend(double minSpend) { this.minSpend = minSpend; }

    public Double getMaxDiscount() { return maxDiscount; }
    public void setMaxDiscount(Double maxDiscount) { this.maxDiscount = maxDiscount; }
}
