<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="models.service" %>
<%@ page import="models.servicePackage" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Service Details | Silver Care</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/public/assets/general.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/public/assets/serviceDetails.css">
</head>

<body>
  <%@ include file="assets/components/header.jsp"%>
  <%@ include file="assets/scripts/loadScripts.jsp"%>

  <main>
    <%
      service svc = (service) request.getAttribute("service");
      List<servicePackage> packages = (List<servicePackage>) request.getAttribute("packages");
    %>

    <%
      if (svc == null) {
    %>
      <p style='color:red; text-align:center;'>Invalid service selected.</p>
    <%
      } else {
        int serviceId = svc.getServiceId();
        String serviceName = svc.getServiceName();
        String serviceDescription = svc.getServiceDescription();
        String imagePath = svc.getImagePath();
        String whatsIncluded = svc.getWhatsIncluded();
    %>

    <!-- Breadcrumb for path -->
    <nav class="breadcrumb">
      <a href="<%= request.getContextPath() %>/services">Services</a>
      <span>/</span>
      <span><%= serviceName %></span>
    </nav>

    <!-- Hero Title -->
    <h1 class="service-title"><%= serviceName %></h1>
    <p class="service-desc"><%= serviceDescription %></p>

    <div class="details-wrapper">

      <!-- LEFT: Service Image -->
      <div class="service-image-box">
        <%
          String imgToUse = (imagePath != null && !imagePath.trim().isEmpty())
              ? ("assets/images/" + imagePath)
              : "assets/images/default_image.png";
        %>
        <img src="<%= imgToUse %>"
             onerror="this.src='assets/images/default_image.png'"
             alt="<%= serviceName %>">
      </div>

      <div class="packages-box">
        <h2>Available Packages</h2>

        <table class="packages-table">
          <tr>
            <th>Package</th>
            <th>Description</th>
            <th>Price</th>
            <th></th>
          </tr>

          <%
            boolean hasPackages = (packages != null && !packages.isEmpty());

            if (hasPackages) {
              for (servicePackage p : packages) {
          %>
            <tr>
              <td><%= p.getPackageName() %></td>
              <td><%= p.getPackageDescription() %></td>
              <td>$<%= String.format("%.2f", p.getPrice()) %></td>
              <td>
                <a class="book-btn"
                   href="verifyBookingAccess.jsp?package_id=<%= p.getPackageId() %>&service_id=<%= serviceId %>">
                  Book
                </a>
              </td>
            </tr>
          <%
              }
            } else {
          %>
            <tr>
              <td colspan="4" style="text-align: center;">No packages available.</td>
            </tr>
          <%
            }
          %>
        </table>
      </div>

    </div>

    <section class="info-section">
      <h2>What’s Included</h2>

      <%
        if (whatsIncluded != null && whatsIncluded.trim().length() > 0) {
      %>
        <ul>
          <%
            for (String item : whatsIncluded.split("\n")) {
          %>
            <li><%= item.replace("•", "").trim() %></li>
          <%
            }
          %>
        </ul>
      <%
        } else {
      %>
        <p>No information available for this service.</p>
      <%
        }
      %>
    </section>

    <section class="info-section">
      <h2>This Service Is Suitable For</h2>
      <ul>
        <li>Seniors who require consistent support</li>
        <li>Families seeking reliable and structured assistance</li>
        <li>Individuals recovering from injury or illness</li>
        <li>Seniors who benefit from companionship and monitoring</li>
      </ul>
    </section>

    <section class="steps-section">
      <h2>How It Works</h2>

      <div class="steps-grid">
        <div class="step-card">
          <div class="step-num">1</div>
          <h3>Select a Package</h3>
          <p>Choose a suitable support package tailored to your needs.</p>
        </div>
        <div class="step-card">
          <div class="step-num">2</div>
          <h3>Pick a Date & Time</h3>
          <p>Choose your preferred availability for your care session.</p>
        </div>
        <div class="step-card">
          <div class="step-num">3</div>
          <h3>Confirm Your Booking</h3>
          <p>Submit the form and our caregiver will be assigned to assist you.</p>
        </div>
      </div>
    </section>

    <%
      } // end svc != null
    %>

  </main>

  <%@ include file="assets/components/footer.jsp"%>
</body>
</html>
