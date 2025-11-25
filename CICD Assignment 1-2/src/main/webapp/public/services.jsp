<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%@ include file="assets/scripts/checkLoggedIn.jsp"%>
<%@ include file="assets/scripts/dbConnection.jsp"%>
<!-- header.jsp goes here -->
<%@ include file="assets/components/header.jsp"%>

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

	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<div class="services-container">

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
			<img src="assets/images/<%=rs.getString("cat_logo")%>"
				alt="<%=rs.getString("cat_name")%> Logo">
			<h3><%=rs.getString("cat_name")%></h3>
			<p><%=rs.getString("cat_description")%></p>

			<a class="view-btn"
				href="serviceList.jsp?cat_id=<%=rs.getInt("cat_id")%>"> View
				Services </a>
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
	<!-- end services-container -->

	<!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>