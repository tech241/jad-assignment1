package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import java.util.function.BiConsumer;
import java.sql.*;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class login
 */
@WebServlet("/login")
public class login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public login() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		String nameOrEmail = request.getParameter("name-or-email");
		String password = request.getParameter("password");
		String rememberMe = request.getParameter("remember-me");
		
		BiConsumer<ResultSet, Integer> process = (rs, index) -> {
			if (rs != null) {
				try {
					int id = rs.getInt("id");
					String name = rs.getString("name");
					String email = rs.getString("email");
					String password2 = rs.getString("password");
					String role = rs.getString("role");
					
					if (bcryptHelper.check(password, password2)) {
						HttpSession session = request.getSession();
						
						session.setAttribute("id", id);
						session.setAttribute("name", name);
						session.setAttribute("email", email);
						session.setAttribute("role", role);
						
						response.sendRedirect("public/account.jsp");
					} else {
						response.sendRedirect("public/login.jsp?errMsg=Wrong password.");
					}
				} catch (Exception e) {
					try {
						response.sendRedirect("public/login.jsp?errMsg=An unknown error occured.");
						System.out.println("Error :" + e);
					} catch (Exception e1) {
						System.out.println("Error :" + e1);
					}
				}
			} else {
				try {
					// query does not give response
					response.sendRedirect("public/login.jsp?errMsg=Member does not exist.");
				} catch (Exception e1) {
					System.out.println("Error :" + e1);
				}
			}
		};
		
		// check if nameOrEmail is email
		// otherwise verify by name
		if (nameOrEmail.startsWith("@") || nameOrEmail.endsWith("@") || !nameOrEmail.contains("@")) {
			postgresHelper.query("SELECT * FROM member WHERE name = ?", process, nameOrEmail);
		} else {
			postgresHelper.query("SELECT * FROM member WHERE email = ?", process, nameOrEmail);
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
