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
            try (Connection conn = postgresHelper.connect()) {

                Array careNeedsArray = conn.createArrayOf("text", fCareNeeds);

                postgresHelper.query(
                        "UPDATE member SET name = ?, email = ?, profile_image = ?, phone = ?, address = ?, " +
                                "emergency_contact_name = ?, emergency_contact_phone = ?, " +
                                "residential_area_code = ?, care_needs = ? " +
                                "WHERE id = ?",
                        null,
                        fName,
                        fEmail,
                        fProfileImage,
                        fPhone,
                        fAddress,
                        fEmerName,
                        fEmerPhone,
                        fResCode,
                        careNeedsArray,
                        id
                );

                // update session after db update
                session.setAttribute("name", fName);
                session.setAttribute("email", fEmail);
                session.setAttribute("profile_image", fProfileImage);
                session.setAttribute("phone", fPhone);
                session.setAttribute("address", fAddress);
                session.setAttribute("emergency_contact_name", fEmerName);
                session.setAttribute("emergency_contact_phone", fEmerPhone);
                session.setAttribute("residential_area_code", fResCode);
                session.setAttribute("care_needs", fCareNeeds);

                response.sendRedirect(request.getContextPath() + "/public/account.jsp?msg=Profile updated");

            } catch (Exception e) {
                e.printStackTrace();
                try {
                    response.sendRedirect(request.getContextPath() + "/public/editDetails.jsp?errMsg=Update failed");
                } catch (Exception ignore) {}
            }
        };

        // validate current password before applying changes
        postgresHelper.validateAccount(session, response, url, id, password, editDetailsAction);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // visiting /editDetails directly should open the form
        response.sendRedirect(request.getContextPath() + "/public/editDetails.jsp");
    }
}
