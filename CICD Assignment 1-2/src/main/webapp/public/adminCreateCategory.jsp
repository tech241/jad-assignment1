<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Category</title>
<link rel="stylesheet" href="assets/adminoptions.css">
</head>
<body>
	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	<%@ include file="assets/scripts/restrictToAdmin.jsp"%>

	<main>
		<div class="center">
			<div class="container">
				<h1>Create Category</h1>

				<%
				String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
				%>
				<span id="errMsg"><%=errMsg%></span>
				<%
				}
				%>

				<form action="../createCategory" method="post">

					<label for="catName">Category Name</label><br> <input
						type="text" name="catName" placeholder="Enter category name"
						id="catName" required><br> <label
						for="catDescription">Description</label><br>
					<textarea id="catDescription" name="catDescription"
						placeholder="Enter description here" required></textarea>
					<br> <label for="catLogo">Logo Path</label><br> <input
						type="text" id="catLogo" name="catLogo"
						placeholder="e.g. images/home_care.png"
						value="images/default_category.png" required><br>

					<button type="submit">Create Category</button>
				</form>

			</div>
		</div>
	</main>

	<%@ include file="assets/components/adminsidebar.jsp"%>
	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>