package servlets;

import dao.bookingDAO;
import dao.serviceCategoryDAO;
import dao.serviceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.BookingDisplayItem;
import models.serviceCategory;
import models.serviceNavItem;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/bookings/upcoming")
public class upcomingBookings extends HttpServlet {

    private final bookingDAO bookingDAO = new bookingDAO();
    private final serviceCategoryDAO categoryDAO = new serviceCategoryDAO();
    private final serviceDAO serviceDAO = new serviceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("id") == null) {
            resp.sendRedirect(req.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
            return;
        }

        int memberId = (Integer) session.getAttribute("id");

        try {
            // header nav
            List<serviceCategory> navCategories = categoryDAO.getAllCategories();
            Map<Integer, List<serviceNavItem>> navServicesByCat = serviceDAO.getNavServicesByCategory();
            req.setAttribute("navCategories", navCategories);
            req.setAttribute("navServicesByCat", navServicesByCat);

            // bookings
            List<BookingDisplayItem> bookings = bookingDAO.getUpcomingBookings(memberId);
            req.setAttribute("bookings", bookings);

            req.getRequestDispatcher("/public/upcomingBookings.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Failed to load upcoming bookings.");
        }
    }
}
