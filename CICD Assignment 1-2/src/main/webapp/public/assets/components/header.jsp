<%@ page import="java.util.*" %>
<%@ page import="models.serviceCategory" %>
<%@ page import="models.serviceNavItem" %>
<%@ include file="../scripts/checkLoggedIn.jsp"%>

<%
    // this data is prepared by the servlets, so db queries are not required anymore
    List<serviceCategory> navCategories =
        (List<serviceCategory>) request.getAttribute("navCategories");

    Map<Integer, List<serviceNavItem>> navServicesByCat =
        (Map<Integer, List<serviceNavItem>>) request.getAttribute("navServicesByCat");
%>

<!-- ACCOUNT DROPDOWN TOGGLE -->
<%
if (isLoggedIn) {
%>
<input type="checkbox" id="toggle-account-dropdown">
<%
}
%>

<!-- HEADER -->
<div class="header">

    <!-- LOGO -->
    <div class="logo">
        <a href="<%= request.getContextPath() %>/home">
            <img src="<%= request.getContextPath() %>/public/assets/images/placeholderlogo.png" id="logo">
<img src="<%= request.getContextPath() %>/public/assets/images/placeholderlogosmall.png" id="logo-small">

        </a>
    </div>
    

    <!-- MENU -->
    <div class="menu">
        <ul class="menu-options">

            <li>
                <a href="<%= request.getContextPath() %>/home">
                    <i class='bx bx-home'></i> Home
                </a>
            </li>

            <!-- SERVICES DROPDOWN -->
            <li class="dropdown mega-dropdown">
                <a href="<%= request.getContextPath() %>/services">
                    <i class='bx bx-handshake'></i> Services
                </a>

                <div class="mega-menu">
                    <%
                    if (navCategories != null && !navCategories.isEmpty()) {
                        for (serviceCategory c : navCategories) {

                            int catId = c.getId();
                            String catName = c.getName();
                            String catLogo = c.getLogo();

                            List<serviceNavItem> servicesInCat = null;
                            if (navServicesByCat != null) {
                                servicesInCat = navServicesByCat.get(catId);
                            }
                    %>

                    <div class="mega-column">
                        <h4>
                            <img src="<%= request.getContextPath() %>/public/assets/images/<%= catLogo %>" class="cat-icon">
                            <%= catName %>
                        </h4>

                        <%
                        if (servicesInCat != null && !servicesInCat.isEmpty()) {
                            for (serviceNavItem s : servicesInCat) {
                        %>
                            <a href="<%= request.getContextPath() %>/services/details?service_id=<%= s.getServiceId() %>">
                                <%= s.getServiceName() %>
                            </a>
                        <%
                            }
                        } else {
                        %>
                            <span class="text-muted" style="font-size: 0.9rem;">No services</span>
                        <%
                        }
                        %>
                    </div>

                    <%
                        }
                    } else {
                    %>
                        <div class="mega-column">
                            <h4>Services</h4>
                            <span class="text-muted" style="font-size: 0.9rem;">No categories</span>
                        </div>
                    <%
                    }
                    %>
                </div>
            </li>

            <%
            if (isLoggedIn) { // if the user is logged in, the following are shown on navbar
            %>
            <li class="dropdown bookings-dropdown">
                <a href="#" class="dropdown-trigger">
                    <i class='bx bx-calendar'></i> My Bookings <i class='bx bx-caret-down'></i>
                </a>

                <ul class="dropdown-menu">
                <li><a href="<%= request.getContextPath() %>/cart"><i class='bx bx-list-ul'></i> Booking Cart</a></li>
<li><a href="<%= request.getContextPath() %>/bookings/upcoming"><i class='bx bx-time'></i> Upcoming</a></li>
<li><a href="<%= request.getContextPath() %>/bookings/past"><i class='bx bx-history'></i> Past</a></li>
                

                </ul>
            </li>
            <%
            }
            %>

            <!-- ADMIN SECTION -->
            <%
            if (isAdmin) {
            %>
            <li>
                <a href="adminIndex.jsp"><i class='bx bx-cog'></i> Admin</a>
            </li>
            <%
            }
            %>

            <!-- ACCOUNT SECTION -->
            <%
            if (isLoggedIn) {
            %>
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
            <%
            } else {
            %>
            <li><a href="login.jsp">Log In</a></li>
            <li><a href="signup.jsp">Sign Up</a></li>
            <%
            }
            %>

        </ul>
    </div>
</div>
