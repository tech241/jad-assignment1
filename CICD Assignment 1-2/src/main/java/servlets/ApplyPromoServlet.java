package servlets;

import dao.PromotionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import models.Promotion;

import java.io.IOException;

@WebServlet("/checkout/apply-promo")
public class ApplyPromoServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("promo_code");
        if (code == null) code = "";
        code = code.trim();
        HttpSession session = req.getSession();

        try {
            PromotionDAO dao = new PromotionDAO();
            Promotion promo = dao.getValidPromoByCode(code);

            if (promo == null) {
                req.getSession().removeAttribute("appliedPromo");
                resp.sendRedirect(req.getContextPath() + "/checkout?errMsg=Invalid or expired promo code.");
                return;
            }
            boolean hasDiscount =
                    promo.getCode() != null &&
                    promo.getDiscountType() != null &&
                    promo.getDiscountValue() > 0;

            if (!hasDiscount) {
                req.getSession().removeAttribute("appliedPromo");
                resp.sendRedirect(req.getContextPath() + "/checkout?errMsg=This promotion is informational only and cannot be applied as a discount.");
                return;
            }
            
            session.setAttribute("flashSuccess", "Promo applied: " + code.toUpperCase());

            // store promo in session
            req.getSession().setAttribute("appliedPromo", promo);
            resp.sendRedirect(req.getContextPath() + "/checkout?msg=Promo applied: " + code.toUpperCase());

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashError", "Invalid or expired promo code.");
            resp.sendRedirect(req.getContextPath() + "/checkout?errMsg=Failed to apply promo.");
        }
    }
}
