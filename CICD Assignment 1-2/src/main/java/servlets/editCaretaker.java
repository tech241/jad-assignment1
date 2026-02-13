package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Caretaker;

import java.io.IOException;
import java.util.ArrayList;

import dao.caretakerDAO;

/**
 * Servlet implementation class editService
 */
@WebServlet("/public/editCaretaker")
public class editCaretaker extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editCaretaker() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());

		String role = (String) request.getSession().getAttribute("role");
		if (role == null || !role.equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/public/403.jsp");
            return;
        }

        try {
            // header nav data
        	Caretaker caretaker = new Caretaker();
        	caretaker.setCaretakerId(Integer.parseInt(request.getParameter("caretakerId")));
        	caretaker.setName(request.getParameter("name"));
        	caretaker.setEmail(request.getParameter("email"));
        	caretaker.setPhone(request.getParameter("phone"));
        	caretaker.setBio(request.getParameter("bio"));
        	caretaker.setExperienceYears(Integer.parseInt(request.getParameter("experienceYears")));
        	if (request.getParameter("imageUrl") != null) {
        		caretaker.setImageUrl(request.getParameter("imageUrl"));
        	}
            int nrow = new caretakerDAO().updateCaretakerById(caretaker);
            request.setAttribute("nrow", nrow);
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
