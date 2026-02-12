package servlets;

import java.sql.*;
import java.util.function.BiConsumer;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class postgresHelper {
	public static Connection connect() {
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
			    if (parameter == null) {
			        stmt.setObject(index, null);
			    } else if (parameter instanceof String) {
			        stmt.setString(index, (String) parameter);
			    } else if (parameter instanceof Integer) {
			        stmt.setInt(index, (int) parameter);
			    } else if (parameter instanceof Boolean) {
			        stmt.setBoolean(index, (boolean) parameter);
			    } else if (parameter instanceof Date) {
			        stmt.setDate(index, (Date) parameter);
			    } else if (parameter instanceof java.sql.Array) {
			        stmt.setArray(index, (java.sql.Array) parameter);
			    } else if (parameter instanceof Double) {
			        stmt.setDouble(index, (double) parameter);
			    } else if (parameter instanceof java.sql.Timestamp) {
			        stmt.setTimestamp(index, (java.sql.Timestamp) parameter);
			    } else {
			        // fallback for any other types
			        stmt.setObject(index, parameter);
			    }

			    index++;
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
	
	public static void validateAccount(HttpSession session, HttpServletResponse response, String url, int id, String password, Runnable function) {
		BiConsumer<ResultSet, Integer> process = (rs, index) -> {
			if (rs != null) {
				try {
					String password2 = rs.getString("password");
					if (bcryptHelper.check(password, password2)) {
						function.run();
					} else {
						response.sendRedirect("public/" + url + ".jsp?errMsg=Wrong password.");
					}
				} catch (Exception e) {
					try {
						response.sendRedirect("public/" + url + ".jsp?errMsg=An unknown error occured.");
						System.out.println("Error :" + e);
					} catch (Exception e1) {
						System.out.println("Error :" + e1);
					}
				}
			} else {
				try {
					// query does not give response
					response.sendRedirect("public/" + url + ".jsp?errMsg=Member does not exist.");
				} catch (Exception e1) {
					System.out.println("Error :" + e1);
				}
			}
		};
		
		// check if nameOrEmail is email
		// otherwise verify by name
		
		postgresHelper.query("SELECT * FROM member WHERE id = ?", process, id);
	}
	
	public static void setSession(HttpSession session, int id, String name, String email) {
		session.setAttribute("id", id);
		session.setAttribute("name", name);
		session.setAttribute("email", email);
		
	}
	
	public static void setSession(HttpSession session, int id, String name, String email, String role) {
		session.setAttribute("id", id);
		session.setAttribute("name", name);
		session.setAttribute("email", email);
		session.setAttribute("role", role);
	}
	
	public static void validateAdmin(HttpSession session, HttpServletResponse response, String url, int id, Runnable function) {
		BiConsumer<ResultSet, Integer> process = (rs, index) -> {
			if (rs != null) {
				try {
					String role = rs.getString("role");
					if ("admin".equals(role)) {
						function.run();
					} else {
						response.sendRedirect("public/" + url + ".jsp?errMsg=You are not admin.");
					}
				} catch (Exception e) {
					try {
						response.sendRedirect("public/" + url + ".jsp?errMsg=An unknown error occured.");
						System.out.println("Error :" + e);
					} catch (Exception e1) {
						System.out.println("Error :" + e1);
					}
				}
			} else {
				try {
					// query does not give response
					response.sendRedirect("public/" + url + ".jsp?errMsg=Member does not exist.");
				} catch (Exception e1) {
					System.out.println("Error :" + e1);
				}
			}
		};
		
		// check if nameOrEmail is email
		// otherwise verify by name
		
		postgresHelper.query("SELECT * FROM member WHERE id = ?", process, id);
	}
	
	public static void validateAccountNoPassword(HttpSession session, HttpServletResponse response, String url, int id, Runnable function) {
		BiConsumer<ResultSet, Integer> process = (rs, index) -> {
			if (rs != null) {
				try {
					function.run();
				} catch (Exception e) {
					try {
						response.sendRedirect("public/" + url + ".jsp?errMsg=An unknown error occured.");
						System.out.println("Error :" + e);
					} catch (Exception e1) {
						System.out.println("Error :" + e1);
					}
				}
			} else {
				try {
					// query does not give response
					response.sendRedirect("public/" + url + ".jsp?errMsg=Member does not exist.");
				} catch (Exception e1) {
					System.out.println("Error :" + e1);
				}
			}
		};
		
		// check if nameOrEmail is email
		// otherwise verify by name
		
		postgresHelper.query("SELECT * FROM member WHERE id = ?", process, id);
	}
	public static void loadMemberProfileToSession(HttpSession session, int memberId) {
	    BiConsumer<ResultSet, Integer> process = (rs, idx) -> {
	        if (rs == null) return;

	        try {
	            session.setAttribute("phone", rs.getString("phone"));
	            session.setAttribute("address", rs.getString("address"));
	            session.setAttribute("emergency_contact_name", rs.getString("emergency_contact_name"));
	            session.setAttribute("emergency_contact_phone", rs.getString("emergency_contact_phone"));
	            session.setAttribute("residential_area_code", rs.getString("residential_area_code"));

	            java.sql.Array arr = rs.getArray("care_needs");
	            String[] needs = (arr == null) ? new String[]{} : (String[]) arr.getArray();
	            session.setAttribute("care_needs", needs);

	        } catch (Exception e) {
	            System.out.println("Error loading member profile: " + e);
	        }
	    };

	    postgresHelper.query("SELECT phone, address, emergency_contact_name, emergency_contact_phone, residential_area_code, care_needs FROM member WHERE id = ?", process, memberId);
	}
}