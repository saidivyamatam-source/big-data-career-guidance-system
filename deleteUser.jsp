<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("adminLogin.html");
    return;
}

int id = Integer.parseInt(request.getParameter("id"));

PreparedStatement ps = con.prepareStatement(
"DELETE FROM users WHERE id=?");

ps.setInt(1,id);
ps.executeUpdate();

response.sendRedirect("viewUsers.jsp");
%>
