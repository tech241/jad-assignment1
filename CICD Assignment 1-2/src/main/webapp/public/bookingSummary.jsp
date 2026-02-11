<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="models.BookingItem"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
<link rel="stylesheet" href="assets/general.css">
<link rel="stylesheet" href="assets/bookingSummary.css">
<script src="https://js.stripe.com/v3/"></script>
</head>
<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	<%
	if (!isLoggedIn) {
		response.sendRedirect("login.jsp?errMsg=Please log in first.");
		return;
	}

	ArrayList<BookingItem> cart = (ArrayList<BookingItem>) session.getAttribute("cart");
	
	double totalPrice = 0;

	if (cart == null || cart.size() == 0) {
	%>
	<h2 style="text-align: center; margin-top: 40px;">You have no
		bookings yet.</h2>
	<%
	return;
	}
	%>

	<main>
	<div class="container">
		<h1>Your Bookings</h1>

		<div class="booking-summary-container">
			<%
			for (BookingItem item : cart) {
				totalPrice += Double.parseDouble(item.price);
			%>
			<div class="booking-card">
				<details>
				<summary><h2><%=item.serviceName%></h2></summary>

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

				<div class="actions">
					<a href="editBooking.jsp?index=<%=cart.indexOf(item)%>"
						class="btn-edit">Edit</a> <a
						href="deleteBooking.jsp?index=<%=cart.indexOf(item)%>"
						class="btn-delete">Delete</a>
				</div>
				</details>
			</div>

			<%
			}
			%>
		</div>
		
		<div class="card-form-div">
			<form id="card-form">
				<label><h2>Card details</h2>
					<div id="card-element"></div>
				</label>
				<p>Total price: $<%= String.format("%.2f", totalPrice) %></p>
				<button type="submit" class="btn-finalize">Finalize & Save Booking</button>
				<span id="error-message"></span>
			</form>
		</div>
	</div>
	</main>
	<%@ include file="assets/components/footer.jsp"%>
	
	<script>
		// inject card detail form
		let stripe = Stripe('pk_test_51SsFlX5hCaA0zVO6wMopFH9IyOzAP0WFNdpRbJwJFNSqHrJ1tInzoYAr7LGLIcDnIbbsEXLvK5cNCXLnmlKI6ZW700TmofHhiM');
		let elements = stripe.elements()
		let card = elements.create('card')
		card.mount('#card-element');
		
		document.getElementById('card-form').addEventListener('submit', async (e) => {
			e.preventDefault();
			
			let intentResult = await fetch('http://localhost:8081/payment', {
				method: 'POST',
				headers: {'Content-Type': 'application/json'},
				body: JSON.stringify({amount: <%= totalPrice * 100 %>, currency: 'sgd'})
			});
			let result = await intentResult.json();
			
			let paymentResult = await stripe.confirmCardPayment(result.clientSecret, {
				payment_method: {
					card: card
				}
			});
			
			if (paymentResult.error) {
				document.getElementById('error-message').textContent = 'An error occured: ' + paymentResult.error.message;
			} else if (paymentResult.paymentIntent.status == 'succeeded') {
				location.href = 'finalizeBooking.jsp';
			} else {
				document.getElementById('error-message').textContent = 'Payment status: ' + paymentResult.paymentIntent.status;
			}
		});
	</script>
</body>
</html>