<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="models.servicePackage"%>
<%@ page import="models.CaretakerOption"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Booking | Silver Care</title>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/general.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/bookings.css">
</head>

<body>
	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<%
	String errMsg = request.getParameter("errMsg");
	if (errMsg != null) {
	%>
	<p style="color: red; text-align: center; margin-bottom: 20px;"><%=errMsg%></p>
	<%
	}

	servicePackage pkg = (servicePackage) request.getAttribute("pkg");
	Integer serviceId = (Integer) request.getAttribute("serviceId");
	List<CaretakerOption> caretakers = (List<CaretakerOption>) request.getAttribute("caretakers");
	%>
	<%
	List<String> availableTimes = (List<String>) request.getAttribute("availableTimes");
	String selectedDate = (String) request.getAttribute("selectedDate");
	%>


	<main class="booking-wrapper">

		<%
		if (pkg == null || serviceId == null) {
		%>
		<p style='color: red; text-align: center;'>Invalid package
			selected.</p>
		<%
		} else {
		%>

		<!-- Breadcrumb -->
		<nav class="breadcrumb">
			<a href="<%=request.getContextPath()%>/services">Services</a> <span>/</span>
			<a
				href="<%=request.getContextPath()%>/services/details?service_id=<%=serviceId%>">
				<%=pkg.getServiceName()%>
			</a> <span>/</span> Booking
		</nav>

		<h1 class="booking-title">
			Book:
			<%=pkg.getPackageName()%></h1>

		<div class="booking-container">

			<!-- Left: Package Summary -->
			<section class="package-summary">
				<h2>Package Details</h2>
				<p>
					<strong>Service:</strong>
					<%=pkg.getServiceName()%></p>
				<p>
					<strong>Package:</strong>
					<%=pkg.getPackageName()%></p>
				<p>
					<strong>Description:</strong>
					<%=pkg.getPackageDescription()%></p>
				<p>
					<strong>Price:</strong> $<%=String.format("%.2f", pkg.getPrice())%></p>
				<p>
					<strong>Duration:</strong>
					<%=pkg.getDurationMinutes()%>
					minutes
				</p>
				<p>
					<strong>Tier:</strong>
					<%=pkg.getTier()%></p>

			</section>

			<!-- Right: Booking Form -->
			<section class="booking-form-section">
				<h2>Confirm Your Booking</h2>

				<form action="<%=request.getContextPath()%>/cart/add" method="POST"
					class="booking-form">

					<input type="hidden" name="package_id"
						value="<%=pkg.getPackageId()%>"> <input type="hidden"
						name="service_id" value="<%=serviceId%>"> <label>Date</label>
					<input type="date" name="date" id="bookingDate" required
						min="<%=java.time.LocalDate.now()%>"
						value="<%=selectedDate != null ? selectedDate : ""%>">

					<div style="margin: 10px 0;">
						<button type="button" class="confirm-btn"
							onclick="checkAvailability()">Check Availability</button>
					</div>

					<label>Available Start Time</label>
					<%
					if (selectedDate != null) {
						try {
							java.time.LocalDate sd = java.time.LocalDate.parse(selectedDate);
							if (sd.equals(java.time.LocalDate.now())) {
					%>
					<small style="color: #6b7280; display: block; margin-top: 6px;">
						For today’s bookings, only future time slots are shown. </small>
					<%
					}
					} catch (Exception ignore) {
					}
					}
					%>

					<%
					if (availableTimes == null) {
					%>
					<p style="color: #6b7280;">
						Select a date and click <b>Check Availability</b> to see available
						slots.
					</p>
					<%
					} else if (availableTimes.isEmpty()) {
					%>
					<p style="color: red;">No slots available for this date. Please
						choose another date.</p>
					<%
					} else {
					%>
					<div
						style="display: flex; flex-wrap: wrap; gap: 10px; margin-top: 8px;">
						<%
						for (String t : availableTimes) {
						%>
						<label
							style="border: 1px solid #e5e7eb; padding: 8px 10px; border-radius: 8px; cursor: pointer;">
							<input type="radio" name="time" value="<%=t%>" required>
							<%=t%>
						</label>
						<%
						}
						%>
					</div>
					<%
					}
					%>

					<small style="color: #6b7280; display: block; margin-top: 6px;">
						Operating hours: 9:00 AM - 6:00 PM </small> <label>Preferred
						Caretaker (Optional)</label> <select name="caretaker_id"
						class="booking-select">
						<option value="">Select a caretaker...</option>

						<%
						if (caretakers == null || caretakers.isEmpty()) {
						%>
						<option value="">No caretakers available for this service</option>
						<%
						} else {
						for (CaretakerOption c : caretakers) {
						%>
						<option value="<%=c.getCaretakerId()%>">
							<%=c.getName()%> (<%=c.getExperienceYears()%> yrs, ★<%=String.format("%.1f", c.getRating())%>)
						</option>
						<%
						}
						}
						%>
					</select> <label>Additional Notes (Optional)</label>
					<textarea name="notes"
						placeholder="Eg: Prefer female caregiver, mobility concerns, etc."></textarea>

					<button type="submit" class="confirm-btn"
						<%=(availableTimes == null || availableTimes.isEmpty() ? "disabled" : "")%>>Add
						to Cart</button>
				</form>


			</section>

		</div>

		<%
		} // end valid pkg/serviceId
		%>

	</main>

	<%@ include file="assets/components/footer.jsp"%>
<script>
function checkAvailability() {
  const date = document.getElementById("bookingDate").value;

  if (!date) {
    alert("Please select a date first.");
    return;
  }

  const serviceId = "<%= serviceId %>";
  const packageId = "<%= pkg.getPackageId() %>";

  window.location.href =
    "<%= request.getContextPath() %>/availability"
    + "?service_id=" + encodeURIComponent(serviceId)
    + "&package_id=" + encodeURIComponent(packageId)
    + "&date=" + encodeURIComponent(date);
}
</script>

</body>
</html>
