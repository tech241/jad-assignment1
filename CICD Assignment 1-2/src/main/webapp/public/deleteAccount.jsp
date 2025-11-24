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
    			<h1>Delete account?</h1>
    			<ul>
    				<li>Your account will be deleted.</li>
    				<li>All upcoming appointments will be deleted with no refund.</li>
    				<li>This process is irreversible.</li>
    			</ul>
    			
    			<%
                String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
                %>
                <span id="errMsg"><%= errMsg %></span>
                <% } %>
    			
    			<form action="../deleteAccount" method="post">
    				<label for="password">Password</label> <br>
                	<input type="password" placeholder="Enter password" name="password" id="password" required> <br>
                	
    				<button type="submit" id="delete-account">Delete Account</button>
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