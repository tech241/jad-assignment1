<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/loginsignup.css">
</head>
<body>
    <!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp" %>

	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp" %>
	
	<!-- for not logged in users only -->
	<%@ include file="assets/scripts/restrictToNotLoggedIn.jsp" %>

    <main>
        <div class="position-relative">
            <div class="position-absolute login">

                <h1>Log In</h1>

                <% String errMsg = request.getParameter("errMsg"); 
                   if (errMsg != null) { %>
                    <span id="errMsg"><%= errMsg %></span>
                <% } %>

                <form action="<%= request.getContextPath() %>/login" method="post">

                    <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") %>">
                    <input type="hidden" name="package_id" value="<%= request.getParameter("package_id") %>">
                    <input type="hidden" name="service_id" value="<%= request.getParameter("service_id") %>">


                    <label for="name-or-email">Name or Email</label><br>
                    <input type="text" name="name-or-email" required><br>

                    <label for="password">Password</label><br>
                    <input type="password" name="password" required><br>

                    <label>
                        <input type="checkbox" name="remember-me"> Remember Me
                    </label><br>

                    <button type="submit">Log In</button>
                </form>

                <span>Don't have an account? 
                    <a href="signup.jsp">Sign Up</a>
                </span>
            </div>
        </div>
    </main>
    
    <!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp" %>

</body>
</html>