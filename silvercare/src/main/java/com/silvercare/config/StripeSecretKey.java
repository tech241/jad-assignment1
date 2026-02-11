package com.silvercare.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import com.stripe.Stripe;

import jakarta.annotation.PostConstruct;

/* ==================================
* Author: Cedric Mok Yue En
* Class: DIT/2A/21
* Description: ST0510 Pract7 - part 3
* ===================================
*/

/*
 * public class StripeSecretKey { // create key; String secretKey =
 * System.getenv("SecretKey");
 * 
 * @PostConstruct public void key() { Stripe.apiKey = secretKey; }
 * 
 * }
 */
@Configuration
public class StripeSecretKey {

    @Value("${stripe.secretKey:}")
    private String secretKeyFromProps;

    @PostConstruct
    public void init() {
    	String envKey = System.getenv("STRIPE_SECRET_KEY");
        String keyToUse = (envKey != null && !envKey.isBlank()) ? envKey : secretKeyFromProps;

        Stripe.apiKey = keyToUse;

        System.out.println("StripeSecretKey loaded. keyPresent=" + (keyToUse != null && !keyToUse.isBlank()));
    }
}