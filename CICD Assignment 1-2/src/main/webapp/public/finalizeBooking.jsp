<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
	// Ensure user is logged in
	if (session.getAttribute("id") == null) {
		response.sendRedirect("login.jsp?errMsg=Please log in first.");
		return;
	}

	// Clear the cart
	session.removeAttribute("cart");

	// Redirect to upcoming bookings with message
	response.sendRedirect("upcomingBookings.jsp?msg=Your booking has been finalized!");
	%>
	
	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>