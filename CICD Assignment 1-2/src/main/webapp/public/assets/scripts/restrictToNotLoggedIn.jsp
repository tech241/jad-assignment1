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
	
	// if the user is logged in, redirect to 403.jsp
	
	if (isLoggedIn) {
		response.sendRedirect("403.jsp");
	}
	
	%>

</body>
</html>