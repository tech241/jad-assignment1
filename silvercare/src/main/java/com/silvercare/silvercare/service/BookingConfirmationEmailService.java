package com.silvercare.silvercare.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.silvercare.silvercare.BookingEmailRow;
import com.silvercare.silvercare.repository.BookingEmailRepository;

import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class BookingConfirmationEmailService {

  private final JavaMailSender mailSender;
  private final BookingEmailRepository repo;

  @Value("${app.mail.from:}")
  private String from;

  @Value("${app.mail.replyTo:}")
  private String replyTo;

  public BookingConfirmationEmailService(JavaMailSender mailSender, BookingEmailRepository repo) {
    this.mailSender = mailSender;
    this.repo = repo;
  }

  public boolean sendIfNotSentYet(String paymentRef) {
	    if (paymentRef == null || paymentRef.isBlank()) return false;

	    if (repo.isEmailAlreadySent(paymentRef)) return false;

	    List<BookingEmailRow> rows = repo.getEmailRowsByPaymentRef(paymentRef);
	    if (rows.isEmpty()) return false;

	    BookingEmailRow first = rows.get(0);

	    String subject = "SilverCare: Booking Confirmed (Payment Received)";
	    String body = buildBody(paymentRef, rows);

	    SimpleMailMessage msg = new SimpleMailMessage();
	    msg.setTo(first.memberEmail());

	    // ✅ Ensure FROM is always set to a real email address
	    String fromEmail = (from != null && !from.isBlank()) ? from : "silvercare123main@gmail.com";
	    msg.setFrom(fromEmail);

	    if (replyTo != null && !replyTo.isBlank()) msg.setReplyTo(replyTo);

	    msg.setSubject(subject);
	    msg.setText(body);

	    mailSender.send(msg);
	    repo.markEmailSentNow(paymentRef);

	    System.out.println("Email sent for paymentRef=" + paymentRef + " to=" + first.memberEmail());
	    return true;
	}



  private String buildBody(String paymentRef, List<BookingEmailRow> rows) {
    DateTimeFormatter df = DateTimeFormatter.ofPattern("dd MMM yyyy");
    DateTimeFormatter tf = DateTimeFormatter.ofPattern("HH:mm");

    StringBuilder sb = new StringBuilder();
    sb.append("Hi ").append(rows.get(0).memberName()).append(",\n\n");
    sb.append("Your booking is confirmed and payment has been received.\n");
    sb.append("Payment reference: ").append(paymentRef).append("\n\n");
    sb.append("Booking details:\n");

    for (BookingEmailRow r : rows) {
      sb.append("- Booking #").append(r.bookingId()).append(": ")
        .append(r.serviceName())
        .append(" on ").append(r.scheduledDate() != null ? r.scheduledDate().format(df) : "TBC")
        .append(" at ").append(r.scheduledTime() != null ? r.scheduledTime().format(tf) : "TBC");

      if (r.caretakerName() != null && !r.caretakerName().isBlank()) {
        sb.append(" (Caretaker: ").append(r.caretakerName()).append(")");
      }
      sb.append("\n");

      if (r.notes() != null && !r.notes().isBlank()) {
        sb.append("  Notes: ").append(r.notes()).append("\n");
      }
    }

    sb.append("\nIf you need to make changes, please contact us.\n");
    sb.append("\nRegards,\nSilverCare Team\n");
    return sb.toString();
  }
}
