<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
String emailParam = request.getParameter("email");
String passwordParam = request.getParameter("password");

// New optional fields from login form
String course = request.getParameter("course");
String skill_name = request.getParameter("skill_name");

double cgpa = 0;
String cgpaParam = request.getParameter("cgpa");
if(cgpaParam != null && !cgpaParam.trim().isEmpty()){
    try { cgpa = Double.parseDouble(cgpaParam); } 
    catch(Exception e){ cgpa = 0; }
}

if(emailParam != null && passwordParam != null){

    PreparedStatement ps = null;
    ResultSet rs = null;
    PreparedStatement psUpdate = null;

    try{
        // ========== LOGIN CHECK ==========
        String query = "SELECT * FROM users WHERE email=? AND password=?";
        ps = con.prepareStatement(query);
        ps.setString(1, emailParam);
        ps.setString(2, passwordParam);
        rs = ps.executeQuery();

        if(rs.next()){
            int id = rs.getInt("id");
            String name = rs.getString("name");
            String userEmail = rs.getString("email");

            // ========== UPDATE SKILLS DATA IF PROVIDED ==========
            if((course != null && !course.isEmpty()) || 
               (skill_name != null && !skill_name.isEmpty()) || 
               cgpa > 0){
                
                String updateQuery = "UPDATE users SET course=?, cgpa=?, skill_name=? WHERE id=?";
                psUpdate = con.prepareStatement(updateQuery);
                psUpdate.setString(1, course != null ? course : rs.getString("course"));
                psUpdate.setDouble(2, cgpa > 0 ? cgpa : rs.getDouble("cgpa"));
                psUpdate.setString(3, skill_name != null ? skill_name : rs.getString("skill_name"));
                psUpdate.setInt(4, id);
                psUpdate.executeUpdate();
            }

            // ========== SESSION SETUP ==========
            session.setAttribute("userId", id);
            session.setAttribute("userName", name);
            session.setAttribute("userEmail", userEmail);

            // ========== REDIRECT TO DASHBOARD ==========
            response.sendRedirect("dashboard.jsp");

        } else {
%>
<script>
    alert("Invalid Email or Password!");
    window.location = "userLogin.html";
</script>
<%
        }

    } catch(Exception e){
        out.println("<h3 style='color:red;'>ERROR: " + e.getMessage() + "</h3>");
    } finally {
        try{
            if(psUpdate != null) psUpdate.close();
            if(rs != null) rs.close();
            if(ps != null) ps.close();
            if(con != null) con.close();
        } catch(Exception e){}
    }
}
%>