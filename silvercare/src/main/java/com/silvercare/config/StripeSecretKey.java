package com.silvercare.config;

import com.stripe.Stripe;

import jakarta.annotation.PostConstruct;

/* ==================================
* Author: Cedric Mok Yue En
* Class: DIT/2A/21
* Description: ST0510 Pract7 - part 3
* ===================================
*/

public class StripeSecretKey {
	// create key;
	String secretKey = System.getenv("SecretKey");
	
	@PostConstruct
	public void key() {
		Stripe.apiKey = secretKey;
	}
	
}