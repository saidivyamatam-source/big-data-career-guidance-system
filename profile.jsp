<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("userId")==null){
    response.sendRedirect("userLogin.jsp");
    return;
}

int userId = (Integer)session.getAttribute("userId");

String fullName="";
double cgpa=0;
int certifications=0;
int internships=0;
int projects=0;
String preferredDomain="";
double expectedSalary=0;

boolean profileExists=false;

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

    Class.forName("com.mysql.jdbc.Driver");

    con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/bigdata_project?useSSL=false&serverTimezone=UTC",
    "root","root");

    ps = con.prepareStatement("SELECT * FROM users_profile WHERE user_id=?");
    ps.setInt(1,userId);
    rs = ps.executeQuery();

    if(rs.next()){
        profileExists=true;
        fullName = rs.getString("full_name");
        cgpa = rs.getDouble("cgpa");
        certifications = rs.getInt("certifications");
        internships = rs.getInt("internships");
        projects = rs.getInt("projects");
        preferredDomain = rs.getString("preferred_domain");
        expectedSalary = rs.getDouble("expected_salary");
    }

}catch(Exception e){
    out.println("<h4 style='color:red;'>Error: "+e.getMessage()+"</h4>");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>User Profile</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
background:linear-gradient(135deg,#0f2027,#203a43,#2c5364);
font-family:Segoe UI;
color:white;
}
.profile-card{
background:white;
color:black;
padding:30px;
border-radius:15px;
box-shadow:0 10px 25px rgba(0,0,0,0.4);
}
.btn-custom{
padding:10px 20px;
border-radius:8px;
font-weight:bold;
}
</style>
</head>

<body>

<div class="container mt-5">
<div class="profile-card">

<h3 class="mb-4">
<%= profileExists ? "✏ Edit Profile" : "📝 Complete Your Profile" %>
</h3>

<form action="<%=request.getContextPath()%>/CompleteProfileServlet" method="post">
<div class="mb-3">
<label class="form-label">Full Name</label>
<input type="text" name="fullName" class="form-control"
value="<%=fullName%>" required>
</div>

<div class="mb-3">
<label class="form-label">CGPA</label>
<input type="number" step="0.01" name="cgpa" class="form-control"
value="<%=cgpa%>" required>
</div>

<div class="mb-3">
<label class="form-label">Projects</label>
<input type="number" name="projects" class="form-control"
value="<%=projects%>" required>
</div>

<div class="mb-3">
<label class="form-label">Internships</label>
<input type="number" name="internships" class="form-control"
value="<%=internships%>" required>
</div>

<div class="mb-3">
<label class="form-label">Certifications</label>
<input type="number" name="certifications" class="form-control"
value="<%=certifications%>" required>
</div>

<div class="mb-3">
<label class="form-label">Preferred Domain</label>
<input type="text" name="preferredDomain" class="form-control"
value="<%=preferredDomain%>" required>
</div>

<div class="mb-3">
<label class="form-label">Expected Salary (LPA)</label>
<input type="number" step="0.01" name="expectedSalary" class="form-control"
value="<%=expectedSalary%>" required>
</div>
<h4>Add Skills</h4>

<div id="skillSection">

<div class="skillRow">

<label>Skill Name:</label>
<input type="text" name="skill_name" required>

<label>Skill Level:</label>
<select name="skill_level" required>
    <option value="1">Beginner</option>
    <option value="2">Intermediate</option>
    <option value="3">Advanced</option>
</select>

<label>Category:</label>
<select name="category" required>
    <option>Programming</option>
    <option>Data Science</option>
    <option>Web Development</option>
    <option>AI & ML</option>
</select>

</div>
</div>
<div class="d-flex justify-content-between">

<button type="submit" class="btn btn-success btn-custom">
<%= profileExists ? "Update Profile" : "Save Profile" %>
</button>

<a href="dashboard.jsp" class="btn btn-secondary btn-custom">
⬅ Back to Dashboard
</a>

</div>

</form>

</div>
</div>

</body>
</html>

<%
try{
if(rs!=null) rs.close();
if(ps!=null) ps.close();
if(con!=null) con.close();
}catch(Exception e){}
%>