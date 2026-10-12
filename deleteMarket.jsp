<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
int id = Integer.parseInt(request.getParameter("id"));

PreparedStatement ps = con.prepareStatement(
"DELETE FROM market_demand WHERE id=?");

ps.setInt(1,id);
ps.executeUpdate();

response.sendRedirect("manageMarket.jsp");
%>
