package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class submitFeedback
 */
@WebServlet("/submitFeedback")
public class submitFeedback extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public submitFeedback() {
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
		String url = "feedback";
		int id = (int) session.getAttribute("id");
		int serviceId = Integer.parseInt(request.getParameter("serviceId"));
		int rating = Integer.parseInt(request.getParameter("rating"));
		String comments = request.getParameter("comments");
		
		Runnable submitFeedback1 = () -> {
			postgresHelper.query("INSERT INTO feedback (member_id, service_id, rating, comments) VALUES (?, ?, ?, ?);", null, id, serviceId, rating, comments);
			try {
				response.sendRedirect("public/account.jsp");
			} catch (Exception e2) {
				System.out.println("Error :" + e2);
			}
		};
		
		postgresHelper.validateAccountNoPassword(session, response, url, id, submitFeedback1);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
