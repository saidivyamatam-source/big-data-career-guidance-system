<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    if(session.getAttribute("studentId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    int studentId = (Integer)session.getAttribute("studentId");
%>
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String name = "", email = "", profilePic = "";
    double cgpa = 0.0;

    try{
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourDB", "root", "password");

        // Fetch student details
        ps = con.prepareStatement("SELECT * FROM students WHERE student_id=?");
        ps.setInt(1, studentId);
        rs = ps.executeQuery();
        if(rs.next()){
            name = rs.getString("name");
            email = rs.getString("email");
            profilePic = rs.getString("profile_pic");
            cgpa = rs.getDouble("cgpa");
        }

    }catch(Exception e){
        out.println(e);
    }
%>
<div class="profile-section">
    <h2>Welcome, <%= name %>!</h2>
    <img src="<%= profilePic %>" alt="Profile Picture" width="120" height="120"/>
    <p>Email: <%= email %></p>
    <p>CGPA: <%= cgpa %></p>
</div>
<h3>Your Skills</h3>
<ul>
<%
    try{
        ps = con.prepareStatement("SELECT * FROM skills WHERE student_id=?");
        ps.setInt(1, studentId);
        rs = ps.executeQuery();
        while(rs.next()){
%>
    <li><%= rs.getString("skill_name") %> - <%= rs.getString("proficiency") %></li>
<%
        }
    }catch(Exception e){ out.println(e); }
%>
</ul>
<h3>Your Projects</h3>
<ul>
<%
    ps = con.prepareStatement("SELECT * FROM projects WHERE student_id=?");
    ps.setInt(1, studentId);
    rs = ps.executeQuery();
    while(rs.next()){
%>
    <li><b><%= rs.getString("project_name") %></b>: <%= rs.getString("description") %> (Completed on <%= rs.getDate("completion_date") %>)</li>
<%
    }
%>
</ul>
<h3>Your Certifications</h3>
<ul>
<%
    ps = con.prepareStatement("SELECT * FROM certifications WHERE student_id=?");
    ps.setInt(1, studentId);
    rs = ps.executeQuery();
    while(rs.next()){
%>
    <li><%= rs.getString("cert_name") %> - <%= rs.getString("issued_by") %> (Issued on <%= rs.getDate("issue_date") %>)</li>
<%
    }
%>
</ul>
<h3>Recommended Jobs</h3>
<ul>
<%
    ps = con.prepareStatement("SELECT * FROM jobs");
    rs = ps.executeQuery();
    while(rs.next()){
%>
    <li><b><%= rs.getString("title") %></b> at <%= rs.getString("company") %> - Level: <%= rs.getString("level") %></li>
<%
    }
%>
</ul>