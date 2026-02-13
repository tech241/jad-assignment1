package servlets;

import dao.bookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class cancelBookingServlet
 */
@WebServlet("/bookings/cancel")
public class cancelBookingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private bookingDAO bookingDAO;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public cancelBookingServlet() {
		super();
		bookingDAO = new bookingDAO();
	}

	/**
	 * We don't cancel via GET. If someone tries to open the URL directly,
	 * just send them back to upcoming bookings.
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.sendRedirect(request.getContextPath() + "/bookings/upcoming");
	}

	/**
	 * Handles cancellation via POST.
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("id") == null) {
			response.sendRedirect(request.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
			return;
		}

		int memberId = (Integer) session.getAttribute("id");

		// support both bookingId and booking_id
		String bookingIdStr = request.getParameter("bookingId");
		if (bookingIdStr == null || bookingIdStr.isBlank()) {
			bookingIdStr = request.getParameter("booking_id");
		}

		if (bookingIdStr == null || bookingIdStr.isBlank()) {
			response.sendRedirect(request.getContextPath() + "/bookings/upcoming?errMsg=Missing booking id.");
			return;
		}

		try {
			int bookingId = Integer.parseInt(bookingIdStr);

			boolean ok = bookingDAO.cancelBooking(memberId, bookingId);

			if (ok) {
				response.sendRedirect(request.getContextPath() + "/bookings/upcoming?msg=Booking cancelled.");
			} else {
				response.sendRedirect(request.getContextPath()
						+ "/bookings/upcoming?errMsg=Unable to cancel booking (maybe already cancelled or past).");
			}

		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/bookings/upcoming?errMsg=Invalid booking id.");
		} catch (Exception e) {
			System.out.println("Error cancelling booking: " + e);
			response.sendRedirect(request.getContextPath() + "/bookings/upcoming?errMsg=Error cancelling booking.");
		}
	}
}
