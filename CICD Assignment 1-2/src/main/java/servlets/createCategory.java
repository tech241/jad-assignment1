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
 */
@WebServlet("/createCategory")
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

        HttpSession session = request.getSession();
        String url = "adminCreateCategory";
        String catName = request.getParameter("catName");
        String catDescription = request.getParameter("catDescription");
        String catLogo = request.getParameter("catLogo");
        int id = (int) session.getAttribute("id");

        Runnable createCategory1 = () -> {
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

        postgresHelper.validateAdmin(session, response, url, id, createCategory1);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doGet(request, response);
    }

}
