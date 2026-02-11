package servlets;

import dao.serviceCategoryDAO;
import dao.serviceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.BookingItem;
import models.serviceCategory;
import models.serviceNavItem;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/checkout")
public class checkoutServlet extends HttpServlet {

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

        @SuppressWarnings("unchecked")
        ArrayList<BookingItem> cart = (ArrayList<BookingItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?errMsg=Your cart is empty.");
            return;
        }

        try {
            // Header nav data (for header.jsp)
            List<serviceCategory> navCategories = categoryDAO.getAllCategories();
            Map<Integer, List<serviceNavItem>> navServicesByCat = serviceDAO.getNavServicesByCategory();
            req.setAttribute("navCategories", navCategories);
            req.setAttribute("navServicesByCat", navServicesByCat);

            // Compute total
            BigDecimal total = BigDecimal.ZERO;
            for (BookingItem item : cart) {
                if (item.price != null && !item.price.isBlank()) {
                    try {
                        total = total.add(new BigDecimal(item.price.trim()));
                    } catch (Exception ignore) {
                        // skip invalid price values
                    }
                }
            }

            req.setAttribute("cart", cart);
            req.setAttribute("total", total);

            req.getRequestDispatcher("/public/checkout.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Failed to load checkout.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // If someone POSTs to /checkout by accident, just show the page
        resp.sendRedirect(req.getContextPath() + "/checkout");
    }
}
