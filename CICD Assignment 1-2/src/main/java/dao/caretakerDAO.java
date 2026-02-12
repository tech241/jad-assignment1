package dao;

import models.Caretaker;
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
    
    public ArrayList<Caretaker> getCaretakers() throws Exception {
        String sql =
            "SELECT * " +
            "FROM caretaker c;";

        ArrayList<Caretaker> list = new ArrayList<Caretaker>();

        try (Connection conn = postgresHelper.connect();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                	Caretaker c = new Caretaker();
                    c.setCaretakerId(rs.getInt("caretaker_id"));
                    c.setName(rs.getString("name"));
                    c.setEmail(rs.getString("email"));
                    c.setPhone(rs.getString("phone"));
                    c.setBio(rs.getString("bio"));
                    c.setExperienceYears(rs.getInt("experience_years"));
                    c.setRating(rs.getDouble("rating"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setImageUrl(rs.getString("image_url"));
                    list.add(c);
                }
            }
        }
        return list;

    }
    
    public Caretaker getCaretakerById(int caretakerId) throws Exception {
        String sql =
            "SELECT * " +
            "FROM caretaker c " +
            "WHERE c.caretaker_id = ?;";
        

        Caretaker caretaker = new Caretaker();

        try (Connection conn = postgresHelper.connect();
            PreparedStatement ps = conn.prepareStatement(sql)) {
        	
        	ps.setInt(1, caretakerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    caretaker.setCaretakerId(rs.getInt("caretaker_id"));
                    caretaker.setName(rs.getString("name"));
                    caretaker.setEmail(rs.getString("email"));
                    caretaker.setPhone(rs.getString("phone"));
                    caretaker.setBio(rs.getString("bio"));
                    caretaker.setExperienceYears(rs.getInt("experience_years"));
                    caretaker.setRating(rs.getDouble("rating"));
                    caretaker.setCreatedAt(rs.getTimestamp("created_at"));
                    caretaker.setImageUrl(rs.getString("image_url"));
                }
            }
        }
        return caretaker;
    }
    
    public int updateCaretakerById(Caretaker caretaker) throws Exception {
    	String where = "";
    	int caretakerIdPos = 6;
    	if (!(caretaker.getImageUrl() == null || caretaker.getImageUrl().equals(""))) {
    		where = ", image_url = ?";
    	}
        String sql =
            "UPDATE caretaker c " +
            "SET name = ?, email = ?, phone = ?, bio = ?, experience_years = ?" +
            where +
            " WHERE c.caretaker_id = ?;";

        try (Connection conn = postgresHelper.connect();
            PreparedStatement ps = conn.prepareStatement(sql)) {
        	
        	ps.setString(1, caretaker.getName());
        	ps.setString(2, caretaker.getEmail());
        	ps.setString(3, caretaker.getPhone());
        	ps.setString(4, caretaker.getBio());
        	ps.setInt(5, caretaker.getExperienceYears());
        	if (!(caretaker.getImageUrl() == null || caretaker.getImageUrl().equals(""))) {
        		ps.setString(6, caretaker.getImageUrl());
        		caretakerIdPos ++;
        	}
        	ps.setInt(caretakerIdPos, caretaker.getCaretakerId());

        	int nrow = ps.executeUpdate();
            return nrow;
        }
    }
}
