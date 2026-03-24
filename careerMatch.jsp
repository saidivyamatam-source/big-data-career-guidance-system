<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
if(session.getAttribute("userId")==null){
response.sendRedirect("userLogin.jsp");
return;
}

int userId=(Integer)session.getAttribute("userId");

String limitParam=request.getParameter("limit");

int limit=10;

if(limitParam!=null){
limit=Integer.parseInt(limitParam);
}

String dbURL="jdbc:mysql://localhost:3306/bigdata_project";
String dbUser="root";
String dbPass="root";

Connection con=null;
PreparedStatement psSkills=null;
PreparedStatement psJobs=null;

ResultSet rsSkills=null;
ResultSet rsJobs=null;

List<String> userSkills=new ArrayList<String>();

List<String[]> jobList=new ArrayList<String[]>();

try{

Class.forName("com.mysql.jdbc.Driver");

con=DriverManager.getConnection(dbURL,dbUser,dbPass);


/* ===== GET USER SKILLS ===== */

psSkills=con.prepareStatement(
"SELECT skill_name FROM skills WHERE user_id=?"
);

psSkills.setInt(1,userId);

rsSkills=psSkills.executeQuery();

while(rsSkills.next()){

userSkills.add(
rsSkills.getString("skill_name").toLowerCase().trim()
);

}


/* ===== GET JOBS ===== */

psJobs=con.prepareStatement(
"SELECT * FROM job_postings"
);

rsJobs=psJobs.executeQuery();


while(rsJobs.next()){

String title=rsJobs.getString("job_title");
String company=rsJobs.getString("company");
String location=rsJobs.getString("job_location");
String link=rsJobs.getString("job_link");
String jobSkills=rsJobs.getString("job_skills");

if(jobSkills==null) jobSkills="";

String jobSkillsLower=jobSkills.toLowerCase();


int matched=0;

for(String skill:userSkills){

if(jobSkillsLower.contains(skill)){

matched++;

}

}


int score=0;

if(userSkills.size()>0){

score=(matched*100)/userSkills.size();

}


if(score>0){

jobList.add(new String[]{
title,
company,
location,
link,
jobSkills,
String.valueOf(score)
});

}

}


/* ===== SORT BY SCORE ===== */

Collections.sort(jobList,new Comparator<String[]>(){

public int compare(String a[],String b[]){

return Integer.parseInt(b[5])-
Integer.parseInt(a[5]);

}

});

%>

<!DOCTYPE html>
<html>

<head>

<title>Career Match</title>

<style>

body{
background:#0d1b2a;
font-family:Segoe UI;
color:white;
}

.container{

width:80%;
margin:auto;
padding:40px;

}

.job-card{

background:rgba(255,255,255,0.05);
padding:25px;
margin-bottom:20px;
border-radius:20px;
box-shadow:0 15px 30px rgba(0,0,0,0.3);
backdrop-filter:blur(10px);

}

.job-card h3{
color:#ffd166;
}

.match{
color:#06d6a0;
font-weight:bold;
}

.btn{

padding:10px 20px;
background:linear-gradient(90deg,#ffd166,#ef476f);
color:white;
border-radius:50px;
text-decoration:none;
display:inline-block;
margin-top:10px;

}

select{

padding:8px;
border-radius:10px;
margin-bottom:20px;

}

.back-btn{

padding:10px 20px;
background:#06d6a0;
color:black;
border-radius:50px;
text-decoration:none;
display:inline-block;
margin-bottom:20px;

}

</style>

</head>

<body>

<div class="container">

<a href="dashboard.jsp" class="back-btn">

⬅ Back Dashboard

</a>

<h2>Top Career Matches</h2>


<!-- Dropdown -->

<form>

Show Jobs :

<select name="limit" onchange="this.form.submit()">

<option value="10" <%=limit==10?"selected":""%>>Top 10</option>

<option value="20" <%=limit==20?"selected":""%>>Top 20</option>

<option value="50" <%=limit==50?"selected":""%>>Top 50</option>

<option value="1000" <%=limit==1000?"selected":""%>>All</option>

</select>

</form>


<%

int count=0;

for(String job[]:jobList){

if(count>=limit) break;

count++;

%>


<div class="job-card">

<h3><%=job[0]%></h3>

<p><b>Company:</b> <%=job[1]%></p>

<p><b>Location:</b> <%=job[2]%></p>

<p><b>Skills:</b> <%=job[4]%></p>

<p class="match">

Match Score :

<%=job[5]%>%

</p>

<a href="<%=job[3]%>" target="_blank" class="btn">

Apply Job

</a>

</div>

<%

}

if(count==0){

%>

<h3>No matching jobs found</h3>

<%

}

%>

</div>

</body>

</html>

<%

}catch(Exception e){

out.println("Error:"+e);

}
%>