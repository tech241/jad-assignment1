<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="models.BookingDisplayItem" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Past Bookings</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/general.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/bookingsDisplay.css">
</head>
<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	
	<%
        List<BookingDisplayItem> bookings =
            (List<BookingDisplayItem>) request.getAttribute("bookings");
    %>
    
    <%
String msg = request.getParameter("msg");
String errMsg = request.getParameter("errMsg");
if (msg != null) {
%>
  <div class="alert success"><%= msg %></div>
<%
}
if (errMsg != null) {
%>
  <div class="alert error"><%= errMsg %></div>
<%
}
%>

    <main class="bookings-wrapper">
        <h1>Past Bookings</h1>

        <div class="bookings-list">
            <% if (bookings == null || bookings.isEmpty()) { %>
                <p class="empty-msg">You have no past bookings.</p>
            <% } else { %>

                <% for (BookingDisplayItem b : bookings) { %>
                    <div class="booking-card past">
                        <h2><%= b.getServiceName() %></h2>

                        <p><strong>Package:</strong> <%= b.getPackageName() %></p>
                        <p><strong>Date:</strong> <%= b.getScheduledDate() %></p>
                        <p><strong>Time:</strong> <%= b.getScheduledTime() %></p>
                        <p><strong>Price:</strong> $<%= b.getPrice() %></p>
                        <p><strong>Notes:</strong> <%= b.getNotes() %></p>

                        <a class="feedback-btn"
                           href="<%=request.getContextPath()%>/public/feedback.jsp?booking_id=<%= b.getBookingId() %>">
                           Leave Feedback
                        </a>
                    </div>
                <% } %>

            <% } %>
        </div>
    </main>

	
	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>
