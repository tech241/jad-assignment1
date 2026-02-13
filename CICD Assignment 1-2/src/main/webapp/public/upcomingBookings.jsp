<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="models.BookingDisplayItem"%>
<%@ page import="java.time.*"%>
<%@ page import="java.time.format.*"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Upcoming Bookings</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/general.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/bookingsDisplay.css">
</head>
<body>

  <%@ include file="assets/components/header.jsp"%>
  <%@ include file="assets/scripts/loadScripts.jsp"%>

  <%
    List<BookingDisplayItem> bookings = (List<BookingDisplayItem>) request.getAttribute("bookings");

    String msg = request.getParameter("msg");
    String errMsg = request.getParameter("errMsg");
    if (msg != null) {
  %>
    <div class="alert success"><%= msg %></div>
  <%
    }
    if (errMsg != null) {
  %>
    <div class="alert error"><%= errMsg %></div>
  <%
    }
  %>

  <main class="bookings-wrapper">
    <h1>My Bookings</h1>

    <div class="bookings-tabs">
      <a class="tab active" href="<%=request.getContextPath()%>/bookings/upcoming">Upcoming</a>
      <a class="tab" href="<%=request.getContextPath()%>/bookings/past">Past</a>
    </div>

    <%
      // ---------- NEXT APPOINTMENT SUMMARY (TOP) ----------
      LocalDateTime now = LocalDateTime.now();
      BookingDisplayItem nextBooking = null;
      LocalDateTime nextDt = null;

      if (bookings != null) {
        for (BookingDisplayItem b : bookings) {
          try {
            // parse date
            LocalDate d;
            Object dateObj = b.getScheduledDate();
            if (dateObj instanceof java.sql.Date) d = ((java.sql.Date) dateObj).toLocalDate();
            else d = LocalDate.parse(String.valueOf(dateObj));

            // parse time
            LocalTime t;
            Object timeObj = b.getScheduledTime();
            if (timeObj instanceof java.sql.Time) t = ((java.sql.Time) timeObj).toLocalTime();
            else {
              String ts = String.valueOf(timeObj);
              if (ts.length() > 5) ts = ts.substring(0, 5);
              t = LocalTime.parse(ts);
            }

            LocalDateTime dt = LocalDateTime.of(d, t);

            // only consider not-cancelled + future/now bookings
            String st = (b.getStatus() == null) ? "" : b.getStatus();
            if (!"CANCELLED".equalsIgnoreCase(st) && !dt.isBefore(now)) {
              if (nextDt == null || dt.isBefore(nextDt)) {
                nextDt = dt;
                nextBooking = b;
              }
            }
          } catch (Exception ignore) {}
        }
      }

      if (nextBooking != null && nextDt != null) {
        long daysLeft = Duration.between(now.toLocalDate().atStartOfDay(), nextDt.toLocalDate().atStartOfDay()).toDays();
        DateTimeFormatter df = DateTimeFormatter.ofPattern("dd MMM yyyy");
        DateTimeFormatter tf = DateTimeFormatter.ofPattern("h:mm a");
    %>

      <div class="next-summary">
        <div class="next-summary-left">
          <p class="next-label">Next appointment</p>
          <h2 class="next-days">
            <%= (daysLeft <= 0 ? "Today" : daysLeft + " days") %>
            <span class="next-small">to your next booking</span>
          </h2>
          <p class="next-meta">
            <strong><%= nextBooking.getServiceName() %></strong> • <%= nextBooking.getPackageName() %><br/>
            <%= nextDt.toLocalDate().format(df) %> • <%= nextDt.toLocalTime().format(tf) %>
          </p>
        </div>
      </div>

    <%
      } // end next-summary
    %>

    <%
      // ---------- MAIN LIST ----------
      if (bookings == null || bookings.isEmpty()) {
    %>
      <p class="empty-msg">No upcoming bookings found.</p>
    <%
      } else {
    %>

      <div class="bookings-list">
        <%
          for (BookingDisplayItem b : bookings) {
            String status = (b.getStatus() == null) ? "" : b.getStatus();

            // Determine if the booking time has passed
            boolean isPast = false;
            try {
              LocalDate d;
              Object dateObj = b.getScheduledDate();
              if (dateObj instanceof java.sql.Date) d = ((java.sql.Date) dateObj).toLocalDate();
              else d = LocalDate.parse(String.valueOf(dateObj));

              LocalTime t;
              Object timeObj = b.getScheduledTime();
              if (timeObj instanceof java.sql.Time) t = ((java.sql.Time) timeObj).toLocalTime();
              else {
                String ts = String.valueOf(timeObj);
                if (ts.length() > 5) ts = ts.substring(0, 5);
                t = LocalTime.parse(ts);
              }

              isPast = LocalDateTime.of(d, t).isBefore(LocalDateTime.now());
            } catch (Exception ignore) {}

            boolean cancelled = "CANCELLED".equalsIgnoreCase(status);

            // Tracker steps
            boolean stepPaid = "PAID".equalsIgnoreCase(status);
            boolean stepPending = "PENDING".equalsIgnoreCase(status);

            // treat UPCOMING as: not cancelled + future
            boolean stepUpcoming = !cancelled && !isPast;
            boolean stepCompleted = !cancelled && isPast;

            // Badge class
            String badgeClass = "badge-default";
            if ("PENDING".equalsIgnoreCase(status)) badgeClass = "badge-pending";
            else if ("PAID".equalsIgnoreCase(status)) badgeClass = "badge-paid";
            else if ("COMPLETED".equalsIgnoreCase(status)) badgeClass = "badge-completed";
            else if ("CANCELLED".equalsIgnoreCase(status)) badgeClass = "badge-cancelled";
        %>

        <div class="booking-card">

          <div class="booking-header">

            <div class="status-tracker <%= cancelled ? "is-cancelled" : "" %>">

              <!-- Step 1: PAYMENT -->
              <div class="track-step <%= stepPaid ? "done" : (stepPending ? "active" : "") %>">
                <span class="dot"></span>
                <span class="label"><%= stepPaid ? "PAID" : "PAYMENT" %></span>
              </div>

              <div class="track-line"></div>

              <!-- Step 2: UPCOMING -->
              <div class="track-step <%= stepUpcoming ? "active" : (stepCompleted ? "done" : "") %>">
                <span class="dot"></span>
                <span class="label">UPCOMING</span>
              </div>

              <div class="track-line"></div>

              <!-- Step 3: COMPLETED -->
              <div class="track-step <%= stepCompleted ? "done" : "" %>">
                <span class="dot"></span>
                <span class="label">COMPLETED</span>
              </div>
            </div>

            <div>
              <p class="booking-title"><%= b.getServiceName() %></p>
              <p class="booking-sub"><%= b.getPackageName() %></p>
            </div>

            <span class="status-badge <%= badgeClass %>"><%= status %></span>
          </div>

          <div class="booking-grid">
            <div><span class="label">Date</span><span class="value"><%= b.getScheduledDate() %></span></div>
            <div><span class="label">Time</span><span class="value"><%= b.getScheduledTime() %></span></div>
            <div><span class="label">Caretaker</span>
              <span class="value"><%= (b.getCaretakerName() == null ? "-" : b.getCaretakerName()) %></span>
            </div>
            <div><span class="label">Booking ID</span><span class="value">#<%= b.getBookingId() %></span></div>
          </div>

          <div class="actions">
            <form method="post" action="<%=request.getContextPath()%>/bookings/cancel">
              <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>" />
              <button class="btn btn-danger" type="submit"
                      onclick="return confirm('Cancel this booking?');">Cancel</button>
            </form>

            <a class="btn btn-ghost"
               href="<%=request.getContextPath()%>/public/bookingDetails.jsp?booking_id=<%= b.getBookingId() %>">
              View Details
            </a>
          </div>

        </div>

        <%
          } // end for
        %>
      </div>

    <%
      } // end else
    %>

  </main>

  <%@ include file="assets/components/footer.jsp"%>
</body>
</html>
