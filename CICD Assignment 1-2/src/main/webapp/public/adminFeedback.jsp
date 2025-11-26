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

    <main>
    
    <div class="container">
    	<h1>Feedback</h1>
    	
    	<div class="search-by">
    		<span class="search-text">Search by:</span>
    	
    		<form>
    			<label for="minRating">Rating from</label>
        		<input type="range" min="1" max="5" value="<%= request.getParameter("minRating") == null ? "1" : request.getParameter("minRating") %>" name="minRating" id="minRating" required>
        		
        		<label for="maxRating">to</label>
        		<input type="range" min="1" max="5" value="<%= request.getParameter("maxRating") == null ? "5" : request.getParameter("maxRating") %>" name="maxRating" id="maxRating" required> <br>
        		
        		<label for="serviceId">Service</label>
        		<select name="serviceId" id="serviceId">
        		
        			<option value="">All services</option>
        		
        			<%
        			ResultSet rsCat2 = null;
        			String currentValue = request.getParameter("serviceId") == null || "".equals(request.getParameter("serviceId")) ? "" : request.getParameter("serviceId");

        			try {
        				Class.forName("org.postgresql.Driver");
        				Connection conn2 = DriverManager.getConnection(
        				"jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require",
        				"neondb_owner", "npg_iCobAxPw5z4X");

        				Statement stmtCat2 = conn2.createStatement();
        				rsCat2 = stmtCat2.executeQuery("SELECT * FROM service ORDER BY service_id;");

        			} catch (Exception e) {
        				out.println("Error in header DB: " + e);
        			}
        			
        			while (rsCat2 != null && rsCat2.next()) {
        			%>
        			
        			<option value="<%= rsCat2.getString("service_id") %>" <%= currentValue.equals(rsCat2.getString("service_id")) ? "selected" : "" %>><%= rsCat2.getString("service_name") %></option>
        			
        			<% } %>
        		
        		</select> <br>
        		
        		<label for="minCreatedAt">Submitted from</label>
        		<input type="date" name="minCreatedAt" id="minCreatedAt" <%= request.getParameter("minCreatedAt") == null ? "" : "value=\"" + request.getParameter("minCreatedAt") + "\"" %>>
        		
        		<label for="maxCreatedAt">to</label>
        		<input type="date" name="maxCreatedAt" id="maxCreatedAt" <%= request.getParameter("maxCreatedAt") == null ? "" : "value=\"" + request.getParameter("maxCreatedAt") + "\"" %>> <br>
        	
        		<button type="submit">Search</button>
    		</form>
    	</div>
    	
    	<div class="section-divider"></div>
    	
    	<h2>Search results</h2>
    	
    	<div class="feedback">
    	
    	<%
		ResultSet rsReview = null;

		try {
			Class.forName("org.postgresql.Driver");
			Connection connReview = DriverManager.getConnection(
			"jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require",
			"neondb_owner", "npg_iCobAxPw5z4X");

			PreparedStatement stmtReview = connReview.prepareStatement("SELECT * FROM get_feedback(?, ?, ?, ?, ?);");
			
			String[] paramsInt = {"minRating", "maxRating", "serviceId"};
			String[] paramsTimestamp = {"minCreatedAt", "maxCreatedAt"};
			int index = 1;
			for (String param : paramsInt) {
				try {
					stmtReview.setInt(index, Integer.parseInt(request.getParameter(param)));
				} catch (Exception e) {
					stmtReview.setObject(index, null);
				}
				
				index ++;
			}
			for (String param : paramsTimestamp) {
				try {
					Date date = Date.valueOf(request.getParameter(param));
					stmtReview.setTimestamp(index, new Timestamp(date.getTime()));
				} catch (Exception e) {
					stmtReview.setObject(index, null);
				}
				
				index ++;
			}
			
			rsReview = stmtReview.executeQuery();

		} catch (Exception e) {
			out.println("Error in header DB: " + e);
		}
				
		while (rsReview != null && rsReview.next()) {
		%>
				
		<div class="review-card">
			<h1>
			<%
			for (int i = 0; i < rsReview.getInt("rating"); i ++) {
				out.print("★");
			}
			for (int i = rsReview.getInt("rating"); i < 5; i ++) {
				out.print("☆");
			}
			%>
			</h1>
			<p><%= rsReview.getString("comments") %></p>
			<strong>- <%= rsReview.getString("name") %></strong><br>
			<span><%= rsReview.getString("service_name") %></span><br>
			<span><%= rsReview.getDate("created_at").toString() %></span>
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
</html>