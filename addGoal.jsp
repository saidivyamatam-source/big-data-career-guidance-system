<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("userId") == null){
    response.sendRedirect("userLogin.jsp");
    return;
}

int userId = (Integer) session.getAttribute("userId");
String goalText = request.getParameter("goalText");

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/bigdata_project","root","root");

PreparedStatement ps = con.prepareStatement(
"INSERT INTO goals(user_id, goal_text, status) VALUES(?,?,?)");

ps.setInt(1, userId);
ps.setString(2, goalText);
ps.setString(3, "Pending");

ps.executeUpdate();
con.close();

response.sendRedirect("dashboard.jsp");
%>
