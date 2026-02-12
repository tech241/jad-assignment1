/*
 * package servlets;
 * 
 * import jakarta.servlet.ServletException; import
 * jakarta.servlet.annotation.WebServlet; import
 * jakarta.servlet.http.HttpServlet; import
 * jakarta.servlet.http.HttpServletRequest; import
 * jakarta.servlet.http.HttpServletResponse; import java.io.IOException;
 * 
 *//**
	 * Servlet implementation class StripePaymentSuccessServlet
	 */
/*
 * @WebServlet("/StripePaymentSuccessServlet") public class
 * StripePaymentSuccessServlet extends HttpServlet { private static final long
 * serialVersionUID = 1L;
 * 
 *//**
	 * @see HttpServlet#HttpServlet()
	 */
/*
 * public StripePaymentSuccessServlet() { super(); // TODO Auto-generated
 * constructor stub }
 * 
 *//**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
/*
 * protected void doGet(HttpServletRequest request, HttpServletResponse
 * response) throws ServletException, IOException { // TODO Auto-generated
 * method stub
 * response.getWriter().append("Served at: ").append(request.getContextPath());
 * }
 * 
 *//**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 *//*
		 * protected void doPost(HttpServletRequest request, HttpServletResponse
		 * response) throws ServletException, IOException { // TODO Auto-generated
		 * method stub doGet(request, response); }
		 * 
		 * }
		 */


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

@WebServlet("/payment-success")
public class StripePaymentSuccessServlet extends HttpServlet {

    private final serviceCategoryDAO categoryDAO = new serviceCategoryDAO();
    private final serviceDAO serviceDAO = new serviceDAO();
    private final bookingDAO bookingDAO = new bookingDAO();

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
                
                // Get bookings that were likely just paid (within last 30 min)
                // We show the first few upcoming bookings which should include just-paid ones
                if (upcomingBookings != null && !upcomingBookings.isEmpty()) {
                    // Show first 3 upcoming bookings as they're likely the ones just paid
                    int count = Math.min(3, upcomingBookings.size());
                    for (int i = 0; i < count; i++) {
                        recentBookings.add(upcomingBookings.get(i));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Calculate total amount paid (from all bookings in list)
            BigDecimal totalPaid = BigDecimal.ZERO;
            for (BookingDisplayItem booking : recentBookings) {
                totalPaid = totalPaid.add(booking.getPrice());
            }

            // Pass error or success message
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
}
