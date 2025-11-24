<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/admin.css">
</head>
<body>
	
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
    	
    		<form action="../submitFeedback" method="post">
    			<label for="name">Name</label>
        		<input type="text" placeholder="Enter name" name="name" id="name" required>
        		
        		<label for="category">Category</label>
        		<select name="category" id="category">
        		
        			<%
        			while (rsCat2 != null && rsCat2.next()) {
        			%>
        			
        			<option value="<%= rsCat2.getString("cat_id") %>"><%= rsCat2.getString("cat_name") %></option>
        			
        			<% } %>
        		
        		</select>
        	
        		<button type="submit">Search</button>
    		</form>
    	</div>
    	
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
		
				stmtCat3 = conn3.prepareStatement("SELECT * FROM service WHERE name LIKE ? AND category = ?;");
				stmtCat3.setString(1, "%" + request.getParameter("name") + "%");
				stmtCat3.setInt(2, Integer.parseInt(request.getParameter("category")));
		
			} catch (Exception e) {
				out.println("Error in header DB: " + e);
			}
			
			while (rsCat3 != null || rsCat3.next()) {
			%>
			
			<div class="service-card">
			
			</div>
			
			<% } %>
    		
    	</div>
    </div>
        
    </main>
    
    <!-- adminsidebar.jsp goes here -->
	<%@ include file="assets/components/adminsidebar.jsp" %>
    
    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>