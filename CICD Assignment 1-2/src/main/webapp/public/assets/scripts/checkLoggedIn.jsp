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
		
		// boolean isLoggedIn;
		// boolean isAdmin;
		// String name;
				
		// script to check if the user if the session storage exists and is valid
		boolean isLoggedIn = session.getAttribute("id") != null;
		boolean isAdmin =  "admin".equals((String) session.getAttribute("role"));
		String name = (String) session.getAttribute("name");
		String email = (String) session.getAttribute("email");
		
		// currently hardcoded, will be changed
		// isLoggedIn = false;
		// isAdmin = false;
		// name = "Test User";
	%>

</body>
</html>