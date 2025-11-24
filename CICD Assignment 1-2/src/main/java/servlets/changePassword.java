package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class changePassword
 */
@WebServlet("/changePassword")
public class changePassword extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public changePassword() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());

		HttpSession session = request.getSession();
		String url = "changePassword";
		int id = (int) session.getAttribute("id");
		String password = request.getParameter("password");
		String newPassword = request.getParameter("new-password");
		String confirmPassword = request.getParameter("confirm-password");
		
		Runnable editDetails1 = () -> {
			postgresHelper.query("UPDATE member SET password = ? WHERE id = ?", null, bcryptHelper.hash(newPassword), id);
			try {
				response.sendRedirect("public/account.jsp");
			} catch (Exception e2) {
				System.out.println("Error :" + e2);
			}
		};
		
		if (newPassword == null || !newPassword.equals(confirmPassword)) {
			response.sendRedirect("public/changePassword.jsp?errMsg=Passwords do not match.");
		} else {
			postgresHelper.validateAccount(session, response, url, id, password, editDetails1);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
