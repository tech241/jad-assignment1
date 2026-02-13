package servlets;

import dao.bookingDAO;
import dao.serviceCategoryDAO;
import dao.serviceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.BookingDisplayItem;
import models.serviceCategory;
import models.serviceNavItem;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Servlet implementation class StripePaymentSuccessServlet
 */
@WebServlet("/payment-success")
public class StripePaymentSuccessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final serviceCategoryDAO categoryDAO = new serviceCategoryDAO();
    private final serviceDAO serviceDAO = new serviceDAO();
    private final bookingDAO bookingDAO = new bookingDAO();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public StripePaymentSuccessServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Integer memberId = (Integer) session.getAttribute("id");

        if (memberId == null) {
            resp.sendRedirect(req.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
            return;
        }

        try {
            // Header nav data
            List<serviceCategory> navCategories = categoryDAO.getAllCategories();
            Map<Integer, List<serviceNavItem>> navServicesByCat = serviceDAO.getNavServicesByCategory();
            req.setAttribute("navCategories", navCategories);
            req.setAttribute("navServicesByCat", navServicesByCat);

            // session id from Stripe redirect
            String sessionId = req.getParameter("session_id");
            if (sessionId == null || sessionId.isBlank()) {
                req.setAttribute("errMsg", "Missing payment session id. Unable to verify payment.");
                req.setAttribute("paymentSuccessful", false);
                req.getRequestDispatcher("/public/paymentSuccess.jsp").forward(req, resp);
                return;
            }

            // Fetch only the bookings linked to this payment
            List<BookingDisplayItem> paidBookings = bookingDAO.getBookingsByPaymentRef(memberId, sessionId);

            // If nothing found, show error (helping to debugging)
            if (paidBookings == null || paidBookings.isEmpty()) {
                req.setAttribute("errMsg", "No bookings found for this payment session.");
                req.setAttribute("paymentSuccessful", false);
                req.getRequestDispatcher("/public/paymentSuccess.jsp").forward(req, resp);
                return;
            }

            // Total paid (based on DB prices for those bookings)
            BigDecimal totalPaid = BigDecimal.ZERO;
            for (BookingDisplayItem b : paidBookings) {
                if (b.getPrice() != null) totalPaid = totalPaid.add(b.getPrice());
            }
            BigDecimal gst = totalPaid.multiply(new BigDecimal("0.09")).setScale(2, java.math.RoundingMode.HALF_UP);
            BigDecimal grandTotal = totalPaid.add(gst).setScale(2, java.math.RoundingMode.HALF_UP);

            req.setAttribute("subtotal", totalPaid);
            req.setAttribute("gst", gst);
            req.setAttribute("totalPaid", grandTotal);
            req.setAttribute("recentBookings", paidBookings);

            // Messages (optional)
            req.setAttribute("errMsg", req.getParameter("errMsg"));
            req.setAttribute("okMsg", req.getParameter("okMsg"));

            req.setAttribute("paymentSuccessful", true);

            req.getRequestDispatcher("/public/paymentSuccess.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Failed to load payment success page.");
        }
    }


    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
