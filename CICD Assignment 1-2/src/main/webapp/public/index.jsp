<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="assets/general.css">
</head>
<body>
    
    <div>
        <input type="checkbox" id="toggle-menu-short">
        
        <div class="header">

            <a href="index.jsp"><img src="assets/images/placeholderlogo.png" id="logo"><img src="assets/images/placeholderlogosmall.png" id="logo-small"></a>

            <div class="menu">
                <label for="toggle-menu-short" id="menu-button">
                    <i class='bxr bx-menu' id="open-menu"></i>
                    <i class='bxr bx-x' id="close-menu"></i>
                </label>

                <ul class="menu-options">
                    <li><a href="index.jsp"><i class='bxr bx-home'></i>Home</a></li>
                    <li><a href="search.jsp"><i class='bxr bx-search'></i>Search</a></li>
                    <li><a href="login.jsp">Log In</a></li>
                    <div id="divider-top"></div>
                    <li><a href="signup.jsp" id="login">Sign Up</a></li>
                    <div id="divider-bottom"></div>
                </ul>
            </div>
        </div>
    </div>

    <main>
        
    </main>

    <div>
        <div class="footer">
            <span>Silver Care &copy;(year). All rights reserved.</span>
        </div>
    </div>

</body>
</html>