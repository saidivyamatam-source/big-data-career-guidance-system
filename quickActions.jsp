<%@ page language="java" contentType="text/html; charset=UTF-8"%> 

<%
if(session.getAttribute("userId")==null){
    response.sendRedirect("userLogin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Quick Actions</title>

<style>



/* Reset */
*{
margin:0;
padding:0;
box-sizing:border-box;
}

/* Body */

body{
font-family:'Roboto',sans-serif;
background:#0d1b2a;
color:white;
overflow-x:hidden;
position:relative;
}


/* Moving Dotted Background */

body::before{
content:'';
position:fixed;
top:0;
left:0;
width:100%;
height:100%;
background: radial-gradient(circle, rgba(255,255,255,0.05) 15%, transparent 15%) repeat;
background-size:80px 80px;
animation:moveBg 60s linear infinite;
z-index:0;
}

@keyframes moveBg{

0%{background-position:0 0;}
100%{background-position:800px 800px;}

}


/* Top Bar */

.top-bar{

position:absolute;
top:20px;
left:0;
width:100%;
padding:0 40px;
display:flex;
justify-content:space-between;
z-index:2;

}


/* Buttons */

.btn{

padding:12px 25px;
border-radius:50px;
text-decoration:none;
font-weight:bold;
transition:0.3s;
display:inline-block;

}


/* Back Button */

.back-btn{

background:linear-gradient(90deg,#ffd166,#ffb703);
color:black;

}


/* Logout Button */

.logout-btn{

background:linear-gradient(90deg,#ef476f,#d62828);
color:white;

}


.btn:hover{

transform:scale(1.05);
box-shadow:0 10px 25px rgba(0,0,0,0.5);

}


/* Container */

.container{

width:95%;
margin:auto;
padding-top:110px;
text-align:center;
position:relative;
z-index:1;

}


/* Heading */

h1{

margin-bottom:10px;
color:#ffd166;

}

p{

margin-bottom:40px;

}


/* Cards Row */

.grid{

display:flex;
justify-content:center;
gap:25px;
flex-wrap:nowrap;

}


/* Cards */

.card{

background:rgba(255,255,255,0.05);
backdrop-filter:blur(10px);
border-radius:20px;
padding:30px;
width:230px;
box-shadow:0 15px 35px rgba(0,0,0,0.3);
border:1px solid rgba(255,255,255,0.1);
transition:0.3s;

}


.card:hover{

transform:translateY(-10px) scale(1.05);

}


/* Icons */

.icon{

font-size:40px;
margin-bottom:15px;

}


/* Titles */

.title{

font-size:18px;
font-weight:bold;
margin-bottom:10px;
color:#ffd166;

}


/* Description */

.desc{

font-size:14px;
margin-bottom:20px;
color:#ddd;

}


/* Card Buttons */

.open-btn{

background:linear-gradient(90deg,#ffd166,#ef476f);
color:white;

}


/* Responsive */

@media(max-width:1200px){

.grid{
flex-wrap:wrap;
}

}



</style>

</head>

<body>


<!-- Floating Background -->

<div class="circle c1"></div>
<div class="circle c2"></div>
<div class="circle c3"></div>
<div class="circle c4"></div>



<!-- Top Buttons -->

<div class="top-bar">

<a href="dashboard.jsp" class="btn back-btn">
⬅ Back
</a>

<a href="logout.jsp" class="btn logout-btn">
Logout
</a>

</div>



<div class="container">


<h1>⚡ Quick Actions</h1>

<p>Access all important features instantly</p>



<div class="grid">


<!-- Career Match -->

<div class="card">

<div class="icon">💼</div>

<div class="title">
Career Match
</div>

<div class="desc">
View top matching jobs based on your skills.
</div>

<a href="careerMatch.jsp" class="btn open-btn">
Open
</a>

</div>



<!-- Analytics -->

<div class="card">

<div class="icon">📊</div>

<div class="title">
Analytics & Insights
</div>

<div class="desc">
Check employability score and AI insights.
</div>

<a href="Analytics_insights.jsp" class="btn open-btn">
Open
</a>

</div>



<!-- Update Profile -->

<div class="card">

<div class="icon">👤</div>

<div class="title">
Update Profile
</div>

<div class="desc">
Modify skills, CGPA, and personal details.
</div>

<a href="academicSummary.jsp" class="btn open-btn">
Edit
</a>

</div>



<!-- Applications -->

<div class="card">

<div class="icon">👤</div>

<div class="title">
profile
</div>

<div class="desc">
view complete profile details
</div>

<a href="viewCompleteDetails.jsp" class="btn open-btn">
View
</a>

</div>



<!-- Skill Gap -->

<div class="card">

<div class="icon">📚</div>

<div class="title">
Skill Gap
</div>

<div class="desc">
Identify missing skills based on demand.
</div>

<a href="Analytics_insights.jsp" class="btn open-btn">
Analyze
</a>

</div>


</div>

</div>

</body>
</html>