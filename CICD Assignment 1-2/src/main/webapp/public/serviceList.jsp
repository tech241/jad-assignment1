<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Services | Silver Cares</title>

<link rel="stylesheet" href="assets/general.css">
<link rel="stylesheet" href="assets/serviceList.css">
</head>

<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<main>

		<%
		String catId = request.getParameter("cat_id");

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String categoryName = "";
		String categoryDescription = "";
		boolean hasServices = false; // flag to check if the services exist or not

		if (catId == null || catId.trim().isEmpty()) {
			out.println("<p style='color:red; text-align:center;'>Invalid category selected.</p>");
		} else {
			try {
				// Load category info
				String catQuery = "SELECT cat_name, cat_description FROM service_category WHERE cat_id = ?";
				pstmt = conn.prepareStatement(catQuery);
				pstmt.setInt(1, Integer.parseInt(catId));
				rs = pstmt.executeQuery();

				if (rs.next()) {
			categoryName = rs.getString("cat_name");
			categoryDescription = rs.getString("cat_description");
				}

				rs.close();
				pstmt.close();
		%>

		<!-- Breadcrumb -->
		<nav class="breadcrumb">
			<a href="services.jsp">Services</a> <span>/</span> <span><%=categoryName%></span>
		</nav>

		<div class="category-header">
			<div class="header-content">
				<h1><%=categoryName%></h1>
				<p><%=categoryDescription%></p>
			</div>
		</div>

		<div class="services-container">

			<%
			String serviceQuery = "SELECT service_id, service_name, service_description, image_path FROM service WHERE cat_id = ? ORDER BY service_name";

			pstmt = conn.prepareStatement(serviceQuery);
			pstmt.setInt(1, Integer.parseInt(catId));
			rs = pstmt.executeQuery();

			while (rs.next()) {
				hasServices = true;

				int serviceId = rs.getInt("service_id");
				String serviceName = rs.getString("service_name");
				String serviceDescription = rs.getString("service_description");
				String imagePath = rs.getString("image_path");
			%>

			<div class="service-card">

				<div class="service-image">
					<img src="assets/images/<%=imagePath%>" alt="<%=serviceName%>"
						onerror="this.src='assets/images/default-service.png'">
				</div>

				<div class="service-content">
					<h3><%=serviceName%></h3>
					<p><%=serviceDescription%></p>

					<div class="service-actions">
						<a class="view-details-btn"
							href="serviceDetails.jsp?service_id=<%=serviceId%>">View
							Details</a> <a class="book-btn"
							href="bookings.jsp?service_id=<%=serviceId%>">Book Now</a>
					</div>
				</div>

			</div>

			<%
			}

			if (!hasServices) {
			%>
			<div class="no-services">
				<p>No services available in this category.</p>
			</div>
			<%
			}

			} catch (Exception e) {
			out.println("<p style='color:red;'>Error loading services: " + e.getMessage() + "</p>");
			}
			}
			%>

		</div>

	</main>

	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>
