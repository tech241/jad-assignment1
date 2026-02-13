<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalTime"%>

<%
Object uidObj = session.getAttribute("id");
if (uidObj == null) {
	response.sendRedirect("login.jsp?errMsg=Please log in first.");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Account</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/account.css">
</head>

<body>
	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	<%@ include file="assets/scripts/restrictToLoggedIn.jsp"%>

	<%
	int hour = LocalTime.now().getHour();
	String greeting = (hour < 12) ? "Morning" : (hour < 18) ? "Afternoon" : "Evening";

	String sessName = (String) session.getAttribute("name");
	String sessEmail = (String) session.getAttribute("email");
	%>

	<main>
		<div class="container">

			<h1>Good <%=greeting%>!</h1>

			<div class="profile">
				<div class="card">

					<%
					String profileImage = (String) session.getAttribute("profile_image");
					boolean hasProfileImage = profileImage != null && !profileImage.trim().isEmpty();
					%>

					<% if (!hasProfileImage) { %>
						<i class="bx bx-user-circle" id="account-icon"></i>
					<% } else {
						String imgSrc = profileImage.startsWith("http")
							? profileImage
							: request.getContextPath() + "/public/" + profileImage;
					%>
						<img class="profile-pic" src="<%= imgSrc %>" alt="Profile Picture">
					<% } %>

					<div class="info">
						<h2><%= sessName == null ? "-" : sessName %></h2>
						<span><%= sessEmail == null ? "-" : sessEmail %></span>

						<p><strong>Phone:</strong>
							<%= session.getAttribute("phone") == null ? "-" : session.getAttribute("phone") %>
						</p>

						<p><strong>Residential Area Code:</strong>
							<%= session.getAttribute("residential_area_code") == null ? "-" : session.getAttribute("residential_area_code") %>
						</p>

						<p><strong>Care Needs:</strong>
							<%
							String[] needs = (String[]) session.getAttribute("care_needs");
							if (needs != null && needs.length > 0) out.print(String.join(", ", needs));
							else out.print("-");
							%>
						</p>
					</div>
				</div>

				<div class="buttons">
					<button onclick="location.href='editDetails.jsp'">Edit Details</button>
					<button onclick="location.href='changePassword.jsp'">Change Password</button>
				</div>
			</div>

			<div class="section-divider"></div>

			<h2>Upcoming Bookings</h2>

			<div class="section-divider"></div>

			<h1>Enjoying our website?</h1>
			<button id="feedback" onclick="location.href='feedback.jsp'">Feedback</button>
			<br><span>Your feedback is greatly appreciated.</span>

			<div class="section-divider"></div>

			<h1>Danger Zone</h1>
			<button id="delete-account" onclick="location.href='deleteAccount.jsp'">Delete Account</button>
			<br><span>This action is permanent and cannot be undone.</span>

		</div>
	</main>

	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>
