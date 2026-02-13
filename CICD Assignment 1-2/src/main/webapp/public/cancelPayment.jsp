<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment Cancelled | Silver Care</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/general.css">
</head>
<body>
  <%@ include file="assets/components/header.jsp"%>
  <%@ include file="assets/scripts/loadScripts.jsp"%>

  <main class="checkout-wrapper">
    <div class="checkout-container">
      <h1>Payment Cancelled</h1>
      <p>Your payment was cancelled. No charges were made.</p>

      <%
        String msg = request.getParameter("msg");
        String errMsg = request.getParameter("errMsg");
        if (msg != null) { %><div class="alert success"><%=msg%></div><% }
        if (errMsg != null) { %><div class="alert error"><%=errMsg%></div><% }
      %>

      <div class="checkout-actions">
        <a class="btn-back" href="<%=request.getContextPath()%>/cart">← Back to Cart</a>
        <a class="btn-pay" href="<%=request.getContextPath()%>/public/services.jsp">Browse Services</a>
      </div>
    </div>
  </main>

  <%@ include file="assets/components/footer.jsp"%>
</body>
</html>
