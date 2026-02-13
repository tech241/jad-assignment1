package servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/checkout/remove-promo")
public class RemovePromoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.getSession().removeAttribute("appliedPromo");
        resp.sendRedirect(req.getContextPath() + "/checkout?msg=Promo removed.");
    }
}
