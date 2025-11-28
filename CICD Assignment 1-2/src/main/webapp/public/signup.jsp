<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link rel="stylesheet" href="assets/loginsignup.css">
</head>
<body>

	<!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp"%>

	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<!-- for not logged in users only -->
	<%@ include file="assets/scripts/restrictToNotLoggedIn.jsp"%>



	<main>

		<div class="position-relative">
			<div class="position-absolute signup">

				<h1>Sign Up</h1>

				<%
				String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
				%>
				<span id="errMsg"><%=errMsg%></span>
				<%
				}
				%>

				<%
				String msg = request.getParameter("msg");
				if (msg != null) {
				%>
				<span><%=msg%></span>
				<%
				}
				%>

				<form action="../signup" method="post">

					<label for="name">Name</label> <br> <input type="text"
						placeholder="Enter name" name="name" id="name" required> <br>

					<label for="email">Email</label> <br> <input type="email"
						placeholder="name@example.com" name="email" id="email" required>
					<br> <label for="password">Password</label> <br> <input
						type="password" placeholder="Enter password" name="password"
						id="password" required> <br> <label
						for="confirm-password">Confirm Password</label> <br> <input
						type="password" placeholder="Enter password again"
						name="confirm-password" id="confirm-password" required> <br>

					<div id="button-group">
						<button type="submit">Sign Up</button>
						<button type="reset" class="secondary-button">Reset</button>
					</div>

				</form>

				<span>Already have an account? <a href="login.jsp">Log In</a></span>

			</div>

			<span id="credit">Photo by <a
				href="https://unsplash.com/@knurpselknie?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"
				target="_blank">Georg Arthur Pflueger</a> on <a
				href="https://unsplash.com/photos/woman-in-brown-button-up-shirt-holding-white-smartphone-TeWwYARfcM4?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText"
				target="_blank">Unsplash</a></span>
		</div>

	</main>

	<!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>