<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<%
	
	// load services
	
	// if serviceId is null or empty return back to adminServices.jsp
	String serviceId2 = request.getParameter("serviceId");
	String catId2 = "";
	String serviceName2 = "";
	String serviceDescription2 = "";
	String imagePath2 = "";
	
	if (serviceId2 == null || "".equals(serviceId2)) {
		response.sendRedirect("adminServices.jsp");
	}
	
	try {
		Class.forName("org.postgresql.Driver");
		Connection connService = DriverManager.getConnection(
		"jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require",
		"neondb_owner", "npg_iCobAxPw5z4X");

		PreparedStatement stmtService = connService.prepareStatement("SELECT * FROM service WHERE service_id = ?;");
		stmtService.setInt(1, Integer.parseInt(serviceId2));
		
		ResultSet rsService = stmtService.executeQuery();
		
		int length = 0;
		
		// if rsService is null, then the service_id is not found
		while (rsService.next()) {
			catId2 = rsService.getString("cat_id");
			serviceName2 = rsService.getString("service_name");
			serviceDescription2 = rsService.getString("service_description");
			imagePath2 = rsService.getString("image_path");
			
			length ++;
		}
		
		if (length <= 0) {
			response.sendRedirect("adminServices.jsp");
		}
		
		connService.close();
	} catch (Exception e) {
		out.println("Error in header DB: " + e);
	}
	
	%>

</body>
</html>