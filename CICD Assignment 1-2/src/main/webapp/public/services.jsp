
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%@ include file="assets/scripts/dbConnection.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Our Services | Silver Cares</title>

<link rel="stylesheet" href="assets/general.css">
<link rel="stylesheet" href="assets/services.css">
</head>

<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<main>

		<!-- Hero Section -->
		<section class="hero-section">
			<div class="hero-content">
				<h1>Our Services</h1>
				<p>Discover our comprehensive range of care services designed to
					enhance the well-being and independence of our seniors. Choose a
					category to explore what we offer.</p>
			</div>
		</section>

		<div class="category-container">

			<%
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				String sqlCommand = "SELECT cat_id, cat_name, cat_description, cat_logo FROM service_category ORDER BY cat_id";
				pstmt = conn.prepareStatement(sqlCommand);
				rs = pstmt.executeQuery();

				while (rs.next()) {
			%>

			<div class="category-card">
				<div class="icon-container">
					<img src="assets/images/<%=rs.getString("cat_logo")%>"
						alt="<%=rs.getString("cat_name")%> Logo">
				</div>

				<h3><%=rs.getString("cat_name")%></h3>
				<p><%=rs.getString("cat_description")%></p>

				<a class="view-btn"
					href="serviceList.jsp?cat_id=<%=rs.getInt("cat_id")%>">View
					Services</a>
			</div>


			<%
			} // end while
			} catch (Exception e) {
			out.println("<p style='color:red; text-align:center;'>Error loading categories: " + e + "</p>");
			} finally {
			if (rs != null)
			rs.close();
			if (pstmt != null)
			pstmt.close();
			if (conn != null)
			conn.close();
			}
			%>

		</div>
	</main>

	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>