package com.silvercare.silvercare.controller;

import java.sql.SQLException;
import java.util.ArrayList;
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
import com.silvercare.silvercare.model.*;

@RestController

public class CaretakerController {
	
//	@PostMapping
	@CrossOrigin
	@RequestMapping(method=RequestMethod.GET, path="/api/caretaker", consumes="application/json")
	public ArrayList<Map<String, Object>> getAllCaretakers() throws StripeException {
		try {
			return new CaretakerModel().getCaretaker();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
}