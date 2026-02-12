package com.silvercare.silvercare.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/test")
public class TestMailController {

    private final JavaMailSender sender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    public TestMailController(JavaMailSender sender) {
        this.sender = sender;
    }

    @GetMapping("/mail")
    public String sendTest(@RequestParam String to) {
        SimpleMailMessage msg = new SimpleMailMessage();
        msg.setTo(to);
        msg.setFrom(fromEmail); // now defined
        msg.setSubject("Test email from SilverCare");
        msg.setText("If you received this, SMTP works.");
        sender.send(msg);
        return "sent";
    }
}
