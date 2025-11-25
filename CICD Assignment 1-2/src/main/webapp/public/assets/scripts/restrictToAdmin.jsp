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
	
	// if the user is not an admin, redirect to 403.jsp
	
	if (!isAdmin) {
		response.sendRedirect("403.jsp");
	}
	
	%>

</body>
</html>