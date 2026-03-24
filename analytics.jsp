<%@ page import="java.sql.*,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;

int totalJobs = 0;
Map skillMap = new HashMap();
String userSkillsInput = request.getParameter("userSkills");
int matchPercentage = 0;

try {

    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/bigdata_project",
        "root",
        "root");

    st = con.createStatement();

    // TOTAL JOBS
    rs = st.executeQuery("SELECT COUNT(*) FROM job_postings");
    if(rs.next()){
        totalJobs = rs.getInt(1);
    }

    // SKILL FREQUENCY
    rs = st.executeQuery("SELECT job_skills FROM job_postings");

    while(rs.next()){

        String skills = rs.getString("job_skills");

        if(skills != null){

            String[] skillArray = skills.split(",");

            for(int i=0; i<skillArray.length; i++){

                String s = skillArray[i].trim().toLowerCase();

                if(skillMap.containsKey(s)){
                    int count = (Integer)skillMap.get(s);
                    skillMap.put(s, count + 1);
                }else{
                    skillMap.put(s, 1);
                }
            }
        }
    }

    // CAREER MATCH
    if(userSkillsInput != null && !userSkillsInput.equals("")){

        String[] userSkills = userSkillsInput.split(",");
        int matched = 0;

        for(int i=0; i<userSkills.length; i++){
            String us = userSkills[i].trim().toLowerCase();

            if(skillMap.containsKey(us)){
                matched++;
            }
        }

        matchPercentage = (matched * 100) / userSkills.length;
    }

} catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
    
<title>Analytics Dashboard</title>

<style>
body{
    margin:0;
    font-family:'Segoe UI',sans-serif;
    background:linear-gradient(135deg,#1e3c72,#2a5298);
    color:white;
}

.main{
    margin:25px;
    padding:3px;
}

.cards{
    display:flex;
    gap:20px;
    flex-wrap:wrap;
}

.card{
    background:rgba(255,255,255,0.1);
    padding:20px;
    border-radius:15px;
    width:220px;
    text-align:center;
}

.card h3{
    margin:0;
    font-size:28px;
    color:#ffd166;
}

.section{
    margin-top:40px;
}

table{
    width:100%;
    border-collapse:collapse;
    margin-top:10px;
}

th,td{
    padding:10px;
    border:1px solid rgba(255,255,255,0.2);
}

th{
    background:#ffd166;
    color:black;
}

input[type=text]{
    padding:8px;
    border-radius:5px;
    width:300px;
}
/* Button Styling */
.top-buttons{
    margin-bottom:20px;
}
.btn{
    text-decoration:none;
    padding:10px 18px;
    margin-right:10px;
    border-radius:8px;
    font-weight:bold;
    transition:0.3s;
    display:inline-block;
}

.home-btn{
    background:#06d6a0;
    color:black;
}

.dashboard-btn{
    background:#ffd166;
    color:black;
}

.btn:hover{
    transform:scale(1.05);
    opacity:0.9;
}

input[type=submit]{
    padding:8px 15px;
    border:none;
    background:#ffd166;
    border-radius:5px;
    cursor:pointer;
}
</style>
</head>

<body>

<div class="main">

<h2>Analytics Dashboard</h2>
<!-- Buttons Section -->
<div class="top-buttons">
    <a href="<%=request.getContextPath()%>/index.jsp" class="btn home-btn">🏠 Home</a>
    <a href="<%=request.getContextPath()%>/adminDashboard.jsp" class="btn dashboard-btn">⬅ Back to Dashboard</a>
</div>
<!-- TOTAL JOBS CARD -->
<div class="cards">
    <div class="card">
        <p>Total Jobs</p>
        <h3><%= totalJobs %></h3>
    </div>
</div>

<!-- TOP 5 COMPANIES -->
<div class="section">
<h3>Top 5 Hiring Companies</h3>

<table>
<tr>
    <th>Company</th>
    <th>Total Jobs</th>
</tr>

<%
rs = st.executeQuery(
"SELECT company, COUNT(*) as total FROM job_postings GROUP BY company ORDER BY total DESC LIMIT 5");

while(rs.next()){
%>
<tr>
    <td><%= rs.getString("company") %></td>
    <td><%= rs.getInt("total") %></td>
</tr>
<%
}
%>

</table>
</div>



<!-- TOP 10 SKILLS -->
<div class="section">
<h3>Top 10 Most Demanded Skills</h3>

<table>
<tr>
    <th>Skill</th>
    <th>Demand Count</th>
</tr>

<%
List list = new ArrayList(skillMap.entrySet());

Collections.sort(list, new Comparator() {
    public int compare(Object o1, Object o2) {
        Map.Entry e1 = (Map.Entry)o1;
        Map.Entry e2 = (Map.Entry)o2;
        Integer v1 = (Integer)e1.getValue();
        Integer v2 = (Integer)e2.getValue();
        return v2.compareTo(v1);
    }
});

int limit = 0;

for(int i=0; i<list.size() && limit<10; i++){
    Map.Entry entry = (Map.Entry)list.get(i);
%>
<tr>
    <td><%= entry.getKey() %></td>
    <td><%= entry.getValue() %></td>
</tr>
<%
    limit++;
}
%>

</table>
</div>


<!-- JOB LEVEL DISTRIBUTION -->
<div class="section">
<h3>Job Level Distribution</h3>

<table>
<tr>
    <th>Job Level</th>
    <th>Count</th>
</tr>

<%
rs = st.executeQuery(
"SELECT job_level, COUNT(*) as total FROM job_postings GROUP BY job_level");

while(rs.next()){
%>
<tr>
    <td><%= rs.getString("job_level") %></td>
    <td><%= rs.getInt("total") %></td>
</tr>
<%
}
%>

</table>
</div>
</body>
</html>

<%
if(rs!=null) rs.close();
if(st!=null) st.close();
if(con!=null) con.close();
%>
