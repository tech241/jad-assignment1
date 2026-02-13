<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback</title>
    <link rel="stylesheet" href="assets/accountoptions.css">
</head>
<body>

    <%@ include file="assets/components/header.jsp" %>
    <%@ include file="assets/scripts/loadScripts.jsp" %>
    <%@ include file="assets/scripts/restrictToLoggedIn.jsp" %>

    <%
      String errMsg = request.getParameter("errMsg");
      String bookingId = request.getParameter("booking_id");

      if (bookingId == null || bookingId.trim().isEmpty()) {
          response.sendRedirect(request.getContextPath() + "/bookings/past?errMsg=Missing booking ID for feedback.");
          return;
      }
    %>

    <main>
      <div class="center">
        <div class="container">
          <h1>Feedback</h1>

          <% if (errMsg != null) { %>
            <span id="errMsg"><%= errMsg %></span>
          <% } %>

          <form action="<%=request.getContextPath()%>/submitFeedback" method="post">
            <!-- booking is the source of truth -->
            <input type="hidden" name="bookingId" value="<%= bookingId %>">

            <div style="margin-bottom: 10px;">
              <strong>Booking ID:</strong> #<%= bookingId %>
            </div>

            <label for="rating">How would you rate this service?</label> <br>
            <input type="range" min="1" max="5" value="5" name="rating" id="rating" required> <br>

            <label for="comments">Please explain why. (Optional)</label> <br>
            <textarea placeholder="Enter message here" name="comments" id="comments"></textarea> <br>

            <button id="submit" type="submit">Submit</button> <br>
            <span>Your response is anonymous. Your personal info will not be shared with third-parties.</span>
          </form>
        </div>
      </div>
    </main>

    <%@ include file="assets/components/footer.jsp" %>

</body>
</html>
