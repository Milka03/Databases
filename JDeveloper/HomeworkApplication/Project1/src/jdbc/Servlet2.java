package jdbc;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

import java.sql.Types;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "Servlet2", urlPatterns = { "/servlet2" })
public class Servlet2 extends HttpServlet {
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
        
        out.println("<p>The servlet has received a GET. This is the reply.</p>");
        out.println("</body></html>");
        out.close();
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        catch (Exception e) { e.printStackTrace();}
        try {
            con = DriverManager.getConnection("jdbc:sqlserver://localhost\\MSSQLSERVER:1433;databaseName=Homework1","sa", "sadatabase");
            String sqlCode = "Insert into Invoices (IMSI, Activation_date, Customer_number, NET_Amount, GROSS_Amount, Current_usage) VALUES (?,?,?,?,?,?)";
            PreparedStatement st = con.prepareStatement(sqlCode);
            
            st.setLong(1, Long.valueOf(request.getParameter("imsi")));
            st.setDate(2, Date.valueOf(request.getParameter("act_date")));
            st.setString(3, request.getParameter("cust_num"));
            st.setDouble(4, Double.valueOf(request.getParameter("net_am")));
            if(request.getParameter("gross_am") == "null" || request.getParameter("gross_am").isEmpty()) st.setDouble(5, Types.NULL);
            else st.setDouble(5, Double.valueOf(request.getParameter("gross_am")));
            if(request.getParameter("curr_usage") == "null" || request.getParameter("curr_usage").isEmpty()) st.setDouble(6, Types.NULL);
            else st.setDouble(6, Double.valueOf(request.getParameter("curr_usage")));
            
            st.executeUpdate();
            
            out.println("<p>Data inserted successfully</p>");
            out.println("<p><a style=\"margin-right:30px\" href=InsertForm.html>Insert new invoice</a>");
            out.println("<a href=servlet3_filter>Show all invoices</a></p>");
            
            st.close();
            con.close();
        }
        
        catch (SQLException e) { 
            e.printStackTrace(); 
            out.println("<p>There were some errors</p>");
            out.println("<a href=InsertForm.html>Try again</a>");
            try {
                con.close();
            }
            catch (SQLException f) {
                f.printStackTrace();
            }                               
        }
        
        out.println("</body></html>");
        out.close();
    }
}
