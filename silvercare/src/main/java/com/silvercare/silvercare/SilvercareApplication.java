package com.silvercare.silvercare;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication(scanBasePackages = "com.silvercare")
public class SilvercareApplication {
	
	@Value("${test.marker:NOT_LOADED}")
	  private String marker;

	public static void main(String[] args) {
		SpringApplication.run(SilvercareApplication.class, args);
	}

	@Bean
	  CommandLineRunner printMarker() {
	    return args -> System.out.println("PROPERTIES MARKER = " + marker);
	  }
}
