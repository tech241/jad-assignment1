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

public class ServiceModel {

	// get all service packages
	public ArrayList<Map<String, Object>> getService(Map<String,String> params) throws SQLException {
		
		Connection conn = null;
		
		try {
			String where = "";
			int count = 0;
			ArrayList<String> paramList = new ArrayList<String>();
			paramList.add("categoryId");
			paramList.add("serviceId");
			paramList.add("packageId");
			paramList.add("caretakerId");
			ArrayList<Integer> ids = new ArrayList<Integer>();
			for (Map.Entry<String, String> param : params.entrySet()) {
				String key = param.getKey();
				if (paramList.contains(key)) {
					if (count == 0) {
						where += "WHERE ";
						count ++;
					} else {
						where += "AND ";
					}
					
					if (key.equals("categoryId")) {
						where += "c.cat_id = ? ";
					} else if (key.equals("serviceId")) {
						where += "s.service_id = ? ";
					} else if (key.equals("packageId")) {
						where += "p.package_id = ? ";
					} else if (key.equals("caretakerId")) {
						where += "ca.caretaker_id = ? ";
					}
					
					ids.add(Integer.parseInt(param.getValue()));
				}
			}
			
			// prepare statement
			conn = DBConnection.getConnection();
			String sqlStr = "SELECT * FROM service_category c "
					+ "JOIN service s ON c.cat_id = s.cat_id "
					+ "JOIN service_package p ON s.service_id = p.service_id "
					+ "JOIN caretaker_service cs ON s.service_id = cs.service_id "
					+ "JOIN caretaker ca ON cs.caretaker_id = ca.caretaker_id "
					+ where
					+ "ORDER BY ca.caretaker_id, p.package_id, s.service_id, c.cat_id;";
			PreparedStatement pstmt = conn.prepareStatement(sqlStr);
			
			int index = 1;
			for (int id : ids) {
				pstmt.setInt(index, id);
				index ++;
			}
			
			// execute statement
			ResultSet rs = pstmt.executeQuery();
			
			ArrayList<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
			
			// get results from statement
			ArrayList<Integer> categories = new ArrayList<Integer>();
			ArrayList<Integer> services = new ArrayList<Integer>();
			ArrayList<Integer> packages = new ArrayList<Integer>();
			ArrayList<Integer> caretakers = new ArrayList<Integer>();
			int categorypos = -1;
			int servicepos = -1;
			while (rs.next()) {
				int catId = rs.getInt("cat_id");
				int serviceId = rs.getInt("service_id");
				int packageId = rs.getInt("package_id");
				int caretakerId = rs.getInt("caretaker_id");
				
				if (!categories.contains(catId)) {
					result.add(Map.of("categoryId", rs.getInt("cat_id"),
							"categoryName", rs.getString("cat_name"),
							"categoryDescription", rs.getString("cat_description"),
							"service", new ArrayList<Map<String, Object>>()));
					categories.add(catId);
					categorypos ++;
					servicepos = -1;
					services.clear();
				}
				
				ArrayList<Map<String, Object>> serviceList = (ArrayList<Map<String, Object>>) result.get(categorypos).get("service");
				if (!services.contains(serviceId)) {
					serviceList.add(Map.of("serviceId", rs.getInt("service_id"),
							"serviceName", rs.getString("service_name"),
							"serviceDescription", rs.getString("service_description"),
							"whatsIncluded", rs.getString("whats_included"),
							"package", new ArrayList<Map<String, Object>>(),
							"caretaker", new ArrayList<Map<String, Object>>()));
					services.add(serviceId);
					servicepos ++;
					caretakers.clear();
				}
				
				if (!packages.contains(packageId)) {
					ArrayList<Map<String, Object>> packageList = (ArrayList<Map<String, Object>>) serviceList.get(servicepos).get("package");
					packageList.add(Map.of("packageId", rs.getInt("package_id"),
							"packageName", rs.getString("package_name"),
							"packageDescription", rs.getString("package_description"),
							"price", rs.getDouble("price"),
							"tier", rs.getString("tier"),
							"durationMinutes", rs.getInt("duration_minutes")));
					packages.add(packageId);
				}
				
				if (!caretakers.contains(caretakerId)) {
					ArrayList<Map<String, Object>> caretakerList = (ArrayList<Map<String, Object>>) serviceList.get(servicepos).get("caretaker");
					caretakerList.add(Map.of("caretakerId", rs.getInt("caretaker_id"),
							"name", rs.getString("name"),
							"email", rs.getString("email"),
							"phone", rs.getString("phone"),
							"bio", rs.getString("bio"),
							"experienceYears", rs.getInt("experience_years"),
							"rating", rs.getDouble("rating")));
					caretakers.add(caretakerId);
				}
			}
			
			return result;
		} catch (Exception e) {
			System.out.print("..............Error: " + e);
			e.printStackTrace();
		} finally {
			conn.close();
		}
		
		return null;
	}
}