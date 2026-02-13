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
        <div class="bookings-tabs">
  <a class="tab" href="<%=request.getContextPath()%>/bookings/upcoming">Upcoming</a>
  <a class="tab active" href="<%=request.getContextPath()%>/bookings/past">Past</a>
</div>
        

        <div class="bookings-list">
            <% if (bookings == null || bookings.isEmpty()) { %>
                <p class="empty-msg">You have no past bookings.</p>
            <% } else { %>

                <% for (BookingDisplayItem b : bookings) { %>
                    <div class="booking-card past">

  <div class="booking-header">
    <div>
      <p class="booking-title"><%= b.getServiceName() %></p>
      <p class="booking-sub"><%= b.getPackageName() %></p>
    </div>
    <%
String status = b.getStatus();
String badgeClass = "badge-default";
String label = status;

if ("CANCELLED".equalsIgnoreCase(status)) { badgeClass = "badge-cancelled"; label = "CANCELLED"; }
else if ("COMPLETED".equalsIgnoreCase(status)) { badgeClass = "badge-completed"; label = "COMPLETED"; }
else if ("PAID".equalsIgnoreCase(status)) { badgeClass = "badge-paid"; label = "PAID"; }
else if ("PENDING".equalsIgnoreCase(status)) { badgeClass = "badge-pending"; label = "PENDING"; }
%>
<% if ("COMPLETED".equalsIgnoreCase(b.getStatus())) { %>
  <a class="btn btn-primary"
     href="<%=request.getContextPath()%>/public/feedback.jsp?booking_id=<%= b.getBookingId() %>">
     Leave Feedback
  </a>
<% } %>


<span class="status-badge <%=badgeClass%>"><%=label%></span>

  </div>

  <div class="booking-grid">
    <div><span class="label">Date</span><span class="value"><%= b.getScheduledDate() %></span></div>
    <div><span class="label">Time</span><span class="value"><%= b.getScheduledTime() %></span></div>
    <div><span class="label">Price</span><span class="value">$<%= b.getPrice() %></span></div>
    <div><span class="label">Booking ID</span><span class="value">#<%= b.getBookingId() %></span></div>
  </div>

  <% if (b.getNotes() != null && !b.getNotes().trim().isEmpty()) { %>
    <p class="notes"><strong>Notes:</strong> <%= b.getNotes() %></p>
  <% } %>

  <div class="actions">
    <a class="btn btn-primary"
       href="<%=request.getContextPath()%>/public/feedback.jsp?booking_id=<%= b.getBookingId() %>">
       Leave Feedback
    </a>

    <a class="btn btn-ghost"
       href="<%=request.getContextPath()%>/public/bookingDetails.jsp?booking_id=<%= b.getBookingId() %>">
       View Details
    </a>
  </div>

</div>

                <% } %>

            <% } %>
        </div>
    </main>

	
	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>
