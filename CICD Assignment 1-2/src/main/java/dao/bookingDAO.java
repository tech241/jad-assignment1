package dao;

import models.BookingItem;
import models.BookingDisplayItem;
import servlets.postgresHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class bookingDAO {

	/*
	 * public int createBooking(int memberId, BookingItem item) throws Exception {
	 * String sql = "INSERT INTO booking " +
	 * "(member_id, service_id, package_id, scheduled_date, scheduled_time, notes, caretaker_id, status) "
	 * + "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";
	 * 
	 * try (Connection conn = postgresHelper.connect(); PreparedStatement ps =
	 * conn.prepareStatement(sql)) {
	 * 
	 * ps.setInt(1, memberId); ps.setInt(2, Integer.parseInt(item.serviceId));
	 * ps.setInt(3, Integer.parseInt(item.packageId)); ps.setDate(4,
	 * java.sql.Date.valueOf(item.date)); ps.setTime(5,
	 * java.sql.Time.valueOf(item.time + ":00")); ps.setString(6, item.notes == null
	 * ? "" : item.notes);
	 * 
	 * if (item.caretaker == null || item.caretaker.trim().isEmpty()) {
	 * ps.setNull(7, Types.INTEGER); } else { ps.setInt(7,
	 * Integer.parseInt(item.caretaker)); }
	 * 
	 * return ps.executeUpdate(); } }
	 */
    public List<BookingDisplayItem> getUpcomingBookings(int memberId) throws Exception {
        String sql =
            "SELECT b.booking_id, s.service_name, p.package_name, " +
            "b.scheduled_date, b.scheduled_time, p.price, b.notes " +
            "FROM booking b " +
            "JOIN service_package p ON b.package_id = p.package_id " +
            "JOIN service s ON b.service_id = s.service_id " +
            "WHERE b.member_id = ? " +
            "AND b.scheduled_date >= CURRENT_DATE " +
            "AND b.status != 'CANCELLED' " +
            "ORDER BY b.scheduled_date ASC, b.scheduled_time ASC";

        List<BookingDisplayItem> list = new ArrayList<>();

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, memberId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    BookingDisplayItem item = new BookingDisplayItem();

                    item.setBookingId(rs.getInt("booking_id"));
                    item.setServiceName(rs.getString("service_name"));
                    item.setPackageName(rs.getString("package_name"));
                    item.setScheduledDate(rs.getDate("scheduled_date").toLocalDate());
                    item.setScheduledTime(rs.getTime("scheduled_time").toLocalTime());
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setNotes(rs.getString("notes"));

                    list.add(item);
                }
            }
        }

        return list;
    }
    public int createBookingReturnId(int memberId, BookingItem item) throws Exception {
        String sql =
          "INSERT INTO booking (member_id, service_id, package_id, scheduled_date, scheduled_time, notes, caretaker_id, status) " +
          "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING') RETURNING booking_id";

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, memberId);
            ps.setInt(2, Integer.parseInt(item.serviceId));
            ps.setInt(3, Integer.parseInt(item.packageId));
            ps.setDate(4, java.sql.Date.valueOf(item.date));
            ps.setTime(5, java.sql.Time.valueOf(item.time + ":00"));
            ps.setString(6, item.notes == null ? "" : item.notes);

            if (item.caretaker == null || item.caretaker.trim().isEmpty()) ps.setNull(7, Types.INTEGER);
            else ps.setInt(7, Integer.parseInt(item.caretaker));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("booking_id");
            }
            throw new Exception("Failed to create booking");
        }
    }
    public void setPaymentRef(int bookingId, String sessionId) throws Exception {
        String sql = "UPDATE booking SET payment_ref = ? WHERE booking_id = ?";
        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        }
    }

    public void markPaidByPaymentRef(String sessionId) throws Exception {
        String sql = "UPDATE booking SET status='PAID', paid_at=NOW() WHERE payment_ref = ?";
        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            ps.executeUpdate();
        }
    }

}
