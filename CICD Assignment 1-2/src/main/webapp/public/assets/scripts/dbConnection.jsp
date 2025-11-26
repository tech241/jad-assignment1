<%@ page import="java.sql.*"%>

<%
Connection conn = null;
//STEP 1: Load JDBC Driver
try {
	Class.forName("org.postgresql.Driver");
} catch (ClassNotFoundException e) {
	out.println("PostgreSQL JDBC Driver not found: " + e);
}
//STEP 2: Define Connection URL
String connURL = "jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require";

String dbUser = "neondb_owner";
String dbPass = "npg_iCobAxPw5z4X";

// STEP 3: Establish Connection to URL 
// Connection conn = null;

try {
	conn = DriverManager.getConnection(connURL, dbUser, dbPass);
	// out.println("DB Connected Successfully"); // use for debugging if needed
} catch (SQLException e) {
	out.println("Connection Error: " + e);
}
%>