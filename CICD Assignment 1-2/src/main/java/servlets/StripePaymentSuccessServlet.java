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

            // Fetch recent bookings (within last 30 minutes to show just-paid bookings)
            List<BookingDisplayItem> recentBookings = new ArrayList<>();
            LocalDate today = LocalDate.now(); 

            try {
                List<BookingDisplayItem> upcomingBookings = bookingDAO.getUpcomingBookings(memberId);

                // Show first 3 upcoming bookings first
                if (upcomingBookings != null && !upcomingBookings.isEmpty()) {
                    int count = Math.min(3, upcomingBookings.size());
                    for (int i = 0; i < count; i++) {
                        recentBookings.add(upcomingBookings.get(i));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Calculate total amount paid
            BigDecimal totalPaid = BigDecimal.ZERO;
            for (BookingDisplayItem booking : recentBookings) {
                totalPaid = totalPaid.add(booking.getPrice());
            }

            // Messages
            String errMsg = req.getParameter("errMsg");
            String okMsg = req.getParameter("okMsg");

            req.setAttribute("recentBookings", recentBookings);
            req.setAttribute("totalPaid", totalPaid);
            req.setAttribute("errMsg", errMsg);
            req.setAttribute("okMsg", okMsg);
            req.setAttribute("paymentSuccessful", errMsg == null);

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
