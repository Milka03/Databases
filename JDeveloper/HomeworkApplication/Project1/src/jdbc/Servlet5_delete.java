package jdbc;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "Servlet5_delete", urlPatterns = { "/servlet5_delete" })
public class Servlet5_delete extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1250";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>Servlet2</title>");
        out.println("<style>");
        out.println("button {background-color:white; color:black; border: 2px solid #4CAF50;}");
        out.println("</style>");    
        out.println("</head>");
        out.println("<body>");
        
        Connection con = null;
        
        try { Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); }
        catch (Exception e) { e.printStackTrace(); }
        try {
            con = DriverManager.getConnection("jdbc:sqlserver://localhost\\MSSQLSERVER:1433;databaseName=Homework1","sa", "sadatabase");
            String value = request.getParameter("idd");
            PreparedStatement st = con.prepareStatement("DELETE FROM Invoices WHERE IMSI =" + value);
            
            st.executeUpdate();
            
            out.println("<p>Deleted successfully</p>");
            out.println("<p><a href=servlet3_filter>Show all invoices</a></p>");
            
            st.close();    
            con.close();
        }
        
        catch (SQLException e) {
            e.printStackTrace(); 
            out.println("<p>There were some errors</p>");
            out.println("<a href=servlet3_filter>Try again</a>");
            try {
                con.close(); }
            catch (SQLException f) {
                f.printStackTrace();
            }
        }
        
        out.println("<p>The servlet has received a GET. This is the reply.</p>");
        out.println("</body></html>");
        out.close();
        
    }
    
    
   
}
