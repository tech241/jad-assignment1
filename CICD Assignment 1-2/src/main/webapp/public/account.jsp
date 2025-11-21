<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/general.css">
</head>
<body>

	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>

	<% 
		// this page should only be accessible if the user is logged in
		// the code should be reuseable so put it as a java/jsp file???
				
		if (!isLoggedIn) {
			response.sendRedirect("403.jsp");
		}
	%>

    <main>
        
        
        
    </main>
    
    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>