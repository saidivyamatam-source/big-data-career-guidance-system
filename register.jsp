<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    String message = "";
    if(request.getMethod().equalsIgnoreCase("POST")){
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // New fields
        String course = request.getParameter("course");
        String cgpaStr = request.getParameter("cgpa");
        String skill_name = request.getParameter("skill_name");

        double cgpa = 0;
        if(cgpaStr != null && !cgpaStr.isEmpty()){
            try { cgpa = Double.parseDouble(cgpaStr); } 
            catch(Exception e) { cgpa = 0; }
        }

        if(!password.equals(confirmPassword)){
            message = "Passwords do not match!";
        } else {
            try{
                String checkQuery = "SELECT * FROM users WHERE email=?";
                PreparedStatement pstCheck = con.prepareStatement(checkQuery);
                pstCheck.setString(1,email);
                ResultSet rs = pstCheck.executeQuery();

                if(rs.next()){
                    message = "Email already registered!";
                } else {
                    String insertQuery = "INSERT INTO users(name,email,password,course,cgpa,skill_name) VALUES(?,?,?,?,?,?)";
                    PreparedStatement pst = con.prepareStatement(insertQuery);
                    pst.setString(1,name);
                    pst.setString(2,email);
                    pst.setString(3,password);
                    pst.setString(4,course);
                    pst.setDouble(5,cgpa);
                    pst.setString(6,skill_name);

                    int i = pst.executeUpdate();
                    if(i > 0){
                        // Set session attributes
                        session.setAttribute("userName", name);
                        session.setAttribute("userEmail", email);

                        // Redirect to dashboard
                        response.sendRedirect("userDashboard.jsp");
                    }
                }
            }catch(Exception e){
                message = "Error: " + e.getMessage();
            }
        }
    }
%>