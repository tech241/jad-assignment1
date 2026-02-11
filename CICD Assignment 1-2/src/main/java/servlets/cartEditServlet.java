package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.BookingItem;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/cart/edit")
public class cartEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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

        req.setAttribute("item", cart.get(index));
        req.setAttribute("index", index);
        req.getRequestDispatcher("/public/editBooking.jsp").forward(req, resp);
    }
}
