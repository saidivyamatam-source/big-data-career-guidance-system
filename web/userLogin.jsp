<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
String emailParam = request.getParameter("email");
String passwordParam = request.getParameter("password");

if(emailParam != null && passwordParam != null){

    PreparedStatement ps = null;
    ResultSet rs = null;
    PreparedStatement psProfile = null;
    ResultSet rsProfile = null;

    try{

        String query = "SELECT * FROM users WHERE email=? AND password=?";
        ps = con.prepareStatement(query);

        ps.setString(1, emailParam);
        ps.setString(2, passwordParam);

        rs = ps.executeQuery();

        if(rs.next()){

            int id = rs.getInt("id");
            String name = rs.getString("name");
            String userEmail = rs.getString("email");

            // Store session values
            session.setAttribute("userId", id);
            session.setAttribute("userName", name);
            session.setAttribute("userEmail", userEmail);

            /* ================= PROFILE CHECK ================= */

            psProfile = con.prepareStatement(
                "SELECT user_id FROM users_profile WHERE user_id=?"
            );

            psProfile.setInt(1, id);
            rsProfile = psProfile.executeQuery();

            if(rsProfile.next()){
                // Profile already exists
                response.sendRedirect("dashboard.jsp");
            } else {
                // First time login ? go to profile page
                response.sendRedirect("profile.jsp");
            }

        } else {
%>
            <script>
                alert("Invalid Email or Password!");
                window.location="userLogin.html";
            </script>
<%
        }

    } catch(Exception e){
        out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
    } finally {

        try{
            if(rsProfile != null) rsProfile.close();
            if(psProfile != null) psProfile.close();
            if(rs != null) rs.close();
            if(ps != null) ps.close();
        }catch(Exception e){}
    }

}
%>