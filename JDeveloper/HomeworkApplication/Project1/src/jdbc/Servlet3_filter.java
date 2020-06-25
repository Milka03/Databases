package jdbc;

import java.io.IOException;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "Servlet3_filter", urlPatterns = { "/servlet3_filter" })
public class Servlet3_filter extends HttpServlet {
    private static final String CONTENT_TYPE = "text/html; charset=windows-1250";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>Servlet3_filter</title>");
        out.println("<style>");
        out.println("table {font family: arial; border-collapse: collapse; border:1px; margin-left:auto;margin-right:auto;}");
        out.println("table tr, table th {border: lpx solid #dddddd; padding:8px;}");
        out.println("table tr:nth-child(even) {background-color: #f2f2f2;}");
        out.println("table tr:hover {background-color: #ddd;}");
        out.println("table th {padding-top:12px; padding-bottom:12px; text-align:left; background-color:#4CAF50; color:white;}");
        out.println("button {background-color:white; color:black; border: 2px solid #4CAF50;}");
        out.println("</style>");    
        out.println("</head>");
        out.println("<body>");
        
        out.println("<form name=\"queryForm\" action=\"servlet3_filter\" method=\"post\">");
        //here buttons show, insert
        out.println("<br>");
        out.println("<div style=\"text-align:center; \">" +
                    "<a style=\"margin-right: 30px;\" href=servlet3_filter>Show all invoices</a><a href=InsertForm.html>Insert invoice</a></div>");
            out.println("<br>");
            out.println("<table>");
                out.println("<tr>");
                    out.println("<td><input type=\"text\" name=\"act_date_from\"/><br clear all>Date (From)</td>");
                    out.println("<td><input type=\"text\" name=\"act_date_to\"/><br clear all>Date (To)</td>");
                    out.println("<td><input type=\"text\" name=\"net_min\"/><br clear all>Min NET Amount</td>");  
                    out.println("<td><input type=\"text\" name=\"net_max\"/><br clear all>Max NET Amount</td>");
                    out.println("<td><input type=\"submit\" name=\"SUBMIT\"/><br clear all>Show</td>");
                out.println("</tr>");     
            out.println("</table>");      
        out.println("</form>");
            
        Connection con = null;
        
