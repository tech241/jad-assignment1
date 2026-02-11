package servlets;

import dao.serviceCategoryDAO;
import dao.serviceDAO;
import models.service;
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

@WebServlet("/services/category")
public class serviceListServlet extends HttpServlet {

    private final serviceCategoryDAO categoryDAO = new serviceCategoryDAO();
    private final serviceDAO serviceDAO = new serviceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String catIdStr = request.getParameter("cat_id");
        int catId;

        try {
            catId = Integer.parseInt(catIdStr);
        } catch (Exception e) {
            response.sendError(400, "Invalid or missing cat_id");
            return;
        }

        try {
            // header data
            List<serviceCategory> navCategories = categoryDAO.getAllCategories();
            Map<Integer, List<serviceNavItem>> navServicesByCat = serviceDAO.getNavServicesByCategory();

            // page data
            serviceCategory category = categoryDAO.getCategoryById(catId);
            if (category == null) {
                response.sendError(404, "Category not found");
                return;
            }

            List<service> services = serviceDAO.getServicesByCategory(catId);

            request.setAttribute("navCategories", navCategories);
            request.setAttribute("navServicesByCat", navServicesByCat);

            request.setAttribute("category", category);
            request.setAttribute("services", services);

            request.getRequestDispatcher("/public/serviceList.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Failed to load services for category.");
        }
    }
}
