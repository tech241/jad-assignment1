package servlets;

import java.sql.*;
import java.util.function.BiConsumer;

public class postgresHelper {
	public static Connection connect() {
		try {
			// Step1: Load JDBC Driver – TO BE OMITTED for newer drivers
			Class.forName("org.postgresql.Driver");
				
			// Step 2: Define Connection URL
			String connURL = System.getenv().get("JADAssignmentDB");
		
			// Step 3: Establish connection to URL
			return DriverManager.getConnection(connURL);
		} catch (Exception e) {
			System.out.println("Error :" + e);
			return null;
		}
	}
	
	public static void query (String sqlStr, BiConsumer<ResultSet, Integer> function) {
		try {
			// Step 4: Create Statement object
			Connection conn = connect();
			Statement stmt = conn.createStatement();
			
			// Step 5: Execute SQL Command
			if (sqlStr.toUpperCase().contains("INSERT")) {
				stmt.executeUpdate(sqlStr);
			} else if (sqlStr.toUpperCase().contains("UPDATE")) {
				stmt.executeUpdate(sqlStr);
			} else if (sqlStr.toUpperCase().contains("DELETE")) {
				stmt.executeUpdate(sqlStr);
			} else if (sqlStr.toUpperCase().contains("SELECT")) {
				process(stmt.executeQuery(sqlStr), function);
			}
			
			// Step 7: Close connection
			conn.close();
		} catch (Exception e) {
			System.out.println("Error :" + e);
		}
	}
	
	public static void query (String sqlStr, BiConsumer<ResultSet, Integer> function, Object... parameters) {
		try {
			// Step 4: Create Statement object
			Connection conn = connect();
			PreparedStatement stmt = conn.prepareStatement(sqlStr);
			
			int index = 1;
			for (Object parameter : parameters) {
				if (parameter instanceof String) {
					stmt.setString(index, (String) parameter);
				} else if (parameter instanceof Integer) {
					stmt.setInt(index, (int) parameter);
				} else if (parameter instanceof Boolean) {
					stmt.setBoolean(index, (boolean) parameter);
				} else if (parameter instanceof Date) {
					stmt.setDate(index, (Date) parameter);
				}
				
				index ++;
			}
				
			// Step 5: Execute SQL Command
			if (sqlStr.toUpperCase().contains("INSERT")) {
				stmt.executeUpdate();
			} else if (sqlStr.toUpperCase().contains("UPDATE")) {
				stmt.executeUpdate();
			} else if (sqlStr.toUpperCase().contains("DELETE")) {
				stmt.executeUpdate();
			} else if (sqlStr.toUpperCase().contains("SELECT")) {
				process(stmt.executeQuery(), function);
			}
			
			// Step 7: Close connection
			conn.close();
		} catch (Exception e) {
			System.out.println("Error :" + e);
		}
	}
	
	public static void process(ResultSet rs, BiConsumer<ResultSet, Integer> function) {
		try {
			// Step 6: Process Result
			int index = 0;
			
			while (rs.next()) {
				index ++;
				
				// function goes here
				function.accept(rs, index);
			}
			
			if (index <= 0) {
				function.accept(null, index);
			}
		} catch (Exception e) {
			System.out.println("Error :" + e);
		}
	}
}