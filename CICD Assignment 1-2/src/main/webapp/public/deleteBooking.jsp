<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
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
	if (!isLoggedIn) {
		response.sendRedirect("login.jsp?errMsg=Please log in first.");
		return;
	}

	int index = Integer.parseInt(request.getParameter("index"));

	ArrayList cart = (ArrayList) session.getAttribute("cart");

	if (cart != null && index >= 0 && index < cart.size()) {
		cart.remove(index);
		session.setAttribute("cart", cart);
	}

	response.sendRedirect("bookingSummary.jsp");
	%>
</body>
<%@ include file="assets/components/footer.jsp"%>
</html>