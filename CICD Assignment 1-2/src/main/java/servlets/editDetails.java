package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Array;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/editDetails")
public class editDetails extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String url = "editDetails";

        Object idObj = session.getAttribute("id");
        if (idObj == null) {
            response.sendRedirect(request.getContextPath() + "/public/login.jsp?errMsg=Please log in first.");
            return;
        }
        int id = Integer.parseInt(idObj.toString());

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String profileImage = request.getParameter("profileImage");
        String password = request.getParameter("password");

        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String residentialAreaCode = request.getParameter("residentialAreaCode");
        String emergencyName = request.getParameter("emergencyName");
        String emergencyPhone = request.getParameter("emergencyPhone");

        String[] careNeeds = request.getParameterValues("careNeeds");
        if (careNeeds == null) careNeeds = new String[]{};

        // enhanced fields (stored into care_needs[])
        String careOther = request.getParameter("careOther");
        String mobilityLevel = request.getParameter("mobilityLevel");
        String preferredLanguage = request.getParameter("preferredLanguage");
        String allergies = request.getParameter("allergies");
        String careNotes = request.getParameter("careNotes");
        String emergencyRelation = request.getParameter("emergencyRelation");

        // normalization
        if (phone != null) phone = phone.trim();
        if (residentialAreaCode != null) residentialAreaCode = residentialAreaCode.trim();
        if (emergencyPhone != null) emergencyPhone = emergencyPhone.trim();
        if (name != null) name = name.trim();
        if (email != null) email = email.trim();
        if (profileImage != null) profileImage = profileImage.trim();

        final String fName = name;
        final String fEmail = email;
        final String fPhone = phone;
        final String fAddress = address;
        final String fResCode = residentialAreaCode;
        final String fEmerName = emergencyName;
        final String fEmerPhone = emergencyPhone;
        final String[] fCareNeeds = careNeeds;
        final String fProfileImage = profileImage;

        Runnable editDetailsAction = () -> {
            String sql =
                "UPDATE member SET name = ?, email = ?, profile_image = ?, phone = ?, address = ?, " +
                "emergency_contact_name = ?, emergency_contact_phone = ?, " +
                "residential_area_code = ?, care_needs = ? " +
                "WHERE id = ?";

            try (Connection conn = postgresHelper.connect();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                // Build final care_needs array (checkboxes + enhanced fields)
                java.util.ArrayList<String> needsList = new java.util.ArrayList<>();
                for (String n : fCareNeeds) {
                    if (n != null && !n.trim().isEmpty()) needsList.add(n.trim());
                }

                if (careOther != null && !careOther.trim().isEmpty()) needsList.add("Other: " + careOther.trim());
                if (mobilityLevel != null && !mobilityLevel.trim().isEmpty()) needsList.add("Mobility: " + mobilityLevel.trim());
                if (preferredLanguage != null && !preferredLanguage.trim().isEmpty()) needsList.add("Preferred Communication: " + preferredLanguage.trim());
                if (allergies != null && !allergies.trim().isEmpty()) needsList.add("Allergies: " + allergies.trim());
                if (careNotes != null && !careNotes.trim().isEmpty()) needsList.add("Care Notes: " + careNotes.trim());
                if (emergencyRelation != null && !emergencyRelation.trim().isEmpty()) needsList.add("Emergency Relation: " + emergencyRelation.trim());

                String[] finalNeeds = needsList.toArray(new String[0]);
                Array careNeedsArray = conn.createArrayOf("text", finalNeeds);

                ps.setString(1, fName);
                ps.setString(2, fEmail);
                ps.setString(3, (fProfileImage != null && !fProfileImage.isEmpty()) ? fProfileImage : null);
                ps.setString(4, fPhone);
                ps.setString(5, fAddress);
                ps.setString(6, fEmerName);
                ps.setString(7, fEmerPhone);
                ps.setString(8, fResCode);
                ps.setArray(9, careNeedsArray);
                ps.setInt(10, id);

                int updated = ps.executeUpdate();
                System.out.println("editDetails updated rows = " + updated);

                if (updated <= 0) {
                    response.sendRedirect(request.getContextPath() + "/public/editDetails.jsp?errMsg=No changes saved.");
                    return;
                }

                // update session after DB update (IMPORTANT: use finalNeeds)
                session.setAttribute("name", fName);
                session.setAttribute("email", fEmail);
                session.setAttribute("profile_image", fProfileImage);
                session.setAttribute("phone", fPhone);
                session.setAttribute("address", fAddress);
                session.setAttribute("emergency_contact_name", fEmerName);
                session.setAttribute("emergency_contact_phone", fEmerPhone);
                session.setAttribute("residential_area_code", fResCode);
                session.setAttribute("care_needs", finalNeeds);

                session.setAttribute("successMsg", "Profile updated successfully.");
                response.sendRedirect(request.getContextPath() + "/public/account.jsp");

            } catch (Exception e) {
                e.printStackTrace();
                try {
                    response.sendRedirect(request.getContextPath() + "/public/editDetails.jsp?errMsg=Update failed");
                } catch (Exception ignore) {}
            }
        };

        postgresHelper.validateAccount(session, response, url, id, password, editDetailsAction);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/public/editDetails.jsp");
    }
}
