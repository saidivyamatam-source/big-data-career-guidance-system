<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
String skill = request.getParameter("skill");
int demand = Integer.parseInt(request.getParameter("demand"));

PreparedStatement ps = con.prepareStatement(
"INSERT INTO market_demand(skill_name,demand_percentage) VALUES(?,?)");

ps.setString(1,skill);
ps.setInt(2,demand);
ps.executeUpdate();

response.sendRedirect("manageMarket.jsp");
%>
