<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>

<%
String userName = (String) session.getAttribute("userName");
String userEmail = (String) session.getAttribute("userEmail");

if(userName == null){
response.sendRedirect("userLogin.jsp");
return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Dashboard - Big Data Professionals</title>

<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
}

html,body{

height:100%;
font-family:'Roboto', sans-serif;
scroll-behavior:smooth;
background:#0d1b2a;
color:#fff;
overflow-x:hidden;

}

/* HEADER */

.header{

background:rgba(13,59,102,0.95);
backdrop-filter:blur(6px);

position:sticky;
top:0;
z-index:1000;

box-shadow:0 4px 20px rgba(0,0,0,0.2);

}

.header .container{

display:flex;
justify-content:space-between;
align-items:center;

padding:15px 0;

}

.logo h1{

font-size:2rem;
font-weight:700;
color:#ffd166;

}

.btn-logout{

background:#e53935;
border:none;
border-radius:50px;
padding:8px 20px;

font-weight:600;
color:white;

}

/* ANIMATED BACKGROUND */

canvas#animated-bg{

position:absolute;
top:0;
left:0;

width:100%;
height:100%;

z-index:0;

}

/* HERO */

.hero{

position:relative;
z-index:1;

text-align:center;

padding:60px 20px;

}

.hero h2{

font-size:2.5rem;
font-weight:700;
color:#ffd166;

margin-bottom:10px;

}

.hero p{

font-size:1.1rem;
color:#e0e0e0;

}

/* DASHBOARD GRID */

.dashboard{

display:grid;

grid-template-columns:repeat(auto-fit,minmax(250px,1fr));

gap:35px;

max-width:1100px;

margin:auto;

padding:40px 20px;

position:relative;
z-index:1;

}

/* DASHBOARD CARD */

.btn-dashboard{

background:rgba(255,255,255,0.05);

border-radius:18px;

padding:28px;

text-align:center;

backdrop-filter:blur(12px);

border:1px solid rgba(255,255,255,0.08);

box-shadow:0 10px 30px rgba(0,0,0,0.35);

transition:all 0.3s ease;

display:flex;

flex-direction:column;

justify-content:space-between;

}

/* CARD HOVER */

.btn-dashboard:hover{

transform:translateY(-8px) scale(1.03);

box-shadow:0 18px 40px rgba(0,0,0,0.5);

}

/* ICON */

.icon{

font-size:36px;

margin-bottom:12px;

}

/* TITLE */

.card-title{

font-size:18px;

font-weight:700;

color:#ffd166;

margin-bottom:10px;

}

/* DESCRIPTION */

.card-desc{

font-size:14px;

color:#ddd;

margin-bottom:18px;

line-height:1.5;

}

/* BUTTON */

.open-btn{

display:inline-block;

padding:8px 20px;

border-radius:40px;

background:linear-gradient(90deg,#ffd166,#ef476f);

color:white;

text-decoration:none;

font-size:14px;

font-weight:600;

transition:0.3s;

}

.open-btn:hover{

transform:scale(1.05);

box-shadow:0 10px 20px rgba(0,0,0,0.4);

}

/* FOOTER */

.footer{

background:#0d3b66;

color:white;

text-align:center;

padding:20px;

font-size:0.9rem;

margin-top:40px;

}

/* MOBILE */

@media(max-width:768px){

.hero h2{font-size:2rem;}

}

</style>

</head>

<body>

<canvas id="animated-bg"></canvas>

<!-- HEADER -->

<header class="header">

<div class="container">

<div class="logo">
<h1>Big Data Professionals</h1>
</div>

<a href="logout.jsp" class="btn btn-danger">
🚪 Logout
</a>

</div>

</header>

<!-- HERO -->

<section class="hero">

<h2>Welcome, <%= userName %>!</h2>

<p>Email: <%= userEmail %></p>

</section>

<!-- DASHBOARD -->

<section class="dashboard">

<!-- Academic Summary -->

<div class="btn-dashboard">

<div>

<div class="icon">🎓</div>

<div class="card-title">
Academic Summary
</div>

<div class="card-desc">
View CGPA, skills and certification details.
</div>

</div>

<a href="academicSummary.jsp" class="open-btn">
Add Profile
</a>

</div>


<!-- Career Match -->

<div class="btn-dashboard">

<div>

<div class="icon">💼</div>

<div class="card-title">
Career Match
</div>

<div class="card-desc">
Find jobs matching your skills and profile.
</div>

</div>

<a href="careerMatch.jsp" class="open-btn">
Open
</a>

</div>


<!-- Analytics -->

<div class="btn-dashboard">

<div>

<div class="icon">📊</div>

<div class="card-title">
Analytics & Insights
</div>

<div class="card-desc">
Check employability score and skill demand.
</div>

</div>

<a href="Analytics_insights.jsp" class="open-btn">
Open
</a>

</div>


<!-- Skill Gap -->

<div class="btn-dashboard">

<div>

<div class="icon">🧠</div>

<div class="card-title">
Skills Gap & Suggestions
</div>

<div class="card-desc">
Identify missing skills and get improvement suggestions.
</div>

</div>

<a href="skillsGap.jsp" class="open-btn">
Open
</a>

</div>


<!-- Quick Actions -->

<div class="btn-dashboard">

<div>

<div class="icon">⚡</div>

<div class="card-title">
Quick Actions
</div>

<div class="card-desc">
Access important features instantly.
</div>

</div>

<a href="quickActions.jsp" class="open-btn">
Open
</a>

</div>


<!-- Career Roadmaps -->

<div class="btn-dashboard">

<div>

<div class="icon">🧭</div>

<div class="card-title">
Career Roadmaps
</div>

<div class="card-desc">
Get a personalized step-by-step career roadmap.
</div>

</div>

<a href="roadmaps.jsp" class="open-btn">
Open
</a>

</div>

</section>

<!-- FOOTER -->

<footer class="footer">

<p>© 2026 Big Data Professionals. All rights reserved.</p>

</footer>

<!-- Bootstrap -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Animated Background -->

<script>

const canvas=document.getElementById('animated-bg');

const ctx=canvas.getContext('2d');

let width=canvas.width=window.innerWidth;
let height=canvas.height=window.innerHeight;

const circles=[];
const numCircles=30;

class Circle{

constructor(){this.reset();}

reset(){

this.x=Math.random()*width;
this.y=Math.random()*height;

this.radius=Math.random()*50+20;

this.speedX=(Math.random()-0.5)*1.2;
this.speedY=(Math.random()-0.5)*1.2;

this.color=`hsla(${Math.random()*360},80%,60%,0.2)`;

}

draw(){

ctx.beginPath();
ctx.arc(this.x,this.y,this.radius,0,Math.PI*2);

ctx.fillStyle=this.color;
ctx.fill();

}

update(){

this.x+=this.speedX;
this.y+=this.speedY;

if(this.x<-this.radius||this.x>width+this.radius||this.y<-this.radius||this.y>height+this.radius){

this.reset();

}

}

}

for(let i=0;i<numCircles;i++){

circles.push(new Circle());

}

function animate(){

ctx.clearRect(0,0,width,height);

circles.forEach(c=>{
c.update();
c.draw();
});

requestAnimationFrame(animate);

}

animate();

window.addEventListener('resize',()=>{

width=canvas.width=window.innerWidth;
height=canvas.height=window.innerHeight;

});

</script>

</body>
</html>