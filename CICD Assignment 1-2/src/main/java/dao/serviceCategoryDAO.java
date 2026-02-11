package dao;

import models.serviceCategory;
import servlets.postgresHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class serviceCategoryDAO {

    private static final String SQL_GET_ALL =
        "SELECT cat_id, cat_name, cat_description, cat_logo " +
        "FROM service_category ORDER BY cat_id";

    private static final String SQL_GET_BY_ID =
        "SELECT cat_id, cat_name, cat_description, cat_logo " +
        "FROM service_category WHERE cat_id = ?";

    public List<serviceCategory> getAllCategories() throws Exception {
        List<serviceCategory> categories = new ArrayList<>();

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                serviceCategory c = new serviceCategory();
                c.setId(rs.getInt("cat_id"));
                c.setName(rs.getString("cat_name"));
                c.setDescription(rs.getString("cat_description"));
                c.setLogo(rs.getString("cat_logo"));
                categories.add(c);
            }
        }
        return categories;
    }

    public serviceCategory getCategoryById(int catId) throws Exception {
        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_BY_ID)) {

            ps.setInt(1, catId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    serviceCategory c = new serviceCategory();
                    c.setId(rs.getInt("cat_id"));
                    c.setName(rs.getString("cat_name"));
                    c.setDescription(rs.getString("cat_description"));
                    c.setLogo(rs.getString("cat_logo"));
                    return c;
                }
            }
        }
        return null;
    }
}
