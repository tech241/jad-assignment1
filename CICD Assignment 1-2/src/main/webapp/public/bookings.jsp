<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="assets/general.css">
<link rel="stylesheet" href="assets/bookings.css">
</head>
<body>
	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<%
	String errMsg = request.getParameter("errMsg");
	if (errMsg != null) {
	%>
	<p style="color: red; text-align: center; margin-bottom: 20px;"><%=errMsg%></p>
	<%
	}
	%>

	<main class="booking-wrapper">

		<%
		String packageId = request.getParameter("package_id");

		if (packageId == null || packageId.trim().isEmpty()) {
			out.println("<p style='color:red;text-align:center;'>Invalid package selected.</p>");
		} else {

			PreparedStatement pstmt = null;
			ResultSet rs = null;

			String serviceName = "";
			String packageName = "";
			String packageDescription = "";
			String price = "";

			try {
				String query = "SELECT p.package_name, p.package_description, p.price, s.service_name "
				+ "FROM service_package p INNER JOIN service s ON p.service_id = s.service_id "
				+ "WHERE p.package_id = ?";

				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, Integer.parseInt(packageId));
				rs = pstmt.executeQuery();

				if (rs.next()) {
			packageName = rs.getString("package_name");
			packageDescription = rs.getString("package_description");
			price = rs.getBigDecimal("price").toString();
			serviceName = rs.getString("service_name");
				}

				rs.close();
				pstmt.close();
		%>

		<!-- Breadcrumb -->
		<nav class="breadcrumb">
			<a href="services.jsp">Services</a> <span>/</span> <a
				href="serviceDetails.jsp?service_id=<%=request.getParameter("service_id")%>">
				<%=serviceName%>
			</a> <span>/</span> Booking
		</nav>

		<h1 class="booking-title">
			Book:
			<%=packageName%></h1>

		<div class="booking-container">

			<!-- Left: Package Summary -->
			<section class="package-summary">
				<h2>Package Details</h2>

				<p>
					<strong>Service:</strong>
					<%=serviceName%></p>
				<p>
					<strong>Package:</strong>
					<%=packageName%></p>
				<p>
					<strong>Description:</strong>
					<%=packageDescription%></p>
				<p>
					<strong>Price:</strong> $<%=price%></p>
			</section>

			<!-- Right: Booking Form -->
			<section class="booking-form-section">
				<h2>Confirm Your Booking</h2>

				<form action="addBooking.jsp" method="POST" class="booking-form"> <!-- form collects all required booking fields and submits them to addBooking.jsp, which will insert the record using JDBC. -->

					<input type="hidden" name="package_id" value="<%=packageId%>"> <!-- these hidden fields ensure that the selected package and service IDs are sent to the backend even though the user does not edit them -->
					<input type="hidden" name="service_id" value="<%=request.getParameter("service_id")%>"> 
					<label>Date</label>
					<input type="date" name="date" id="bookingDate" required min="<%=java.time.LocalDate.now()%>"> <!-- prevent past dates by setting minimum value to today. type="date" shows the in-built HTML calendar. -->
					<label>Preferred Time</label> 
					<input type="time" name="time" min="09:00" max="18:00" required> <!-- HTML automatically prevents out-of-range times -->
					<small style="color: #6b7280; margin-top: 4px; display: block;">Operating hours: 9:00 AM - 6:00 PM</small> 
					<label>Preferred Caretaker (Optional)</label> 
					<select name="caretaker_id" class="booking-select">
					<option value="">Select a caretaker...</option> <!-- load all available caretakers -->
						<%
						try {
							String serviceId = request.getParameter("service_id");

							if (serviceId != null && !serviceId.trim().isEmpty()) {
								String queryCaretaker = "SELECT c.caretaker_id, c.name, c.experience_years, c.rating " + "FROM caretaker c "
								+ "INNER JOIN caretaker_service cs ON c.caretaker_id = cs.caretaker_id " + "WHERE cs.service_id = ? "
								+ "ORDER BY c.rating DESC";

								PreparedStatement pstmtCare = conn.prepareStatement(queryCaretaker);
								pstmtCare.setInt(1, Integer.parseInt(serviceId));
								ResultSet rsCare = pstmtCare.executeQuery();

								if (!rsCare.isBeforeFirst()) { // isBeforeFirst checks if the ResultSet has any rows inside it. 
							out.println("<option value=''>No caretakers available for this service</option>");
								}

								while (rsCare.next()) {
							int careId = rsCare.getInt("caretaker_id");
							String careName = rsCare.getString("name");
							int exp = rsCare.getInt("experience_years");
							double rating = rsCare.getDouble("rating");
						%>
						<option value="<%=careId%>"><%=careName%> (<%=exp%> yrs,
							★<%=String.format("%.1f", rating)%>)
						</option>
						<%
						}
						rsCare.close();
						pstmtCare.close();
						} else {
						out.println("<option value=''>Error: Service not found</option>");
						}
						} catch (Exception e) {
						out.println("<option value=''>Error loading caretakers: " + e.getMessage() + "</option>");
						}
						%>
					</select> <label>Additional Notes (Optional)</label>
					<textarea name="notes"
						placeholder="Eg: Prefer female caregiver, mobility concerns, etc."></textarea>

					<button type="submit" class="confirm-btn">Confirm Booking</button>
				</form>
			</section>

		</div>

		<%
		} catch (Exception e) {
		out.println("<p style='color:red;'>Error loading package: " + e + "</p>");
		}
		}
		%>

	</main>

	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>