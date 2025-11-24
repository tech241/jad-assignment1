<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%
	Connection conn = null;
	Statement stmtCat = null;
	ResultSet rsCat = null;

	try {
		Class.forName("org.postgresql.Driver");
		conn = DriverManager.getConnection(
		"jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require",
		"neondb_owner", "npg_iCobAxPw5z4X");

		stmtCat = conn.createStatement();
		rsCat = stmtCat.executeQuery("SELECT * FROM service_category ORDER BY cat_id");

	} catch (Exception e) {
		out.println("Error in header DB: " + e);
	}
	%>
	
	<% if (isLoggedIn) { %>
	<input type="checkbox" id="toggle-account-dropdown">
	<% } %>

	<!-- HEADER -->
	<div class="header">

		<!-- LOGO -->
		<div class="logo">
			<a href="homepage.jsp"> <img
				src="assets/images/placeholderlogo.png" id="logo"> <img
				src="assets/images/placeholderlogosmall.png" id="logo-small">
			</a>
		</div>

		<!-- MENU -->
		<div class="menu">

			<ul class="menu-options">

				<li><a href="homepage.jsp"><i class='bx bx-home'></i> Home</a></li>

				<!-- SERVICES DROPDOWN -->
				<li class="dropdown mega-dropdown"><a href="#"><i
						class='bx bx-handshake'></i> Services</a>

					<div class="mega-menu">

						<%
						while (rsCat != null && rsCat.next()) {

							int catId = rsCat.getInt("cat_id");
							String catName = rsCat.getString("cat_name");
							String catLogo = rsCat.getString("cat_logo");

							// Query services for the specific category
							String sqlSvc = "SELECT service_id, service_name FROM service WHERE cat_id=" + catId;
							Statement stmtSvc = conn.createStatement();
							ResultSet rsSvc = stmtSvc.executeQuery(sqlSvc);
						%>

						<div class="mega-column">
							<h4>
								<img src="assets/images/<%=catLogo%>" class="cat-icon">
								<%=catName%>
							</h4>

							<%
							while (rsSvc.next()) {
							%>

							<a href="services.jsp?service_id=<%=rsSvc.getInt("service_id")%>">
								<%=rsSvc.getString("service_name")%>
							</a>

							<%
							}
							%>
						</div>

						<%
						rsSvc.close();
						stmtSvc.close();
						} // end category loop
						%>

					</div></li>
					
				<!-- ADMIN SECTION -->
				<%
				if (isAdmin) {
				%>

				<li><a href="adminIndex.jsp"><i class='bx bx-cog'></i> Admin</a></li>

				<%
				}
				%>

				<!-- ACCOUNT SECTION -->
				<%
				if (isLoggedIn) {
				%>

				<li id="account-dropdown">
					<label for="toggle-account-dropdown" id="account-dropdown-button">
						<i class="bx bx-user"></i> <span><%= name %></span> <i
						class="bx bx-caret-down" id="open-dropdown"></i> <i
						class="bx bx-caret-up" id="close-dropdown"></i>
					</label>

					<ul id="account-dropdown-menu">
						<li><a href="account.jsp">View Account</a></li>
						<li><a href="assets/scripts/logout.jsp">Log Out</a></li>
					</ul>
				</li>

				<%
				} else {
				%>

				<li><a href="login.jsp">Log In</a></li>
				<li><a href="signup.jsp">Sign Up</a></li>

				<%
				}
				%>

			</ul>
		</div>
	</div>

	<%
	try {
		if (rsCat != null)
			rsCat.close();
		if (stmtCat != null)
			stmtCat.close();
		if (conn != null)
			conn.close();
	} catch (Exception e) {
		out.println("Error closing DB: " + e);
	}
	%>
</body>
</html>