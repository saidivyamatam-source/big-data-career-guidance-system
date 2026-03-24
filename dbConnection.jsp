<%@ page import="java.sql.*" %>
<%
    String url = "jdbc:mysql://localhost:3306/bigdata_project";
    String user = "root"; // your MySQL username
    String pass = "root";     // your MySQL password
    Connection con = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection(url, user, pass);
    } catch(Exception e) {
        out.println("Database connection error: " + e.getMessage());
    }
%>
