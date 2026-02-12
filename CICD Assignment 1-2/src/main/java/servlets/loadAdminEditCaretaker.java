package servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.Response;
import models.BookingItem;
import models.Caretaker;
import models.CaretakerOption;
import models.serviceCategory;
import models.serviceNavItem;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import dao.caretakerDAO;

/**
 * Servlet implementation class getAllCaretakers
 */
@WebServlet("/public/adminEditCaretaker")
public class loadAdminEditCaretaker extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public loadAdminEditCaretaker() {
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
            Caretaker caretaker = new caretakerDAO().getCaretakerById(Integer.parseInt(request.getParameter("caretakerId")));
            request.setAttribute("caretaker", caretaker);
            request.getRequestDispatcher("/public/adminEditCaretaker.jsp").forward(request, response);

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
