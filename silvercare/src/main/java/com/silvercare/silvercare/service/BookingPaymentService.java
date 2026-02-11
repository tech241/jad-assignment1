package com.silvercare.silvercare.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class BookingPaymentService {

    private final JdbcTemplate jdbc;

    public BookingPaymentService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public int markPaidBySessionId(String sessionId) {
        String sql = """
            UPDATE booking
            SET status = 'PAID',
                paid_at = NOW()
            WHERE payment_ref = ?
        """;
        return jdbc.update(sql, sessionId);
    }

    public int markCancelledBySessionId(String sessionId) {
        String sql = """
            UPDATE booking
            SET status = 'CANCELLED'
            WHERE payment_ref = ?
              AND status = 'PENDING'
        """;
        return jdbc.update(sql, sessionId);
    }
}
