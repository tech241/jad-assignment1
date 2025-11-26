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
    				<label for="rating">How do you rate our website?</label> <br>
                	<input type="range" min="1" max="5" value="1" name="rating" id="rating" required> <br>
                	
                	<label for="message">Please explain why. (Optional)</label> <br>
                	<textarea placeholder="Enter message here" name="message" id="message"></textarea> <br>
                	
    				<button id="submit" type="submit">Submit</button> <br>
    				<span>Your response is anonymous. Your personal info will not be stored in our feedback form.</span>
    			</form>
    		</div>
    	</div>
    
    </main>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>