<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;

try {

    Class.forName("com.mysql.jdbc.Driver");   // Updated driver
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/bigdata_project?useSSL=false&serverTimezone=UTC",
        "root",
        "root");

    st = con.createStatement();

    // Since id is removed, order by date instead
    rs = st.executeQuery("SELECT * FROM job_postings ORDER BY first_seen DESC");

} catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
<title>View Uploaded Jobs</title>

<style>
body{
    margin:0;
    font-family:'Segoe UI',sans-serif;
    background:linear-gradient(135deg,#1e3c72,#2a5298);
    color:white;
}

.main{
    margin:25px;
    padding:3px;
}

.top-buttons{
    margin-bottom:20px;
}

.btn{
    text-decoration:none;
    padding:10px 18px;
    margin-right:10px;
    border-radius:8px;
    font-weight:bold;
    transition:0.3s;
    display:inline-block;
}

.home-btn{
    background:#06d6a0;
    color:black;
}

.dashboard-btn{
    background:#ffd166;
    color:black;
}

.btn:hover{
    transform:scale(1.05);
    opacity:0.9;
}

table{
    width:100%;
    border-collapse:collapse;
    background:rgba(255,255,255,0.1);
    backdrop-filter:blur(15px);
}

th,td{
    padding:10px;
    border:1px solid rgba(255,255,255,0.2);
    font-size:14px;
}

th{
    background:#ffd166;
    color:black;
}

tr:hover{
    background:rgba(255,255,255,0.1);
}

.summary{
    max-width:300px;
    white-space:nowrap;
    overflow:hidden;
    text-overflow:ellipsis;
}
</style>
</head>

<body>

<div class="main">

<h2>Uploaded Job Postings</h2>

<div class="top-buttons">
    <a href="<%=request.getContextPath()%>/index.jsp" class="btn home-btn">🏠 Home</a>
    <a href="<%=request.getContextPath()%>/adminDashboard.jsp" class="btn dashboard-btn">⬅ Back to Dashboard</a>
</div>

<table>
<tr>
    <th>Job Title</th>
    <th>Company</th>
    <th>Location</th>
    <th>Level</th>
    <th>Type</th>
    <th>Skills</th>
</tr>

<%
while(rs != null && rs.next()){
%>
<tr>
    <td><%= rs.getString("job_title") %></td>
    <td><%= rs.getString("company") %></td>
    <td><%= rs.getString("job_location") %></td>
    <td><%= rs.getString("job_level") %></td>
    <td><%= rs.getString("job_type") %></td>
    <td class="summary"><%= rs.getString("job_skills") %></td>
</tr>
<%
}
%>

</table>

</div>

</body>
</html>