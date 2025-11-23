package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet implementation class signup
 */
@WebServlet("/signup")
public class signup extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public signup() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		
		// check email is valid
		if (email.startsWith("@") || email.endsWith("@") || !email.contains("@")) {
			response.sendRedirect("public/signup.jsp?errMsg=Invalid email.");
		// check passwords match
		} else if (password.equals(confirmPassword)) {
			response.sendRedirect("public/signup.jsp?errMsg=Passwords do not match.");
		// perform sign up
		} else {
			// create an account
			postgresHelper.query("INSERT INTO member (name, email, password) VALUES (?, ?, ?)", null, name, email, bcryptHelper.hash(password));
			
			//
			response.sendRedirect("public/signup.jsp?msg=Signup successful. Please login to the website to get started.");
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
