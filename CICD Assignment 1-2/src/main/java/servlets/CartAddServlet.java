package servlets;

import dao.caretakerDAO;
import dao.bookingDAO;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalTime;

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
    private final bookingDAO bookingDAO = new bookingDAO();


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

        // 1) validate date
        LocalDate selectedDate;
        try {
            selectedDate = LocalDate.parse(date);
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

        // 2) validate time + availability (duration-based)
        try {
            if (time == null || time.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/cart/add?package_id=" + packageId + "&service_id=" + serviceId
                        + "&errMsg=Please select an available time slot.");
                return;
            }

            int durationMin = bookingDAO.getPackageDurationMinutes(packageId);

            LocalTime start = LocalTime.parse(time); // "HH:mm"
            LocalTime end = start.plusMinutes(durationMin);
            
            if (selectedDate.equals(LocalDate.now())) {
                LocalTime cutoff = LocalTime.now().plusMinutes(15);
                if (!start.isAfter(cutoff)) {
                    resp.sendRedirect(req.getContextPath()
                            + "/cart/add?package_id=" + packageId
                            + "&service_id=" + serviceId
                            + "&errMsg=Please choose a time later today.");
                    return;
                }
            }

            if (start.isBefore(LocalTime.of(9, 0)) || end.isAfter(LocalTime.of(18, 0))) {
                resp.sendRedirect(req.getContextPath() + "/cart/add?package_id=" + packageId + "&service_id=" + serviceId
                        + "&errMsg=Selected time is outside operating hours.");
                return;
            }

            Integer preferredCaretakerId = null;
            if (caretaker != null && !caretaker.isBlank()) {
                preferredCaretakerId = Integer.parseInt(caretaker);
            }

            Integer assignedCaretaker = bookingDAO.findAnyAvailableCaretaker(
                    serviceId,
                    Date.valueOf(selectedDate),
                    Time.valueOf(start),
                    Time.valueOf(end),
                    preferredCaretakerId
            );

            if (assignedCaretaker == null) {
                resp.sendRedirect(req.getContextPath() + "/cart/add?package_id=" + packageId + "&service_id=" + serviceId
                        + "&errMsg=Selected slot is no longer available. Please check availability again.");
                return;
            }

            // auto-assign a caretaker or confirm the one chosen from the dropdown
            caretaker = String.valueOf(assignedCaretaker);
            
            


        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/cart/add?package_id=" + packageId + "&service_id=" + serviceId
                    + "&errMsg=Invalid time selected.");
            return;
        }

        // 3) fetch package + add to cart
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
            item.durationMinutes = pkg.getDurationMinutes();
            
            int caretakerId = Integer.parseInt(caretaker);
            models.CaretakerOption caretakerInfo = caretakerDAO.getCaretakerById(caretakerId);
            if (caretakerInfo != null) {
                item.caretakerName = caretakerInfo.getName();
            }

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
