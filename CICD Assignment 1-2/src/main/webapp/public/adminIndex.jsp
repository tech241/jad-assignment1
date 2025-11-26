<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/admin.css">
</head>
<body>
	
	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>
	
	<!-- for admins only -->
	<%@ include file="assets/scripts/restrictToAdmin.jsp" %>
	
	<!-- load statistics -->
	<%@ include file="assets/scripts/loadStatistics.jsp" %>

    <main>
    	<div class="container">
    		<h1>Hello, admin <%= name %>!</h1>
    		
    		<div class="stats">
    		
    			<%
    			for (String key : stats.keySet()) {
    			%>
    			
    			<div class="stat-card"><span class="number"><%= stats.get(key) %></span><br><span><%= key %></span></div>
    			
    			<% } %>
    			
    		</div>
        </div>
    </main>
    
    <!-- adminsidebar.jsp goes here -->
	<%@ include file="assets/components/adminsidebar.jsp" %>
    
    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>