package com.silvercare.silvercare.model;
import java.sql.*;
import java.util.ArrayList;
import java.util.Map;

import com.silvercare.config.DBConnection;

/* ==================================
* Author: Cedric Mok Yue En
* Class: DIT/2A/21
* Description: ST0510 Pract7 - part 3
* ===================================
*/

public class CaretakerModel {

	// get all caretakers
	public ArrayList<Map<String, Object>> getCaretaker() throws SQLException {
		
		Connection conn = null;
		
		try {
			// prepare statement
			conn = DBConnection.getConnection();
			String sqlStr = "SELECT c.caretaker_id, c.name, c.experience_years, c.rating " +
		            "FROM caretaker c " +
		            "INNER JOIN caretaker_service cs ON c.caretaker_id = cs.caretaker_id";
			PreparedStatement pstmt = conn.prepareStatement(sqlStr);
			
			// execute statement
			ResultSet rs = pstmt.executeQuery();
			
			ArrayList<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
			
			// get results from statement
			while (rs.next()) {
				result.add(Map.of("caretakerId", rs.getInt("caretaker_id"),
						"name", rs.getString("name"),
						"experienceYears", rs.getInt("experience_years"),
						"rating", rs.getString("rating")));
			}
			
			return result;
		} catch (Exception e) {
			System.out.print("..............UserDetailsDB: " + e);
		} finally {
			conn.close();
		}
		
		return null;
	}
}