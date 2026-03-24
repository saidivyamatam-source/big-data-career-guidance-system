<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("userId") == null){
    response.sendRedirect("userLogin.jsp");
    return;
}

int skillId = Integer.parseInt(request.getParameter("id"));

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/bigdata_project","root","root");

PreparedStatement ps = con.prepareStatement(
"DELETE FROM skills WHERE id=?");

ps.setInt(1, skillId);
ps.executeUpdate();

con.close();

response.sendRedirect("dashboard.jsp");
%>
