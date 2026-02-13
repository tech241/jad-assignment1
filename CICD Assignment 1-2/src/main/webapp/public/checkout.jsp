<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="models.BookingItem"%>
<%@ page import="java.time.LocalTime"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="models.Promotion"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Checkout | Silver Care</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/general.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/checkout.css">
</head>
<body>

<%@ include file="assets/components/header.jsp"%>
<%@ include file="assets/scripts/loadScripts.jsp"%>

<%
String msg = request.getParameter("msg");
String errMsg = request.getParameter("errMsg");
String promoError = (String) request.getAttribute("promoError");

if (msg != null && !msg.isEmpty()) { %>
  <div class="alert success"><%= msg %></div>
<% }
if (errMsg != null && !errMsg.isEmpty()) { %>
  <div class="alert error"><%= errMsg %></div>
<% }
if (promoError != null && !promoError.isEmpty()) { %>
  <div class="alert error"><%= promoError %></div>
<% } %>

<%
ArrayList<BookingItem> cart = (ArrayList<BookingItem>) request.getAttribute("cart");
BigDecimal subtotal = (BigDecimal) request.getAttribute("subtotal");
BigDecimal gst = (BigDecimal) request.getAttribute("gst");
BigDecimal totalWithGst = (BigDecimal) request.getAttribute("totalWithGst");
BigDecimal discount = (BigDecimal) request.getAttribute("discount");
BigDecimal finalTotal = (BigDecimal) request.getAttribute("finalTotal");

Promotion appliedPromo = (Promotion) request.getAttribute("appliedPromo");
List<Promotion> promos = (List<Promotion>) request.getAttribute("promos");

if (cart == null || cart.isEmpty() || subtotal == null) {
  response.sendRedirect(request.getContextPath() + "/cart?errMsg=Your cart is empty.");
  return;
}
%>

<main class="checkout-wrapper">
  <div class="checkout-container">
    <h1>Order Review</h1>
    <p class="checkout-subtitle">Please review your booking details before payment</p>

    <div class="order-summary-section">
      <h2 class="section-title">Your Bookings</h2>

      <%
      int itemNumber = 1;
      for (BookingItem item : cart) {
        LocalTime startTime = LocalTime.parse(item.time);
        LocalTime endTime = startTime.plusMinutes(item.durationMinutes);
      %>

      <div class="booking-detail-card">
        <div class="booking-header">
          <span class="item-number">Service <%=itemNumber%></span>
          <span class="service-name"><%=item.serviceName%></span>
        </div>

        <div class="booking-details-grid">
          <div class="detail-row">
            <span class="detail-label">Package:</span>
            <span class="detail-value"><%=item.packageName%></span>
          </div>

          <div class="detail-row">
            <span class="detail-label">Date:</span>
            <span class="detail-value"><%=item.date%></span>
          </div>

          <div class="detail-row">
            <span class="detail-label">Time:</span>
            <span class="detail-value">
              <%=startTime.format(DateTimeFormatter.ofPattern("hh:mm a"))%>
              - <%=endTime.format(DateTimeFormatter.ofPattern("hh:mm a"))%>
            </span>
          </div>

          <div class="detail-row">
            <span class="detail-label">Duration:</span>
            <span class="detail-value"><%=item.durationMinutes%> minutes</span>
          </div>

          <div class="detail-row">
            <span class="detail-label">Caretaker:</span>
            <span class="detail-value"><%=(item.caretakerName != null && !item.caretakerName.isEmpty() ? item.caretakerName : "Assigned")%></span>
          </div>

          <% if (item.notes != null && !item.notes.isEmpty()) { %>
          <div class="detail-row full-width">
            <span class="detail-label">Special Notes:</span>
            <span class="detail-value notes"><%=item.notes%></span>
          </div>
          <% } %>
        </div>

        <div class="booking-price-row">
          <span class="price-label">Price:</span>
          <span class="price-value">$<%=item.price%></span>
        </div>
      </div>

      <%
        itemNumber++;
      }
      %>
    </div>

    <div class="order-total-section">
      <div class="total-row">
        <span class="total-label">Subtotal (excl. GST):</span>
        <span class="total-value">$<%= subtotal %></span>
      </div>

      <div class="total-row">
        <span class="total-label">GST (9%):</span>
        <span class="total-value">$<%= gst %></span>
      </div>

      <div class="total-row">
        <span class="total-label">Total (incl. GST):</span>
        <span class="total-value">$<%= totalWithGst %></span>
      </div>

      <div class="total-row">
        <span class="total-label">Discount:</span>
        <span class="total-value">-$<%= discount %></span>
      </div>

      <div class="total-row highlight">
        <span class="total-label-main">Final Total:</span>
        <span class="total-value-main">$<%= finalTotal %></span>
      </div>
    </div>

    <div class="promo-section">
      <h2 class="section-title">Promotions</h2>

      <div class="promo-apply">
        <form method="post" action="<%=request.getContextPath()%>/checkout/apply-promo" class="promo-form">
        <p class="promo-hint">Only one promo code can be applied per checkout.</p>
          <input type="text" name="promo_code" placeholder="Enter promo code" maxlength="50" />
          <button type="submit" class="btn-secondary">Apply</button>
        </form>

        <% if (appliedPromo != null && appliedPromo.getCode() != null) { %>
          <div class="promo-applied">
            Applied: <strong><%= appliedPromo.getCode() %></strong>
            <form method="post" action="<%=request.getContextPath()%>/checkout/remove-promo" style="display:inline;">
              <button type="submit" class="link-btn">Remove</button>
            </form>
          </div>
        <% } %>
      </div>

      <% if (promos != null && !promos.isEmpty()) { %>
        <div class="promo-list">
          <% for (Promotion p : promos) { %>
            <div class="promo-card">
              <div class="promo-title"><%= p.getTitle() %></div>
              <% if (p.getThemeTag() != null && !p.getThemeTag().isEmpty()) { %>
                <div class="promo-tag"><%= p.getThemeTag() %></div>
              <% } %>
              <% if (p.getDescription() != null && !p.getDescription().isEmpty()) { %>
                <div class="promo-desc"><%= p.getDescription() %></div>
              <% } %>
              <% if (p.getCode() != null && !p.getCode().isEmpty()) { %>
                <div class="promo-code">Code: <strong><%= p.getCode() %></strong></div>
              <% } %>
            </div>
          <% } %>
        </div>
      <% } %>
    </div>

    <div class="checkout-actions">
      <a class="btn-back" href="<%=request.getContextPath()%>/cart">← Back to Cart</a>

      <form action="<%=request.getContextPath()%>/stripe/create-checkout-session" method="post" class="payment-form">
        <input type="hidden" name="amount" value="<%= finalTotal.toString() %>">
        <button type="submit" class="btn-pay">Proceed to Payment</button>
      </form>
    </div>

  </div>
</main>

<%@ include file="assets/components/footer.jsp"%>
</body>
</html>
