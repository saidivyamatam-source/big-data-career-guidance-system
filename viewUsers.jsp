<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("adminLogin.html");
    return;
}

PreparedStatement ps = con.prepareStatement(
"SELECT u.id, u.name, u.email, " +
"p.cgpa, p.projects, p.internships, p.certifications, " +
"p.preferred_domain, p.expected_salary " +
"FROM users u " +
"LEFT JOIN users_profile p ON u.id = p.user_id");

ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>View Users</title>

<style>
body{
    margin-left:25px;
    font-family:'Segoe UI',sans-serif;
    background:linear-gradient(135deg,#1e3c72,#2a5298);
    color:white;
    padding:40px;
}

.container{
    max-width:1400px;
    margin:auto;
}

.card{
    background:rgba(255,255,255,0.1);
    backdrop-filter:blur(20px);
    padding:25px;
    border-radius:20px;
    box-shadow:0 8px 32px rgba(0,0,0,0.4);
}

h2{
    color:#ffd166;
    margin-bottom:20px;
}

table{
    width:100%;
    border-collapse:collapse;
    font-size:14px;
}

th{
    background:rgba(255,255,255,0.2);
    padding:10px;
}

td{
    padding:8px;
    text-align:center;
    border-bottom:1px solid rgba(255,255,255,0.2);
}

tr:hover{
    background:rgba(255,255,255,0.1);
}

.delete-btn{
    background:#e63946;
    color:white;
    padding:6px 12px;
    border-radius:6px;
    text-decoration:none;
}

.delete-btn:hover{
    background:#c1121f;
}
</style>

</head>
<body>


<div class="container">
<div class="card">
<div style="margin-bottom:20px;">
    <a href="adminDashboard.jsp" 
       style="
       background:#ffd166;
       color:#000;
       padding:8px 18px;
       border-radius:8px;
       text-decoration:none;
       font-weight:bold;">
       ← Back to Dashboard
    </a>
</div>


<h2>Registered Users - Complete Details</h2>

<table>
<tr>
<th>ID</th>
<th>Name</th>
<th>Email</th>
<th>CGPA</th>
<th>Projects</th>
<th>Internships</th>
<th>Certifications</th>
<th>Domain</th>
<th>Expected Salary</th>
<th>Resume Strength</th>
<th>Placement %</th>
<th>Predicted Salary</th>

</tr>

<%
while(rs.next()){

    int id = rs.getInt("id");
    String name = rs.getString("name");
    String email = rs.getString("email");

    double cgpa = rs.getDouble("cgpa");
    int projects = rs.getInt("projects");
    int internships = rs.getInt("internships");
    int certifications = rs.getInt("certifications");

    String domain = rs.getString("preferred_domain");
    double expectedSalary = rs.getDouble("expected_salary");

    // Same logic as user dashboard
    double resumeStrength =
        (projects * 10) +
        (certifications * 5) +
        (internships * 15);

    double placementProbability =
        (cgpa * 10) +
        (internships * 15) +
        (resumeStrength * 0.4);

    if(placementProbability > 100)
        placementProbability = 100;

    double predictedSalary =
        (cgpa * 0.6) +
        (projects * 0.5) +
        (internships * 0.8) +
        (certifications * 0.3);
%>

<tr>
<td><%=id%></td>
<td><%=name%></td>
<td><%=email%></td>
<td><%=cgpa%></td>
<td><%=projects%></td>
<td><%=internships%></td>
<td><%=certifications%></td>
<td><%=domain%></td>
<td><%=expectedSalary%> LPA</td>
<td><%=resumeStrength%></td>
<td><%=String.format("%.2f",placementProbability)%> %</td>
<td><%=String.format("%.2f",predictedSalary)%> LPA</td>
<td>

</td>
</tr>

<% } %>

</table>

</div>
</div>

</body>
</html>