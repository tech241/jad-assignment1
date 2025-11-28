<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="assets/general.css">
<link rel="stylesheet" href="assets/serviceDetails.css">
</head>
<body>
	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<main>

		<%
		// Get service_id from URL
		String serviceId = request.getParameter("service_id");
		String whatsIncluded = "";

		if (serviceId == null || serviceId.trim().isEmpty()) {
			out.println("<p style='color:red; text-align:center;'>Invalid service selected.</p>");
		} else {

			PreparedStatement pstmt = null;
			ResultSet rs = null;

			String serviceName = "";
			String serviceDescription = "";
			String imagePath = "";

			try {
				// Load main service info
				String svcQuery = "SELECT service_name, service_description, image_path, whats_included FROM service WHERE service_id = ?";
				pstmt = conn.prepareStatement(svcQuery);
				pstmt.setInt(1, Integer.parseInt(serviceId));
				rs = pstmt.executeQuery();

				if (rs.next()) {
			serviceName = rs.getString("service_name");
			serviceDescription = rs.getString("service_description");
			imagePath = rs.getString("image_path");
			whatsIncluded = rs.getString("whats_included");

				}

				rs.close();
				pstmt.close();
		%>

		<!-- Breadcrumb for path -->
		<nav class="breadcrumb">
			<a href="services.jsp">Services</a> <span>/</span> <span><%=serviceName%></span>
		</nav>
		<!-- Hero Title -->
		<h1 class="service-title"><%=serviceName%></h1>
		<p class="service-desc"><%=serviceDescription%></p>

		<div class="details-wrapper">

			<!-- LEFT: Service Image -->
			<div class="service-image-box">
				<img src="assets/images/<%=imagePath%>"
					onerror="this.src='assets/images/default_image.png'"
					alt="<%=serviceName%>">
			</div>

			<!-- RIGHT: Packages Table -->
			<div class="packages-box">
				<h2>Available Packages</h2>

				<table class="packages-table">
					<tr>
						<th>Package</th>
						<th>Description</th>
						<th>Price</th>
						<th></th>
					</tr>

					<%
					// Load packages
					String pkgQuery = "SELECT package_id, package_name, package_description, price FROM service_package WHERE service_id = ? ORDER BY price ASC";
					pstmt = conn.prepareStatement(pkgQuery);
					pstmt.setInt(1, Integer.parseInt(serviceId));
					rs = pstmt.executeQuery();

					boolean hasPackages = false;

					while (rs.next()) {
						hasPackages = true;
					%>

					<tr>
						<td><%=rs.getString("package_name")%></td>
						<td><%=rs.getString("package_description")%></td>
						<td>$<%=rs.getBigDecimal("price")%></td>
						<td><a class="book-btn"
							href="verifyBookingAccess.jsp?package_id=<%=rs.getInt("package_id")%>&service_id=<%=serviceId%>">
								Book </a></td>
					</tr>

					<%
					}

					if (!hasPackages) {
					%>
					<tr>
						<td colspan="4" style="text-align: center;">No packages
							available.</td>
					</tr>
					<%
					}

					} catch (Exception e) {
					out.println("<p style='color:red;'>Error loading service: " + e + "</p>");
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

				</table>
			</div>

		</div>

		<section class="info-section">
			<h2>What’s Included</h2>

			<%
			if (whatsIncluded != null && whatsIncluded.trim().length() > 0) {
			%>
			<ul>
				<%
				for (String item : whatsIncluded.split("\n")) {
				%>
				<li><%=item.replace("•", "").trim()%></li>
				<%
				}
				%>
			</ul>
			<%
			} else {
			%>
			<p>No information available for this service.</p>
			<%
			}
			%>
		</section>

		<!-- NEW SECTION: Suitable For -->
		<section class="info-section">
			<h2>This Service Is Suitable For</h2>
			<ul>
				<li>Seniors who require consistent support</li>
				<li>Families seeking reliable and structured assistance</li>
				<li>Individuals recovering from injury or illness</li>
				<li>Seniors who benefit from companionship and monitoring</li>
			</ul>
		</section>

		<!-- NEW SECTION: How It Works -->
		<section class="steps-section">
			<h2>How It Works</h2>

			<div class="steps-grid">
				<div class="step-card">
					<div class="step-num">1</div>
					<h3>Select a Package</h3>
					<p>Choose a suitable support package tailored to your needs.</p>
				</div>
				<div class="step-card">
					<div class="step-num">2</div>
					<h3>Pick a Date & Time</h3>
					<p>Choose your preferred availability for your care session.</p>
				</div>
				<div class="step-card">
					<div class="step-num">3</div>
					<h3>Confirm Your Booking</h3>
					<p>Submit the form and our caregiver will be assigned to assist
						you.</p>
				</div>
			</div>
		</section>

	</main>

	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>