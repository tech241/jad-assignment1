package models;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class PromoCalculator {

    public static PromoResult compute(Promotion promo, BigDecimal totalWithGst) {
        PromoResult r = new PromoResult();
        r.promo = promo;

        if (promo == null || promo.getCode() == null || promo.getCode().isBlank()) {
            r.ok = true; // no promo is fine
            return r;
        }

        r.appliedCode = promo.getCode();

        // min spend check against totalWithGst 
        BigDecimal minSpend = BigDecimal.valueOf(promo.getMinSpend()).setScale(2, RoundingMode.HALF_UP);
        if (totalWithGst.compareTo(minSpend) < 0) {
            r.ok = false;
            r.message = "Promo requires minimum spend of $" + minSpend.toString();
            return r;
        }

        String type = promo.getDiscountType(); // can be fixed or percent
        BigDecimal discount = BigDecimal.ZERO;

        if ("FIXED".equalsIgnoreCase(type)) {
            discount = BigDecimal.valueOf(promo.getDiscountValue());
        } else if ("PERCENT".equalsIgnoreCase(type)) {
            BigDecimal pct = BigDecimal.valueOf(promo.getDiscountValue()); // e.g. 10 means 10%
            discount = totalWithGst.multiply(pct).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        } else {
            // code exists but no discount type => treat as invalid promo setup
            r.ok = false;
            r.message = "Promo code is not configured correctly.";
            return r;
        }

        // max discount cap 
        if (promo.getMaxDiscount() != null) {
            BigDecimal max = BigDecimal.valueOf(promo.getMaxDiscount()).setScale(2, RoundingMode.HALF_UP);
            if (discount.compareTo(max) > 0) discount = max;
        }

        // never exceed total
        if (discount.compareTo(totalWithGst) > 0) discount = totalWithGst;

        r.ok = true;
        r.discount = discount.setScale(2, RoundingMode.HALF_UP);
        return r;
    }
}
