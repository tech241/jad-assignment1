<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="models.BookingItem" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="assets/general.css">
<link rel="stylesheet" href="assets/editBooking.css">
</head>
<body>
	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	<%
	if (!isLoggedIn) {
		response.sendRedirect("login.jsp?errMsg=Please log in first.");
		return;
	}

	int index = Integer.parseInt(request.getParameter("index"));
	ArrayList<BookingItem> cart = (ArrayList<BookingItem>) session.getAttribute("cart");

	BookingItem item = cart.get(index); // direct access — no reflection needed!
	%>

	<h1>Edit Booking</h1>

	<form action="updateBooking.jsp" method="post" class="edit-form">

		<input type="hidden" name="index" value="<%=index%>"> <label>Date</label>
		<input type="date" name="date" value="<%=item.date%>" required>

		<label>Time</label> <input type="time" name="time"
			value="<%=item.time%>" required> <label>Notes</label>
		<textarea name="notes"><%=item.notes%></textarea>

		<button type="submit">Save Changes</button>
	</form>
<%@ include file="assets/components/footer.jsp"%>
</body>
</html>