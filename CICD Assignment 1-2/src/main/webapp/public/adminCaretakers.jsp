<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="models.*" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/admin.css">
</head>
<body>

    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
	
	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>
	
	<!-- for admins only -->
	<%@ include file="assets/scripts/restrictToAdmin.jsp" %>

    <main>
    	<div class="container">
    		<h1>Caretakers</h1>
			
			<%
			Integer nrow = (Integer) request.getAttribute("nrow");
			if (nrow != null) {
				out.print("<p>Caretaker successfully updated.</p>");
			}
			%>
			
    		<div class="caretakers">
    		
    		<%
    		ArrayList<Caretaker> caretakers = (ArrayList<Caretaker>) request.getAttribute("caretakers");
			if (caretakers != null) {
				for (Caretaker caretaker : caretakers) {
			%>
			
			<div class="caretaker">
				<img src="<%
				String image = caretaker.getImageUrl();
				if (image != null) {
					out.print(image);
				} else {
					out.print(request.getContextPath() + "/public/assets/images/default_profile_image.png");
				}
				%>">
				<h1><%= caretaker.getName() %></h1>
				<p>
					Caretaker Id: <%= caretaker.getCaretakerId() %> <br>
					Experience: <%= caretaker.getExperienceYears() %> Years <br>
					Rating: <%= caretaker.getRating() %>
				</p>
				<button onclick="location.href = '<%= request.getContextPath() %>/public/adminEditCaretaker?caretakerId=<%= caretaker.getCaretakerId() %>'">Update Caretaker</button>
			</div>
			
			<%
				}
			}
    		%>
    		
    		</div>
        </div>
    </main>
    
    <!-- adminsidebar.jsp goes here -->
	<%@ include file="assets/components/adminsidebar.jsp" %>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>