<style>
body{
    margin:0;
    font-family:'Segoe UI',sans-serif;
    background:linear-gradient(135deg,#1e3c72,#2a5298);
}

/* Sidebar */
.sidebar{
    width:250px;
    height:100vh;
    position:fixed;
    top:0;
    left:0;
    background:#1e2f4f;
    padding:20px;
    color:white;
}

.sidebar h3{
    color:#ffd166;
    margin-bottom:30px;
}

.sidebar a{
    display:block;
    padding:12px;
    color:white;
    text-decoration:none;
    border-radius:10px;
    margin-bottom:10px;
    transition:0.3s;
}

.sidebar a:hover{
    background:rgba(255,255,255,0.2);
}

/* Main Content */
.main{
    margin-left:250px;
    padding:60px;
    min-height:100vh;
}
</style>

<div class="sidebar">
    <h3>Admin Panel</h3>

    <a href="adminDashboard.jsp">Home</a>
    <a href="viewUsers.jsp">View Users</a>
    <a href="manageMarket.jsp">Manage Market Demand</a>
    <a href="uploadIndustryData.jsp">Upload Industry CSV</a>
    <a href="viewJobs.jsp">View Uploaded Jobs</a>
    <a href="analytics.jsp">Analytics</a>
    <a href="logout.jsp">Logout</a>
</div>
