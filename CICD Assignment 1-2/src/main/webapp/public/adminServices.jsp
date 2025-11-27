<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="assets/scripts/checkLoggedIn.jsp" %>
<%@ include file="assets/scripts/dbConnection.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/admin.css">
</head>
<body>

    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
	
	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>
	
	<!-- for admins only -->
	<%@ include file="assets/scripts/restrictToAdmin.jsp" %>
	
	<%
	Connection conn2 = null;
	Statement stmtCat2 = null;
	ResultSet rsCat2 = null;

	try {
		Class.forName("org.postgresql.Driver");
		conn2 = DriverManager.getConnection(
		"jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require",
		"neondb_owner", "npg_iCobAxPw5z4X");

		stmtCat2 = conn2.createStatement();
		rsCat2 = stmtCat2.executeQuery("SELECT * FROM service_category ORDER BY cat_id;");

	} catch (Exception e) {
		out.println("Error in header DB: " + e);
	}
	%>

    <main>
    
    <div class="container">
    	<h1>Manage Services</h1>
    	
    	<div class="search-by">
    		<span class="search-text">Search by:</span>
    	
    		<form>
    			<label for="name">Name</label>
        		<input type="text" placeholder="Enter name" name="name" id="name" value="<%= request.getParameter("name") == null ? "" : request.getParameter("name") %>">
        		
        		<label for="category">Category</label>
        		<select name="category" id="category">
        		
        			<option value="0">All categories</option>
        		
        			<%
        			while (rsCat2 != null && rsCat2.next()) {
        			%>
        			
        			<option value="<%= rsCat2.getString("cat_id") %>" <%= rsCat2.getString("cat_id").equals(request.getParameter("category")) ? "selected" : "" %>><%= rsCat2.getString("cat_name") %></option>
        			
        			<% } %>
        		
        		</select>
        	
        		<button type="submit">Search</button>
    		</form>
    	</div>
    	
    	<button onclick="location.href = 'adminCreateService.jsp'">Create service</button>
    	
    	<div class="section-divider"></div>
    	
    	<h2>Search results</h2>
    	
    	<div class="search-results" id="search-results">
    	
    		<%
    		Connection conn3 = null;
    		PreparedStatement stmtCat3 = null;
			ResultSet rsCat3 = null;
			
			try {
				Class.forName("org.postgresql.Driver");
				conn3 = DriverManager.getConnection(
				"jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require",
				"neondb_owner", "npg_iCobAxPw5z4X");
				
				String where = "";
				String serName = request.getParameter("name");
				String catId = request.getParameter("category");
				
				boolean serNameNull = serName == null || "".equals(serName);
				boolean catIdNull = catId == null || "0".equals(catId);
				
				if (!serNameNull || !catIdNull) {
					where += " WHERE";
				}
				
				if (!serNameNull) {
					where += " s.service_name LIKE ?";
				}
				
				if (!serNameNull && !catIdNull) {
					where += " AND";
				}
				
				if (!catIdNull) {
					where += " s.cat_id = ?";
				}
		
				stmtCat3 = conn3.prepareStatement("SELECT * FROM service s JOIN service_category c ON s.cat_id = c.cat_id" + where + ";");
				
				if (!serNameNull) {
					stmtCat3.setString(1, "%" + serName + "%");
				}
				
				if (!catIdNull) {
					stmtCat3.setInt(serNameNull ? 1 : 2, Integer.parseInt(catId));
				}
				
				rsCat3 = stmtCat3.executeQuery();
		
			} catch (Exception e) {
				out.println("Error in header DB: " + e);
			}
			
			while (rsCat3 != null && rsCat3.next()) {
			%>
			
			<div class="service-card">
				<img src="assets/<%= rsCat3.getString("image_path") %>"><br>
				<span>
					<strong><%= rsCat3.getString("service_name") %></strong><br>
					<small><%= rsCat3.getString("cat_name") %></small><br>
					<%= rsCat3.getString("service_description") %><br>
					<a href="services.jsp?service_id=<%= rsCat3.getString("service_id") %>">View page</a><br>
					
					<div class="action-buttons">
						<button onclick="location.href = 'adminEditService.jsp?serviceId=<%= rsCat3.getString("service_id") %>'" class="secondary-button">Edit</button>
						<button onclick="location.href = 'adminDeleteService.jsp?serviceId=<%= rsCat3.getString("service_id") %>'" class="dangerous-button">Delete</button>
					</div>
				</span>
			</div>
			
			<% } %>
    		
    	</div>
    </div>
        
    </main>
    
    <!-- adminsidebar.jsp goes here -->
	<%@ include file="assets/components/adminsidebar.jsp" %>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>