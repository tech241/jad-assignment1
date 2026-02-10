package servlets;

import dao.serviceCategoryDAO;
import dao.serviceDAO;
import models.serviceCategory;
import models.serviceNavItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/services")
public class servicesServlet extends HttpServlet {

    private final serviceCategoryDAO categoryDAO = new serviceCategoryDAO();
    private final serviceDAO serviceDAO = new serviceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Load categories (for page + header)
            List<serviceCategory> categories = categoryDAO.getAllCategories();

            // 2. Load services grouped by category (for header mega menu)
            Map<Integer, List<serviceNavItem>> navServicesByCat =
                    serviceDAO.getNavServicesByCategory();

            // 3. Set request attributes
            request.setAttribute("categories", categories);
            request.setAttribute("navCategories", categories);
            request.setAttribute("navServicesByCat", navServicesByCat);

            // 4. Forward to view
            request.getRequestDispatcher("/public/services.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Failed to load services categories.");
        }
    }
}
