<%@ page import="java.sql.*" %>
<%
    // Session check
    String userName = (String)session.getAttribute("userName");

    if(userName == null){
        response.sendRedirect("userLogin.jsp");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            height:100vh;
            display:flex;
            justify-content:center;
            align-items:center;
            background: linear-gradient(135deg,#0d1b2a,#1b263b);
            font-family:'Segoe UI', sans-serif;
            color:white;
            margin:0;
        }

        .dashboard-box {
            background:rgba(255,255,255,0.05);
            padding:40px;
            border-radius:20px;
            text-align:center;
            backdrop-filter:blur(10px);
            box-shadow:0 15px 35px rgba(0,0,0,0.4);
            width:400px;
        }

        h2 {
            color:#ffd166;
            margin-bottom:20px;
        }

        .btn-login {
            background:#ef476f;
            border:none;
            border-radius:50px;
            padding:10px 25px;
            font-weight:600;
            margin-top:20px;
        }

        .btn-login:hover {
            transform:translateY(-3px);
            box-shadow:0 10px 20px rgba(0,0,0,0.4);
        }
    </style>
</head>

<body>

<div class="dashboard-box">
    <h2>Welcome, <%= userName %></h2>
    <p>Registration Successful!</p>
    <p>You are now part of Big Data Professionals.</p>

    <a href="userLogin.html" class="btn btn-login text-white">Login</a>
</div>

</body>
</html>
