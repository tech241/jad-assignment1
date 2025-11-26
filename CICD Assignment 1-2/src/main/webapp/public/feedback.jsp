<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="assets/scripts/checkLoggedIn.jsp" %>
<%@ include file="assets/scripts/dbConnection.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/accountoptions.css">
</head>
<body>

    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
	
	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>
	
	<%@ include file="assets/scripts/restrictToLoggedIn.jsp" %>
	
	<%
	// this will probably get a rework idk really
	%>

    <main>
    
        <div class="center">
    		<div class="container">
    			<h1>Feedback</h1>
    			
    			<%
                String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
                %>
                <span id="errMsg"><%= errMsg %></span>
                <% } %>
    			
    			<form action="../submitFeedback" method="post">
    				<label for="serviceId">What service did you book?</label>
        			<select name="serviceId" id="serviceId">
        			
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
        			
        				<option value="<%= rsCat2.getString("service_id") %>"><%= rsCat2.getString("service_name") %></option>
        				
        				<% } %>
        		
        			</select> <br>
    			
    				<label for="rating">How would you rate this service?</label> <br>
                	<input type="range" min="1" max="5" value="1" name="rating" id="rating" required> <br>
                	
                	<label for="comments">Please explain why. (Optional)</label> <br>
                	<textarea placeholder="Enter message here" name="comments" id="comments"></textarea> <br>
                	
    				<button id="submit" type="submit">Submit</button> <br>
    				<span>Your response is anonymous. Your personal info will not be shared with third-parties.</span>
    			</form>
    		</div>
    	</div>
    
    </main>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>