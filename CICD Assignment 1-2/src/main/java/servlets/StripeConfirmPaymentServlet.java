/*
 * package servlets;
 * 
 * import jakarta.servlet.ServletException; import
 * jakarta.servlet.annotation.WebServlet; import
 * jakarta.servlet.http.HttpServlet; import
 * jakarta.servlet.http.HttpServletRequest; import
 * jakarta.servlet.http.HttpServletResponse;
 * 
 * import java.io.IOException; import java.net.HttpURLConnection; import
 * java.net.URL; import java.nio.charset.StandardCharsets;
 * 
 * @WebServlet("/stripe/confirm-payment") public class
 * StripeConfirmPaymentServlet extends HttpServlet {
 * 
 * private static final long serialVersionUID = 1L;
 * 
 * @Override protected void doGet(HttpServletRequest request,
 * HttpServletResponse response) throws ServletException, IOException {
 * 
 * String sessionId = request.getParameter("session_id"); if (sessionId == null
 * || sessionId.isBlank()) { response.sendRedirect(request.getContextPath() +
 * "/public/paymentSuccess.jsp?errMsg=Missing Stripe session id."); return; }
 * 
 * try { // Call Spring Boot confirm endpoint URL url = new
 * URL("http://localhost:8081/api/stripe/confirm"); HttpURLConnection con =
 * (HttpURLConnection) url.openConnection(); con.setRequestMethod("POST");
 * con.setRequestProperty("Content-Type", "application/json");
 * con.setDoOutput(true);
 * 
 * String payload = "{\"sessionId\":\"" + escapeJson(sessionId) + "\"}";
 * con.getOutputStream().write(payload.getBytes(StandardCharsets.UTF_8));
 * 
 * int status = con.getResponseCode(); String resBody = new String( (status >=
 * 200 && status < 300 ? con.getInputStream() :
 * con.getErrorStream()).readAllBytes(), StandardCharsets.UTF_8 );
 * 
 * 
 * boolean paid = resBody.contains("\"paymentStatus\":\"paid\""); boolean
 * updated = !resBody.contains("\"updatedBookings\":0");
 * 
 * if (status >= 200 && status < 300 && paid && updated) {
 * 
 * request.getSession().removeAttribute("cart");
 * response.sendRedirect(request.getContextPath() +
 * "/payment-success?okMsg=Payment confirmed!"); } else if (status >= 200 &&
 * status < 300 && paid) {
 * 
 * response.sendRedirect(request.getContextPath() +
 * "/payment-success?okMsg=Payment verified, but booking update not found. Please contact support."
 * ); } else { response.sendRedirect(request.getContextPath() +
 * "/payment-success?errMsg=Payment not confirmed yet. Please refresh in a moment."
 * ); }
 * 
 * } catch (Exception e) { e.printStackTrace();
 * response.sendRedirect(request.getContextPath() +
 * "/public/paymentSuccess.jsp?errMsg=Error confirming payment."); } }
 * 
 * private String escapeJson(String s) { return
 * s.replace("\\", "\\\\").replace("\"", "\\\""); } }
 */

package servlets;

import dao.bookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@WebServlet("/stripe/confirm-payment")
public class StripeConfirmPaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final bookingDAO bookingDAO = new bookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sessionId = request.getParameter("session_id");
        if (sessionId == null || sessionId.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/payment-success?errMsg=Missing Stripe session id.");
            return;
        }

        try {
            // Call Spring Boot confirm endpoint
            URL url = new URL("http://localhost:8081/api/stripe/confirm");
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json");
            con.setDoOutput(true);

            String payload = "{\"sessionId\":\"" + escapeJson(sessionId) + "\"}";
            con.getOutputStream().write(payload.getBytes(StandardCharsets.UTF_8));

            int status = con.getResponseCode();
            String resBody = new String(
                    (status >= 200 && status < 300 ? con.getInputStream() : con.getErrorStream()).readAllBytes(),
                    StandardCharsets.UTF_8
            );

            boolean paid = resBody.contains("\"paymentStatus\":\"paid\"") || resBody.contains("\"paid\":true");

            if (status >= 200 && status < 300 && paid) {
                // update db in jsp
                bookingDAO.markPaidByPaymentRef(sessionId);

                // clear cart to prevent payment twice
                request.getSession().removeAttribute("cart");

                // pass session_id to payment-success so it can load bookings by payment_ref
                response.sendRedirect(request.getContextPath()
                        + "/payment-success?session_id=" + urlEncode(sessionId)
                        + "&okMsg=Payment confirmed!");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/payment-success?session_id=" + urlEncode(sessionId)
                        + "&errMsg=Payment not confirmed yet. Please refresh in a moment.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/payment-success?session_id=" + urlEncode(sessionId)
                    + "&errMsg=Error confirming payment.");
        }
    }

    private String escapeJson(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private String urlEncode(String s) {
        try {
            return java.net.URLEncoder.encode(s, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return s;
        }
    }
}
