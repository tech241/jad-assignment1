
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="models.serviceCategory" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Our Services | Silver Cares</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/public/assets/general.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/public/assets/services.css">



</head>

<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	

	<%
    List<serviceCategory> categories =
        (List<serviceCategory>) request.getAttribute("categories");
%>


<div class="container py-4">
  <h1 class="mb-4">Services</h1>

  <div class="row">
    <%
      if (categories != null && !categories.isEmpty()) {
        for (serviceCategory c : categories) {
    %>
      <div class="col-md-4 mb-3">
        <div class="card h-100">
          <%-- Adjust this depending on how you store cat_logo --%>
          <img class="card-img-top"
               src="assets/images/<%= c.getLogo() %>"
               alt="<%= c.getName() %>"/>

          <div class="card-body">
            <h5 class="card-title"><%= c.getName() %></h5>
            <p class="card-text"><%= c.getDescription() %></p>

            <a class="btn btn-primary"
               href="<%= request.getContextPath() %>/services/category?cat_id=<%= c.getId() %>">
              View services
            </a>
          </div>
        </div>
      </div>
    <%
        }
      } else {
    %>
      <p>No service categories found.</p>
    <%
      }
    %>
  </div>
</div>



	<%@ include file="assets/components/footer.jsp"%>

</body>
</html>