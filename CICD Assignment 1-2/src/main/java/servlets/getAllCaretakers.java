package servlets;

import java.io.IOException;
import java.util.ArrayList;

import dao.caretakerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Caretaker;

/**
 * Servlet implementation class getAllCaretakers
 */
@WebServlet("/public/adminCaretakers")
public class getAllCaretakers extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getAllCaretakers() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		String role = (String) request.getSession().getAttribute("role");
		if (role == null || !role.equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/public/403.jsp");
            return;
        }

        try {
            // header nav data
            ArrayList<Caretaker> caretakers = new caretakerDAO().getCaretakers();
            request.setAttribute("caretakers", caretakers);
            request.getRequestDispatcher("/public/adminCaretakers.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Failed to load cart.");
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
