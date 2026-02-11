<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="models.BookingItem"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Checkout | Silver Care</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/general.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/bookingSummary.css">
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

<main class="booking-summary-container">
  <h1>Checkout</h1>

  <div style="max-width: 900px; margin: 0 auto;">
    <h2>Order Summary</h2>

    <% for (BookingItem item : cart) { %>
      <div class="booking-card">
        <h3><%= item.serviceName %></h3>
        <p><strong>Package:</strong> <%= item.packageName %></p>
        <p><strong>Date:</strong> <%= item.date %></p>
        <p><strong>Time:</strong> <%= item.time %></p>
        <p><strong>Price:</strong> $<%= item.price %></p>
      </div>
    <% } %>

    <div style="text-align:right; margin-top: 16px; font-size: 1.2rem;">
      <strong>Total: $<%= total.toString() %></strong>
    </div>

    <!-- the stripe endpoint will be placed here later on -->
    <div style="display:flex; gap: 12px; justify-content:flex-end; margin-top: 20px;">
      <a class="btn-edit" href="<%=request.getContextPath()%>/cart">Back to Cart</a>

      <!-- Placeholder: point this to Spring Boot Stripe create-checkout-session endpoint -->
      <form action="<%=request.getContextPath()%>/stripe/create-checkout-session" method="post">
  <input type="hidden" name="amount" value="<%= total.toString() %>">
  <button type="submit" class="btn-finalize">Pay with Stripe</button>
</form>
    </div>
  </div>
</main>

<%@ include file="assets/components/footer.jsp"%>
</body>
</html>
