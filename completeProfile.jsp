<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if(session.getAttribute("userId") == null){
    response.sendRedirect("userLogin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Complete Profile - Big Data AI</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    background: linear-gradient(135deg,#0f2027,#203a43,#2c5364);
    font-family: 'Segoe UI', sans-serif;
}
.card-box{
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0 8px 25px rgba(0,0,0,0.3);
}
.title{
    text-align:center;
    font-weight:bold;
    color:#0d1b2a;
}
.btn-custom{
    background:#ffb703;
    border:none;
}
.btn-custom:hover{
    background:#fb8500;
}
</style>

</head>
<body>

<div class="container mt-5 mb-5">
<div class="row justify-content-center">
<div class="col-md-8">

<div class="card-box">

<h3 class="title">Complete Your Academic & Career Profile</h3>
<hr>

<form action="CompleteProfileServlet" method="post">

<!-- BASIC DETAILS -->
<h5 class="mt-3">👤 Basic Details</h5>

<div class="mb-3">
<label>Full Name</label>
<input type="text" name="fullName" class="form-control" required>
</div>

<div class="mb-3">
<label>Phone</label>
<input type="text" name="phone" class="form-control" required>
</div>

<div class="mb-3">
<label>Gender</label>
<select name="gender" class="form-control">
<option>Male</option>
<option>Female</option>
<option>Other</option>
</select>
</div>

<div class="mb-3">
<label>City</label>
<input type="text" name="city" class="form-control" required>
</div>

<!-- EDUCATION DETAILS -->
<h5 class="mt-4">🎓 Education Details</h5>

<div class="mb-3">
<label>Degree</label>
<input type="text" name="degree" class="form-control" placeholder="B.Tech / B.Sc / M.Tech" required>
</div>

<div class="mb-3">
<label>Specialization</label>
<input type="text" name="specialization" class="form-control" placeholder="Data Science / AI / CSE" required>
</div>

<div class="mb-3">
<label>University</label>
<input type="text" name="university" class="form-control" required>
</div>

<div class="mb-3">
<label>Year of Passing</label>
<input type="number" name="year" class="form-control" required>
</div>

<div class="mb-3">
<label>CGPA</label>
<input type="number" step="0.01" name="cgpa" class="form-control" min="0" max="10" required>
</div>

<!-- EXPERIENCE DETAILS -->
<h5 class="mt-4">💼 Experience & Achievements</h5>

<div class="mb-3">
<label>Number of Certifications</label>
<input type="number" name="certifications" class="form-control" min="0" required>
</div>

<div class="mb-3">
<label>Number of Internships</label>
<input type="number" name="internships" class="form-control" min="0" required>
</div>

<div class="mb-3">
<label>Number of Projects</label>
<input type="number" name="projects" class="form-control" min="0" required>
</div>

<!-- CAREER PREFERENCE -->
<h5 class="mt-4">🚀 Career Preference</h5>

<div class="mb-3">
<label>Preferred Domain</label>
<select name="preferredDomain" class="form-control">
<option>Data Science</option>
<option>Artificial Intelligence</option>
<option>Web Development</option>
<option>Cybersecurity</option>
<option>Cloud Computing</option>
</select>
</div>

<div class="mb-3">
<label>Expected Salary (LPA)</label>
<input type="number" step="0.1" name="expectedSalary" class="form-control" required>
</div>

<br>

<button type="submit" class="btn btn-custom w-100">
Save Profile & Continue to Dashboard
</button>

</form>

</div>

</div>
</div>
</div>

</body>
</html>