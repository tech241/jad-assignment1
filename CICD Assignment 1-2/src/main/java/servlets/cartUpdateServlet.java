package servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.BookingItem;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;

@WebServlet("/cart/update")
public class cartUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("id") == null) {
            resp.sendRedirect(req.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
            return;
        }

        int index;
        try {
            index = Integer.parseInt(req.getParameter("index"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/cart?errMsg=Invalid cart item.");
            return;
        }

        @SuppressWarnings("unchecked")
        ArrayList<BookingItem> cart = (ArrayList<BookingItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?errMsg=Your cart is empty.");
            return;
        }
        if (index < 0 || index >= cart.size()) {
            resp.sendRedirect(req.getContextPath() + "/cart?errMsg=Cart item not found.");
            return;
        }

        String date = req.getParameter("date");
        String time = req.getParameter("time");
        String notes = req.getParameter("notes");

        // Validate date
        try {
            LocalDate selectedDate = LocalDate.parse(date);
            if (selectedDate.isBefore(LocalDate.now())) {
                resp.sendRedirect(req.getContextPath() + "/cart/edit?index=" + index
                        + "&errMsg=You cannot book a date in the past.");
                return;
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/cart/edit?index=" + index
                    + "&errMsg=Invalid date selected.");
            return;
        }

        // Validate time 
        try {
            LocalTime t = LocalTime.parse(time);
            LocalTime open = LocalTime.of(9, 0);
            LocalTime close = LocalTime.of(18, 0);

            if (t.isBefore(open) || t.isAfter(close)) {
                resp.sendRedirect(req.getContextPath() + "/cart/edit?index=" + index
                        + "&errMsg=Time must be between 09:00 and 18:00.");
                return;
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/cart/edit?index=" + index
                    + "&errMsg=Invalid time selected.");
            return;
        }

        // Update cart item
        BookingItem item = cart.get(index);
        item.date = date;
        item.time = time;
        item.notes = (notes == null ? "" : notes);

        session.setAttribute("cart", cart);
        resp.sendRedirect(req.getContextPath() + "/cart?msg=Booking updated.");
    }
}
