package servlets;

import dao.PromotionDAO;
import dao.caretakerDAO;
import dao.serviceCategoryDAO;
import dao.serviceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/checkout")
public class checkoutServlet extends HttpServlet {

    private final serviceCategoryDAO categoryDAO = new serviceCategoryDAO();
    private final serviceDAO serviceDAO = new serviceDAO();
    private final caretakerDAO caretakerDAO = new caretakerDAO();
    private final PromotionDAO promoDAO = new PromotionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

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

            // Ensure caretaker names show properly
            for (BookingItem item : cart) {
                if (item.caretakerName == null || item.caretakerName.isEmpty()) {
                    try {
                        int caretakerId = Integer.parseInt(item.caretaker);
                        CaretakerOption c = caretakerDAO.getCaretakerById(caretakerId);
                        item.caretakerName = (c != null ? c.getName() : "Assigned");
                    } catch (Exception e) {
                        item.caretakerName = "Assigned";
                    }
                }
            }

            // Subtotal
            BigDecimal subtotal = BigDecimal.ZERO;
            for (BookingItem item : cart) {
                String priceStr = (item.price == null ? "0" : item.price.trim());
                try {
                    subtotal = subtotal.add(new BigDecimal(priceStr));
                } catch (Exception ignore) {}
            }
            subtotal = subtotal.setScale(2, RoundingMode.HALF_UP);

            // GST + Total
            BigDecimal gst = subtotal.multiply(new BigDecimal("0.09")).setScale(2, RoundingMode.HALF_UP);
            BigDecimal totalWithGst = subtotal.add(gst).setScale(2, RoundingMode.HALF_UP);

            // Promotions to display
            List<Promotion> promos = promoDAO.getCheckoutPromotions();
            req.setAttribute("promos", promos);

            // Applied promo from session
            Promotion applied = (Promotion) session.getAttribute("appliedPromo");

         // Re-fetch from DB so expiry/is_active/start/end/show_checkout are always enforced
         Promotion freshApplied = null;
         try {
             if (applied != null && applied.getCode() != null && !applied.getCode().trim().isEmpty()) {
                 freshApplied = promoDAO.getValidPromoByCode(applied.getCode());
             }
         } catch (Exception ignore) {}

         PromoResult pr = PromoCalculator.compute(freshApplied, totalWithGst);


            if (!pr.ok  && pr.promo != null) {
                session.removeAttribute("appliedPromo");
                req.setAttribute("promoError", pr.message);
                req.setAttribute("appliedPromo", pr.promo);
                req.setAttribute("discount", BigDecimal.ZERO.setScale(2));
                req.setAttribute("finalTotal", totalWithGst);
            } else {
                req.setAttribute("appliedPromo", pr.promo); // can be null in the db tbable
                req.setAttribute("discount", pr.discount);
                req.setAttribute("finalTotal", totalWithGst.subtract(pr.discount).setScale(2, RoundingMode.HALF_UP));
                
                if (pr.promo != null) session.setAttribute("appliedPromo", pr.promo);
            }

            // send everything to JSP
            req.setAttribute("cart", cart);
            req.setAttribute("total", subtotal);
            req.setAttribute("subtotal", subtotal);
            req.setAttribute("gst", gst);
            req.setAttribute("totalWithGst", totalWithGst);

            req.getRequestDispatcher("/public/checkout.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/cart?errMsg=Failed to load checkout.");
        }
    }
}
