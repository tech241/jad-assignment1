package com.silvercare.config;
import java.sql.*;

/* ==================================
* Author: Cedric Mok Yue En
* Class: DIT/2A/21
* Description: ST0510 Pract7 - part 3
* ===================================
*/

public class DBConnection {
	
	public static Connection getConnection() {
		
		try {
			// Step1: Load JDBC Driver – TO BE OMITTED for newer drivers
			Class.forName("org.postgresql.Driver");
				
			// Step 2: Define Connection URL
			String url = "jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require";
	        String user = "neondb_owner";
	        String pass = "npg_iCobAxPw5z4X";
		
			// Step 3: Establish connection to URL
			return DriverManager.getConnection(url, user, pass);
		} catch (Exception e) {
			System.out.println("Error :" + e);
			return null;
		}
		
	}
	
}
