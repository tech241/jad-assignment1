<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="models.BookingItem"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="assets/general.css">
<link rel="stylesheet" href="assets/bookingSummary.css">
</head>
<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	<%
	if (!isLoggedIn) {
		response.sendRedirect("login.jsp?errMsg=Please log in first.");
		return;
	}

	// ArrayList is used to temporarily store the user's selected bookings in their session before finalizing and saving into db
	// ArrayList is used since it is dynamic, easy to iterate and allows editing or removing items by index
	ArrayList<BookingItem> cart = (ArrayList<BookingItem>) session.getAttribute("cart");

	if (cart == null || cart.size() == 0) {
	%>
	<h2 style="text-align: center; margin-top: 40px;">You have no
		bookings yet.</h2>
	<%
	return;
	}
	%>

	<h1>Your Bookings</h1>

	<div class="booking-summary-container">
		<%
		for (BookingItem item : cart) { // loop through the arraylist called cart
		%>
		<div class="booking-card">
			<h2><%=item.serviceName%></h2>

			<p>
				<strong>Package:</strong>
				<%=item.packageName%></p>
			<p>
				<strong>Date:</strong>
				<%=item.date%></p>
			<p>
				<strong>Time:</strong>
				<%=item.time%></p>
			<p>
				<strong>Notes:</strong>
				<%=(item.notes == null || item.notes.isEmpty() ? "None" : item.notes)%></p>
			<p>
				<strong>Price:</strong> $<%=item.price%></p>

			<div class="actions"> <!-- index of each item represents its position in the cart -->
				<a href="editBooking.jsp?index=<%=cart.indexOf(item)%>"
					class="btn-edit">Edit</a> <a
					href="deleteBooking.jsp?index=<%=cart.indexOf(item)%>"
					class="btn-delete">Delete</a> <a href="finalizeBooking.jsp"
					class="btn-finalize">Finalize & Save Booking</a> <!-- this btn means user can review their temporary items, confirm or edit and then items are inserted into the db -->
			</div>
		</div>

		<%
		}
		%>
	</div>
	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>