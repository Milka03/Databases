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

@WebServlet(name = "Servlet4_update", urlPatterns = { "/servlet4_update" })
public class Servlet4_update extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1250";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>Servlet4_update</title></head>");
        out.println("<body>");
        
        Connection con = null;
        
        try { Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); }
        catch (Exception e) { e.printStackTrace();}
        try {
            con = DriverManager.getConnection("jdbc:sqlserver://localhost\\MSSQLSERVER:1433;databaseName=Homework1","sa", "sadatabase");
            Statement st = con.createStatement();
            ResultSet result = st.executeQuery("SELECT IMSI, Activation_date, Customer_number, NET_Amount, GROSS_Amount, Current_usage FROM INVOICES WHERE" +
                            " IMSI = " + request.getParameter("id"));
    
            result.next();
            out.println("<form name=\"editForm\" action=\"servlet4_update\" method=\"post\">");
                out.println("<p><input type=\"text\" name=\"imsi\" value=\"" + result.getString("IMSI") +   "\"/>IMSI number</p>");
                out.println("<p><input type=\"text\" name=\"act_date\" value=\"" + result.getString("Activation_date") +   "\"/>Activation Date </p>");
                out.println("<p><input type=\"text\" name=\"cust_num\" value=\"" + result.getString("Customer_number") +   "\"/>Customer number</p>");
                out.println("<p><input type=\"text\" name=\"net_am\" value=\"" + result.getString("NET_Amount") +   "\"/>NET Amount</p>");
                out.println("<p><input type=\"text\" name=\"gross_am\" value=\"" );
                    if(result.getString("GROSS_Amount")==null) out.println("" +   "\"/>GROSS Amount</p>");
                    else out.println(result.getString("GROSS_Amount") +  "\"/>GROSS Amount</p>");
                out.println("<p><input type=\"text\" name=\"curr_usage\" value=\"" );
                    if(result.getString("Current_usage")==null) out.println("" +   "\"/>Current usage</p>");
                    else out.println(result.getString("Current_usage") + "\"/>Current usage</p>");
                out.println("<p><input type=\"submit\" name=\"SUBMIT\"/></p>");
            out.println("</form>");
        
            result.close();
            st.close();    
            con.close();
        }
        
        catch (SQLException e) {  
            e.printStackTrace(); 
            out.println("<p>Error</p>");
            try {
                con.close(); }
            catch (SQLException f) {
                f.printStackTrace();
            }
        } 
                 
        ///out.println("<p>The servlet has received a GET. This is the reply.</p>");
        out.println("</body></html>");
        out.close();
    }
    

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>Servlet4_update</title>");
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
            PreparedStatement st = con.prepareStatement("UPDATE INVOICES SET Activation_date = ?,Customer_number = ?,NET_Amount = ?, GROSS_Amount = ?,Current_usage = ? WHERE IMSI = ?");
        
            st.setDate(1, Date.valueOf(request.getParameter("act_date")));
            st.setString(2, request.getParameter("cust_num"));
            st.setDouble(3, Double.valueOf(request.getParameter("net_am")));
            if(request.getParameter("gross_am") == null || request.getParameter("gross_am").isEmpty())  st.setDouble(4, Types.NULL);
            else st.setDouble(4, Double.valueOf(request.getParameter("gross_am")));
            
            if(request.getParameter("curr_usage") == null || request.getParameter("curr_usage").isEmpty())  st.setDouble(5, Types.NULL);
            else st.setDouble(5, Double.valueOf(request.getParameter("curr_usage")));
            
            st.setLong(6, Long.valueOf(request.getParameter("imsi")));
    
            st.executeUpdate();
            
            st.close();    
            con.close();
            out.println("<p>Updated successfully</p>");
            out.println("<p><a href=servlet3_filter>Show all invoices</a></p>");
        }
        
        catch (SQLException e) {  
            e.printStackTrace(); 
            out.println("<p>Error</p>");
            
            try {
                con.close(); }
            catch (SQLException f) {
                f.printStackTrace();
            }   
        } 
        
        //out.println("<p>The servlet has received a POST. This is the reply.</p>");
        out.println("</body></html>");
        out.close();
    }
}
