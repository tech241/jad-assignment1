package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class deleteService
 */
@WebServlet("/deleteService")
public class deleteService extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public deleteService() {
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
		String url = "adminEditService";
		String serviceId = request.getParameter("serviceId");
		int id = (int) session.getAttribute("id");
		
		Runnable deleteService1 = () -> {
			postgresHelper.query("DELETE FROM service WHERE service_id = ?;", null, Integer.parseInt(serviceId));
			try {
				response.sendRedirect("public/adminServices.jsp");
			} catch (Exception e2) {
				System.out.println("Error :" + e2);
			}
		};
		
		postgresHelper.validateAdmin(session, response, url, id, deleteService1);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
