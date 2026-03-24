<%@ page import="java.sql.*" %>
<%
int id = Integer.parseInt(request.getParameter("id"));
String name = request.getParameter("skillName");
int level = Integer.parseInt(request.getParameter("skillLevel"));

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/bigdata_project","root","root");

PreparedStatement ps = con.prepareStatement(
"UPDATE skills SET skill_name=?, skill_level=? WHERE id=?");

ps.setString(1,name);
ps.setInt(2,level);
ps.setInt(3,id);
ps.executeUpdate();

con.close();

response.sendRedirect("dashboard.jsp");
%>
