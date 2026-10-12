<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ include file="dbConnection.jsp" %>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");

PreparedStatement ps = null;
ResultSet rs = null;

try {

    String query = "SELECT * FROM admin WHERE username=? AND password=?";
    ps = con.prepareStatement(query);

    ps.setString(1, username);
    ps.setString(2, password);

    rs = ps.executeQuery();

    if(rs.next()){
        session.setAttribute("admin", username);
        response.sendRedirect("adminDashboard.jsp");
    } 
    else {
%>

<!DOCTYPE html>
<html>
<head>
<title>Login Error</title>

<style>

body{
margin:0;
font-family:'Segoe UI',sans-serif;
background:linear-gradient(135deg,#0f172a,#1e293b);
height:100vh;
display:flex;
justify-content:center;
align-items:center;
}

/* Popup Container */

.popup{

background:rgba(255,255,255,0.05);
backdrop-filter:blur(15px);

padding:40px;
border-radius:15px;

text-align:center;

box-shadow:0 15px 40px rgba(0,0,0,0.6);

animation:fadeIn 0.5s ease;

}

/* Icon */

.icon{

font-size:50px;
margin-bottom:10px;

}

/* Title */

.title{

font-size:22px;
font-weight:bold;
margin-bottom:10px;

}

/* Message */

.msg{

color:#cbd5f5;
margin-bottom:20px;

}

/* Button */

.btn{

background:#ef4444;

border:none;
padding:10px 25px;

border-radius:25px;

font-size:14px;
font-weight:bold;

color:white;

cursor:pointer;

transition:0.3s;

}

.btn:hover{

background:#dc2626;
transform:scale(1.05);

}

/* Animation */

@keyframes fadeIn{

from{
opacity:0;
transform:scale(0.8);
}

to{
opacity:1;
transform:scale(1);
}

}

</style>

</head>

<body>

<div class="popup">

<div class="icon">❌</div>

<div class="title">
Invalid Admin Credentials
</div>

<div class="msg">
Username or Password is incorrect.
Please try again.
</div>

<button class="btn" onclick="window.location='adminLogin.html'">
Try Again
</button>

</div>

</body>
</html>

<%
    }

} catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>