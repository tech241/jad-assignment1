<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="models.BookingItem"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" name="viewport"
	content="width=device-width, initial-scale=1">
<title>Insert title here</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/general.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/bookingSummary.css">
</head>
<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	<%
	if (!isLoggedIn) {
		response.sendRedirect(request.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
		return;
	}

	// ArrayList is used to temporarily store the user's selected bookings in their session before finalizing and saving into db
	// ArrayList is used since it is dynamic, easy to iterate and allows editing or removing items by index

	ArrayList<BookingItem> cart = (ArrayList<BookingItem>) request.getAttribute("cart");

	if (cart == null || cart.size() == 0) {
	%>
	<h2 style="text-align: center; margin-top: 40px;">You have no
		bookings yet.</h2>
	<%
	return;
	}
	%>
	<%
	String msg = request.getParameter("msg");
	String errMsg = request.getParameter("errMsg");

	if (msg != null) {
	%>
	<p style="color: green; text-align: center;"><%=msg%></p>
	<%
	}
	if (errMsg != null) {
	%>
	<p style="color: red; text-align: center;"><%=errMsg%></p>
	<%
	}
	%>

	<main>
		<div class="container">
			<h1>Your Bookings</h1>


			<div class="booking-summary-container">
				<%
				for (int i = 0; i < cart.size(); i++) {
					BookingItem item = cart.get(i);
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
						<%=(item.notes == null || item.notes.isEmpty() ? "None" : item.notes)%>
					</p>
					<p>
      <strong>Assigned Caretaker:</strong>
      <%=(item.caretakerName != null && !item.caretakerName.isEmpty() ? item.caretakerName : "Not assigned")%>
  </p>
					<p>
						<strong>Price:</strong> $<%=item.price%></p>


					<div class="actions">
						<a href="<%=request.getContextPath()%>/cart/edit?index=<%=i%>"
							class="btn-edit">Edit</a> <a
							href="<%=request.getContextPath()%>/cart/remove?index=<%=i%>"
							class="btn-delete">Delete</a>

					</div>

				</div>
				<%
				}
				%>

				<!-- ONE checkout button for whole cart -->
				<div style="text-align: center; margin: 30px 0;">
					<a href="<%=request.getContextPath()%>/checkout" class="btn-primary adjacent">Proceed to Payment</a>
						<a href="<%=request.getContextPath()%>/services" class="btn-secondary">+ Add More Services</a>

				</div>
				<!-- booking-summary-container -->
			</div>
			<!-- container -->
	</main>

	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>