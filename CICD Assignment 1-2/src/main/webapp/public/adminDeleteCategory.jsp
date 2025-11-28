<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Category</title>
<link rel="stylesheet" href="assets/adminoptions.css">
</head>
<body>
	<!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp"%>

	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<!-- for admins only -->
	<%@ include file="assets/scripts/restrictToAdmin.jsp"%>

	<main>
		<div class="center">
			<div class="container">
				<h1>Delete Category?</h1>
				<p>All services under this category will be affected. This
					process is irreversible.</p>

				<%
				String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
				%>
				<span id="errMsg"><%=errMsg%></span>
				<%
				}
				%>

				<form action="../deleteCategory" method="post">
					<input style="display: none;" name="catId"
						value="<%=request.getParameter("catId")%>">

					<button type="submit" class="dangerous-button">Delete
						Category</button>
				</form>
			</div>
		</div>
	</main>

	<!-- adminsidebar.jsp goes here -->
	<%@ include file="assets/components/adminsidebar.jsp"%>

	<!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>