<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="models.BookingItem" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="assets/general.css">
</head>
<body>
	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	
	<%@ include file="assets/scripts/restrictToLoggedIn.jsp" %>

	<%
	if (!isLoggedIn) {
		response.sendRedirect("login.jsp?errMsg=Please log in first.");
		return;
	}

	int index = Integer.parseInt(request.getParameter("index"));

	ArrayList<BookingItem> cart = (ArrayList<BookingItem>) session.getAttribute("cart");

	BookingItem item = cart.get(index);

	// Update fields directly
	item.date = request.getParameter("date");
	item.time = request.getParameter("time");
	item.notes = request.getParameter("notes");

	// Save back
	session.setAttribute("cart", cart);

	// Redirect
	response.sendRedirect("bookingSummary.jsp");
	%>
</body>
</html>