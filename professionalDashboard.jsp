<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>

<%
if(session.getAttribute("userId")==null){
    response.sendRedirect("userLogin.jsp");
    return;
}

int userId = (Integer)session.getAttribute("userId");
String userName = (String)session.getAttribute("userName");

Class.forName("com.mysql.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/bigdata_project?useSSL=false&serverTimezone=UTC",
"root","root");

/* ================= PROFILE DATA ================= */

double cgpa=0;
int certifications=0;
int internships=0;
int projects=0;
String preferredDomain="";
double expectedSalary=0;

PreparedStatement psProfile = con.prepareStatement(
"SELECT cgpa, certifications, internships, projects, preferred_domain, expected_salary FROM users_profile WHERE user_id=?");

psProfile.setInt(1,userId);
ResultSet rsProfile = psProfile.executeQuery();

if(rsProfile.next()){
    cgpa = rsProfile.getDouble("cgpa");
    certifications = rsProfile.getInt("certifications");
    internships = rsProfile.getInt("internships");
    projects = rsProfile.getInt("projects");
    preferredDomain = rsProfile.getString("preferred_domain");
    expectedSalary = rsProfile.getDouble("expected_salary");
}



/* ================= SAME ANALYTICS CALCULATION ================= */

// Resume Strength
double resumeStrength =
    (projects * 10) +
    (certifications * 5) +
    (internships * 15);

if(resumeStrength > 100)
    resumeStrength = 100;

// Placement Probability
double placementProbability =
    (cgpa * 10) +
    (internships * 15) +
    (resumeStrength * 0.4);

if(placementProbability > 100)
    placementProbability = 100;

// Salary Prediction
double predictedSalary =
    (cgpa * 0.6) +
    (projects * 0.5) +
    (internships * 0.8) +
    (certifications * 0.3);

DecimalFormat df = new DecimalFormat("0.00");

/* ================= SKILL GAP ================= */

PreparedStatement psGap = con.prepareStatement(
"SELECT m.skill_name, m.demand_percentage, IFNULL(s.skill_level,0) as user_level " +
"FROM market_demand m LEFT JOIN skills s " +
"ON m.skill_name=s.skill_name AND s.user_id=?");

psGap.setInt(1,userId);
ResultSet rsGap = psGap.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>AI Career Intelligence Dashboard</title>

<style>
body{margin:0;font-family:'Segoe UI';background:#f4f6f9;}
.sidebar{position:fixed;width:230px;height:100%;background:#1b263b;color:white;padding:20px;}
.sidebar a{display:block;color:white;padding:12px;text-decoration:none;}
.sidebar a:hover{background:#415a77;}
.main{margin-left:250px;padding:20px;}
.cards{display:flex;gap:20px;flex-wrap:wrap;}
.card{background:white;padding:20px;border-radius:10px;width:220px;
box-shadow:0 4px 10px rgba(0,0,0,0.1);transition:0.3s;}
.card:hover{transform:translateY(-5px);box-shadow:0 8px 20px rgba(0,0,0,0.2);}
.section{background:white;margin-top:20px;padding:20px;border-radius:10px;
box-shadow:0 4px 10px rgba(0,0,0,0.1);}
.progress-bar{background:#ddd;border-radius:20px;overflow:hidden;}
.progress{height:22px;color:white;text-align:center;line-height:22px;font-size:13px;}
.green{background:#28a745;}
.blue{background:#007bff;}
table{width:100%;border-collapse:collapse;}
th,td{padding:10px;border-bottom:1px solid #ddd;text-align:left;}
th{background:#f0f0f0;}
</style>
</head>

<body>

<div class="sidebar">
<h3>User Panel</h3>
<a href="dashboard.jsp">Home</a>
<a href="profile.jsp">Profile</a>
<a href="logout.jsp">Logout</a>
</div>

<div class="main">

<h2>Welcome, <%=userName%></h2>

<!-- SUMMARY CARDS -->
<div class="cards">

<div class="card">
<h4>Resume Strength</h4>
<p><%=df.format(resumeStrength)%></p>
</div>

<div class="card">
<h4>Placement Probability</h4>
<p><%=df.format(placementProbability)%>%</p>
</div>

<div class="card">
<h4>Predicted Salary</h4>
<p><%=df.format(predictedSalary)%> LPA</p>
</div>
</div>

<!-- PERFORMANCE ANALYTICS -->
<div class="section">
<h3>Performance Analytics</h3>

<p>Resume Strength</p>
<div class="progress-bar">
<div class="progress blue" style="width:<%=resumeStrength%>%">
<%=df.format(resumeStrength)%>%
</div>
</div>

<br>

<p>Placement Probability</p>
<div class="progress-bar">
<div class="progress green" style="width:<%=placementProbability%>%">
<%=df.format(placementProbability)%>%
</div>
</div>

</div>

<!-- ACADEMIC PROFILE -->
<div class="section">
<h3>Academic Profile</h3>
<p><b>CGPA:</b> <%=cgpa%></p>
<p><b>Projects:</b> <%=projects%></p>
<p><b>Internships:</b> <%=internships%></p>
<p><b>Certifications:</b> <%=certifications%></p>
<p><b>Preferred Domain:</b> <%=preferredDomain%></p>
<p><b>Expected Salary:</b> <%=expectedSalary%> LPA</p>
</div>

</div>
</body>
</html>

<%
con.close();
%>