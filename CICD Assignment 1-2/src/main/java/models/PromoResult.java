package models;

import java.math.BigDecimal;

public class PromoResult {
    public boolean ok;
    public String message;

    public Promotion promo;              // may be null
    public String appliedCode;            // may be null

    public BigDecimal discount = BigDecimal.ZERO;  // discount amount in dollars
}
