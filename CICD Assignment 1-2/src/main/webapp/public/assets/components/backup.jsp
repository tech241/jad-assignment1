<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%-- <div>
        <input type="checkbox" id="toggle-menu-short">
        
        <% if (isLoggedIn) { %>
        <input type="checkbox" id="toggle-account-dropdown">
        <% } %>
        
        <div class="header">

            <a href="index.jsp"><img src="assets/images/placeholderlogo.png" id="logo"><img src="assets/images/placeholderlogosmall.png" id="logo-small"></a>

            <div class="menu">
                <label for="toggle-menu-short" id="menu-button">
                    <i class='bxr bx-menu' id="open-menu"></i>
                    <i class='bxr bx-x' id="close-menu"></i>
                </label>

                <ul class="menu-options">
                	<!-- base options, everyone receives it -->
                    <li><a href="index.jsp"><i class='bxr bx-home'></i>Home</a></li>
                    <li><a href="services.jsp"><i class='bxr bx-handshake'></i>Services</a></li>
                    
                    <% if (isLoggedIn) { %>
                    
                    <!-- options if the person is logged in -->
                    <div id="account-dropdown">
                    	<label for="toggle-account-dropdown" id="account-dropdown-button">
                    		<i class='bxr bx-user'></i>
                    		<span><%= name %></span>
                    		<i class='bxr bx-caret-big-down' id="open-dropdown"></i>
                    		<i class='bxr bx-caret-big-up' id="close-dropdown"></i>
                    	</label>
                    	
                    	<ul id="account-dropdown-menu">
                			<li><a href="account.jsp">View Account</a><li>
                			<li><a href="#">Log Out</a><li>
                		</ul>
                    </div>
                    
                    <% } else { %>
                    
                    <!-- options if the person is not logged in -->
                    <div id="login-signup">
                        <li><a href="login.jsp">Log In</a></li>
                        <div id="divider-top"></div>
                        <li><a href="signup.jsp" id="login">Sign Up</a></li>
                        <div id="divider-bottom"></div>
                    </div>
                    
                    <% } %>
                </ul>
            </div>
        </div>
    </div> --%>

<%
// Script to check if the user is logged in. Currently hardcoded for debug purposes.
// In the future, this will detect session storage, where if it exists and is valid, then the user is logged in.
// If the user is also an admin, turn on admin features.

// boolean isLoggedIn;
// boolean isAdmin;
// String name;

// script to check if the user if the session storage exists and is valid
/* boolean isLoggedIn = session.getAttribute("id") != null;
boolean isAdmin = "admin".equals((String) session.getAttribute("role"));
String name = (String) session.getAttribute("name");
String email = (String) session.getAttribute("email"); */

// currently hardcoded, will be changed
// isLoggedIn = false;
// isAdmin = false;
// name = "Test User";
%>
</body>
</html>