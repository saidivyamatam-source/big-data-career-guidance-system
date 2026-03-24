<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
if(session.getAttribute("userId")==null){
    response.sendRedirect("userLogin.jsp");
    return;
}

int userId = (Integer) session.getAttribute("userId");

String dbURL = "jdbc:mysql://localhost:3306/bigdata_project";
String dbUser = "root";
String dbPass = "root";

Connection con = null;
PreparedStatement psUser = null;
PreparedStatement psSkills = null;
PreparedStatement psJobs = null;
ResultSet rsUser = null;
ResultSet rsSkills = null;
ResultSet rsJobs = null;

double cgpa = 0;
List<String> studentSkills = new ArrayList<String>();
Map<String,Integer> marketDemand = new LinkedHashMap<String,Integer>();

int employabilityScore = 0;
int resumeScore = 0;

try{
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(dbURL, dbUser, dbPass);

    // FETCH CGPA
    psUser = con.prepareStatement("SELECT cgpa FROM users WHERE id=?");
    psUser.setInt(1, userId);
    rsUser = psUser.executeQuery();

    if(rsUser.next()){
        cgpa = rsUser.getDouble("cgpa");
    }

    // FETCH SKILLS
    psSkills = con.prepareStatement(
    "SELECT DISTINCT LOWER(TRIM(skill_name)) AS skill_name FROM skills WHERE user_id=?");

    psSkills.setInt(1, userId);
    rsSkills = psSkills.executeQuery();

    while(rsSkills.next()){
        String skill = rsSkills.getString("skill_name");

        if(skill != null && !skill.equals("")){
            studentSkills.add(skill);
        }
    }

    // MARKET DEMAND
    psJobs = con.prepareStatement("SELECT job_skills FROM job_postings");
    rsJobs = psJobs.executeQuery();

    while(rsJobs.next()){

        String jobSkills = rsJobs.getString("job_skills");

        if(jobSkills != null && !jobSkills.trim().equals("")){

            String[] arr = jobSkills.toLowerCase().split(",");

            for(String s : arr){

                s=s.trim();

                if(!s.equals("")){

                    marketDemand.put(s,
                    marketDemand.getOrDefault(s,0)+1);

                }
            }
        }
    }

    // EMPLOYABILITY SCORE

    int matchedSkills = 0;

    for(String skill : studentSkills){

        if(marketDemand.containsKey(skill)){

            matchedSkills++;

        }
    }

    int totalStudentSkills = studentSkills.size();

    double skillMatchPercent = 0;

    if(totalStudentSkills>0){

        skillMatchPercent =
        ((double)matchedSkills/totalStudentSkills)*100;

    }

    int cgpaScore = (int)((cgpa/10)*40);

    int skillScore = (int)((skillMatchPercent/100)*60);

    employabilityScore = cgpaScore + skillScore;

    if(employabilityScore>100)
        employabilityScore=100;


    // RESUME SCORE

    int resumePoints = 0;

    if(cgpa>=8)
        resumePoints+=40;
    else if(cgpa>=7)
        resumePoints+=30;
    else if(cgpa>=6)
        resumePoints+=20;
    else
        resumePoints+=10;

    if(totalStudentSkills>=8)
        resumePoints+=40;
    else if(totalStudentSkills>=5)
        resumePoints+=30;
    else if(totalStudentSkills>=3)
        resumePoints+=20;
    else if(totalStudentSkills>0)
        resumePoints+=10;

    if(matchedSkills>=5)
        resumePoints+=20;
    else if(matchedSkills>=3)
        resumePoints+=15;
    else if(matchedSkills>=1)
        resumePoints+=10;

    resumeScore=resumePoints;

    if(resumeScore>100)
        resumeScore=100;

%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Analytics Dashboard</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">

<style>

* { margin:0; padding:0; box-sizing:border-box; }
html, body { height:100%; font-family:'Roboto', sans-serif; scroll-behavior:smooth; background:#0d1b2a; color:#fff; overflow-x:hidden; }

body::before {
content:'';
position:fixed;
top:0; left:0;
width:100%; height:100%;
background: radial-gradient(circle, rgba(255,255,255,0.05) 15%, transparent 15%) repeat;
background-size:80px 80px;
animation: moveBg 60s linear infinite;
z-index:0;
}

@keyframes moveBg {
0%{background-position:0 0;}
100%{background-position:800px 800px;}
}

.container { max-width:1100px; margin:60px auto; padding:0 20px; position:relative; z-index:1; }

.header { text-align:center; margin-bottom:40px; position:relative; }

.header h1 { font-size:2.8rem; color:#ffd166; margin-bottom:20px; }

.back-btn {
position:absolute;
top:0;
left:0;
padding:10px 25px;
border-radius:50px;
font-weight:700;
background: linear-gradient(90deg,#ef476f,#ffd166);
color:#0d1b2a;
text-decoration:none;
}

.card {
background: rgba(255,255,255,0.07);
padding:40px;
margin-bottom:40px;
border-radius:25px;
backdrop-filter: blur(15px);
border:1px solid rgba(255,255,255,0.1);
box-shadow:0 20px 50px rgba(0,0,0,0.4);
}

.score {
font-size:50px;
font-weight:700;
color:#06d6a0;
text-align:center;
margin-top:10px;
}

table {
width:100%;
border-collapse:collapse;
margin-top:20px;
}

th, td {
padding:14px;
text-align:center;
border-bottom:1px solid rgba(255,255,255,0.1);
}

th {
background:linear-gradient(90deg,#ffd166,#ffb703);
}

.no-data {
color:#ef476f;
font-weight:bold;
text-align:center;
padding:25px;
}

canvas {
margin-top:20px;
}

</style>

</head>

<body>

<div class="container">

<div class="header">
<h1>📊 Student Analytics</h1>
<a href="dashboard.jsp" class="back-btn">⬅ Back</a>
</div>


<div class="card">
<h2>Employability Score</h2>
<div class="score"><%=employabilityScore%>%</div>
</div>


<div class="card">
<h2>Resume Strength Score</h2>
<div class="score"><%=resumeScore%>%</div>
</div>



<div class="card">

<h2>Skill Alignment</h2>

<% if(studentSkills.size()==0){ %>

<div class="no-data">
No skills found
</div>

<% } else { %>

<table>

<tr>
<th>Skill</th>
<th>Market Demand</th>
</tr>

<% for(String s:studentSkills){ %>

<tr>

<td><%=s%></td>

<td><%=marketDemand.getOrDefault(s,0)%></td>

</tr>

<% } %>

</table>

<% } %>

</div>



<div class="card">

<h2>Industry Demand Chart</h2>

<canvas id="chart"></canvas>

<script>

new Chart(document.getElementById("chart"),{

type:'bar',

data:{

labels:[

<% for(String s:studentSkills){
out.print("'"+s+"',");
} %>

],

datasets:[{

label:'Market Demand',

data:[

<% for(String s:studentSkills){
out.print(marketDemand.getOrDefault(s,0)+",");
} %>

],

backgroundColor:'rgba(255,193,7,0.8)',
borderColor:'rgba(255,193,7,1)',
borderWidth:2

}]

}

});

</script>

</div>

</div>

</body>
</html>

<%
}catch(Exception e){
out.println("<h3 style='color:red;'>ERROR: "+e.getMessage()+"</h3>");
}
finally{
try{if(con!=null)con.close();}catch(Exception e){}
}
%>