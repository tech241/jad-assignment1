<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%
		// Script to check if the user is logged in. Currently hardcoded for debug purposes.
		// In the future, this will detect session storage, where if it exists and is valid, then the user is logged in.
		// If the user is also an admin, turn on admin features.
		
		boolean isLoggedIn;
		boolean isAdmin;
				
		// script to check if the user if the session storage exists and is valid
		
		// currently hardcoded, will be changed
		isLoggedIn = true;
		isAdmin = true;
	%>

</body>
</html>