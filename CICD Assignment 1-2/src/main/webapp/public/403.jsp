<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/403.css">
</head>
<body>
	
	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>

    <main>
    
    <!-- this page is used if the user is not authorized to visit the page -->
    <div class="center">
    	<div class="container">
    		<h1>Oops!</h1>
    		<p>You're not allowed to see this page.</p>
    		<button onclick="location.href = 'homepage.jsp';">Go back</button>
    	</div>
    </div>
        
    </main>
    
    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>