package dao;

import models.Promotion;
import servlets.postgresHelper;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {

    private Promotion map(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setPromoId(rs.getInt("promo_id"));
        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));
        p.setThemeTag(rs.getString("theme_tag"));
        p.setImagePath(rs.getString("image_path"));

        p.setActive(rs.getBoolean("is_active"));
        p.setStartDate(rs.getDate("start_date"));
        p.setEndDate(rs.getDate("end_date"));

        p.setShowHome(rs.getBoolean("show_home"));
        p.setShowServices(rs.getBoolean("show_services"));
        p.setShowCheckout(rs.getBoolean("show_checkout"));

        p.setCode(rs.getString("code"));
        p.setDiscountType(rs.getString("discount_type"));
        p.setDiscountValue(rs.getDouble("discount_value"));
        p.setMinSpend(rs.getDouble("min_spend"));

        Object maxObj = rs.getObject("max_discount");
        p.setMaxDiscount(maxObj == null ? null : rs.getDouble("max_discount"));
        return p;
    }

    // Show on checkout (includes info-only promos too)
    public List<Promotion> getCheckoutPromotions() throws Exception {
        String sql = """
            SELECT *
            FROM promotion
            WHERE show_checkout = TRUE
              AND is_active = TRUE
              AND (start_date IS NULL OR start_date <= CURRENT_DATE)
              AND (end_date IS NULL OR end_date >= CURRENT_DATE)
            ORDER BY promo_id DESC
        """;

        List<Promotion> list = new ArrayList<>();
        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // For applying code (must be code-based + active + in date range)
    public Promotion getValidPromoByCode(String code) throws Exception {
        if (code == null) return null;
        code = code.trim();
        if (code.isEmpty()) return null;

        String sql =
            "SELECT * FROM promotion " +
            "WHERE UPPER(code) = UPPER(?) " +
            "  AND is_active = TRUE " +
            "  AND show_checkout = TRUE " +
            "  AND (start_date IS NULL OR start_date <= CURRENT_DATE) " +
            "  AND (end_date IS NULL OR end_date >= CURRENT_DATE) " +
            "LIMIT 1";

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs); // your existing mapper
            }
        }
        return null;
    }


    // --- Admin side stuff ---
    public List<Promotion> getAllPromotions() throws Exception {
        String sql = "SELECT * FROM promotion ORDER BY promo_id DESC";
        List<Promotion> list = new ArrayList<>();
        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public void toggleActive(int promoId, boolean active) throws Exception {
        String sql = "UPDATE promotion SET is_active = ? WHERE promo_id = ?";
        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, promoId);
            ps.executeUpdate();
        }
    }
 // Show ONE promo on homepage (dynamic banner from assignment brief) 
    public Promotion getActiveHomePromotion() throws Exception {
        String sql = """
            SELECT *
            FROM promotion
            WHERE show_home = TRUE
              AND is_active = TRUE
              AND (start_date IS NULL OR start_date <= CURRENT_DATE)
              AND (end_date IS NULL OR end_date >= CURRENT_DATE)
            ORDER BY start_date DESC NULLS LAST, promo_id DESC
            LIMIT 1
        """;

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return map(rs);
        }
        return null;
    }

}
