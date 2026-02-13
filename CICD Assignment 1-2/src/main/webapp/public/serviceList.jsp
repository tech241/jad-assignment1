<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="models.serviceCategory" %>
<%@ page import="models.service" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Services | Silver Cares</title>

<link rel="stylesheet" href="<%= request.getContextPath() %>/public/assets/general.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/public/assets/serviceList.css">
</head>

<body>

  <%@ include file="assets/components/header.jsp"%>
  <%@ include file="assets/scripts/loadScripts.jsp"%>

  <main>
    <%
      serviceCategory category = (serviceCategory) request.getAttribute("category");
      List<service> services = (List<service>) request.getAttribute("services");
    %>

    <%
      if (category == null) {
    %>
        <p style="color:red; text-align:center;">Invalid category selected.</p>
    <%
      } else {
        String categoryName = category.getName();
        String categoryDescription = category.getDescription();
    %>

    <!-- Breadcrumb for path -->
    <nav class="breadcrumb">
      <a href="<%= request.getContextPath() %>/services">Services</a>
      <span>/</span>
      <span><%= categoryName %></span>
    </nav>

    <!-- Category header -->
    <div class="category-header">
      <div class="header-content">
        <h1><%= categoryName %></h1>
        <p><%= categoryDescription %></p>
      </div>
    </div>

    <!-- Services list -->
    <div class="services-container">
      <%
        boolean hasServices = (services != null && !services.isEmpty());

        if (hasServices) {
          for (service s : services) {
            int serviceId = s.getServiceId();
            String serviceName = s.getServiceName();
            String serviceDescription = s.getServiceDescription();
            String imagePath = s.getImagePath();
      %>

      <div class="service-card">
        <div class="service-image">
          <%
            if (imagePath != null && !imagePath.trim().isEmpty()) {
          %>
            <img src="<%= request.getContextPath() %>/public/assets/images/<%= imagePath %>"
                 alt="<%= serviceName %>"
                 onerror="this.src='<%= request.getContextPath() %>/public/assets/images/default_image.png'">
          <%
            } else {
          %>
            <img src="<%= request.getContextPath() %>/public/assets/images/default-service.png" alt="<%= serviceName %>">
          <%
            }
          %>
        </div>

        <div class="service-content">
          <h3><%= serviceName %></h3>
          <p><%= serviceDescription %></p>

          <div class="service-actions">
            <a class="view-details-btn"
               href="<%= request.getContextPath() %>/services/details?service_id=<%= serviceId %>">
              View Details
            </a>
          </div>
        </div>
      </div>

      <%
          } // end loop
        } else {
      %>
        <div class="no-services">
          <p>No services available in this category.</p>
        </div>
      <%
        }
      %>
    </div>

    <%
      } // end category != null
    %>

  </main>

  <%@ include file="assets/components/footer.jsp"%>
</body>
</html>
