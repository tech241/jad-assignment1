<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%@ include file="assets/scripts/checkLoggedIn.jsp"%>
<%@ include file="assets/scripts/dbConnection.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Services | Silver Cares</title>

<link rel="stylesheet" href="assets/serviceList.css">
</head>

<body>

	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<main>

		<%
		Connection connCat3 = null;
		PreparedStatement pstmtCat3 = null;
		ResultSet rsCat3 = null;
		String catId2 = request.getParameter("cat_id");

		String categoryName = "";
		String categoryDescription = "";
		boolean hasServices = false;

		if (catId2 == null || catId2.trim().isEmpty()) {
			out.println("<p style='color:red; text-align:center;'>Invalid category selected.</p>");
		} else {
			try {
				// Category info
				String catQuery = "SELECT cat_name, cat_description FROM service_category WHERE cat_id = ?";
				pstmtCat3 = conn.prepareStatement(catQuery);
				pstmtCat3.setInt(1, Integer.parseInt(catId2));
				rsCat3 = pstmtCat3.executeQuery();

				if (rsCat3.next()) {
			categoryName = rsCat3.getString("cat_name");
			categoryDescription = rsCat3.getString("cat_description");
				}

				rsCat3.close();
				pstmtCat3.close();
		%>

		<!-- Breadcrumb for path -->
		<nav class="breadcrumb">
			<a href="services.jsp">Services</a> <span>/</span> <span><%=categoryName%></span>
		</nav>

		<!-- Category header -->
		<div class="category-header">
			<div class="header-content">
				<h1><%=categoryName%></h1>
				<p><%=categoryDescription%></p>
			</div>
		</div>

		<!-- Services list -->
		<div class="services-container">

			<%
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
			
			String serviceQuery = "SELECT service_id, service_name, service_description, image_path FROM service WHERE cat_id = ? ORDER BY service_name";
			pstmtCat3 = conn.prepareStatement(serviceQuery);
			pstmtCat3.setInt(1, Integer.parseInt(catId2));
			rsCat3 = pstmtCat3.executeQuery();

			while (rsCat3.next()) {
				hasServices = true;
				int serviceId = rsCat3.getInt("service_id");
				String serviceName = rsCat3.getString("service_name");
				String serviceDescription = rsCat3.getString("service_description");
				String imagePath = rsCat3.getString("image_path");
			%>

			<div class="service-card">
				<div class="service-image">
					<%
					if (imagePath != null && !imagePath.trim().isEmpty()) {
					%>
					<img src="assets/images/<%=imagePath%>"
						alt="<%=serviceName%>" onerror="this.src='assets/images/default_image.png'">
					<%
					} else {
					%>
					<img src="assets/images/default-service.png"
						alt="<%=serviceName%>">
					<%
					}
					%>
				</div>

				<div class="service-content">
					<h3><%=rsCat3.getString("service_name")%></h3>
					<p><%=rsCat3.getString("service_description")%></p>

					<div class="service-actions">
						<a class="view-details-btn"
							href="serviceDetails.jsp?service_id=<%=rsCat3.getInt("service_id")%>">View
							Details</a> <a class="book-btn"
							href="booking.jsp?service_id=<%=rsCat3.getInt("service_id")%>">Book
							Now</a>
					</div>
				</div>
			</div>

			<%
			}

			if (!hasServices) {
			out.println("<div class='no-services'><p>No services available in this category.</p></div>");
			}

			} catch (Exception e) {
			out.println("<p style='color:red;'>Error loading services: " + e.getMessage() + "</p>");
			} finally {
			if (rsCat3 != null)
			rsCat3.close();
			if (pstmtCat3 != null)
			pstmtCat3.close();
			if (connCat3 != null)
			connCat3.close();
			}
			}
			%>

		</div>

	</main>

	<%@ include file="assets/components/header.jsp"%>
	
	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>
