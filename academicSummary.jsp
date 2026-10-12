<%@ page language="java" contentType="text/html; charset=UTF-8"%> 
<%@ page import="java.sql.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/bigdata_project";
    String dbUser = "root";
    String dbPass = "root";
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String userName = "";
    String course = "";
    double cgpa = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Academic & Skill Summary</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
/* ================= General Reset ================= */
* { margin:0; padding:0; box-sizing:border-box; }
html, body { height:100%; font-family:'Roboto', sans-serif; scroll-behavior:smooth; background:#0d1b2a; color:#fff; overflow-x:hidden; }

/* ================= Animated Background ================= */
#animated-bg {
    position:fixed;
    top:0; left:0;
    width:100%; height:100%;
    z-index:0;
    pointer-events:none;
}

/* ================= Container & Cards ================= */
.container { 
    padding:50px 20px; 
    max-width:1000px; 
    margin:auto; 
    position:relative; 
    z-index:1; 
}

.card {
    background: rgba(255,255,255,0.05); 
    border-radius:20px; 
    padding:30px; 
    margin-bottom:30px; 
    backdrop-filter: blur(10px); 
    border:1px solid rgba(255,255,255,0.1); 
    box-shadow:0 15px 35px rgba(0,0,0,0.3); 
    transition: all 0.3s ease;
}
.card:hover { 
    transform: translateY(-10px) scale(1.02); 
    box-shadow:0 20px 50px rgba(0,0,0,0.5); 
}
.card h3 { color:#ffd166; margin-bottom:15px; font-weight:700; }

/* ================= Inputs ================= */
input, select, textarea { 
    background: rgba(255,255,255,0.1); 
    border:1px solid #fff; 
    color:#fff; 
    padding:10px 15px; 
    border-radius:10px; 
    width:100%; 
    margin-bottom:15px; 
    font-size:1rem; 
}
input::placeholder, textarea::placeholder { color: rgba(255,255,255,0.7); }

/* ================= Lists ================= */
ul { padding-left:20px; color:#e0e0e0; }

/* ================= Buttons ================= */
.btn, .btn-save, .add-btn, .back-btn, .view-all-btn {
    display:inline-block;
    padding:12px 25px;
    border-radius:50px;
    font-weight:700;
    text-decoration:none;
    transition:0.3s;
    text-align:center;
}

/* Gradient Buttons */
.btn, .btn-save { 
    background: linear-gradient(90deg,#ffd166,#ef476f); 
    color:#fff; 
}
.btn:hover, .btn-save:hover { 
    transform:translateY(-3px) scale(1.05); 
    box-shadow:0 10px 25px rgba(0,0,0,0.5); 
}

.add-btn { 
    background: linear-gradient(90deg,#06d6a0,#118ab2); 
    color:#fff; 
}
.add-btn:hover { 
    transform:translateY(-3px) scale(1.05); 
    box-shadow:0 10px 25px rgba(0,0,0,0.5); 
}

.back-btn { 
    background:#ef476f; 
    position:absolute; 
    top:20px; 
    left:20px; 
    color:#fff; 
}
.back-btn:hover { 
    transform:translateY(-3px) scale(1.05); 
    box-shadow:0 10px 20px rgba(0,0,0,0.4); 
}

.view-all-btn { 
    display:block; 
    margin:30px auto; 
    background:#06d6a0; 
    color:#fff; 
    text-align:center; 
}
.view-all-btn:hover { 
    transform:translateY(-3px) scale(1.05); 
    box-shadow:0 10px 25px rgba(0,0,0,0.5); 
}

/* ================= Progress Bar ================= */
.progress { height:25px; border-radius:10px; }
.progress-bar { font-weight:bold; color:#0d1b2a; }

/* ================= Responsive ================= */
@media(max-width:768px){ 
    input, select, textarea { font-size:0.95rem; } 
    .card { padding:20px; }
    .btn, .btn-save, .add-btn { padding:10px 20px; font-size:0.95rem; }
}
/* ================= Floating Bubbles Background ================= */
body::before {
    content:'';
    position:fixed;
    top:0; left:0; width:100%; height:100%;
    background: radial-gradient(circle, rgba(255,255,255,0.05) 15%, transparent 15%) repeat;
    background-size:80px 80px;
    animation: moveBg 60s linear infinite;
    z-index:0;
}
@keyframes moveBg {
    0%{background-position:0 0;}
    100%{background-position:800px 800px;}
}
</style>


<!-- ================= Animated Background Script ================= -->
<script>


function addCertification() {
    const container = document.getElementById('certifications-container');
    const html = `
        <div class="cert-block">
            <label>Certification Name</label><input type="text" name="cert_name[]" placeholder="Enter certification name">
            <label>Issued By</label><input type="text" name="issued_by[]" placeholder="Issuer">
            <label>Date Earned</label><input type="date" name="date_earned[]">
            <hr>
        </div>`;
    container.insertAdjacentHTML('beforeend', html);
}

function addSkill() {
    const container = document.getElementById('skills-container');
    const html = `
        <div class="skill-block">
            <label>Skill Name</label><input type="text" name="skill_name[]" placeholder="Enter skill">
            <label>Skill Level (%)</label><input type="number" name="skill_level[]" min="0" max="100" placeholder="Enter level">
            <hr>
        </div>`;
    container.insertAdjacentHTML('beforeend', html);
}

function addProject() {
    const container = document.getElementById('projects-container');
    const html = `
        <div class="project-block">
            <label>Project Title</label><input type="text" name="project_title[]" placeholder="Enter project title">
            <label>Technologies</label><input type="text" name="technologies[]" placeholder="Technologies used">
            <label>Status</label><input type="text" name="status[]" placeholder="Status">
            <hr>
        </div>`;
    container.insertAdjacentHTML('beforeend', html);
}
</script>
</head>
<body>
    
<div class="container">
    

<!-- Back Button -->
<a href="dashboard.jsp" class="btn btn-primary back-btn">Back</a>


<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Get user info
        ps = conn.prepareStatement("SELECT name, course, cgpa FROM users WHERE id=?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if(rs.next()) {
            userName = rs.getString("name");
            course = rs.getString("course");
            cgpa = rs.getDouble("cgpa");
        }
%>

<h2 class="mb-4 text-center">Academic & Skill Summary - <%= userName %></h2>

<form action="updateProfileServlet" method="post">

<!-- Academic Info -->
<div class="card">
    <h3>Course / Degree & CGPA</h3>
    <label>Course / Degree</label>
    <input type="text" name="course" value="<%= course %>" placeholder="Enter your course or degree" required>
    <label>CGPA / Grades (out of 10)</label>
    <input type="number" name="cgpa" step="0.01" max="10" min="0" value="<%= cgpa %>" required>
</div>

<!-- Certifications -->
<div class="card">
    <h3>Certifications & Trainings</h3>
    <div id="certifications-container">
<%
        ps = conn.prepareStatement("SELECT cert_name, issued_by, date_earned FROM certifications WHERE user_id=?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        boolean hasCert = false;
        while(rs.next()) {
            hasCert = true;
%>
        <div class="cert-block">
            <label>Certification Name</label><input type="text" name="cert_name[]" value="<%= rs.getString("cert_name") %>">
            <label>Issued By</label><input type="text" name="issued_by[]" value="<%= rs.getString("issued_by") %>">
            <label>Date Earned</label><input type="date" name="date_earned[]" value="<%= rs.getDate("date_earned") %>">
            <hr>
        </div>
<%      }
        if(!hasCert){ %>
        <div class="cert-block">
            <label>Certification Name</label><input type="text" name="cert_name[]" placeholder="Enter certification name">
            <label>Issued By</label><input type="text" name="issued_by[]" placeholder="Issuer">
            <label>Date Earned</label><input type="date" name="date_earned[]">
            <hr>
        </div>
<% } %>
    </div>
    <button type="button" class="btn btn-info add-btn" onclick="addCertification()">Add Another Certification</button>
</div>

<!-- Skills -->
<div class="card">
    <h3>Skills</h3>
    <div id="skills-container">
<%
        ps = conn.prepareStatement("SELECT skill_name, skill_level FROM skills WHERE user_id=?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        boolean hasSkill = false;
        while(rs.next()) {
            hasSkill = true;
%>
        <div class="skill-block">
            <label>Skill Name</label><input type="text" name="skill_name[]" value="<%= rs.getString("skill_name") %>">
            <label>Skill Level (%)</label><input type="number" name="skill_level[]" min="0" max="100" value="<%= rs.getInt("skill_level") %>">
            <hr>
        </div>
<%      }
        if(!hasSkill){ %>
        <div class="skill-block">
            <label>Skill Name</label><input type="text" name="skill_name[]" placeholder="Enter skill">
            <label>Skill Level (%)</label><input type="number" name="skill_level[]" min="0" max="100" placeholder="Enter level">
            <hr>
        </div>
<% } %>
    </div>
    <button type="button" class="btn btn-info add-btn" onclick="addSkill()">Add Another Skill</button>
</div>

<!-- Projects -->
<div class="card">
    <h3>Projects Completed</h3>
    <div id="projects-container">
<%
        ps = conn.prepareStatement("SELECT project_title, technologies, status FROM projects WHERE user_id=?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        boolean hasProj = false;
        while(rs.next()) {
            hasProj = true;
%>
        <div class="project-block">
            <label>Project Title</label><input type="text" name="project_title[]" value="<%= rs.getString("project_title") %>">
            <label>Technologies</label><input type="text" name="technologies[]" value="<%= rs.getString("technologies") %>">
            <label>Status</label><input type="text" name="status[]" value="<%= rs.getString("status") %>">
            <hr>
        </div>
<%      }
        if(!hasProj){ %>
        <div class="project-block">
            <label>Project Title</label><input type="text" name="project_title[]" placeholder="Enter project title">
            <label>Technologies</label><input type="text" name="technologies[]" placeholder="Technologies used">
            <label>Status</label><input type="text" name="status[]" placeholder="Status">
            <hr>
        </div>
<% } %>
    </div>
    <button type="button" class="btn btn-info add-btn" onclick="addProject()">Add Another Project</button>
</div>

<!-- Single Save Button -->
<button type="submit" class="btn btn-success btn-save">Save All Details</button>
       <br> 

</form>

<!-- View Complete Details -->
<a href="viewCompleteDetails.jsp" class="btn btn-info view-all-btn">View Complete Details</a>

<%
    } catch(Exception e){ out.println("Error: "+e.getMessage()); }
    finally { try { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(conn!=null) conn.close(); } catch(Exception e){} } 
%>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>