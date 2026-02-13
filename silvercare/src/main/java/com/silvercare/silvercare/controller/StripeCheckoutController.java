package com.silvercare.silvercare.controller;

import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;

import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/stripe")
public class StripeCheckoutController {

	@PostMapping("/checkout-session")
	public Map<String, String> createCheckoutSession(@RequestBody Map<String, Object> request) throws StripeException {

		// Stripe.apiKey = System.getenv("SecretKey");

		Long amountCents = Long.parseLong(request.get("amountCents").toString());
		String currency = request.get("currency").toString();
		String bookingIds = request.get("bookingIds").toString();

		SessionCreateParams params = SessionCreateParams.builder().setMode(SessionCreateParams.Mode.PAYMENT)
				.setSuccessUrl("http://localhost:8080/CICD_Assignment_1-2/stripe/confirm-payment?session_id={CHECKOUT_SESSION_ID}")
				.setCancelUrl("http://localhost:8080/CICD_Assignment_1-2/payment-cancel?session_id={CHECKOUT_SESSION_ID}")
				.addLineItem(SessionCreateParams.LineItem.builder().setQuantity(1L)
						.setPriceData(SessionCreateParams.LineItem.PriceData.builder().setCurrency(currency)
								.setUnitAmount(amountCents)
								.setProductData(SessionCreateParams.LineItem.PriceData.ProductData.builder()
										.setName("SilverCare Booking Payment").build())
								.build())
						.build())
				.putMetadata("bookingIds", bookingIds).build();

		Session session = Session.create(params);

		return Map.of("url", session.getUrl(), "sessionId", session.getId());
	}
}
