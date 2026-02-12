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
	 * Servlet implementation class cancelBookingServlet
	 */
/*
 * @WebServlet("/cancelBookingServlet") public class cancelBookingServlet
 * extends HttpServlet { private static final long serialVersionUID = 1L;
 * 
 *//**
	 * @see HttpServlet#HttpServlet()
	 */
/*
 * public cancelBookingServlet() { super(); // TODO Auto-generated constructor
 * stub }
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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/bookings/cancel")
public class cancelBookingServlet extends HttpServlet {

    private final bookingDAO bookingDAO = new bookingDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("id") == null) {
            resp.sendRedirect(req.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
            return;
        }

        int memberId = (Integer) session.getAttribute("id");

        String bookingIdStr = req.getParameter("bookingId"); 
        if (bookingIdStr == null) {
            bookingIdStr = req.getParameter("booking_id");
        }

        if (bookingIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/bookings/upcoming?errMsg=Missing booking id.");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);

            boolean ok = bookingDAO.cancelBooking(memberId, bookingId);

            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/bookings/upcoming?msg=Booking cancelled.");
            } else {
                resp.sendRedirect(req.getContextPath() + "/bookings/upcoming?errMsg=Unable to cancel booking.");
            }

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/bookings/upcoming?errMsg=Invalid booking id.");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/bookings/upcoming?errMsg=Error cancelling booking.");
        }
    }
}
