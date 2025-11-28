<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.HashMap"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%
	HashMap<String, Object> stats = new HashMap<String, Object>();
	
    try {
        Class.forName("org.postgresql.Driver");
        Connection connStats = DriverManager.getConnection(
		"jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require",
        "neondb_owner", "npg_iCobAxPw5z4X");

		Statement stmtStats = connStats.createStatement();
		ResultSet rsStats = stmtStats.executeQuery("SELECT * FROM get_statistics();");
		
		while (rsStats.next()) {
			ResultSetMetaData rsmdStats = rsStats.getMetaData();
			for (int index = 1; index <= rsmdStats.getColumnCount(); index ++) {
    			String columnName = rsmdStats.getColumnName(index);
    			String valueRaw = rsStats.getString(columnName);
    			
    			try {
    				Double value = Double.parseDouble(valueRaw);
    				stats.put(columnName, valueRaw.contains(".") ? String.format("%.2f", value) : rsStats.getInt(columnName));
    			} catch (Exception e) {
    				stats.put(columnName, valueRaw);
    			}
			}
		}
	} catch (Exception e) {
		out.println("Error in header DB: " + e);
	}
    %>

</body>
</html>