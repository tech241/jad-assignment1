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
import java.util.List;
import java.util.Map;

/**
 * Servlet implementation class pastBookings
 */
@WebServlet("/bookings/past")
public class pastBookings extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final bookingDAO bookingDAO = new bookingDAO();
    private final serviceCategoryDAO categoryDAO = new serviceCategoryDAO();
    private final serviceDAO serviceDAO = new serviceDAO();

    /**
     * @see HttpServlet#HttpServlet()
     */
    public pastBookings() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false); 
        Integer memberIdObj = (session == null) ? null : (Integer) session.getAttribute("id");

        if (memberIdObj == null) {
            resp.sendRedirect(req.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
            return;
        }

        int memberId = memberIdObj;

        try {
            // header
            List<serviceCategory> navCategories = categoryDAO.getAllCategories();
            Map<Integer, List<serviceNavItem>> navServicesByCat = serviceDAO.getNavServicesByCategory();
            req.setAttribute("navCategories", navCategories);
            req.setAttribute("navServicesByCat", navServicesByCat);

            // bookings
            List<BookingDisplayItem> bookings = bookingDAO.getPastBookings(memberId);
            req.setAttribute("bookings", bookings);

            req.getRequestDispatcher("/public/pastBookings.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load past bookings.");
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
