<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
if(session.getAttribute("userId")==null){
    response.sendRedirect("userLogin.jsp");
    return;
}

int userId = (Integer) session.getAttribute("userId");

String fullName="";
double cgpa=0;
int certifications=0;
int internships=0;
int projects=0;
String domain="";
double expectedSalary=0;

Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/bigdata_project","root","root");

PreparedStatement ps=con.prepareStatement(
"SELECT * FROM users_profile WHERE user_id=?");
ps.setInt(1,userId);
ResultSet rs=ps.executeQuery();

if(rs.next()){
    fullName=rs.getString("full_name");
    cgpa=rs.getDouble("cgpa");
    certifications=rs.getInt("certifications");
    internships=rs.getInt("internships");
    projects=rs.getInt("projects");
    domain=rs.getString("preferred_domain");
    expectedSalary=rs.getDouble("expected_salary");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Profile</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background:#f4f7fc;">

<div class="container mt-5">
<div class="card p-4 shadow">

<h3>Edit Profile Details</h3>
<hr>

<form action="UpdateProfileServlet" method="post">

<div class="mb-3">
<label>Full Name</label>
<input type="text" name="fullName" value="<%=fullName%>" class="form-control" required>
</div>

<div class="mb-3">
<label>CGPA</label>
<input type="number" step="0.01" name="cgpa" value="<%=cgpa%>" class="form-control" required>
</div>

<div class="mb-3">
<label>Projects</label>
<input type="number" name="projects" value="<%=projects%>" class="form-control" required>
</div>

<div class="mb-3">
<label>Internships</label>
<input type="number" name="internships" value="<%=internships%>" class="form-control" required>
</div>

<div class="mb-3">
<label>Certifications</label>
<input type="number" name="certifications" value="<%=certifications%>" class="form-control" required>
</div>

<div class="mb-3">
<label>Preferred Domain</label>
<input type="text" name="domain" value="<%=domain%>" class="form-control">
</div>

<div class="mb-3">
<label>Expected Salary (LPA)</label>
<input type="number" step="0.1" name="expectedSalary" value="<%=expectedSalary%>" class="form-control">
</div>

<button type="submit" class="btn btn-success">💾 Update Profile</button>
<a href="dashboard.jsp" class="btn btn-secondary">Cancel</a>

</form>

</div>
</div>

</body>
</html>

<%
con.close();
%>