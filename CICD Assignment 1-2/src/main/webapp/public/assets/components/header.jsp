

<%@ page import="java.sql.*" %>

<%
    Statement stmtCat = null;
    ResultSet rsCat = null;

    try {
        stmtCat = conn.createStatement();
        rsCat = stmtCat.executeQuery("SELECT * FROM service_category ORDER BY cat_id");
    } catch (Exception e) {
        out.println("Header Category Load Error: " + e);
    }
%>

<!-- ACCOUNT DROPDOWN TOGGLE -->
<% if (isLoggedIn) { %>
<input type="checkbox" id="toggle-account-dropdown">
<% } %>

<!-- HEADER -->
<div class="header">

    <!-- LOGO -->
    <div class="logo">
        <a href="homepage.jsp">
            <img src="assets/images/placeholderlogo.png" id="logo">
            <img src="assets/images/placeholderlogosmall.png" id="logo-small">
        </a>
    </div>

    <!-- MENU -->
    <div class="menu">
        <ul class="menu-options">

            <li><a href="homepage.jsp"><i class='bx bx-home'></i> Home</a></li>

            <!-- SERVICES DROPDOWN -->
            <li class="dropdown mega-dropdown">
                <a href="services.jsp"><i class='bx bx-handshake'></i> Services</a>

                <div class="mega-menu">
                    <%
                        try {
                            while (rsCat != null && rsCat.next()) {

                                int catId = rsCat.getInt("cat_id");
                                String catName = rsCat.getString("cat_name");
                                String catLogo = rsCat.getString("cat_logo");

                                // Query services inside each category
                                Statement stmtSvc = conn.createStatement();
                                ResultSet rsSvc = stmtSvc.executeQuery(
                                    "SELECT service_id, service_name FROM service WHERE cat_id = " + catId
                                );
                    %>

                        <div class="mega-column">
                            <h4>
                                <img src="assets/images/<%= catLogo %>" class="cat-icon">
                                <%= catName %>
                            </h4>

                            <%
                                while (rsSvc.next()) {
                            %>
                                <a href="serviceDetails.jsp?service_id=<%= rsSvc.getInt("service_id") %>">

                                    <%= rsSvc.getString("service_name") %>
                                </a>
                            <%
                                } // end services loop
                            %>
                        </div>

                    <%
                                rsSvc.close();
                                stmtSvc.close();
                            } // end category loop
                        } catch (Exception e) {
                            out.println("Header Service Load Error: " + e);
                        }
                    %>
                </div>
            </li>

            <!-- ADMIN SECTION -->
            <% if (isAdmin) { %>
                <li><a href="adminIndex.jsp"><i class='bx bx-cog'></i> Admin</a></li>
            <% } %>

            <!-- ACCOUNT SECTION -->
            <% if (isLoggedIn) { %>
                <li id="account-dropdown">
                    <label for="toggle-account-dropdown" id="account-dropdown-button">
                        <i class="bx bx-user"></i> 
                        <span><%= name %></span>
                        <i class="bx bx-caret-down" id="open-dropdown"></i>
                        <i class="bx bx-caret-up" id="close-dropdown"></i>
                    </label>

                    <ul id="account-dropdown-menu">
                        <li><a href="account.jsp">View Account</a></li>
                        <li><a href="assets/scripts/logout.jsp">Log Out</a></li>
                    </ul>
                </li>
            <% } else { %>
                <li><a href="login.jsp">Log In</a></li>
                <li><a href="signup.jsp">Sign Up</a></li>
            <% } %>

        </ul>
    </div>
</div>

<%
    // Close only header-specific ResultSets/Statements (NOT conn)
    try {
        if (rsCat != null) rsCat.close();
        if (stmtCat != null) stmtCat.close();
    } catch (Exception e) {
        out.println("Header Close Error: " + e);
    }
%>
