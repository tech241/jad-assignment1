package servlets;

import dao.caretakerDAO;
import dao.serviceCategoryDAO;
import dao.serviceDAO;
import dao.servicePackageDAO;

import models.BookingItem;
import models.CaretakerOption;
import models.serviceCategory;
import models.serviceNavItem;
import models.servicePackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/cart/add")
public class CartAddServlet extends HttpServlet {

    private final serviceCategoryDAO categoryDAO = new serviceCategoryDAO();
    private final serviceDAO serviceDAO = new serviceDAO();

    private final servicePackageDAO packageDAO = new servicePackageDAO();
    private final caretakerDAO caretakerDAO = new caretakerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("id") == null) {
            resp.sendRedirect(req.getContextPath()
                    + "/public/login.jsp?errMsg=You must be logged in to make a booking.");
            return;
        }

        String packageIdStr = req.getParameter("package_id");
        String serviceIdStr = req.getParameter("service_id");

        int packageId, serviceId;
        try {
            packageId = Integer.parseInt(packageIdStr);
            serviceId = Integer.parseInt(serviceIdStr);
        } catch (Exception e) {
            resp.sendError(400, "Invalid package_id or service_id");
            return;
        }

        try {
            // header nav
            List<serviceCategory> navCategories = categoryDAO.getAllCategories();
            Map<Integer, List<serviceNavItem>> navServicesByCat = serviceDAO.getNavServicesByCategory();
            req.setAttribute("navCategories", navCategories);
            req.setAttribute("navServicesByCat", navServicesByCat);

            // page data
            servicePackage pkg = packageDAO.getPackageSummary(packageId);
            if (pkg == null) {
                resp.sendError(404, "Package not found");
                return;
            }

            List<CaretakerOption> caretakers = caretakerDAO.getCaretakersForService(serviceId);

            req.setAttribute("pkg", pkg);
            req.setAttribute("serviceId", serviceId);
            req.setAttribute("caretakers", caretakers);

            // pass errMsg if any
            req.getRequestDispatcher("/public/bookings.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Failed to load booking form.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("id") == null) {
            resp.sendRedirect(req.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
            return;
        }

        String packageIdStr = req.getParameter("package_id");
        String serviceIdStr = req.getParameter("service_id");
        String date = req.getParameter("date");
        String time = req.getParameter("time");
        String caretaker = req.getParameter("caretaker_id");
        String notes = req.getParameter("notes");

        int packageId, serviceId;
        try {
            packageId = Integer.parseInt(packageIdStr);
            serviceId = Integer.parseInt(serviceIdStr);
        } catch (Exception e) {
            resp.sendError(400, "Invalid package_id or service_id");
            return;
        }

        // validate date
        try {
            LocalDate selectedDate = LocalDate.parse(date);
            if (selectedDate.isBefore(LocalDate.now())) {
                resp.sendRedirect(req.getContextPath() + "/cart/add?package_id=" + packageId + "&service_id=" + serviceId
                        + "&errMsg=You cannot book a date in the past.");
                return;
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/cart/add?package_id=" + packageId + "&service_id=" + serviceId
                    + "&errMsg=Invalid date selected.");
            return;
        }

        try {
            servicePackage pkg = packageDAO.getPackageSummary(packageId);
            if (pkg == null) {
                resp.sendError(404, "Package not found");
                return;
            }

            BookingItem item = new BookingItem();
            item.packageId = String.valueOf(packageId);
            item.serviceId = String.valueOf(serviceId);
            item.date = date;
            item.time = time;
            item.notes = (notes == null ? "" : notes);
            item.caretaker = caretaker;

            item.serviceName = pkg.getServiceName();
            item.packageName = pkg.getPackageName();
            item.price = String.format("%.2f", pkg.getPrice());

            @SuppressWarnings("unchecked")
            ArrayList<BookingItem> cart = (ArrayList<BookingItem>) req.getSession().getAttribute("cart");
            if (cart == null) cart = new ArrayList<>();
            cart.add(item);
            req.getSession().setAttribute("cart", cart);

            resp.sendRedirect(req.getContextPath() + "/cart");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Failed to add item to cart.");
        }
    }
}
