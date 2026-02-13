package servlets;

import dao.bookingDAO;
import dao.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/submitFeedback")
public class submitFeedback extends HttpServlet {
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Use POST");
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("id") == null) {
      response.sendRedirect(request.getContextPath() + "/public/login.jsp?errMsg=" + enc("Please log in first."));
      return;
    }

    int memberId = (int) session.getAttribute("id");

    // ---- Read + validate inputs ----
    Integer bookingId = toInt(request.getParameter("bookingId"));
    Integer rating = toInt(request.getParameter("rating"));
    String comments = request.getParameter("comments");

    if (bookingId == null) {
      response.sendRedirect(request.getContextPath() + "/public/feedback.jsp?errMsg=" + enc("Missing booking ID."));
      return;
    }

    if (rating == null || rating < 1 || rating > 5) {
      response.sendRedirect(request.getContextPath() + "/public/feedback.jsp?booking_id=" + bookingId +
          "&errMsg=" + enc("Rating must be between 1 and 5."));
      return;
    }

    if (comments != null && comments.length() > 1000) {
      response.sendRedirect(request.getContextPath() + "/public/feedback.jsp?booking_id=" + bookingId +
          "&errMsg=" + enc("Comments too long (max 1000 characters)."));
      return;
    }

    // ---- DAO calls (no ResultSet in servlet) ----
    bookingDAO bdao = new bookingDAO();
    FeedbackDAO fdao = new FeedbackDAO();

    // Booking must belong to this member
    Integer serviceId = bdao.getServiceIdForMemberBooking(bookingId, memberId);
    if (serviceId == null) {
      response.sendRedirect(request.getContextPath() + "/bookings/past?errMsg=" + enc("Booking not found."));
      return;
    }

    // Only allow feedback if booking is complete
    String status = bdao.getBookingStatusForMember(bookingId, memberId);
    if (status == null || !status.equalsIgnoreCase("COMPLETED")) {
      response.sendRedirect(request.getContextPath() + "/bookings/past?errMsg=" +
          enc("You can only leave feedback after the booking is completed."));
      return;
    }

    // Prevent feedback that is duplicate
    if (fdao.feedbackExistsForBooking(bookingId)) {
      response.sendRedirect(request.getContextPath() + "/bookings/past?errMsg=" +
          enc("Feedback already submitted for this booking."));
      return;
    }

    // inserting the feedback
    boolean ok = fdao.insertFeedback(memberId, serviceId, bookingId, rating, comments);
    if (!ok) {
      response.sendRedirect(request.getContextPath() + "/public/feedback.jsp?booking_id=" + bookingId +
          "&errMsg=" + enc("Failed to submit feedback."));
      return;
    }

    response.sendRedirect(request.getContextPath() + "/bookings/past?msg=" +
        enc("Thank you! Your feedback has been submitted."));
  }

  private static Integer toInt(String s) {
    if (s == null) return null;
    try { return Integer.parseInt(s.trim()); }
    catch (Exception e) { return null; }
  }

  private static String enc(String s) {
    return URLEncoder.encode(s, StandardCharsets.UTF_8);
  }
}
