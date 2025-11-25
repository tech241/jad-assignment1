package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class createService
 */
@WebServlet("/createService")
public class createService extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public createService() {
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
		String catId = request.getParameter("catId");
		String serviceName = request.getParameter("serviceName");
		String serviceDescription = request.getParameter("serviceDescription");
		String imagePath = request.getParameter("imagePath");
		int id = (int) session.getAttribute("id");
		
		Runnable createService1 = () -> {
			postgresHelper.query("INSERT INTO service (cat_id, service_name, service_description, image_path) VALUES (?, ?, ?, ?);", null, Integer.parseInt(catId), serviceName, serviceDescription, imagePath);
			try {
				response.sendRedirect("public/adminServices.jsp");
			} catch (Exception e2) {
				System.out.println("Error :" + e2);
			}
		};
		
		postgresHelper.validateAdmin(session, response, url, id, createService1);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
