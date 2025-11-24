<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/account.css">
</head>
<body>

	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>

	<% 
		// this page should only be accessible if the user is logged in
		// the code should be reuseable so put it as a java/jsp file???
	%>
	
	<!-- import java.util.LocalDate -->
	<%@ page import="java.time.LocalTime"%>
	
	<%
	int hour = LocalTime.now().getHour();
	String greeting = (hour < 12) ? "Morning" : (hour < 18) ? "Afternoon" : "Evening";
	%>
	
	<%@ include file="assets/scripts/restrictToLoggedIn.jsp" %>

    <main>
        
        <div class="container">
        	
        	<h1>Good <%= greeting %>!</h1>
        	
        	<!-- profile -->
        	<div class="profile">
        	
        		<div class="card">
        		
        			<i class="bx bx-user-circle" id="account-icon"></i>
        			
        			<div class="info">
        				<h2><%= name %></h2>
        				<span><%= email %></span>
        			</div>
        			
        		</div>
        		
        		<div class="buttons">
        			<button onclick="location.href = 'editDetails.jsp'">Edit Details</button>
        			<button onclick="location.href = 'changePassword.jsp'">Change Password</button>
        		</div>
        		
        	</div>
        	
        	<div class="section-divider"></div>
        	
        	<h1>Upcoming bookings</h1>
        	
        	<div class="section-divider"></div>
        	
        	<h1>Enjoying our website?</h1>
        	<button id="feedback" onclick="location.href = 'feedback.jsp'">Feedback</button> <br>
        	<span>Whether you enjoy our website or not, your feedback is 100% appreciated.</span>
        	
        	<div class="section-divider"></div>
        	
        	<h1>Dangerous zone</h1>
        	<button id="delete-account" onclick="location.href = 'deleteAccount.jsp'">Delete Account</button> <br>
        	<span>This action will cause you to lose all of your data. Additionally, all of your appointments will be cancelled and no refund will be issued. This process is irreversible.</span>
        	
        </div>
        
    </main>
    
    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>