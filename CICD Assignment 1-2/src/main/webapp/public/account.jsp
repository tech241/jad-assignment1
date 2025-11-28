<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!-- import java.util.LocalDate -->
<%@ page import="java.time.LocalTime"%>


<%
Object uidObj = session.getAttribute("id");
if (uidObj == null) {
	response.sendRedirect("login.jsp?errMsg=Please log in first.");
	return;
}
int userId = (Integer) uidObj;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link rel="stylesheet" href="assets/account.css">
</head>
<body>

	<!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp"%>
	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	<%@ include file="assets/scripts/restrictToLoggedIn.jsp"%>



	<%
	// this page should only be accessible if the user is logged in
	// the code should be reuseable so put it as a java/jsp file???
	%>

	<%
	int hour = LocalTime.now().getHour();
	String greeting = (hour < 12) ? "Morning" : (hour < 18) ? "Afternoon" : "Evening";
	%>

	<%@ include file="assets/scripts/restrictToLoggedIn.jsp"%>

	<main>
		<div class="container">

			<h1>
				Good
				<%=greeting%>!
			</h1>

			<!-- PROFILE -->
			<div class="profile">
				<div class="card">
					<i class="bx bx-user-circle" id="account-icon"></i>

					<div class="info">
						<h2><%=name%></h2>
						<span><%=email%></span>
					</div>
				</div>

				<div class="buttons">
					<button onclick="location.href='editDetails.jsp'">Edit
						Details</button>
					<button onclick="location.href='changePassword.jsp'">Change
						Password</button>
				</div>
			</div>

			<div class="section-divider"></div>


			<h2>Upcoming Bookings</h2>

			<div class="section-divider"></div>

			<h1>Enjoying our website?</h1>
			<button id="feedback" onclick="location.href='feedback.jsp'">Feedback</button>
			<br> <span>Your feedback is greatly appreciated.</span>

			<div class="section-divider"></div>

			<h1>Danger Zone</h1>
			<button id="delete-account"
				onclick="location.href='deleteAccount.jsp'">Delete Account
			</button>
			<br> <span>This action is permanent and cannot be undone.</span>

		</div>
	</main>

	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>