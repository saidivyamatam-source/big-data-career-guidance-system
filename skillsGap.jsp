<%@ page language="java" contentType="text/html; charset=UTF-8"%> 
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%

Integer userId=(Integer)session.getAttribute("userId");

if(userId==null){
response.sendRedirect("userLogin.jsp");
return;
}

/* SELECTED DOMAIN */

String domain=request.getParameter("domain");

if(domain==null)
domain="Data Engineer";


String url="jdbc:mysql://localhost:3306/bigdata_project";
String dbUser="root";
String dbPass="root";

Connection con=null;

/* OLD JAVA SYNTAX */

Set userSkills=new HashSet();
Set domainSkills=new HashSet();
Set missingSkills=new HashSet();

/* 50 MARKET DOMAINS */

String domains[]={

"Data Engineer",
"Data Analyst",
"Data Scientist",
"Big Data Engineer",
"Machine Learning Engineer",
"AI Engineer",
"Cloud Engineer",
"DevOps Engineer",
"Software Engineer",
"Backend Developer",

"Frontend Developer",
"Full Stack Developer",
"Database Administrator",
"ETL Developer",
"Business Analyst",
"BI Developer",
"Analytics Engineer",
"ML Ops Engineer",
"AI Researcher",
"Deep Learning Engineer",

"Computer Vision Engineer",
"NLP Engineer",
"Security Engineer",
"Cybersecurity Analyst",
"Network Engineer",
"System Administrator",
"Cloud Architect",
"Solutions Architect",
"Platform Engineer",
"Site Reliability Engineer",

"Product Analyst",
"Quantitative Analyst",
"Research Analyst",
"Marketing Analyst",
"Financial Analyst",
"Risk Analyst",
"Blockchain Developer",
"IoT Engineer",
"Embedded Engineer",
"Game Developer",

"Mobile Developer",
"QA Engineer",
"Automation Engineer",
"Test Engineer",
"Technical Support Engineer",
"IT Consultant",
"ERP Consultant",
"Salesforce Developer",
"Power BI Developer",
"Tableau Developer"

};

%>


<!DOCTYPE html>
<html>
<head>

<title>Skill Gap Analysis</title>

<style>

*{margin:0;padding:0;box-sizing:border-box;}

body{
background:#0d1b2a;
font-family:Arial;
color:white;
}

/* moving background */

body::before{
content:'';
position:fixed;
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


.container{
width:85%;
margin:auto;
padding:40px;
position:relative;
z-index:1;
}


/* TOP BAR */

.topbar{
position:absolute;
top:20px;
left:0;
right:0;
}


.back{
float:left;
padding:12px 25px;
background:#06d6a0;
color:white;
text-decoration:none;
border-radius:8px;
font-size:16px;
}

.logout{
float:right;
padding:12px 25px;
background:#e53935;
color:white;
text-decoration:none;
border-radius:8px;
font-size:16px;
}



/* CARDS */

.card{
background:rgba(255,255,255,0.05);
padding:40px;
margin-bottom:30px;
border-radius:20px;
box-shadow:0 15px 35px rgba(0,0,0,0.4);
font-size:18px;
}


h2{
text-align:center;
margin-bottom:30px;
font-size:32px;
}


h3{
margin-bottom:15px;
}


/* DROPDOWN */

select{
padding:14px;
border-radius:10px;
margin-bottom:30px;
width:320px;
font-size:16px;
}


/* PROGRESS */

.progress{
height:30px;
background:#333;
border-radius:20px;
overflow:hidden;
margin-top:15px;
}

.bar{
height:30px;
background:#06d6a0;
}


/* LIST */

ul{
padding-left:25px;
}

li{
margin-bottom:8px;
font-size:17px;
}

.center{
text-align:center;
font-size:40px;
margin-top:10px;
}

.resource{
margin-left:15px;
color:#ffd166;
text-decoration:none;
font-weight:bold;
}

.resource:hover{
text-decoration:underline;
}

</style>

</head>

<body>

<div class="container">

<div class="topbar">

<a href="dashboard.jsp" class="back">⬅ Back</a>

<a href="logout.jsp" class="logout">Logout</a>

</div>


<h2>Skill Gap Analysis</h2>

<%

try{

Class.forName("com.mysql.jdbc.Driver");

con=DriverManager.getConnection(url,dbUser,dbPass);


/* USER SKILLS */

PreparedStatement ps1=
con.prepareStatement(
"SELECT skill_name FROM skills WHERE user_id=?");

ps1.setInt(1,userId);

ResultSet rs1=ps1.executeQuery();

while(rs1.next()){

userSkills.add(rs1.getString(1).toLowerCase());

}



/* DOMAIN SKILLS */

PreparedStatement ps2=
con.prepareStatement(
"SELECT job_skills FROM job_postings WHERE job_title LIKE ?");

ps2.setString(1,"%"+domain+"%");

ResultSet rs2=ps2.executeQuery();


while(rs2.next()){

String s=rs2.getString(1);

if(s!=null){

String arr[]=s.split(",");

for(int i=0;i<arr.length;i++){

domainSkills.add(arr[i].trim().toLowerCase());

}

}

}



/* SKILL GAP */

missingSkills.addAll(domainSkills);
missingSkills.removeAll(userSkills);



/* MATCH % */

int match=0;

if(domainSkills.size()>0){

int matched=domainSkills.size()-missingSkills.size();

match=(matched*100)/domainSkills.size();

}

%>



<form>

<select name="domain" onchange="this.form.submit()">

<%

for(int i=0;i<domains.length;i++){

%>

<option value="<%=domains[i]%>"
<% if(domains[i].equals(domain)) out.print("selected"); %>>

<%=domains[i]%>

</option>

<%

}

%>

</select>

</form>



<!-- MATCH CARD -->

<div class="card">

<h3>Selected Domain: <%=domain%></h3>

<div class="center">

<%=match%> %

</div>

<div class="progress">

<div class="bar" style="width:<%=match%>%">

</div>

</div>

</div>



<!-- USER SKILLS -->

<div class="card">

<h3>Your Skills</h3>

<ul>

<%

Iterator it=userSkills.iterator();

while(it.hasNext()){

out.println("<li>"+it.next()+"</li>");

}

%>

</ul>

</div>



<!-- SKILL GAPS -->

<div class="card">

<h3>Top Skill Gaps</h3>

<ul>

<%

Iterator it2=missingSkills.iterator();

int count=0;

while(it2.hasNext()){

out.println("<li>"+it2.next()+"</li>");

count++;

if(count==15)break;

}

%>

</ul>

</div>



<!-- RECOMMENDATIONS WITH YOUTUBE RESOURCES -->

<div class="card">

<h3>Recommendations & Learning Resources</h3>

<ul>

<%

Iterator it3=missingSkills.iterator();

count=0;

while(it3.hasNext()){

String s=(String)it3.next();

/* Generate YouTube search */

String yt="https://www.youtube.com/results?search_query="+s.replace(" ","+")+"+tutorial";

out.println("<li>Learn "+s+" to improve match "
+"<a class='resource' target='_blank' href='"+yt+"'>▶ Watch Tutorial</a></li>");

count++;

if(count==10)break;

}

%>

</ul>

</div>


<%

}catch(Exception e){

out.println(e);

}

%>

</div>

</body>
</html>