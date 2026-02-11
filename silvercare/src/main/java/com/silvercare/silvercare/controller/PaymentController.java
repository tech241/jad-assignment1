package com.silvercare.silvercare.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.CrossOrigin;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;

@RestController

public class PaymentController {
	
//	@PostMapping
	@CrossOrigin
	@RequestMapping(method=RequestMethod.POST, path="/payment", consumes="application/json")
	public Map<String, Object> createPayment(@RequestBody Map<String, Object> request) throws StripeException {
		Stripe.apiKey = System.getenv("SecretKey");
		System.out.print(System.getenv("SecretKey"));
		
		Long amount = Long.parseLong(request.get("amount").toString());
		String currency = request.get("currency").toString();
		
		PaymentIntentCreateParams params = PaymentIntentCreateParams.builder().setAmount(amount).setCurrency(currency).build();
		PaymentIntent intent = PaymentIntent.create(params);
		
		return Map.of("clientSecret", intent.getClientSecret());
	}
	
}