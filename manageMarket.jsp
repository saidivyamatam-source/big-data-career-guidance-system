<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>



<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("adminLogin.html");
    return;
}

PreparedStatement ps = con.prepareStatement("SELECT * FROM market_demand");
ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>Manage Market Demand</title>

<style>
body{
    margin:0;
    font-family:'Segoe UI',sans-serif;
    background:linear-gradient(135deg,#1e3c72,#2a5298);
    color:white;
    padding:40px;
}

.container{
    max-width:1000px;
    margin:auto;
}

.card{
    background:rgba(255,255,255,0.1);
    backdrop-filter:blur(15px);
    padding:25px;
    border-radius:20px;
    box-shadow:0 8px 32px rgba(0,0,0,0.4);
    margin-bottom:30px;
}

h2{
    margin-bottom:20px;
    color:#ffd166;
}

input{
    padding:10px;
    border-radius:8px;
    border:none;
    margin-right:10px;
    margin-bottom:10px;
}

input[type="submit"]{
    background:#ffd166;
    font-weight:bold;
    cursor:pointer;
    transition:0.3s;
}

input[type="submit"]:hover{
    background:#ffb703;
}

table{
    width:100%;
    border-collapse:collapse;
    margin-top:20px;
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

.delete-btn{
    background:#e63946;
    color:white;
    padding:6px 12px;
    border-radius:6px;
    text-decoration:none;
    transition:0.3s;
}

.delete-btn:hover{
    background:#c1121f;
}
</style>

</head>

<body>
<%@ include file="adminSidebar.jsp" %>
<div class="container">

<div class="card">
<h2>Manage Market Demand</h2>

<form action="saveMarket.jsp" method="post">
    <input type="text" name="skill" placeholder="Enter Skill Name" required>
    <input type="number" name="demand" placeholder="Demand %" min="1" max="100" required>
    <input type="submit" value="Add Skill">
</form>
</div>

<div class="card">
<table>
<tr>
<th>ID</th>
<th>Skill</th>
<th>Demand %</th>
<th>Action</th>
</tr>

<% while(rs.next()){ %>
<tr>
<td><%=rs.getInt("id")%></td>
<td><%=rs.getString("skill_name")%></td>
<td><%=rs.getInt("demand_percentage")%>%</td>
<td>
<a class="delete-btn" href="deleteMarket.jsp?id=<%=rs.getInt("id")%>">
Delete
</a>
</td>
</tr>
<% } %>

</table>
</div>

</div>

</body>
</html>
