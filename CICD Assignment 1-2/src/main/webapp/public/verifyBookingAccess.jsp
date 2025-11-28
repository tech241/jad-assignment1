<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<%
	String packageId = request.getParameter("package_id");
	String serviceId = request.getParameter("service_id");

	if (!isLoggedIn) {
		response.sendRedirect(request.getContextPath() + "/public/login.jsp?errMsg=You must be logged in to make a booking.&redirect=book&package_id="
		+ packageId + "&service_id=" + serviceId);
	} else {
		response.sendRedirect("bookings.jsp?package_id=" + packageId + "&service_id=" + serviceId);
	}
	%>
</body>
</html>	