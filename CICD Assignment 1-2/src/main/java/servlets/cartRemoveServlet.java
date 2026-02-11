package servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.BookingItem;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/cart/remove")
public class cartRemoveServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

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
        ArrayList<BookingItem> cart =
                (ArrayList<BookingItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?errMsg=Your cart is empty.");
            return;
        }

        if (index < 0 || index >= cart.size()) {
            resp.sendRedirect(req.getContextPath() + "/cart?errMsg=Cart item not found.");
            return;
        }

        cart.remove(index);
        session.setAttribute("cart", cart);

        resp.sendRedirect(req.getContextPath() + "/cart?msg=Booking removed.");
    }
}
