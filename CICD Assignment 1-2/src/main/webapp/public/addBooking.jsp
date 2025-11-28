<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="models.BookingItem"%>

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

	<%
	if (!isLoggedIn) {
		response.sendRedirect("login.jsp?errMsg=Please log in first.");
		return;
	}

	int memberId = (Integer) session.getAttribute("id");
	String packageId = request.getParameter("package_id");
	String serviceId = request.getParameter("service_id");
	String date = request.getParameter("date");
	String time = request.getParameter("time");
	String caretaker = request.getParameter("caretaker_id");
	String notes = request.getParameter("notes");

	java.time.LocalDate selectedDate = java.time.LocalDate.parse(date);
	java.time.LocalDate today = java.time.LocalDate.now();

	if (selectedDate.isBefore(today)) {
		response.sendRedirect("bookings.jsp?package_id=" + packageId + "&service_id=" + serviceId
		+ "&errMsg=You cannot book a date in the past.");
		return;
	}

	try {
		String sql = "INSERT INTO booking "
		+ "(member_id, service_id, package_id, scheduled_date, scheduled_time, notes, caretaker_id) "
		+ "VALUES (?, ?, ?, ?, ?, ?, ?)";

		PreparedStatement pstmtInsert = conn.prepareStatement(sql);
		pstmtInsert.setInt(1, memberId);
		pstmtInsert.setInt(2, Integer.parseInt(serviceId));
		pstmtInsert.setInt(3, Integer.parseInt(packageId));
		pstmtInsert.setDate(4, java.sql.Date.valueOf(selectedDate));
		pstmtInsert.setTime(5, java.sql.Time.valueOf(time + ":00"));
		pstmtInsert.setString(6, notes == null ? "" : notes);

		if (caretaker == null || caretaker.trim().isEmpty()) {
			pstmtInsert.setNull(7, java.sql.Types.INTEGER);
		} else {
			pstmtInsert.setInt(7, Integer.parseInt(caretaker));
		}

		pstmtInsert.executeUpdate();
		pstmtInsert.close();

		BookingItem item = new BookingItem();

		// Fill from form request
		item.packageId = packageId;
		item.serviceId = serviceId;
		item.date = date;
		item.time = time;
		item.notes = (notes == null ? "" : notes);
		item.caretaker = caretaker;

		// Now load service + package names and price for the BookingItem
		try {
			String sqlDetails = "SELECT s.service_name, p.package_name, p.price " + "FROM service s "
			+ "INNER JOIN service_package p ON s.service_id = p.service_id " + "WHERE p.package_id = ?";

			PreparedStatement pstmtDetails = conn.prepareStatement(sqlDetails);
			pstmtDetails.setInt(1, Integer.parseInt(packageId));
			ResultSet rsDetails = pstmtDetails.executeQuery();

			if (rsDetails.next()) {
		item.serviceName = rsDetails.getString("service_name");
		item.packageName = rsDetails.getString("package_name");
		item.price = rsDetails.getBigDecimal("price").toString();
			}

			rsDetails.close();
			pstmtDetails.close();

		} catch (Exception e) {
			out.println("Cart Load Error: " + e.getMessage());
		}

		// Now store BookingItem in session cart
		ArrayList<BookingItem> cart = (ArrayList<BookingItem>) session.getAttribute("cart");

		if (cart == null) {
			cart = new ArrayList<>();
		}

		cart.add(item);

		// Save back into session
		session.setAttribute("cart", cart);

		response.sendRedirect("bookingSuccess.jsp");

	} catch (Exception e) {
		out.println("Booking Error: " + e.getMessage());
	}
	%>
	<%@ include file="assets/components/footer.jsp"%>
</body>
</html>