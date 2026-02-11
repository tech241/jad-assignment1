package com.silvercare.silvercare.controller;

import com.silvercare.silvercare.service.BookingPaymentService;
import com.stripe.model.checkout.Session;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/stripe")
public class StripeConfirmController {

    private final BookingPaymentService bookingPaymentService;

    public StripeConfirmController(BookingPaymentService bookingPaymentService) {
        this.bookingPaymentService = bookingPaymentService;
    }

    @PostMapping("/confirm")
    public Map<String, Object> confirmAndMarkPaid(@RequestBody Map<String, Object> body) throws Exception {
        String sessionId = body.get("sessionId").toString();

        // Stripe.apiKey is already set by StripeSecretKey config
        Session session = Session.retrieve(sessionId);

        boolean paid = "paid".equalsIgnoreCase(session.getPaymentStatus());

        int updated = 0;
        if (paid) {
            updated = bookingPaymentService.markPaidBySessionId(sessionId);
        }

        return Map.of(
                "sessionId", sessionId,
                "paymentStatus", session.getPaymentStatus(),
                "updatedBookings", updated
        );
    }
}
