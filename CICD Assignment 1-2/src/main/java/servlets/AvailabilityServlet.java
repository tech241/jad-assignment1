package servlets;

import dao.bookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.*;
import java.util.*;

@WebServlet("/availability")
public class AvailabilityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private bookingDAO bookingDAO;

    private static final LocalTime OPEN = LocalTime.of(9, 0);
    private static final LocalTime CLOSE = LocalTime.of(18, 0);

    public AvailabilityServlet() {
        super();
        bookingDAO = new bookingDAO();
    }

    private LocalTime roundUpToStep(LocalTime t, int stepMinutes) {
        int minutes = t.getHour() * 60 + t.getMinute();
        int rounded = ((minutes + stepMinutes - 1) / stepMinutes) * stepMinutes; 
        int hr = rounded / 60;
        int min = rounded % 60;
        if (hr >= 24) return LocalTime.of(23, 59); 
        return LocalTime.of(hr, min);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String serviceIdStr = request.getParameter("service_id");
        String packageIdStr = request.getParameter("package_id");
        String dateStr = request.getParameter("date");

        if (serviceIdStr == null || packageIdStr == null || dateStr == null ||
                serviceIdStr.isBlank() || packageIdStr.isBlank() || dateStr.isBlank()) {

            response.sendRedirect(request.getContextPath()
                    + "/cart/add?package_id=" + (packageIdStr == null ? "" : packageIdStr)
                    + "&service_id=" + (serviceIdStr == null ? "" : serviceIdStr)
                    + "&errMsg=Please select a date to check availability.");
            return;
        }

        LocalDate selectedDate;
        try {
            selectedDate = LocalDate.parse(dateStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()
                    + "/cart/add?package_id=" + packageIdStr
                    + "&service_id=" + serviceIdStr
                    + "&errMsg=Invalid date selected.");
            return;
        }

        // block past dates here too 
        if (selectedDate.isBefore(LocalDate.now())) {
            response.sendRedirect(request.getContextPath()
                    + "/cart/add?package_id=" + packageIdStr
                    + "&service_id=" + serviceIdStr
                    + "&errMsg=Please select today or a future date.");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            int packageId = Integer.parseInt(packageIdStr);

            int durationMin = bookingDAO.getPackageDurationMinutes(packageId);
            int stepMinutes = bookingDAO.calculateOptimalInterval(packageId);

            // compute earliest start time (today => now + 15, rounded to step)
            LocalTime earliestStart = OPEN;
            if (selectedDate.equals(LocalDate.now())) {
                LocalTime minStartTime = LocalTime.now().plusMinutes(15);
                if (minStartTime.isBefore(OPEN)) minStartTime = OPEN;
                earliestStart = roundUpToStep(minStartTime, stepMinutes);
            }

            List<String> availableTimes = new ArrayList<>();

            for (LocalTime start = earliestStart; start.isBefore(CLOSE); start = start.plusMinutes(stepMinutes)) {
                LocalTime end = start.plusMinutes(durationMin);
                if (end.isAfter(CLOSE)) break;

                Integer freeCaretaker = bookingDAO.findAnyAvailableCaretaker(
                        serviceId,
                        Date.valueOf(selectedDate),
                        Time.valueOf(start),
                        Time.valueOf(end),
                        null
                );

                if (freeCaretaker != null) {
                    availableTimes.add(start.toString()); // "HH:mm"
                }
            }

            request.setAttribute("availableTimes", availableTimes);
            request.setAttribute("selectedDate", dateStr);

            request.getRequestDispatcher("/cart/add?package_id="
                    + packageIdStr + "&service_id=" + serviceIdStr)
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/cart/add?package_id=" + packageIdStr
                    + "&service_id=" + serviceIdStr
                    + "&errMsg=Failed to load availability.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
