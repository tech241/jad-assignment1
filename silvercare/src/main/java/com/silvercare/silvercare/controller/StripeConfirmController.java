package com.silvercare.silvercare.controller;

import com.silvercare.silvercare.service.BookingPaymentService;
import com.silvercare.silvercare.service.BookingConfirmationEmailService;
import com.stripe.model.checkout.Session;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/stripe")
public class StripeConfirmController {

    private final BookingPaymentService bookingPaymentService;
    private final BookingConfirmationEmailService emailService;

    public StripeConfirmController(BookingPaymentService bookingPaymentService,
                                   BookingConfirmationEmailService emailService) {
        this.bookingPaymentService = bookingPaymentService;
        this.emailService = emailService;
    }

    @PostMapping("/confirm")
    public Map<String, Object> confirmAndMarkPaid(@RequestBody Map<String, Object> body) throws Exception {
        Object sid = body.get("sessionId");
        String sessionId = sid == null ? null : sid.toString();

        if (sessionId == null || sessionId.isBlank()) {
            return Map.of(
                    "paymentStatus", "unknown",
                    "updatedBookings", 0,
                    "emailSent", false,
                    "error", "Missing sessionId"
            );
        }

        Session session = Session.retrieve(sessionId);
        String paymentStatus = session.getPaymentStatus();
        boolean paid = "paid".equalsIgnoreCase(paymentStatus);

        int updated = 0;
        boolean emailSent = false;

        if (paid) {
            updated = bookingPaymentService.markPaidBySessionId(sessionId);

            // Send email only if DB update happened (means bookings exist for this ref)
            if (updated > 0) {
                emailSent = emailService.sendIfNotSentYet(sessionId); // payment_ref = sessionId
                System.out.println("Confirm paid=" + paid + ", updated=" + updated + ", sessionId=" + sessionId);
            }
        }

        return Map.of(
                "sessionId", sessionId,
                "paymentStatus", paymentStatus,
                "updatedBookings", updated,
                "emailSent", emailSent
        );
    }
    
}
