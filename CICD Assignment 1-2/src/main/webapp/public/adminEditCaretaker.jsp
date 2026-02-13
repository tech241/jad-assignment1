<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="models.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/adminoptions.css">
</head>
<body>

    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
	
	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>
	
	<!-- for admins only -->
	<%@ include file="assets/scripts/restrictToAdmin.jsp" %>

    <main>
    	<div class="center-long">
    		<div class="container">
    			<h1>Edit Details</h1>
    			
    			<%
    			Caretaker caretaker = (Caretaker) request.getAttribute("caretaker");
                String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
                %>
                <span id="errMsg"><%= errMsg %></span>
                <% } %>
    			
    			<form action="<%= request.getContextPath() %>/public/editCaretaker" method="post">
    			
    				<input style="display: none;" name="caretakerId" value="<%= caretaker.getCaretakerId() %>">
    			
    				<label for="name">Name</label> <br>
                    <input type="text" placeholder="Enter name" name="name" id="name" value="<%= caretaker.getName() %>" required> <br>
                    
                    <label for="email">Email</label> <br>
                    <input type="text" placeholder="Enter email" name="email" id="email" value="<%= caretaker.getEmail() %>" required> <br>
                    
                    <label for="phone">Phone</label> <br>
                    <input type="text" placeholder="Enter phone" name="phone" id="phone" value="<%= caretaker.getPhone() %>" required> <br>
                    
                    <label for="bio">Bio</label> <br>
                    <textarea placeholder="Enter bio here" name="bio" id="bio" required><%= caretaker.getBio() %></textarea> <br>
                    
                    <label for="experienceYears">Experience (in years)</label> <br>
                    <input type="number" placeholder="Enter years" name="experienceYears" id="experienceYears" value="<%= caretaker.getExperienceYears() %>" required> <br>
                    
    				<label for="imageUrl">Image Url</label> <br>
                	<input type="text" placeholder="Enter path" name="imageUrl" id="imageUrl" value="<%= caretaker.getImageUrl() != null ? caretaker.getImageUrl() : "" %>"> <br>
                	
    				<button type="submit">Edit Details</button>
    			</form>
    		</div>
    	</div>
    </main>
    
	<!-- adminsidebar.jsp goes here -->
	<%@ include file="assets/components/adminsidebar.jsp" %>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>