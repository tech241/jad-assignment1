package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class createCategory
 * This servlet handles the creation of a new service category by an admin user. 
 * Retrieves form data, validates the admin access, runs the INSERT SQL and redirects back to the admin services page 
 */
@WebServlet("/createCategory") // servlet mapping
public class createCategory extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public createCategory() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        response.getWriter().append("Served at: ").append(request.getContextPath());

        // retrieve form and session data. HttpSession allows data to persist across pages.
        HttpSession session = request.getSession();
        String url = "adminCreateCategory";
        String catName = request.getParameter("catName");
        String catDescription = request.getParameter("catDescription");
        String catLogo = request.getParameter("catLogo");
        int id = (int) session.getAttribute("id");

        Runnable createCategory1 = () -> { // insert statement is wrapped inside Runnable so that validateAdmin() can run it only if the user has admin rights. 
            postgresHelper.query(
                "INSERT INTO service_category (cat_name, cat_description, cat_logo) VALUES (?, ?, ?);",
                null,
                catName, catDescription, catLogo
            );

            try {
                response.sendRedirect("public/adminServices.jsp");
            } catch (Exception e2) {
                System.out.println("Error :" + e2);
            }
        };

        postgresHelper.validateAdmin(session, response, url, id, createCategory1); // servlet delegates the validation to a helper method inside postgresHelper.java.
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doGet(request, response);
    }

}
