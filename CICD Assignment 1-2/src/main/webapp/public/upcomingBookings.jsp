<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="models.BookingDisplayItem"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upcoming Bookings</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/general.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/bookingsDisplay.css">

</head>
<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<%
	List<BookingDisplayItem> bookings = (List<BookingDisplayItem>) request.getAttribute("bookings");
	%>
	<%
	String msg = request.getParameter("msg");
	String errMsg = request.getParameter("errMsg");
	if (msg != null) {
	%>
	<div class="alert success"><%=msg%></div>
	<%
	}
	if (errMsg != null) {
	%>
	<div class="alert error"><%=errMsg%></div>
	<%
	}
	%>

	<h2>Upcoming Bookings</h2>

	<%
	if (bookings == null || bookings.isEmpty()) {
	%>
	<p>No upcoming bookings found.</p>
	<%
	} else {
	%>
	<div class="bookings-list">
		<%
		for (BookingDisplayItem b : bookings) {
		%>
		<div class="booking-card">
			<p>
				<strong><%=b.getServiceName()%></strong> —
				<%=b.getPackageName()%></p>
			<p>
				Date:
				<%=b.getScheduledDate()%>
				| Time:
				<%=b.getScheduledTime()%></p>
			<p>
				Caretaker:
				<%=(b.getCaretakerName() == null ? "-" : b.getCaretakerName())%></p>
			<p>
				Status:
				<%=b.getStatus()%></p>

			<!-- Cancel button will become MVC later -->
			<form method="post"
				action="<%=request.getContextPath()%>/bookings/cancel">
				<input type="hidden" name="bookingId"
					value="<%=b.getBookingId()%>" />
				<button type="submit"
					onclick="return confirm('Cancel this booking?');">Cancel</button>
			</form>
		</div>
		<%
		}
		%>
	</div>
	<%
	}
	%>

	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>
