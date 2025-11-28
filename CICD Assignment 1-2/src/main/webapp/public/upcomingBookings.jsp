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

	PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM get_upcoming_bookings(?)");
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
