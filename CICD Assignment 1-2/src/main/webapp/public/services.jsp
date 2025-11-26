
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%@ include file="assets/scripts/checkLoggedIn.jsp"%>
<%@ include file="assets/scripts/dbConnection.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Our Services | Silver Cares</title>

<link rel="stylesheet" href="assets/services.css">
</head>

<body>

	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<main>

		<!-- Hero Section -->
		<section class="hero-section">
			<div class="hero-content">
				<h1>Our Services</h1>
				<p>Discover our comprehensive range of care services designed to
					enhance the well-being and independence of our seniors. Choose a
					category to explore what we offer.</p>
			</div>
		</section>

		<div class="category-container">

			<%
			Connection connCat3 = null;
			//STEP 1: Load JDBC Driver
			try {
				Class.forName("org.postgresql.Driver");
			} catch (ClassNotFoundException e) {
				out.println("PostgreSQL JDBC Driver not found: " + e);
			}
			//STEP 2: Define Connection URL
			String connURLCat3 = "jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require";

			String dbUserCat3 = "neondb_owner";
			String dbPassCat3 = "npg_iCobAxPw5z4X";

			// STEP 3: Establish Connection to URL 
			// Connection conn = null;
			
			try {
				connCat3 = DriverManager.getConnection(connURLCat3, dbUserCat3, dbPassCat3);
				// out.println("DB Connected Successfully"); // use for debugging if needed
			} catch (SQLException e) {
				out.println("Connection Error: " + e);
			}
			
			PreparedStatement pstmtCat3 = null;
			ResultSet rsCat3 = null;

			try {
				String sqlCommand = "SELECT cat_id, cat_name, cat_description, cat_logo FROM service_category ORDER BY cat_id";
				pstmtCat3 = connCat3.prepareStatement(sqlCommand);
				rsCat3 = pstmtCat3.executeQuery();

				while (rsCat3.next()) {
			%>

			<div class="category-card">
				<div class="icon-container">
					<img src="assets/images/<%=rsCat3.getString("cat_logo")%>"
						alt="<%=rsCat3.getString("cat_name")%> Logo">
				</div>

				<h3><%=rsCat3.getString("cat_name")%></h3>
				<p><%=rsCat3.getString("cat_description")%></p>

				<a class="view-btn"
					href="serviceList.jsp?cat_id=<%=rsCat3.getInt("cat_id")%>">View
					Services</a>
			</div>


			<%
			} 
			} catch (Exception e) {
			out.println("<p style='color:red; text-align:center;'>Error loading categories: " + e + "</p>");
			} finally {
			if (rsCat3 != null)
			rsCat3.close();
			if (pstmtCat3 != null)
			pstmtCat3.close();
			if (connCat3 != null)
			connCat3.close();
			}
			%>

		</div>
	</main>
	
	<%@ include file="assets/components/header.jsp"%>
	
	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>