<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/accountoptions.css">
</head>
<body>
	
	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>
	
	<%@ include file="assets/scripts/restrictToLoggedIn.jsp" %>

	<main>
    	<div class="center">
    		<div class="container">
    			<h1>Edit Details</h1>
    			
    			<%
                String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
                %>
                <span id="errMsg"><%= errMsg %></span>
                <% } %>
    			
    			<form action="../editDetails" method="post">
    				<label for="name">Name</label> <br>
                    <input type="text" placeholder="Enter name" name="name" id="name" value="<%= name %>" required> <br>

                    <label for="email">Email</label> <br>
                    <input type="email" placeholder="name@example.com" name="email" id="email" value="<%= email %>" required> <br>
                    
    				<label for="password">Enter password to change details</label> <br>
                	<input type="password" placeholder="Enter password" name="password" id="password" required> <br>
                	
    				<button type="submit">Edit Details</button>
    			</form>
    		</div>
    	</div>
    </main>
    
    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>