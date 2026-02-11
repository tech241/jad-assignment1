package dao;

import models.BookingItem;
import servlets.postgresHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;

public class bookingDAO {

    public int createBooking(int memberId, BookingItem item) throws Exception {
        String sql = "INSERT INTO booking " +
                "(member_id, service_id, package_id, scheduled_date, scheduled_time, notes, caretaker_id, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            ps.setInt(2, Integer.parseInt(item.serviceId));
            ps.setInt(3, Integer.parseInt(item.packageId));
            ps.setDate(4, java.sql.Date.valueOf(item.date));
            ps.setTime(5, java.sql.Time.valueOf(item.time + ":00"));
            ps.setString(6, item.notes == null ? "" : item.notes);

            if (item.caretaker == null || item.caretaker.trim().isEmpty()) {
                ps.setNull(7, Types.INTEGER);
            } else {
                ps.setInt(7, Integer.parseInt(item.caretaker));
            }

            return ps.executeUpdate();
        }
    }
}
