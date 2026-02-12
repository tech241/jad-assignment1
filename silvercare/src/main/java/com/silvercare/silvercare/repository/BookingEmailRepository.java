package com.silvercare.silvercare.repository;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.silvercare.silvercare.BookingEmailRow;

import java.util.List;

@Repository
public class BookingEmailRepository {
  private final JdbcTemplate jdbc;

  public BookingEmailRepository(JdbcTemplate jdbc) {
    this.jdbc = jdbc;
  }

  public List<BookingEmailRow> getEmailRowsByPaymentRef(String paymentRef) {
    String sql = """
      SELECT
        b.booking_id,
        m.name AS member_name,
        m.email AS member_email,
        s.service_name,
        c.name AS caretaker_name,
        b.scheduled_date,
        b.scheduled_time,
        b.notes
      FROM booking b
      JOIN member m ON m.id = b.member_id
      JOIN service s ON s.service_id = b.service_id
      LEFT JOIN caretaker c ON c.caretaker_id = b.caretaker_id
      WHERE b.payment_ref = ?
      ORDER BY b.scheduled_date, b.scheduled_time, b.booking_id
    """;

    return jdbc.query(sql, (rs, rowNum) -> new BookingEmailRow(
        rs.getInt("booking_id"),
        rs.getString("member_name"),
        rs.getString("member_email"),
        rs.getString("service_name"),
        rs.getString("caretaker_name"),
        rs.getDate("scheduled_date").toLocalDate(),
        rs.getTime("scheduled_time").toLocalTime(),
        rs.getString("notes")
    ), paymentRef);
  }

  public boolean isEmailAlreadySent(String paymentRef) {
    String sql = "SELECT COUNT(*) FROM booking WHERE payment_ref = ? AND email_sent_at IS NOT NULL";
    Integer count = jdbc.queryForObject(sql, Integer.class, paymentRef);
    return count != null && count > 0;
  }

  public void markEmailSentNow(String paymentRef) {
    String sql = "UPDATE booking SET email_sent_at = NOW() WHERE payment_ref = ? AND email_sent_at IS NULL";
    jdbc.update(sql, paymentRef);
  }
}
