package dao;

import models.BookingItem;
import models.BookingDisplayItem;
import servlets.postgresHelper;

import java.math.BigDecimal;
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
		autoMarkCompletedForPastPaidBookings(memberId);

		String sql =
				  "SELECT b.booking_id, b.scheduled_date, b.scheduled_time, b.status, b.notes, " +
				  "       s.service_name, p.package_name, p.price, c.name AS caretaker_name " +
				  "FROM booking b " +
				  "JOIN service s ON b.service_id = s.service_id " +
				  "JOIN service_package p ON b.package_id = p.package_id " +
				  "LEFT JOIN caretaker c ON b.caretaker_id = c.caretaker_id " +
				  "WHERE b.member_id = ? " +
				  "  AND b.status IN ('PENDING','PAID') " +
				  "  AND (b.scheduled_date > CURRENT_DATE " +
				  "       OR (b.scheduled_date = CURRENT_DATE AND b.scheduled_time >= CURRENT_TIME)) " +
				  "ORDER BY b.scheduled_date ASC, b.scheduled_time ASC";

	    List<BookingDisplayItem> list = new ArrayList<>();

	    Connection conn = postgresHelper.connect();
	    if (conn == null) {
	        throw new Exception("Failed to establish database connection");
	    }
	    try (Connection connection = conn;
	         PreparedStatement ps = connection.prepareStatement(sql)) {

	        ps.setInt(1, memberId);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                BookingDisplayItem item = new BookingDisplayItem();
	                item.setBookingId(rs.getInt("booking_id"));
	                item.setScheduledDate(rs.getDate("scheduled_date").toLocalDate());
	                item.setScheduledTime(rs.getTime("scheduled_time").toLocalTime());
	                item.setStatus(rs.getString("status"));
	                item.setNotes(rs.getString("notes"));

	                item.setServiceName(rs.getString("service_name"));
	                item.setPackageName(rs.getString("package_name"));
	                item.setPrice(rs.getBigDecimal("price")); // or double
	                item.setCaretakerName(rs.getString("caretaker_name"));

	                list.add(item);
	            }
	        }
	    }

	    return list;
	}


	public int createBookingReturnId(int memberId, BookingItem item) throws Exception {
		String sql = "INSERT INTO booking (member_id, service_id, package_id, scheduled_date, scheduled_time, notes, caretaker_id, status) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING') RETURNING booking_id";

		try (Connection conn = postgresHelper.connect(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, memberId);
			ps.setInt(2, Integer.parseInt(item.serviceId));
			ps.setInt(3, Integer.parseInt(item.packageId));
			ps.setDate(4, java.sql.Date.valueOf(item.date));
			ps.setTime(5, java.sql.Time.valueOf(item.time + ":00"));
			ps.setString(6, item.notes == null ? "" : item.notes);

			if (item.caretaker == null || item.caretaker.trim().isEmpty())
				ps.setNull(7, Types.INTEGER);
			else
				ps.setInt(7, Integer.parseInt(item.caretaker));

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return rs.getInt("booking_id");
			}
			throw new Exception("Failed to create booking");
		}
	}

	public void setPaymentRef(int bookingId, String sessionId) throws Exception {
		String sql = "UPDATE booking SET payment_ref = ? WHERE booking_id = ?";
		try (Connection conn = postgresHelper.connect(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, sessionId);
			ps.setInt(2, bookingId);
			ps.executeUpdate();
		}
	}

	public void markPaidByPaymentRef(String sessionId) throws Exception {
		String sql = "UPDATE booking SET status='PAID', paid_at=NOW() WHERE payment_ref = ?";
		try (Connection conn = postgresHelper.connect(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, sessionId);
			ps.executeUpdate();
		}
	}

	public int getPackageDurationMinutes(int packageId) throws Exception {
		String sql = "SELECT duration_minutes FROM service_package WHERE package_id = ?";
		try (Connection conn = postgresHelper.connect(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, packageId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return rs.getInt(1);
			}
		}
		return 60; 
	}

	public List<Integer> getCaretakersForService(int serviceId) throws Exception {
		String sql = "SELECT caretaker_id FROM caretaker_service WHERE service_id = ?";
		List<Integer> ids = new ArrayList<>();
		try (Connection conn = postgresHelper.connect(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, serviceId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next())
					ids.add(rs.getInt(1));
			}
		}
		return ids;
	}

	/**
	 * Checking for overlap in bookings by looking ats existingStart < newEnd AND newStart < existingEnd Existing end
	 * time is computed via existing booking's package duration.
	 */
	public boolean isCaretakerFree(int caretakerId, java.sql.Date date, java.sql.Time newStart, java.sql.Time newEnd)
			throws Exception {

		String sql = """
				SELECT COUNT(*)
				FROM booking b
				JOIN service_package sp ON b.package_id = sp.package_id
				WHERE b.caretaker_id = ?
				AND b.scheduled_date = ?
				AND b.status IN ('PENDING','PAID')
				AND b.scheduled_time < ?
				AND ? < (b.scheduled_time + (sp.duration_minutes || ' minutes')::interval)
				""";

		try (Connection conn = postgresHelper.connect(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, caretakerId);
			ps.setDate(2, date);
			ps.setTime(3, newEnd);
			ps.setTime(4, newStart);

			try (ResultSet rs = ps.executeQuery()) {
				rs.next();
				return rs.getInt(1) == 0;
			}
		}
	}

	/**
	 * Returns an available caretakerId for this time window, or null if none. If
	 * preferredCaretakerId is provided, only checks that caretaker.
	 */
	public Integer findAnyAvailableCaretaker(int serviceId, java.sql.Date date, java.sql.Time start, java.sql.Time end,
			Integer preferredCaretakerId) throws Exception {
		if (preferredCaretakerId != null) {
			return isCaretakerFree(preferredCaretakerId, date, start, end) ? preferredCaretakerId : null;
		}

		for (int cid : getCaretakersForService(serviceId)) {
			if (isCaretakerFree(cid, date, start, end))
				return cid;
		}
		return null;
	}
	public int calculateOptimalInterval(int packageId) throws Exception {
	    int durationMin = getPackageDurationMinutes(packageId);

	    int interval;
	    if (durationMin >= 180) interval = 60;      // 3h packages => 1h steps
	    else if (durationMin >= 120) interval = 30; // 2h packages => 30m steps
	    else interval = 15;                          // shorter packages => 15m steps

	    return interval;
	}
	public List<BookingDisplayItem> getPastBookings(int memberId) throws Exception {
		autoMarkCompletedForPastPaidBookings(memberId);


	    
		String sql =
				  "SELECT b.booking_id, b.scheduled_date, b.scheduled_time, b.status, b.notes, " +
				  "       s.service_name, p.package_name, p.price, c.name AS caretaker_name " +
				  "FROM booking b " +
				  "JOIN service s ON b.service_id = s.service_id " +
				  "JOIN service_package p ON b.package_id = p.package_id " +
				  "LEFT JOIN caretaker c ON b.caretaker_id = c.caretaker_id " +
				  "WHERE b.member_id = ? " +
				  "  AND (b.status IN ('CANCELLED','COMPLETED')) " +
				  "ORDER BY b.scheduled_date DESC, b.scheduled_time DESC";

	    List<BookingDisplayItem> list = new ArrayList<>();

	    try (Connection conn = postgresHelper.connect();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, memberId);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                BookingDisplayItem item = new BookingDisplayItem();
	                item.setBookingId(rs.getInt("booking_id"));
	                item.setScheduledDate(rs.getDate("scheduled_date").toLocalDate());
	                item.setScheduledTime(rs.getTime("scheduled_time").toLocalTime());
	                item.setStatus(rs.getString("status"));
	                item.setNotes(rs.getString("notes"));

	                item.setServiceName(rs.getString("service_name"));
	                item.setPackageName(rs.getString("package_name"));
	                item.setPrice(rs.getBigDecimal("price"));
	                item.setCaretakerName(rs.getString("caretaker_name"));

	                list.add(item);
	            }
	        }
	    }

	    return list;
	}
	public boolean cancelBooking(int memberId, int bookingId) throws Exception {
	    String sql =
	        "UPDATE booking SET status='CANCELLED' " +
	        "WHERE booking_id = ? AND member_id = ? " +
	        "AND status <> 'CANCELLED' " +
	        "AND (scheduled_date > CURRENT_DATE OR (scheduled_date = CURRENT_DATE AND scheduled_time > CURRENT_TIME))";

	    try (Connection conn = postgresHelper.connect();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, bookingId);
	        ps.setInt(2, memberId);

	        return ps.executeUpdate() > 0;
	    }
	}
	public void cancelPendingBookingsByPaymentRef(int memberId, String paymentRef) throws Exception {
	    String sql = "UPDATE booking " +
	                 "SET status = 'CANCELLED' " +
	                 "WHERE member_id = ? AND payment_ref = ? AND status = 'PENDING'";
	    try (Connection conn = postgresHelper.connect();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, memberId);
	        ps.setString(2, paymentRef);
	        ps.executeUpdate();
	    }
	}
	public List<BookingDisplayItem> getBookingsByPaymentRef(int memberId, String paymentRef) throws Exception {

	    String sql =
	        "SELECT b.booking_id, b.scheduled_date, b.scheduled_time, b.status, b.notes, " +
	        "       s.service_name, p.package_name, p.price, c.name AS caretaker_name " +
	        "FROM booking b " +
	        "JOIN service s ON b.service_id = s.service_id " +
	        "JOIN service_package p ON b.package_id = p.package_id " +
	        "LEFT JOIN caretaker c ON b.caretaker_id = c.caretaker_id " +
	        "WHERE b.member_id = ? AND b.payment_ref = ? " +
	        "ORDER BY b.scheduled_date ASC, b.scheduled_time ASC";

	    List<BookingDisplayItem> list = new ArrayList<>();

	    try (Connection conn = postgresHelper.connect();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, memberId);
	        ps.setString(2, paymentRef);

	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                BookingDisplayItem item = new BookingDisplayItem();
	                item.setBookingId(rs.getInt("booking_id"));
	                item.setScheduledDate(rs.getDate("scheduled_date").toLocalDate());
	                item.setScheduledTime(rs.getTime("scheduled_time").toLocalTime());
	                item.setStatus(rs.getString("status"));
	                item.setNotes(rs.getString("notes"));

	                item.setServiceName(rs.getString("service_name"));
	                item.setPackageName(rs.getString("package_name"));
	                item.setPrice(rs.getBigDecimal("price"));
	                item.setCaretakerName(rs.getString("caretaker_name"));

	                list.add(item);
	            }
	        }
	    }

	    return list;
	}
	public boolean markCompleted(int bookingId) throws Exception {
	    String sql = "UPDATE booking SET status='COMPLETED' WHERE booking_id=? AND status='PAID'";
	    try (Connection conn = postgresHelper.connect();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, bookingId);
	        return ps.executeUpdate() > 0;
	    }
	}
	public int autoMarkCompletedForPastPaidBookings(int memberId) throws Exception {
	    String sql =
	        "UPDATE booking " +
	        "SET status = 'COMPLETED' " +
	        "WHERE member_id = ? " +
	        "  AND status = 'PAID' " +
	        "  AND (scheduled_date < CURRENT_DATE " +
	        "       OR (scheduled_date = CURRENT_DATE AND scheduled_time < CURRENT_TIME))";

	    try (Connection conn = postgresHelper.connect();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, memberId);
	        return ps.executeUpdate(); // returns how many rows got updated
	    }
	}
	public void applyPromotionToBooking(int bookingId, String promoCode,
	        BigDecimal originalAmount, BigDecimal discountAmount, BigDecimal finalAmount) throws Exception {

	    String sql = "UPDATE booking SET promo_code=?, original_amount=?, discount_amount=?, final_amount=? WHERE booking_id=?";

	    try (Connection conn = postgresHelper.connect();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setString(1, promoCode);
	        ps.setBigDecimal(2, originalAmount);
	        ps.setBigDecimal(3, discountAmount);
	        ps.setBigDecimal(4, finalAmount);
	        ps.setInt(5, bookingId);

	        ps.executeUpdate();
	    }
	}
	public Integer getServiceIdForMemberBooking(int bookingId, int memberId) {
		  String sql = "SELECT service_id FROM booking WHERE booking_id=? AND member_id=?";
		  try (Connection conn = postgresHelper.connect();
		       PreparedStatement ps = conn.prepareStatement(sql)) {
		    ps.setInt(1, bookingId);
		    ps.setInt(2, memberId);
		    try (ResultSet rs = ps.executeQuery()) {
		      if (rs.next()) return rs.getInt("service_id");
		      return null;
		    }
		  } catch (Exception e) {
		    System.out.println("getServiceIdForMemberBooking error: " + e);
		    return null;
		  }
		}

		public String getBookingStatusForMember(int bookingId, int memberId) {
		  String sql = "SELECT status FROM booking WHERE booking_id=? AND member_id=?";
		  try (Connection conn = postgresHelper.connect();
		       PreparedStatement ps = conn.prepareStatement(sql)) {
		    ps.setInt(1, bookingId);
		    ps.setInt(2, memberId);
		    try (ResultSet rs = ps.executeQuery()) {
		      if (rs.next()) return rs.getString("status");
		      return null;
		    }
		  } catch (Exception e) {
		    System.out.println("getBookingStatusForMember error: " + e);
		    return null;
		  }
		}
		public Integer getServiceIdIfFeedbackEligible(int bookingId, int memberId) {
		    String sql =
		        "SELECT service_id " +
		        "FROM booking " +
		        "WHERE booking_id=? AND member_id=? " +
		        "  AND status='PAID' " +
		        "  AND (scheduled_date < CURRENT_DATE " +
		        "       OR (scheduled_date = CURRENT_DATE AND scheduled_time < CURRENT_TIME))";

		    try (Connection conn = postgresHelper.connect();
		         PreparedStatement ps = conn.prepareStatement(sql)) {

		        ps.setInt(1, bookingId);
		        ps.setInt(2, memberId);

		        try (ResultSet rs = ps.executeQuery()) {
		            if (rs.next()) return rs.getInt("service_id");
		            return null;
		        }
		    } catch (Exception e) {
		        System.out.println("getServiceIdIfFeedbackEligible error: " + e);
		        return null;
		    }
		}

}
