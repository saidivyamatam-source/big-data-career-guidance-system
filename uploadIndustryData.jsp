<%@ include file="adminSidebar.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>Upload Industry Dataset</title>

<style>
body{
    margin:0;
    font-family:'Segoe UI',sans-serif;
    background:linear-gradient(135deg,#1e3c72,#2a5298);
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
    color:white;
}

.card{
    background:rgba(255,255,255,0.1);
    backdrop-filter:blur(20px);
    padding:40px;
    border-radius:20px;
    box-shadow:0 8px 32px rgba(0,0,0,0.4);
    width:450px;
    text-align:center;
}

h2{
    color:#ffd166;
    margin-bottom:25px;
}

input[type="file"]{
    width:100%;
    padding:10px;
    margin-bottom:20px;
    border-radius:8px;
    border:none;
    background:white;
    color:black;
}

input[type="submit"]{
    padding:10px 25px;
    border:none;
    border-radius:8px;
    background:#ffd166;
    font-weight:bold;
    cursor:pointer;
    transition:0.3s;
}

input[type="submit"]:hover{
    background:#ffb703;
}

.note{
    margin-top:15px;
    font-size:14px;
    opacity:0.8;
}
</style>

</head>

<body>


<div class="card">
    <h2>Upload Industry Dataset (CSV)</h2>

    <form action="<%=request.getContextPath()%>/UploadJobCSVServlet"
      method="post"
      enctype="multipart/form-data">


        <input type="file" name="file" accept=".csv" required>
        <input type="submit" value="Upload">
    </form>

    <div class="note">
        CSV format: SkillName,DemandPercentage
    </div>
</div>

</body>
</html>
