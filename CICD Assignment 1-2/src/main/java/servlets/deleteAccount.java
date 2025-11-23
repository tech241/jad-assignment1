package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.ResultSet;
import java.util.function.BiConsumer;

/**
 * Servlet implementation class deleteAccount
 */
@WebServlet("/deleteAccount")
public class deleteAccount extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public deleteAccount() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		String id = request.getParameter("id");
		String password = request.getParameter("password");
		
		BiConsumer<ResultSet, Integer> process = (rs, index) -> {
			if (rs != null) {
				try {
					String password2 = rs.getString("password");
					
					if (bcryptHelper.check(password, password2)) {
						HttpSession session = request.getSession();
						session.invalidate();
						
						postgresHelper.query("DELETE FROM member WHERE id = ?", null, id);
						response.sendRedirect("public/homepage.jsp");
					} else {
						response.sendRedirect("public/deleteAccount.jsp?errMsg=Wrong password.");
					}
				} catch (Exception e) {
					try {
						response.sendRedirect("public/deleteAccount.jsp?errMsg=An unknown error occured.");
						System.out.println("Error :" + e);
					} catch (Exception e1) {
						System.out.println("Error :" + e1);
					}
				}
			} else {
				try {
					// query does not give response
					response.sendRedirect("public/deleteAccount.jsp?errMsg=Member does not exist.");
				} catch (Exception e1) {
					System.out.println("Error :" + e1);
				}
			}
		};
		
		// check if nameOrEmail is email
		// otherwise verify by name
		
		if (id != null) {
			postgresHelper.query("SELECT password FROM member WHERE id = ?", process, id);
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
