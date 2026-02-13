package servlets;

import dao.bookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/payment-cancel")
public class StripePaymentCancelServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private final bookingDAO bookingDAO = new bookingDAO();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    HttpSession session = req.getSession();
    Integer memberId = (Integer) session.getAttribute("id");
    if (memberId == null) {
      resp.sendRedirect(req.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
      return;
    }

    String sessionId = req.getParameter("session_id");
    if (sessionId == null || sessionId.isBlank()) {
      resp.sendRedirect(req.getContextPath() + "/public/cancelPayment.jsp?errMsg=Missing payment session id.");
      return;
    }

    try {
      // Cancel ONLY pending bookings tied to this payment_ref
      bookingDAO.cancelPendingBookingsByPaymentRef(memberId, sessionId);

      // Optional: clear cart so user doesn't pay duplicates (your call)
      session.removeAttribute("cart");

      req.setAttribute("msg", "Your pending booking slots were released.");
      req.getRequestDispatcher("/public/cancelPayment.jsp").forward(req, resp);
    } catch (Exception e) {
      e.printStackTrace();
      resp.sendRedirect(req.getContextPath() + "/public/cancelPayment.jsp?errMsg=Failed to cancel pending bookings.");
    }
  }
}
