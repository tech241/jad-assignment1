package dao;

import models.CaretakerOption;
import servlets.postgresHelper;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class caretakerDAO {

    public List<CaretakerOption> getCaretakersForService(int serviceId) throws Exception {
        String sql =
            "SELECT c.caretaker_id, c.name, c.experience_years, c.rating " +
            "FROM caretaker c " +
            "INNER JOIN caretaker_service cs ON c.caretaker_id = cs.caretaker_id " +
            "WHERE cs.service_id = ? " +
            "ORDER BY c.rating DESC";

        List<CaretakerOption> list = new ArrayList<>();

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CaretakerOption c = new CaretakerOption();
                    c.setCaretakerId(rs.getInt("caretaker_id"));
                    c.setName(rs.getString("name"));
                    c.setExperienceYears(rs.getInt("experience_years"));
                    c.setRating(rs.getDouble("rating"));
                    list.add(c);
                }
            }
        }
        return list;
    }
    public CaretakerOption getCaretakerById(int caretakerId) throws Exception {
        String sql = "SELECT caretaker_id, name, experience_years, rating FROM caretaker WHERE caretaker_id = ?";

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, caretakerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CaretakerOption c = new CaretakerOption();
                    c.setCaretakerId(rs.getInt("caretaker_id"));
                    c.setName(rs.getString("name"));
                    c.setExperienceYears(rs.getInt("experience_years"));
                    c.setRating(rs.getDouble("rating"));
                    return c;
                }
            }
        }
        return null;
    }
}
