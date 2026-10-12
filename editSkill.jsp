<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
if(session.getAttribute("userId") == null){
    response.sendRedirect("userLogin.jsp");
    return;
}

int userId = (Integer) session.getAttribute("userId");

String dbURL = "jdbc:mysql://localhost:3306/bigdata_project";
String dbUser = "root";
String dbPass = "root";

Connection con = null;
PreparedStatement psSkills = null;
PreparedStatement psJobs = null;
PreparedStatement psInsert = null;
ResultSet rsSkills = null;
ResultSet rsJobs = null;

String userSkills = "";

try{
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(dbURL, dbUser, dbPass);

    // ================== GET USER SKILLS ==================
    psSkills = con.prepareStatement("SELECT skill_name FROM skills WHERE user_id=?");
    psSkills.setInt(1, userId);
    rsSkills = psSkills.executeQuery();

    List<String> skillList = new ArrayList<String>();
    while(rsSkills.next()){
        String skill = rsSkills.getString("skill_name");
        if(skill != null && !skill.trim().equals("")){
            skillList.add(skill.trim().toLowerCase());
        }
    }

    if(skillList.size() == 0){
%>
<p style="color:red;">No skills found in your profile.</p>
<%
        return;
    }

    // Convert to comma-separated string
    userSkills = String.join(",", skillList);

%>

<!DOCTYPE html>
<html>
<head>
<title>Career Match</title>
<style>
body{
    font-family: Arial;
    background: linear-gradient(to right,#1e3c72,#2a5298);
    margin:0;
    padding:20px;
    color:white;
}
.container{
    width:85%;
    margin:auto;
}
h2{
    text-align:center;
    margin-bottom:30px;
}
.job-card{
    background:white;
    color:black;
    padding:20px;
    margin-bottom:20px;
    border-radius:12px;
    box-shadow:0px 5px 15px rgba(0,0,0,0.3);
}
.job-card h3{
    margin:0;
    color:#1e3c72;
}
.match{
    font-weight:bold;
    color:green;
}
.btn{
    display:inline-block;
    padding:8px 15px;
    background:#1e3c72;
    color:white;
    text-decoration:none;
    border-radius:6px;
    margin-top:10px;
}
.btn:hover{
    background:#16335c;
}
.back-btn{
    background:#ff9800;
    margin-bottom:20px;
}
.back-btn:hover{
    background:#e68900;
}
</style>
</head>
<body>

<div class="container">
<a href="dashboard.jsp" class="btn back-btn">⬅ Back to Dashboard</a>

<h2>Top Career Matches</h2>

<%
    // ================= DELETE OLD MATCHES =================
    PreparedStatement psDelete = con.prepareStatement("DELETE FROM job_match_results WHERE user_id=?");
    psDelete.setInt(1, userId);
    psDelete.executeUpdate();
    psDelete.close();

    // ================= GET ALL JOBS =================
    psJobs = con.prepareStatement("SELECT * FROM job_postings");
    rsJobs = psJobs.executeQuery();

    // TEMP STORAGE FOR JOBS
    List<String[]> jobList = new ArrayList<String[]>();

    String[] userSkillArr = userSkills.toLowerCase().split(",");
    for(int i=0; i<userSkillArr.length; i++){
        userSkillArr[i] = userSkillArr[i].trim();
    }

    while(rsJobs.next()){
        int jobId = rsJobs.getInt("id");
        String title = rsJobs.getString("job_title");
        String company = rsJobs.getString("company");
        String location = rsJobs.getString("job_location");
        String link = rsJobs.getString("job_link");
        String skills = rsJobs.getString("job_skills");
        if(skills == null) skills = "";

        String[] jobSkillArr = skills.toLowerCase().split(",");
        for(int i=0;i<jobSkillArr.length;i++){
            jobSkillArr[i] = jobSkillArr[i].trim();
        }

        // ================== CALCULATE MATCH SCORE ==================
        int matchedSkills = 0;
        for(String uSkill : userSkillArr){
            if(uSkill.isEmpty()) continue;
            for(String jSkill : jobSkillArr){
                if(uSkill.equals(jSkill)){
                    matchedSkills++;
                    break; // prevent double counting
                }
            }
        }

        int matchScore = 0;
        if(userSkillArr.length > 0){
            matchScore = (int) Math.round((matchedSkills * 100.0) / userSkillArr.length);
            if(matchScore > 100) matchScore = 100;
        }

        jobList.add(new String[]{String.valueOf(jobId), title, company, location, link, skills, String.valueOf(matchScore)});
    }

    // ================= SORT JOBS BY HIGHEST MATCH =================
    Collections.sort(jobList, new Comparator<String[]>(){
        public int compare(String[] a, String[] b){
            return Integer.parseInt(b[6]) - Integer.parseInt(a[6]);
        }
    });

    int count = 0;
    for(int i=0; i<jobList.size() && count<5; i++){
        String[] job = jobList.get(i);
        int jobId = Integer.parseInt(job[0]);
        int score = Integer.parseInt(job[6]);

        if(score > 0){
            count++;

            // INSERT INTO job_match_results
            psInsert = con.prepareStatement(
                "INSERT INTO job_match_results(user_id, job_id, match_score) VALUES(?,?,?)"
            );
            psInsert.setInt(1, userId);
            psInsert.setInt(2, jobId);
            psInsert.setInt(3, score);
            psInsert.executeUpdate();
            psInsert.close();
%>

<div class="job-card">
    <h3><%= job[1] %></h3>
    <p><strong>Company:</strong> <%= job[2] %></p>
    <p><strong>Location:</strong> <%= job[3] %></p>
    <p><strong>Skills:</strong> <%= job[5] %></p>
    <p class="match">Match Score: <%= score %>%</p>
    <a href="<%= job[4] %>" target="_blank" class="btn">Apply Now</a>
</div>

<%
        }
    }

    if(count == 0){
%>
<p>No matching jobs found.</p>
<%
    }

}catch(Exception e){
    out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
}finally{
    try{ if(rsSkills != null) rsSkills.close(); }catch(Exception e){}
    try{ if(rsJobs != null) rsJobs.close(); }catch(Exception e){}
    try{ if(psSkills != null) psSkills.close(); }catch(Exception e){}
    try{ if(psJobs != null) psJobs.close(); }catch(Exception e){}
    try{ if(psInsert != null) psInsert.close(); }catch(Exception e){}
    try{ if(con != null) con.close(); }catch(Exception e){}
}
%>

</div>
</body>
</html>