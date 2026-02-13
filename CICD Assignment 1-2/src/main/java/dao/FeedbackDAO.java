package dao;

import java.sql.*;

import servlets.postgresHelper;

public class FeedbackDAO {

	public boolean feedbackExistsForBooking(int bookingId) {
		  String sql = "SELECT 1 FROM feedback WHERE booking_id=? LIMIT 1";
		  try (Connection conn = postgresHelper.connect();
		       PreparedStatement ps = conn.prepareStatement(sql)) {
		    ps.setInt(1, bookingId);
		    try (ResultSet rs = ps.executeQuery()) {
		      return rs.next();
		    }
		  } catch (Exception e) {
		    System.out.println("feedbackExistsForBooking error: " + e);
		    return false;
		  }
		}

		public boolean insertFeedback(int memberId, int serviceId, int bookingId, int rating, String comments) {
		  String sql = "INSERT INTO feedback (member_id, service_id, booking_id, rating, comments) VALUES (?,?,?,?,?)";
		  try (Connection conn = postgresHelper.connect();
		       PreparedStatement ps = conn.prepareStatement(sql)) {

		    ps.setInt(1, memberId);
		    ps.setInt(2, serviceId);
		    ps.setInt(3, bookingId);
		    ps.setInt(4, rating);
		    ps.setString(5, comments);

		    return ps.executeUpdate() == 1;
		  } catch (Exception e) {
		    System.out.println("insertFeedback error: " + e);
		    return false;
		  }
		}
}
