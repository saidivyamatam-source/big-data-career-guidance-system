<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");

PreparedStatement ps = null;
ResultSet rs = null;

try {

    String query = "SELECT * FROM admin WHERE username=? AND password=?";
    ps = con.prepareStatement(query);   // using con from dbConnection.jsp

    ps.setString(1, username);
    ps.setString(2, password);

    rs = ps.executeQuery();

    if(rs.next()){
        session.setAttribute("admin", username);
        response.sendRedirect("adminDashboard.jsp");
    } 
    else {
%>
        <script>
            alert("Invalid Admin Credentials!");
            window.location="adminLogin.html";
        </script>
<%
    }

} catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>
