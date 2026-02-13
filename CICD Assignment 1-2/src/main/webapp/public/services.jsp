<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="models.serviceCategory"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Our Services | Silver Care</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/general.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/services.css">
</head>

<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file= "assets/scripts/loadScripts.jsp"%>

	<%
	List<serviceCategory> categories = (List<serviceCategory>) request.getAttribute("categories");
	%>

	<!-- HERO -->
	<section class="hero-section">
		<div class="hero-content">
			<h1>Our Services</h1>
			<p>Select a category to explore services and packages.</p>
		</div>
	</section>

	<!-- CATEGORY GRID -->
	<div class="category-container">
		<%
		if (categories != null && !categories.isEmpty()) {
			for (serviceCategory c : categories) {
				String logo = c.getLogo();
				if (logo == null || logo.trim().isEmpty()) {
					logo = "images/default_image.png";
				}
				if (!logo.startsWith("images/")) {
					logo = "images/" + logo;
				}
		%>
		<a class="category-card"
			href="<%=request.getContextPath()%>/services/category?cat_id=<%=c.getId()%>">
			<div class="category-icon">
				<img src="<%=request.getContextPath()%>/public/assets/<%=logo%>"
					alt="<%=c.getName()%>"
					onerror="this.src='<%=request.getContextPath()%>/public/assets/images/default_image.png'">
			</div>
			<h3><%=c.getName()%></h3>
			<p><%=c.getDescription()%></p>
			<span class="category-btn">View services</span>
		</a>
		<%
		}
		} else {
		%>
		<p>No service categories found.</p>
		<%
		}
		%>
	</div>

	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>
