<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("adminLogin.html");
    return;
}

int totalUsers = 0;
int totalDatasets = 0;
String topSkill="";

double avgResume = 0;
double avgPlacement = 0;
double avgSalary = 0;

try{

    // Count users
    Statement st1 = con.createStatement();
    ResultSet rs1 = st1.executeQuery("SELECT COUNT(*) FROM users");
    if(rs1.next()){
        totalUsers = rs1.getInt(1);
    }
    rs1.close();
    st1.close();

    // Count datasets
    Statement st2 = con.createStatement();
    ResultSet rs2 = st2.executeQuery("SELECT COUNT(*) FROM job_postings");
    if(rs2.next()){
        totalDatasets = rs2.getInt(1);
    }
    rs2.close();
    st2.close();

    // Top Skill
    PreparedStatement psTop = con.prepareStatement(
    "SELECT skill_name FROM market_demand ORDER BY demand_percentage DESC LIMIT 1");

    ResultSet rsTop = psTop.executeQuery();
    if(rsTop.next()){
        topSkill = rsTop.getString(1);
    }
    rsTop.close();
    psTop.close();

    // ==============================
    // Calculate Average User Metrics
    // ==============================

    PreparedStatement psUsers = con.prepareStatement(
    "SELECT cgpa, projects, internships, certifications FROM users_profile");

    ResultSet rsUsers = psUsers.executeQuery();

    int count = 0;

    while(rsUsers.next()){

        double cgpa = rsUsers.getDouble("cgpa");
        int projects = rsUsers.getInt("projects");
        int internships = rsUsers.getInt("internships");
        int certifications = rsUsers.getInt("certifications");

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

        avgResume += resumeStrength;
        avgPlacement += placementProbability;
        avgSalary += predictedSalary;

        count++;
    }

    if(count > 0){
        avgResume /= count;
        avgPlacement /= count;
        avgSalary /= count;
    }

    rsUsers.close();
    psUsers.close();

}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    margin:0;
    background:linear-gradient(135deg,#1e3c72,#2a5298);
    font-family:'Segoe UI';
    color:white;
}
.sidebar{
    width:250px;
    height:100vh;
    position:fixed;
    background:rgba(0,0,0,0.4);
    padding:20px;
}
.sidebar a{
    display:block;
    padding:12px;
    color:white;
    text-decoration:none;
    border-radius:10px;
    margin-bottom:10px;
}
.sidebar a:hover{
    background:rgba(255,255,255,0.2);
}
.main{
    margin-left:270px;
    padding:30px;
}
.card-glass{
    background:rgba(255,255,255,0.1);
    padding:25px;
    border-radius:20px;
    backdrop-filter:blur(20px);
    box-shadow:0 8px 32px rgba(0,0,0,0.4);
    text-align:center;
}
</style>
</head>

<body>

<div class="sidebar">
    <h3>Admin Panel</h3>
    <a href="viewUsers.jsp">View Users</a>
    <a href="manageMarket.jsp">Manage Market Demand</a>
    <a href="uploadIndustryData.jsp">Upload Industry CSV</a>
    <a href="viewJobs.jsp">View Uploaded Jobs</a>
    <a href="analytics.jsp">Analytics</a>
    <a href="logout.jsp">Logout</a>
    
</div>

<div class="main">
    <h2>Welcome, <%= session.getAttribute("admin") %></h2>
    <br>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="card-glass">
                <h4>Total Users</h4>
                <h2><%= totalUsers %></h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card-glass">
                <h4>Total Datasets</h4>
                <h2><%= totalDatasets %></h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card-glass">
                <h4>Top Skill</h4>
                <h2><%= topSkill %></h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card-glass">
                <h4>Avg Resume Strength</h4>
                <h2><%= String.format("%.2f", avgResume) %></h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card-glass">
                <h4>Avg Placement Probability</h4>
                <h2><%= String.format("%.2f", avgPlacement) %> %</h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card-glass">
                <h4>Avg Predicted Salary</h4>
                <h2><%= String.format("%.2f", avgSalary) %> LPA</h2>
            </div>
        </div>

    </div>

</div>

</body>
</html>