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
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String catId = request.getParameter("cat_id");

		String categoryName = "";
		String categoryDescription = "";
		boolean hasServices = false;

		if (catId == null || catId.trim().isEmpty()) {
			out.println("<p style='color:red; text-align:center;'>Invalid category selected.</p>");
		} else {
			try {
				// Category info
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
					<h3><%=rs.getString("service_name")%></h3>
					<p><%=rs.getString("service_description")%></p>

					<div class="service-actions">
						<a class="view-details-btn"
							href="serviceDetails.jsp?service_id=<%=rs.getInt("service_id")%>">View
							Details</a> <a class="book-btn"
							href="bookings.jsp?service_id=<%=rs.getInt("service_id")%>">Book
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
			if (rs != null)
			rs.close();
			if (pstmt != null)
			pstmt.close();
			if (conn != null)
			conn.close();
			}
			}
			%>

		</div>

	</main>

	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>