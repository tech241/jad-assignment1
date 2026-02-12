package servlets;

import dao.bookingDAO;
import models.BookingItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalTime;
import java.util.ArrayList;

@WebServlet("/stripe/create-checkout-session")
public class StripeCreateCheckoutSessionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private bookingDAO bookingDAO = new bookingDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {

            Object idObj = session.getAttribute("id");
            if (idObj == null) {
                response.sendRedirect(request.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
                return;
            }
            int memberId = Integer.parseInt(idObj.toString());

            @SuppressWarnings("unchecked")
            ArrayList<BookingItem> cart =
                    (ArrayList<BookingItem>) session.getAttribute("cart");

            if (cart == null || cart.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart?errMsg=Your cart is empty.");
                return;
            }

            ArrayList<Integer> bookingIds = new ArrayList<>();
            long totalCents = 0;

            // checking again before inserting bookings into database to ensure booked at correct time
            for (BookingItem item : cart) {

                int serviceId = Integer.parseInt(item.serviceId);
                int packageId = Integer.parseInt(item.packageId);

                int durationMin = bookingDAO.getPackageDurationMinutes(packageId);

                LocalTime start = LocalTime.parse(item.time); // "HH:mm"
                LocalTime end = start.plusMinutes(durationMin);

                Integer preferredCaretakerId = null;
                if (item.caretaker != null && !item.caretaker.isBlank()) {
                    try {
                        preferredCaretakerId = Integer.parseInt(item.caretaker);
                    } catch (Exception ignore) {
                        preferredCaretakerId = null;
                    }
                }

                Integer assignedCaretaker = bookingDAO.findAnyAvailableCaretaker(
                        serviceId,
                        Date.valueOf(item.date),
                        Time.valueOf(start),
                        Time.valueOf(end),
                        preferredCaretakerId
                );

                if (assignedCaretaker == null) {
                    response.sendRedirect(request.getContextPath()
                            + "/cart?errMsg=One of your selected slots is no longer available. Please re-check availability.");
                    return;
                }

                // ✅ update item caretaker to the final assigned caretaker (supports multiple caretakers per slot)
                item.caretaker = String.valueOf(assignedCaretaker);

                // Now insert booking
                int bookingId = bookingDAO.createBookingReturnId(memberId, item);
                bookingIds.add(bookingId);

                String priceStr = (item.price == null ? "0" : item.price.trim());
                BigDecimal price = new BigDecimal(priceStr);
                totalCents += price.multiply(new BigDecimal("100")).longValue();
            }

            String payloadJson = "{"
                    + "\"amountCents\":" + totalCents + ","
                    + "\"currency\":\"sgd\","
                    + "\"bookingIds\":\"" + bookingIds.toString() + "\""
                    + "}";

            @SuppressWarnings("deprecation")
            URL url = new URL("http://localhost:8081/api/stripe/checkout-session");
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);
            con.getOutputStream().write(payloadJson.getBytes(StandardCharsets.UTF_8));

            String resJson = new String(con.getInputStream().readAllBytes(), StandardCharsets.UTF_8);

            String sessionId = extractJsonValue(resJson, "sessionId");
            String checkoutUrl = extractJsonValue(resJson, "url");

            for (int bid : bookingIds) {
                bookingDAO.setPaymentRef(bid, sessionId);
            }

            response.sendRedirect(checkoutUrl);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/checkout?errMsg=Payment initialization failed.");
        }
    }

    private String extractJsonValue(String json, String key) {
        String pattern = "\"" + key + "\":\"";
        int i = json.indexOf(pattern);
        if (i < 0) return null;
        int start = i + pattern.length();
        int end = json.indexOf("\"", start);
        return end > start ? json.substring(start, end) : null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
