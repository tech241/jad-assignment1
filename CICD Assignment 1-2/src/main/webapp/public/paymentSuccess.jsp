<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.time.LocalTime"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="models.BookingDisplayItem"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful | Silver Care</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/general.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/paymentSuccess.css">
</head>
<body>

<%@ include file="assets/components/header.jsp"%>
<%@ include file="assets/scripts/loadScripts.jsp"%>

<%
    @SuppressWarnings("unchecked")
    List<BookingDisplayItem> recentBookings = (List<BookingDisplayItem>) request.getAttribute("recentBookings");
    BigDecimal totalPaid = (BigDecimal) request.getAttribute("totalPaid");
    String errMsg = (String) request.getAttribute("errMsg");
    String okMsg = (String) request.getAttribute("okMsg");
    Boolean paymentSuccessful = (Boolean) request.getAttribute("paymentSuccessful");
    
    if (paymentSuccessful == null) paymentSuccessful = true;
%>

<main class="payment-wrapper">
    <div class="payment-container">
        
        <!-- Success/Error Messages -->
        <% if (errMsg != null) { %>
        <div class="error-message">
            <strong>⚠️ Warning:</strong> <%= errMsg %>
        </div>
        <% } %>
        
        <% if (okMsg != null) { %>
        <div class="success-message">
            ✅ <%= okMsg %>
        </div>
        <% } %>

        <!-- Success Header -->
        <div class="success-header">
            <div class="success-icon">✅</div>
            <h1>Payment Successful!</h1>
            <p>Your bookings have been confirmed.</p>
        </div>

        <!-- Confirmation Details -->
        <div class="confirmation-section">
            <div class="confirmation-header">
                <span class="confirmation-icon">📋</span>
                <h2>Confirmation Details</h2>
            </div>
            
            <div class="confirmation-details">
                <div class="detail-item">
                    <span class="detail-label">Amount Paid</span>
                    <span class="detail-value highlight">$<%= totalPaid != null ? totalPaid.toString() : "0.00" %></span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Number of Services</span>
                    <span class="detail-value"><%= recentBookings != null ? recentBookings.size() : 0 %></span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Payment Status</span>
                    <span class="detail-value" style="color: #16a09e; font-weight: 600;">✅ PAID</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Confirmation</span>
                    <span class="detail-value">Sent to your email</span>
                </div>
            </div>
        </div>

        <!-- Booking Details -->
        <% if (recentBookings != null && !recentBookings.isEmpty()) { %>
        <div class="bookings-section">
            <h3>Your Bookings</h3>
            
            <div class="booking-cards">
                <% for (int i = 0; i < recentBookings.size(); i++) {
                    BookingDisplayItem booking = recentBookings.get(i);
                    LocalTime startTime = booking.getScheduledTime();
                    LocalTime endTime = startTime != null ? startTime.plusMinutes(120) : null; // Default 2 hours
                %>
                <div class="booking-card">
                    <div class="booking-card-header">
                        <div>
                            <p class="booking-service"><%= booking.getServiceName() %></p>
                            <p class="booking-package"><%= booking.getPackageName() %></p>
                        </div>
                        <div class="booking-price">
                            <div class="booking-price-label">Price</div>
                            <div class="booking-price-value">$<%= booking.getPrice() %></div>
                        </div>
                    </div>

                    <div class="booking-details-grid">
                        <div class="booking-detail">
                            <span class="booking-detail-label">Date</span>
                            <span class="booking-detail-value"><%= booking.getScheduledDate() %></span>
                        </div>
                        <div class="booking-detail">
                            <span class="booking-detail-label">Time</span>
                            <span class="booking-detail-value">
                                <% if (startTime != null && endTime != null) { %>
                                    <%= startTime.format(java.time.format.DateTimeFormatter.ofPattern("hh:mm a")) %> - <%= endTime.format(java.time.format.DateTimeFormatter.ofPattern("hh:mm a")) %>
                                <% } else { %>
                                    <%= booking.getScheduledTime() %>
                                <% } %>
                            </span>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <div class="empty-bookings">
            <p>No booking details available. Your bookings are being processed.</p>
        </div>
        <% } %>

        <!-- Next Steps -->
        <div class="next-steps-section">
            <h3>📌 What's Next?</h3>
            <ul>
                <li><strong>Confirmation Email:</strong> We've sent a detailed confirmation to your email address.</li>
                <li><strong>Caretaker Assignment:</strong> We'll assign and confirm your caretaker within 2 hours.</li>
                <li><strong>Pre-Service Contact:</strong> Your caretaker will reach out 24 hours before the scheduled time.</li>
                <li><strong>Service Completion:</strong> After the service, you can leave feedback and rate your experience.</li>
            </ul>
        </div>

        <!-- Contact Information -->
        <div class="contact-section">
            <h3>Questions or Need Help?</h3>
            <div class="contact-items">
                <a href="tel:+18005555555" class="contact-item">
                    <span>1-800-CARE-NOW</span>
                </a>
                <a href="mailto:support@silvercare.com" class="contact-item">
                    <span>support@silvercare.com</span>
                </a>
                <a href="<%=request.getContextPath()%>/public/feedback.jsp" class="contact-item">
                    <span>Contact Support</span>
                </a>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="<%=request.getContextPath()%>/bookings/upcoming" class="btn-primary">
                View My Bookings
            </a>
            <a href="<%=request.getContextPath()%>/services" class="btn-secondary">
                Browse More Services
            </a>
        </div>

    </div>
</main>

<%@ include file="assets/components/footer.jsp"%>
</body>
</html>