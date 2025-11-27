<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/adminoptions.css">
</head>
<body>

    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
	
	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>
	
	<!-- for admins only -->
	<%@ include file="assets/scripts/restrictToAdmin.jsp" %>
	
	<!-- loading service info -->
	<%@ include file="assets/scripts/loadServiceInfo.jsp" %>

    <main>
    	<div class="center">
    		<div class="container">
    			<h1>Delete Service?</h1>
    			<p>All appointments for this service will be deleted. This process is irreversible.</p>
    			
    			<%
                String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
                %>
                <span id="errMsg"><%= errMsg %></span>
                <% } %>
    			
    			<form action="../deleteService" method="post">
    				<input style="display: none;" name="serviceId" value="<%= serviceId2 %>">
                	
    				<button type="submit" class="dangerous-button">Delete Service</button>
    			</form>
    		</div>
    	</div>
    </main>
    
	<!-- adminsidebar.jsp goes here -->
	<%@ include file="assets/components/adminsidebar.jsp" %>
    

    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>