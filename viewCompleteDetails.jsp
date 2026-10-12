<%@ page language="java" contentType="text/html; charset=UTF-8"%>  
<%@ page import="java.sql.*" %>

<%
Integer userId = (Integer) session.getAttribute("userId");
if(userId == null){
response.sendRedirect("userLogin.jsp");
return;
}

String url = "jdbc:mysql://localhost:3306/bigdata_project";
String dbUser = "root";
String dbPass = "root";

Connection conn = null;
PreparedStatement psUser = null, psCert = null, psSkill = null, psProj = null;
ResultSet rsUser = null, rsCert = null, rsSkill = null, rsProj = null;

String userName = "";
String course = "";
double cgpa = 0;
%>

<!DOCTYPE html>
<html>
<head>

<title>Complete Details</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

/* Reset */

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Segoe UI;
}


/* Background */

body{

background: linear-gradient(135deg,#0f2027,#203a43,#2c5364);
min-height:100vh;

}


/* Moving dotted background */

body::before {
content:'';
position:fixed;
top:0;
left:0;
width:100%;
height:100%;
background: radial-gradient(circle, rgba(255,255,255,0.05) 15%, transparent 15%) repeat;
background-size:80px 80px;
animation: moveBg 60s linear infinite;
z-index:0;
}

@keyframes moveBg {
0%{background-position:0 0;}
100%{background-position:800px 800px;}
}


/* Container */

.container{

max-width:1100px;
margin:auto;
padding:50px;
position:relative;
z-index:2;

}


/* Title */

h2{

font-size:34px;
font-weight:bold;
color:white;
margin-bottom:30px;

}


/* Cards */

.card{

background:rgba(255,255,255,0.08);

padding:35px;

border-radius:20px;

margin-bottom:30px;

backdrop-filter:blur(10px);

border:1px solid rgba(255,255,255,0.2);

box-shadow:0px 10px 30px rgba(0,0,0,0.4);

transition:.3s;

}

.card:hover{

transform:translateY(-6px);

}


/* Card Titles */

.card h3{

color:#ffd166;

font-size:26px;

margin-bottom:20px;

}


/* Text */

p,li{

font-size:18px;

color:#eee;

}

ul{

padding-left:25px;

}


/* Back Button */

.back-btn{

position:absolute;

left:10px;
top:10px;

padding:12px 28px;

background:#1abc9c;

border-radius:10px;

color:white;

text-decoration:none;

font-weight:bold;

font-size:16px;

box-shadow:0px 5px 15px rgba(0,0,0,0.3);

transition:.3s;

}

.back-btn:hover{

background:#16a085;

}


</style>

</head>


<body>

<div class="container">

<a href="dashboard.jsp" class="back-btn">
⬅ Back
</a>

<%

try{

Class.forName("com.mysql.jdbc.Driver");

conn = DriverManager.getConnection(url,dbUser,dbPass);


/* User Info */

psUser = conn.prepareStatement(
"SELECT name,course,cgpa FROM users WHERE id=?");

psUser.setInt(1,userId);

rsUser = psUser.executeQuery();

if(rsUser.next()){

userName=rsUser.getString("name");

course=rsUser.getString("course");

cgpa=rsUser.getDouble("cgpa");

}

%>


<h2 align="center">

Complete Details - <%= userName %>

</h2>



<!-- Academic -->

<div class="card">

<h3>🎓 Academic Details</h3>

<p>

<b>Course :</b> <%= course %>

</p>

<p>

<b>CGPA :</b> <%= cgpa %> / 10

</p>

</div>



<!-- Certifications -->

<div class="card">

<h3>📜 Certifications</h3>

<ul>

<%

psCert=conn.prepareStatement(
"SELECT cert_name,issued_by,date_earned FROM certifications WHERE user_id=?");

psCert.setInt(1,userId);

rsCert=psCert.executeQuery();

boolean hasCert=false;

while(rsCert.next()){

hasCert=true;

%>

<li>

<%= rsCert.getString("cert_name") %>

-

<%= rsCert.getString("issued_by") %>

(

<%= rsCert.getDate("date_earned") %>

)

</li>

<%

}

if(!hasCert){

%>

<li>No Certifications Added</li>

<%

}

%>

</ul>

</div>



<!-- Skills -->

<div class="card">

<h3>💻 Skills</h3>

<ul>

<%

psSkill=conn.prepareStatement(
"SELECT skill_name,skill_level FROM skills WHERE user_id=?");

psSkill.setInt(1,userId);

rsSkill=psSkill.executeQuery();

boolean hasSkill=false;

while(rsSkill.next()){

hasSkill=true;

%>

<li>

<%= rsSkill.getString("skill_name") %>

-

<%= rsSkill.getInt("skill_level") %> %

</li>

<%

}

if(!hasSkill){

%>

<li>No Skills Added</li>

<%

}

%>

</ul>

</div>



<!-- Projects -->

<div class="card">

<h3>🚀 Projects</h3>

<ul>

<%

psProj=conn.prepareStatement(
"SELECT project_title,technologies,status FROM projects WHERE user_id=?");

psProj.setInt(1,userId);

rsProj=psProj.executeQuery();

boolean hasProj=false;

while(rsProj.next()){

hasProj=true;

%>

<li>

<b>

<%= rsProj.getString("project_title") %>

</b>

-

<%= rsProj.getString("technologies") %>

(

<%= rsProj.getString("status") %>

)

</li>

<%

}

if(!hasProj){

%>

<li>No Projects Added</li>

<%

}

%>

</ul>

</div>



<%

}catch(Exception e){

out.println("Error :"+e.getMessage());

}

%>


</div>

</body>

</html>