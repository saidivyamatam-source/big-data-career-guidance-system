<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="dbConnection.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%
if(session.getAttribute("userId")==null){
    response.sendRedirect("userLogin.jsp");
    return;
}

int userId = (Integer) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html>
<head>
<title>User Dashboard</title>

<style>
body{
    font-family:'Segoe UI',sans-serif;
    background:linear-gradient(135deg,#1e3c72,#2a5298);
    color:white;
    padding:30px;
}
h2,h3{ color:#ffd166; }

table{
    width:100%;
    border-collapse:collapse;
    margin-top:20px;
    background:rgba(255,255,255,0.1);
    border-radius:10px;
}

th{
    background:rgba(255,255,255,0.2);
    padding:12px;
}

td{
    padding:10px;
    text-align:center;
    border-bottom:1px solid rgba(255,255,255,0.2);
}

tr:hover{
    background:rgba(255,255,255,0.1);
}

.card{
    background:rgba(255,255,255,0.1);
    padding:20px;
    border-radius:15px;
    margin-top:20px;
}
.btn-custom {
    background-color: #4CAF50;
    color: #fff;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    text-decoration: none;
}

.btn-custom:hover {
    background-color: #3e8e41;
}

.btn-custom:active {
    transform: translateY(1px);
}


</style>
</head>

<body>

<h2>Welcome to Your Dashboard</h2>
<a href="dashboard.jsp" class="btn btn-secondary btn-custom">
⬅ Back to Dashboard
</a>

<!-- ============================= -->
<!-- 🔥 TOP 5 JOB MATCHES -->
<!-- ============================= -->

<h3>🔥 Top Job Matches</h3>

<%
try{

PreparedStatement psTop = con.prepareStatement(
"SELECT jp.job_title, jp.company, jp.job_level, jmr.match_score " +
"FROM job_match_results jmr " +
"JOIN job_postings jp ON jmr.job_id = jp.id " +
"WHERE jmr.user_id=? " +
"ORDER BY jmr.match_score DESC LIMIT 5");

psTop.setInt(1, userId);
ResultSet rsTop = psTop.executeQuery();
%>

<table>
<tr>
<th>Rank</th>
<th>Job</th>
<th>Company</th>
<th>Level</th>
<th>Match %</th>
</tr>

<%
int rank = 1;
while(rsTop.next()){
%>
<tr>
<td><%=rank++%></td>
<td><%=rsTop.getString("job_title")%></td>
<td><%=rsTop.getString("company")%></td>
<td><%=rsTop.getString("job_level")%></td>
<td><%=String.format("%.2f", rsTop.getDouble("match_score"))%>%</td>
</tr>
<%
}
%>
</table>

<%
}catch(Exception e){
out.println("<p style='color:red;'>Error loading matches</p>");
}
%>

<!-- ============================= -->
<!-- 📊 SKILL GAP ANALYSIS -->
<!-- ============================= -->

<h3 style="margin-top:40px;">📊 Skill Gap Analysis</h3>

<%
try{

PreparedStatement psGap = con.prepareStatement(
"SELECT jp.job_skills, jp.job_title " +
"FROM job_match_results jmr " +
"JOIN job_postings jp ON jmr.job_id = jp.id " +
"WHERE jmr.user_id=? " +
"ORDER BY jmr.match_score DESC LIMIT 1");

psGap.setInt(1, userId);
ResultSet rsGap = psGap.executeQuery();

if(rsGap.next()){

    String jobSkillsText = rsGap.getString("job_skills");
    String jobTitle = rsGap.getString("job_title");

    if(jobSkillsText != null){

        PreparedStatement psUserSkills = con.prepareStatement(
        "SELECT skill_name FROM skills WHERE user_id=?");

        psUserSkills.setInt(1, userId);
        ResultSet rsUserSkills = psUserSkills.executeQuery();

        Set<String> userSkills = new HashSet<String>();

        while(rsUserSkills.next()){
            userSkills.add(
            rsUserSkills.getString("skill_name")
            .toLowerCase().trim());
        }

        String[] jobSkillsArr = jobSkillsText.toLowerCase().split(",");

        List<String> missingSkills =
        new ArrayList<String>();

        for(int i=0;i<jobSkillsArr.length;i++){
            String skill = jobSkillsArr[i].trim();
            if(!userSkills.contains(skill)){
                missingSkills.add(skill);
            }
        }

        int totalSkills = jobSkillsArr.length;
        int gapCount = missingSkills.size();
        double gapPercent = (totalSkills == 0) ? 0 :
                ((double)gapCount / totalSkills) * 100;
%>

<div class="card">

<h4>Top Job: <%= jobTitle %></h4>

<p><b>Missing Skills:</b></p>

<ul>
<%
for(int i=0;i<missingSkills.size();i++){
%>
<li><%= missingSkills.get(i) %></li>
<%
}
%>
</ul>

<p><b>Skill Gap:</b>
<%= String.format("%.2f", gapPercent) %>%</p>

<%
if(gapPercent > 40){
%>
<p style="color:#ff6b6b;">
<b>Recommendation:</b> Improve core technical skills to increase match score.
</p>
<%
}else{
%>
<p style="color:#06d6a0;">
<b>Great!</b> You are highly aligned with this role.
</p>
<%
}
%>

</div>

<%
    }
}else{
%>
<p>No job match data found. Please update profile.</p>
<%
}

}catch(Exception e){
out.println("<p style='color:red;'>Error loading skill gap</p>");
}
%>

</body>
</html>