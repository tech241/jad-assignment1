<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="models.BookingItem" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/general.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/editBooking.css">
</head>
<body>
	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	<%
	if (!isLoggedIn) {
	    response.sendRedirect(request.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
	    return;
	}
	%>
	<%
    // These are set by CartEditServlet
    BookingItem item = (BookingItem) request.getAttribute("item");
    Integer index = (Integer) request.getAttribute("index");

    if (item == null || index == null) {
        response.sendRedirect(request.getContextPath() + "/cart?errMsg=Invalid cart item.");
        return;
    }

    String errMsg = request.getParameter("errMsg");
    if (errMsg != null) {
%>
    <p style="color:red; text-align:center; margin: 10px 0;"><%= errMsg %></p>
<%
    }
%>

	<h1>Edit Booking</h1>

	<form action="<%=request.getContextPath()%>/cart/update" method="post" class="edit-form">

    <input type="hidden" name="index" value="<%= index %>">

    <label>Date</label>
    <input type="date" name="date" value="<%= item.date %>" required min="<%= java.time.LocalDate.now() %>">

    <label>Time</label>
    <input type="time" name="time" value="<%= item.time %>" min="09:00" max="18:00" required>

    <label>Notes</label>
    <textarea name="notes"><%= (item.notes == null ? "" : item.notes) %></textarea>

    <div style="display:flex; gap: 12px; margin-top: 16px;">
        <a href="<%=request.getContextPath()%>/cart" class="btn-edit" style="text-decoration:none; padding:10px 14px;">
            Cancel
        </a>

        <button type="submit">Save Changes</button>
    </div>

</form>
<%@ include file="assets/components/footer.jsp"%>
</body>
</html>