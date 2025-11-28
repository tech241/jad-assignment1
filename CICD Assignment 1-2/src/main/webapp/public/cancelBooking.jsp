<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ page import="java.sql.*"%>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<%
	if (!isLoggedIn) {
		response.sendRedirect("login.jsp?errMsg=Please log in first.");
		return;
	}

	int bookingId = Integer.parseInt(request.getParameter("booking_id"));
	int memberId = (Integer) session.getAttribute("id");

	String sql = "DELETE FROM booking WHERE booking_id = ? AND member_id = ?";

	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, bookingId);
	pstmt.setInt(2, memberId);
	pstmt.executeUpdate();
	pstmt.close();

	response.sendRedirect("upcomingBookings.jsp?msg=Booking cancelled.");
	%>
</body>
</html>