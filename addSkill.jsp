<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
Integer userId = (Integer)session.getAttribute("userId");

if(userId == null){
    response.sendRedirect("userLogin.jsp");
}

String skillName = request.getParameter("skillName");
String skillLevel = request.getParameter("skillLevel");
String category = request.getParameter("category");

try{

    PreparedStatement ps = con.prepareStatement(
        "INSERT INTO skills (user_id, skill_name, skill_level, category) VALUES (?, ?, ?, ?)"
    );

    ps.setInt(1, userId);
    ps.setString(2, skillName);
    ps.setInt(3, Integer.parseInt(skillLevel));
    ps.setString(4, category);

    ps.executeUpdate();

%>

<script>
    alert("Skill Added Successfully!");
    window.location="dashboard.jsp";
</script>

<%
}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>

