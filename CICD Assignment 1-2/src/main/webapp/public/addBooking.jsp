<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="models.BookingItem"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="assets/general.css">
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
	String packageId = request.getParameter("package_id");
	String serviceId = request.getParameter("service_id");
	String date = request.getParameter("date");
	String time = request.getParameter("time");
	String caretaker = request.getParameter("caretaker_id");
	String notes = request.getParameter("notes");


	java.time.LocalDate selectedDate = java.time.LocalDate.parse(date);
	java.time.LocalDate today = java.time.LocalDate.now();

	if (selectedDate.isBefore(today)) {
		response.sendRedirect("bookings.jsp?package_id=" + packageId + "&service_id=" + serviceId
		+ "&errMsg=You cannot book a date in the past.");
		return;
	}


	try {
		String sql = "INSERT INTO booking "
		+ "(member_id, service_id, package_id, scheduled_date, scheduled_time, notes, caretaker_id) "
		+ "VALUES (?, ?, ?, ?, ?, ?, ?)";

		PreparedStatement pstmtInsert = conn.prepareStatement(sql);
		pstmtInsert.setInt(1, memberId);
		pstmtInsert.setInt(2, Integer.parseInt(serviceId));
		pstmtInsert.setInt(3, Integer.parseInt(packageId));
		pstmtInsert.setDate(4, java.sql.Date.valueOf(selectedDate));
		pstmtInsert.setTime(5, java.sql.Time.valueOf(time + ":00"));
		pstmtInsert.setString(6, notes == null ? "" : notes);

		if (caretaker == null || caretaker.trim().isEmpty()) {
			pstmtInsert.setNull(7, java.sql.Types.INTEGER);
		} else {
			pstmtInsert.setInt(7, Integer.parseInt(caretaker));
		}

		pstmtInsert.executeUpdate();
		pstmtInsert.close();


		response.sendRedirect("bookingSuccess.jsp");

	} catch (Exception e) {
		out.println("Booking Error: " + e.getMessage());
	}
	%>

</body>
</html>