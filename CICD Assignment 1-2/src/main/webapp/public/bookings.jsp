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
	// --- read inputs once ---
	servicePackage pkg = (servicePackage) request.getAttribute("pkg");
	Integer serviceId = (Integer) request.getAttribute("serviceId");
	List<CaretakerOption> caretakers = (List<CaretakerOption>) request.getAttribute("caretakers");

	List<String> availableTimes = (List<String>) request.getAttribute("availableTimes");
	String selectedDate = (String) request.getAttribute("selectedDate");

	String errMsg = request.getParameter("errMsg");

	boolean hasSlots = (availableTimes != null && !availableTimes.isEmpty());
	%>

	<%
	if (errMsg != null) {
	%>
	<div
		style="background-color: #fee2e2; border: 1px solid #fecaca; border-radius: 10px; padding: 12px 16px; margin-bottom: 20px; color: #991b1b; text-align: center;">
		<%=errMsg%>
	</div>
	<%
	}
	%>

	<main class="booking-wrapper">
		<%
		if (pkg == null || serviceId == null) {
		%>
		<p style="color: red; text-align: center;">Invalid package
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
					<strong>Service:</strong> <span><%=pkg.getServiceName()%></span>
				</p>
				<p>
					<strong>Package:</strong> <span><%=pkg.getPackageName()%></span>
				</p>
				<p>
					<strong>Description:</strong> <span><%=pkg.getPackageDescription()%></span>
				</p>
				<p>
					<strong>Price:</strong> <span>$<%=String.format("%.2f", pkg.getPrice())%></span>
				</p>
				<p>
					<strong>Duration:</strong> <span><%=pkg.getDurationMinutes()%>
						minutes</span>
				</p>
				<p>
					<strong>Tier:</strong> <span><%=pkg.getTier()%></span>
				</p>
			</section>

			<!-- Right: Booking Form -->
			<section class="booking-form-section">
				<h2>Confirm Your Booking</h2>

				<form action="<%=request.getContextPath()%>/cart/add" method="POST"
					class="booking-form">

					<input type="hidden" name="package_id"
						value="<%=pkg.getPackageId()%>"> <input type="hidden"
						name="service_id" value="<%=serviceId%>"> <label
						for="bookingDate">Date</label>
					<div class="date-row">
						<input type="date" name="date" id="bookingDate" required
							min="<%=java.time.LocalDate.now()%>"
							value="<%=selectedDate != null ? selectedDate : ""%>">

						<button type="button" id="checkAvailabilityBtn" class="check-btn"
							onclick="checkAvailability()">Check Availability</button>
					</div>

					<div id="dateError" style="display: none;"></div>


					<%
					// Optional helper message for same-day bookings
					boolean isSameDay = false;
					if (selectedDate != null) {
						try {
							java.time.LocalDate sd = java.time.LocalDate.parse(selectedDate);
							isSameDay = sd.equals(java.time.LocalDate.now());
						} catch (Exception ignore) {
						}
					}
					%>

					<%
					if (isSameDay) {
					%>
					<small style="color: #6b7280; display: block; margin-top: 6px;">
						For today's bookings, only future time slots are shown. </small>
					<%
					}
					%>

					<label style="display: block; margin-top: 16px;">Available Start Time</label>

<%
if (availableTimes == null) {
%>
  <div id="availabilityNotice"
       style="background-color: #eff6ff; border: 1px solid #bfdbfe; border-radius: 10px; padding: 16px; margin-top: 8px; color: #1e40af; font-size: 0.95rem;">
    Select a date and click <b>Check Availability</b> to see available time slots.
  </div>

<%
} else if (availableTimes.isEmpty()) {
%>
  <div id="slotError"
       style="background-color: #fee2e2; border: 1px solid #fecaca; border-radius: 10px; padding: 16px; margin-top: 8px; color: #991b1b; font-size: 0.95rem;">
    <strong>No available slots for this date.</strong> Please choose another date.
  </div>

<%
} else {
%>
  <div class="time-slots-wrapper">
    <%
      String currentPeriod = "";

      for (String t : availableTimes) {
        java.time.LocalTime time = java.time.LocalTime.parse(t);
        String period = time.getHour() < 12 ? "morning" : "afternoon";

        if (!period.equals(currentPeriod)) {
          if (!currentPeriod.isEmpty()) {
    %>
            </div>
    <%
          }
          currentPeriod = period;
    %>
          <span class="time-period-label"><%= period.equals("morning") ? "Morning" : "Afternoon" %></span>
          <div class="time-slots-grid">
    <%
        }

        String displayTime = time.format(java.time.format.DateTimeFormatter.ofPattern("h:mm a"));
        String[] parts = displayTime.split(" ");
        String timeOnly = parts[0];
        String ampm = parts.length > 1 ? parts[1] : "";
    %>

        <label class="time-slot-label">
          <input type="radio" name="time" value="<%=t%>" required>
          <div class="time-slot-button">
            <span class="time-display"><%=timeOnly%></span>
            <span class="am-pm"><%=ampm%></span>
          </div>
        </label>

    <%
      } // end for

      if (!currentPeriod.isEmpty()) {
    %>
        </div>
    <%
      }
    %>
  </div>
<%
} 
%>


		<small style="color: #6b7280; display: block; margin-top: 6px;">Operating
			hours: 9:00 AM - 6:00 PM</small> <label>Preferred Caretaker
			(Optional)</label> <select name="caretaker_id" class="booking-select">
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
			<%=(!hasSlots ? "disabled" : "")%>>Add to Cart</button>

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
  const dateEl = document.getElementById("bookingDate");
  const date = dateEl ? dateEl.value : "";

  if (!date) {
    alert("Please select a date first.");
    return;
  }

  const serviceId = "<%= serviceId %>";
  const packageId = "<%= pkg.getPackageId() %>";
  const base = "<%= request.getContextPath() %>";

			window.location.href = base + "/availability" + "?service_id="
					+ encodeURIComponent(serviceId) + "&package_id="
					+ encodeURIComponent(packageId) + "&date="
					+ encodeURIComponent(date);
		}
	</script>


	<script>
		// Date validation 
		(function() {
			const bookingDate = document.getElementById("bookingDate");
			const dateError = document.getElementById("dateError"); 
			const checkBtn = document.getElementById("checkAvailabilityBtn"); // button id

			if (!bookingDate)
				return;

			bookingDate
					.addEventListener(
							"change",
							function() {
								const selectedDate = new Date(this.value);
								const today = new Date();
								today.setHours(0, 0, 0, 0);

								const isPast = selectedDate < today;

								if (isPast) {
									this.classList.add("input-error");
									if (dateError) {
										dateError.style.display = "block";
										dateError.textContent = "Please select today or a future date.";
									}
									if (checkBtn)
										checkBtn.disabled = true;
								} else {
									this.classList.remove("input-error");
									if (dateError)
										dateError.style.display = "none";
									if (checkBtn)
										checkBtn.disabled = false;
								}
							});
		})();
	</script>

</body>
</html>
