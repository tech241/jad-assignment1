package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class editService
 */
@WebServlet("/editService")
public class editService extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editService() {
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
		String catId = request.getParameter("catId");
		String serviceName = request.getParameter("serviceName");
		String serviceDescription = request.getParameter("serviceDescription");
		String imagePath = request.getParameter("imagePath");
		int id = (int) session.getAttribute("id");
		
		Runnable editService1 = () -> {
			postgresHelper.query("UPDATE service SET cat_id = ?, service_name = ?, service_description = ?, image_path = ? WHERE service_id = ?;", null, Integer.parseInt(catId), serviceName, serviceDescription, imagePath, Integer.parseInt(serviceId));
			try {
				response.sendRedirect("public/adminServices.jsp");
			} catch (Exception e2) {
				System.out.println("Error :" + e2);
			}
		};
		
		postgresHelper.validateAdmin(session, response, url, id, editService1);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
