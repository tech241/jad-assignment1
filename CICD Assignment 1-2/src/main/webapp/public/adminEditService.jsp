<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
	
	<!-- loading service info -->
	<%@ include file="assets/scripts/loadServiceInfo.jsp" %>

    <main>
    	<div class="center">
    		<div class="container">
    			<h1>Edit Details</h1>
    			
    			<%
                String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
                %>
                <span id="errMsg"><%= errMsg %></span>
                <% } %>
    			
    			<form action="../editService" method="post">
    				<input style="display: none;" name="serviceId" value="<%= serviceId2 %>">
    			
    				<label for="serviceName">Name</label> <br>
                    <input type="text" placeholder="Enter name" name="serviceName" id="serviceName" value="<%= serviceName2 %>" required> <br>
                    
                    <label for="catId">Category</label> <br>
        			<select name="catId" id="catId">
        		
        				<%
        				ResultSet rsCat2 = null;

        				try {
        					Class.forName("org.postgresql.Driver");
        					Connection conn2 = DriverManager.getConnection(
        					"jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require",
        					"neondb_owner", "npg_iCobAxPw5z4X");

        					Statement stmtCat2 = conn2.createStatement();
        					rsCat2 = stmtCat2.executeQuery("SELECT * FROM service_category ORDER BY cat_id;");

        				} catch (Exception e) {
        					out.println("Error in header DB: " + e);
        				}
        				
        				while (rsCat2 != null && rsCat2.next()) {
        				%>
        			
        				<option value="<%= rsCat2.getString("cat_id") %>" <%= rsCat2.getString("cat_id").equals(catId2) ? "selected" : "" %>><%= rsCat2.getString("cat_name") %></option>
        			
        				<% } %>
        		
        			</select><br>

                    <label for="serviceDescription">Service Description</label> <br>
                	<textarea placeholder="Enter description here" name="serviceDescription" id="serviceDescription" required><%= serviceDescription2 %></textarea> <br>
                    
    				<label for="imagePath">Image Path</label> <br>
                	<input type="text" placeholder="Enter path" name="imagePath" id="imagePath" value="<%= imagePath2 %>" required> <br>
                	
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