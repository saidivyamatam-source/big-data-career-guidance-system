<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
String selectedDomain = request.getParameter("domain");

PreparedStatement ps;

if(selectedDomain==null || selectedDomain.equals("All")){
    ps = con.prepareStatement("SELECT * FROM domain_roadmaps");
}else{
    ps = con.prepareStatement("SELECT * FROM domain_roadmaps WHERE domain_name=?");
    ps.setString(1,selectedDomain);
}

ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>

<title>Career Roadmaps</title>

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:'Segoe UI',sans-serif;
}

/* PAGE BACKGROUND */

body{
background:linear-gradient(135deg,#0f172a,#1e293b);
color:white;
min-height:100vh;
}

/* HEADER */

.header{
background:#020617;
padding:22px;
text-align:center;
font-size:30px;
font-weight:700;
letter-spacing:1px;
box-shadow:0 4px 15px rgba(0,0,0,0.6);
}

/* NAV BUTTONS */

.back{
position:absolute;
left:20px;
top:20px;
background:#38bdf8;
padding:9px 18px;
border-radius:8px;
text-decoration:none;
color:black;
font-weight:600;
transition:0.3s;
}

.back:hover{
background:#0ea5e9;
}

.logout{
position:absolute;
right:20px;
top:20px;
background:#ef4444;
padding:9px 18px;
border-radius:8px;
text-decoration:none;
color:white;
font-weight:600;
transition:0.3s;
}

.logout:hover{
background:#dc2626;
}

/* FILTER SECTION */

.controls{
text-align:center;
margin:35px;
}

select,input{
padding:10px 15px;
border-radius:8px;
border:none;
font-size:14px;
margin:5px;
}

input[type="submit"]{
background:#38bdf8;
cursor:pointer;
font-weight:600;
}

input[type="submit"]:hover{
background:#0ea5e9;
}

/* CONTAINER */

.container{
display:flex;
flex-direction:column;
gap:45px;
padding:40px 80px;
}

/* DOMAIN CARD */

.domainCard{
background:#1e293b;
border-radius:16px;
padding:30px;
box-shadow:0 15px 35px rgba(0,0,0,0.5);
transition:0.3s;
}

.domainCard:hover{
transform:translateY(-5px);
}

/* DOMAIN TITLE */

.title{
font-size:28px;
color:#38bdf8;
margin-bottom:25px;
font-weight:600;
}

/* ROADMAP FLOW */

.roadmap{
display:flex;
align-items:center;
justify-content:flex-start;
flex-wrap:wrap;
gap:20px;
}

/* STEP */

.step{
background:#334155;
padding:18px;
border-radius:12px;
width:190px;
text-align:center;
transition:0.3s;
box-shadow:0 6px 18px rgba(0,0,0,0.4);
}

.step:hover{
transform:scale(1.08);
background:#475569;
}

/* STEP TITLE */

.stepTitle{
font-weight:bold;
margin-bottom:8px;
color:#22c55e;
font-size:15px;
}

/* ARROW */

.arrow{
font-size:28px;
margin:5px;
}

/* INFO SECTIONS */

.section{
margin-top:16px;
font-size:15px;
line-height:1.6;
}

/* SALARY */

.salary{
color:#22c55e;
font-weight:bold;
font-size:16px;
}

/* RESOURCE LINKS */

.resources a{
color:#38bdf8;
text-decoration:none;
}

.resources a:hover{
text-decoration:underline;
}

.resources ul{
margin-top:8px;
padding-left:18px;
}

</style>

</head>

<body>

<a class="back" href="dashboard.jsp">⬅ Back</a>
<a class="logout" href="logout.jsp">Logout</a>

<div class="header">
🚀 Career Learning Roadmaps
</div>

<div class="controls">

<form method="get">

<select name="domain">

<option>All</option>

<%
PreparedStatement ps2 = con.prepareStatement("SELECT DISTINCT domain_name FROM domain_roadmaps");
ResultSet rs2 = ps2.executeQuery();

while(rs2.next()){
%>

<option value="<%=rs2.getString("domain_name")%>">
<%=rs2.getString("domain_name")%>
</option>

<%
}
%>

</select>

<input type="submit" value="Filter">

</form>

</div>

<div class="container">

<%
while(rs.next()){

String steps = rs.getString("roadmap_steps");
String[] stepList = steps.split("\n");
%>

<div class="domainCard">

<div class="title">
<%=rs.getString("domain_name")%>
</div>

<div class="roadmap">

<%
for(int i=0;i<stepList.length;i++){
%>

<div class="step">

<div class="stepTitle">
Step <%=i+1%>
</div>

<div>
<%=stepList[i]%>
</div>

</div>

<%
if(i < stepList.length-1){
%>

<div class="arrow">➡</div>

<%
}
}
%>

</div>

<div class="section">
<b>Skills:</b> <%=rs.getString("required_skills")%>
</div>

<div class="section">
<b>Projects:</b> <%=rs.getString("projects")%>
</div>

<div class="section">
<b>Career Tips:</b> <%=rs.getString("career_tips")%>
</div>

<div class="section salary">
💰 Salary: <%=rs.getString("expected_salary")%>
</div>

<div class="section">
⏱ Learning Time: <%=rs.getString("learning_time")%>
</div>

<div class="section resources">

<b>Resources:</b>

<ul>

<%
String resources = rs.getString("resources");

if(resources!=null){

String[] resList = resources.split("\n");

for(int i=0;i<resList.length;i++){

String[] parts = resList[i].split("-");

if(parts.length==2){
%>

<li>

<a href="<%=parts[1].trim()%>" target="_blank">
<%=parts[0].trim()%>
</a>

</li>

<%
}
}
}
%>

</ul>

</div>

</div>

<%
}
%>

</div>

</body>
</html>