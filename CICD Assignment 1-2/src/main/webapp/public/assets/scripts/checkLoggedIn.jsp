<%
boolean isLoggedIn = session.getAttribute("id") != null;
boolean isAdmin = "admin".equals((String) session.getAttribute("role"));
String name = (String) session.getAttribute("name");
String email = (String) session.getAttribute("email");
%>