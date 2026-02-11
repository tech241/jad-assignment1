package servlets;

import dao.serviceCategoryDAO;
import dao.serviceDAO;
import dao.servicePackageDAO;
import models.service;
import models.serviceCategory;
import models.serviceNavItem;
import models.servicePackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/services/details")
public class serviceDetailsServlet extends HttpServlet {

    private final serviceCategoryDAO categoryDAO = new serviceCategoryDAO();
    private final serviceDAO serviceDAO = new serviceDAO();
    private final servicePackageDAO packageDAO = new servicePackageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String serviceIdStr = request.getParameter("service_id");
        int serviceId;

        try {
            serviceId = Integer.parseInt(serviceIdStr);
        } catch (Exception e) {
            response.sendError(400, "Invalid or missing service_id");
            return;
        }

        try {
            // header data
            List<serviceCategory> navCategories = categoryDAO.getAllCategories();
            Map<Integer, List<serviceNavItem>> navServicesByCat = serviceDAO.getNavServicesByCategory();

            // page data
            service svc = serviceDAO.getServiceById(serviceId);
            if (svc == null) {
                response.sendError(404, "Service not found");
                return;
            }

            List<servicePackage> packages = packageDAO.getPackagesByServiceId(serviceId);

            request.setAttribute("navCategories", navCategories);
            request.setAttribute("navServicesByCat", navServicesByCat);

            request.setAttribute("service", svc);
            request.setAttribute("packages", packages);

            request.getRequestDispatcher("/public/serviceDetails.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Failed to load service details.");
        }
    }
}
