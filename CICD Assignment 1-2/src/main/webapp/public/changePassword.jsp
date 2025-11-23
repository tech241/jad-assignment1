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
    			<h2>Change Password</h2>
    			
    			<%
                String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
                %>
                <span id="errMsg"><%= errMsg %></span>
                <% } %>
    			
    			<form action="../changePassword" method="post">
    				<label for="password">Password</label> <br>
                	<input type="password" placeholder="Enter password" name="password" id="password" required> <br>
                	
                	<label for="new-password">New password</label> <br>
                	<input type="password" placeholder="New password" name="new-password" id="new-password" required> <br>
                	
                	<label for="confirm-password">Confirm password</label> <br>
                	<input type="password" placeholder="Enter new password again" name="confirm-password" id="confirm-password" required> <br>
                	
    				<button type="submit">Change Password</button>
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