        try { Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); }
        catch (Exception e) { e.printStackTrace();}
        try {
            con = DriverManager.getConnection("jdbc:sqlserver://localhost\\MSSQLSERVER:1433;databaseName=Homework1","sa", "sadatabase");
            Statement st = con.createStatement();
            ResultSet result = st.executeQuery("SELECT IMSI,Activation_date, Customer_number, NET_Amount, GROSS_Amount,Current_usage FROM INVOICES");
        
//            out.println("<style>");
//            out.println("table {font family: arial; border-collapse: collapse; border:1px; margin-left:auto;margin-right:auto;}");
//            out.println("table tr, table th {border: lpx solid #dddddd; padding:2px;}");
//            out.println("</style>");
            out.println("<br>");
            out.println("<h2 style=\"text-align: center;\">Invoices</h2><br>");
            out.println("<table>");
            out.println("<tr>" +
                "<th>IMSI</th>" +
                "<th>Activation_date</th>" +
                "<th>Customer_number</th>" +
                "<th>NET_Amount</th>" +
                "<th>GROSS_Amount</th>" +
                "<th>Current_usage</th>" +
                "<th>Action</th>" +
                "<th>Action</th>" +      
                "<th>Action</th>" +
                "</tr>");
            
            while(result.next()){
                out.println("<tr>" +
                "<td>" + result.getString("IMSI")            + "</td>" +
                "<td>" + result.getString("Activation_date") + "</td>" +
                "<td>" + result.getString("Customer_number") + "</td>" +
                "<td>" + result.getString("NET_Amount")      + "</td>");
                if(result.getString("GROSS_Amount")==null ||  result.getString("GROSS_Amount")=="0.0000") out.println("<td>" + "" + "</td>");
                else out.println("<td>" + result.getString("GROSS_Amount")    + "</td>");
                if(result.getString("Current_usage")==null ||  result.getString("Current_usage")=="0.00") out.println("<td>" + "" + "</td>");
                else out.println("<td>" + result.getString("Current_usage")   + "</td>"); 
                out.println("<td>" + "<a href=servlet1?ids=" + result.getString("IMSI")+">Insert similar</a>" + "</td>" +
                "<td>" + "<a href=servlet4_update?id=" + result.getString("IMSI")+">Update</a>" + "</td>" +
                "<td>" + "<a href=servlet5_delete?idd=" + result.getString("IMSI")+ ">Delete</a>" + "</td>" +
                "</tr>");
            }        
            out.println("</table>");
        
            result.close();
            st.close();    
            con.close();
        }
        catch (SQLException e) { e.printStackTrace(); }
        
        //out.println("<p>The servlet has received a GET. This is the reply.</p>");
        out.println("</body></html>");
        out.close();
    }



    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType(CONTENT_TYPE);
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>Servlet3_filter</title>"); 
        out.println("<style>");
        out.println("table {font family: arial; border-collapse: collapse; border:1px; margin-left:auto;margin-right:auto;}");
        out.println("table tr, table th {border: lpx solid #dddddd; padding:8px;}");
        out.println("table tr:nth-child(even) {background-color: #f2f2f2;}");
        out.println("table tr:hover {background-color: #ddd;}");
        out.println("table th {padding-top:12px; padding-bottom:12px; text-align:left; background-color:#4CAF50; color:white;}");
        out.println("button {background-color:white; color:black; border: 2px solid #4CAF50;}");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<form name=\"queryForm\" action=\"servlet3_filter\" method=\"post\">");
        //here buttons show, insert
        out.println("<br>");
        out.println("<div style=\"text-align:center;\">" +
                    "<a style=\"margin-right: 30px;\" href=servlet3_filter>Show all invoices</a><a href=InsertForm.html>Insert invoice</a></div>");
        out.println("<br>");
            out.println("<table>");
                out.println("<tr>");
                    out.println("<td><input type=\"text\" name=\"act_date_from\"/><br clear all>Date (From)</td>");
                    out.println("<td><input type=\"text\" name=\"act_date_to\"/><br clear all>Date (To)</td>");
                    out.println("<td><input type=\"text\" name=\"net_min\"/><br clear all>Min NET Amount</td>");  
                    out.println("<td><input type=\"text\" name=\"net_max\"/><br clear all>Max NET Amount</td>");
                    out.println("<td><input type=\"submit\" name=\"SUBMIT\"/><br clear all>Show</td>");
                out.println("</tr>");     
            out.println("</table>");      
        out.println("</form>");
        
        String date1 = request.getParameter("act_date_from");
        String date2 = request.getParameter("act_date_to");
        String netmin = request.getParameter("net_min");
        String netmax = request.getParameter("net_max");
        Connection con = null;
        
        
        try { Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); }
        catch (Exception e) { e.printStackTrace();}
        try {
            con = DriverManager.getConnection("jdbc:sqlserver://localhost\\MSSQLSERVER:1433;databaseName=Homework1","sa", "sadatabase");
            StringBuilder sqlCode = new StringBuilder();
            sqlCode.append("SELECT * FROM INVOICES WHERE 1 = 1");
            
            if(!date1.isEmpty())
                sqlCode.append(" and Activation_date >= Convert(datetime," + date1 + ")"); //date.valueof(string)
            if(!date2.isEmpty()) 
                sqlCode.append(" and Activation_date < Convert(datetime, " + date2 + ")"); 
            if(!netmin.isEmpty())
                sqlCode.append(" and NET_Amount >= " + netmin);
            if(!netmax.isEmpty())
                sqlCode.append(" and NET_Amount <= " + netmax);
            
            Statement st = con.createStatement();
            ResultSet res = st.executeQuery(sqlCode.toString());
            
            out.println("<br>");
            out.println("<h2 style=\"text-align: center;\">Invoices</h2><br>");
            out.println("<table>");
            out.println("<tr>" +
                    "<th>IMSI</th>" +
                    "<th>Activation_date</th>" +
                    "<th>Customer_number</th>" +
                    "<th>NET_Amount</th>" +
                    "<th>GROSS_Amount</th>" +
                    "<th>Current_usage</th>" +
                    "<th>Action</th>" +
                    "<th>Action</th>" +    
                    "<th>Action</th>" +
                    "</tr>");
                
            while(res.next()){
                out.println("<tr>" +
                "<td>" + res.getString("IMSI")            + "</td>" +
                "<td>" + res.getString("Activation_date") + "</td>" +
                "<td>" + res.getString("Customer_number") + "</td>" +
                "<td>" + res.getString("NET_Amount")      + "</td>");
                if(res.getString("GROSS_Amount")==null || res.getString("GROSS_Amount")=="0.0000") out.println("<td>" + "" + "</td>");
                else out.println("<td>" + res.getString("GROSS_Amount")    + "</td>");
                if(res.getString("Current_usage")==null ||  res.getString("Current_usage")=="0.00") out.println("<td>" + "" + "</td>");
                else out.println("<td>" + res.getString("Current_usage")   + "</td>"); 
                out.println("<td>" + "<a href=servlet1?ids=" + res.getString("IMSI")+">Insert similar</a>" + "</td>" +
                "<td>" + "<a href=servlet4_update?id=" + res.getString("IMSI")+">Update</a>" + "</td>" +
                "<td>" + "<a href=servlet5_delete?idd=" + res.getString("IMSI")+ ">Delete</a>" + "</td>" +
                "</tr>");
            }             
            out.println("</table>");
                    
            res.close();
            st.close();
            con.close();
        }
        
        catch (SQLException e) { 
            e.printStackTrace(); 
        }
        
        out.println("</body></html>");
        out.close();
    }
}
