<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="models.BookingItem"%>
<%@ page import="java.time.LocalTime"%>
<%@ page import="java.time.format.DateTimeFormatter"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout | Silver Care</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/general.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/checkout.css">
</head>
<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<%
	ArrayList<BookingItem> cart = (ArrayList<BookingItem>) request.getAttribute("cart");
	BigDecimal total = (BigDecimal) request.getAttribute("total");

	if (cart == null || cart.isEmpty() || total == null) {
		response.sendRedirect(request.getContextPath() + "/cart?errMsg=Your cart is empty.");
		return;
	}
	%>

	<main class="checkout-wrapper">
		<div class="checkout-container">
			<h1>Order Review</h1>
			<p class="checkout-subtitle">Please review your booking details
				before payment</p>

			<div class="order-summary-section">
				<h2 class="section-title">Your Bookings</h2>

				<%
				int itemNumber = 1;
				for (BookingItem item : cart) {
					// Calculate end time from duration
					LocalTime startTime = LocalTime.parse(item.time);
					LocalTime endTime = startTime.plusMinutes(item.durationMinutes);
				%>
				<div class="booking-detail-card">
					<!-- Service Badge & Name -->
					<div class="booking-header">
						<span class="item-number">Service <%=itemNumber%></span> <span
							class="service-name"><%=item.serviceName%></span>
					</div>

					<!-- Details Grid (2 columns) -->
					<div class="booking-details-grid">
						<div class="detail-row">
							<span class="detail-label">Package:</span> <span
								class="detail-value"><%=item.packageName%></span>
						</div>

						<div class="detail-row">
							<span class="detail-label">Date:</span> <span
								class="detail-value"><%=item.date%></span>
						</div>

						<div class="detail-row">
							<span class="detail-label">Time:</span> <span
								class="detail-value"> <%=startTime.format(DateTimeFormatter.ofPattern("hh:mm a"))%>
								- <%=endTime.format(DateTimeFormatter.ofPattern("hh:mm a"))%>
							</span>
						</div>


						<div class="detail-row">
							<span class="detail-label">Duration:</span> <span
								class="detail-value"><%=item.durationMinutes%> minutes</span>
						</div>

						<div class="detail-row">
							<span class="detail-label">Caretaker:</span> <span
								class="detail-value"><%=(item.caretakerName != null && !item.caretakerName.isEmpty() ? item.caretakerName : "Assigned")%></span>
						</div>

						<!-- Special Notes (if present) -->
						<%
						if (item.notes != null && !item.notes.isEmpty()) {
						%>
						<div class="detail-row full-width">
							<span class="detail-label">Special Notes:</span> <span
								class="detail-value notes"><%=item.notes%></span>
						</div>
						<%
						}
						%>
					</div>

					<!-- Price -->
					<div class="booking-price-row">
						<span class="price-label">Price:</span> <span class="price-value">$<%=item.price%></span>
					</div>
				</div>
				<%
				itemNumber++;
				}
				%>
			</div>

			<!-- Order Total Section -->
			<div class="order-total-section">
				<div class="total-row">
					<span class="total-label">Subtotal:</span> <span
						class="total-value">$<%=total.toString()%></span>
				</div>
				<div class="total-row highlight">
					<span class="total-label-main">Total Amount:</span> <span
						class="total-value-main">$<%=total.toString()%></span>
				</div>
			</div>

			<!-- Action Buttons -->
			<div class="checkout-actions">
				<a class="btn-back" href="<%=request.getContextPath()%>/cart">←
					Back to Cart</a>
				<form
					action="<%=request.getContextPath()%>/stripe/create-checkout-session"
					method="post" class="payment-form">
					<input type="hidden" name="amount" value="<%=total.toString()%>">
					<button type="submit" class="btn-pay">Proceed to Payment</button>
				</form>
			</div>
		</div>
	</main>

	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>
