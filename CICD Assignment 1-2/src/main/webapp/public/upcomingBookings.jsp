<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.time.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upcoming Bookings</title>
<link rel="stylesheet" href="assets/general.css">
<link rel="stylesheet" href="assets/bookingsDisplay.css">
</head>
<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<%
	if (!isLoggedIn) {
		response.sendRedirect("login.jsp?errMsg=Please log in first.");
		return;
	}

	int memberId = (Integer) session.getAttribute("id");

	String sql = "SELECT b.booking_id, b.scheduled_date, b.scheduled_time, b.notes, "
			+ "s.service_name, p.package_name, p.price " + "FROM booking b "
			+ "INNER JOIN service s ON b.service_id = s.service_id "
			+ "INNER JOIN service_package p ON b.package_id = p.package_id "
			+ "WHERE b.member_id = ? AND b.scheduled_date >= CURRENT_DATE ORDER BY b.booking_id DESC";

	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, memberId);
	ResultSet rs = pstmt.executeQuery();
	%>

	<main class="bookings-wrapper">
		<h1>Upcoming Bookings</h1>

		<div class="bookings-list">
			<%
			boolean hasData = false;
			while (rs.next()) {
				hasData = true;
			%>

			<div class="booking-card">

				<h2><%=rs.getString("service_name")%></h2>
				<p>
					<strong>Package:</strong>
					<%=rs.getString("package_name")%></p>
				<p>
					<strong>Date:</strong>
					<%=rs.getDate("scheduled_date")%></p>
				<p>
					<strong>Time:</strong>
					<%=rs.getTime("scheduled_time")%></p>
				<p>
					<strong>Price:</strong> $<%=rs.getBigDecimal("price")%></p>
				<p>
					<strong>Notes:</strong>
					<%=rs.getString("notes")%></p>
				<a class="btn-cancel"
					href="cancelBooking.jsp?booking_id=<%=rs.getInt("booking_id")%>">
					Cancel Booking </a>

			</div>

			<%
			}

			if (!hasData) {
			%>
			<p class="empty-msg">You have no upcoming bookings.</p>
			<%
			}

			rs.close();
			pstmt.close();
			%>
		</div>

	</main>
	
	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>
