<%@ page import="java.sql.*" %>
<%
int id = Integer.parseInt(request.getParameter("id"));

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/bigdata_project","root","root");

PreparedStatement ps = con.prepareStatement(
"UPDATE goals SET status='Completed' WHERE id=?");

ps.setInt(1,id);
ps.executeUpdate();

con.close();

response.sendRedirect("dashboard.jsp");
%>
