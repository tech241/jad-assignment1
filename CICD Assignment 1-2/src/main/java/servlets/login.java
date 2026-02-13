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
		
		String nameOrEmail = request.getParameter("name-or-email");
		String password = request.getParameter("password");
		String rememberMe = request.getParameter("remember-me");
		
		BiConsumer<ResultSet, Integer> process = (rs, index) -> {
	        try {
	            if (rs != null) {
	                String password2 = rs.getString("password");

	                if (bcryptHelper.check(password, password2)) {
	                    HttpSession session = request.getSession(true);
	                    postgresHelper.setSessionFromMemberRow(session, rs);

	                    // Redirect after successful login (change to your desired page)
	                    response.sendRedirect(request.getContextPath() + "/public/account.jsp");
	                } else {
	                    response.sendRedirect("public/login.jsp?errMsg=Invalid credentials.");
	                }
	            } else {
	                response.sendRedirect("public/login.jsp?errMsg=Member does not exist.");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            try {
	                response.sendRedirect("public/login.jsp?errMsg=Login failed due to server error.");
	            } catch (IOException ex) {
	                ex.printStackTrace();
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
