<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.io.*,javax.servlet.http.Part" %>
<%@ include file="dbConnection.jsp" %>

<%
if(session.getAttribute("admin")==null){
    response.sendRedirect("adminLogin.html");
    return;
}

int inserted = 0;

try{

    Part filePart = request.getPart("file");
    InputStream fileContent = filePart.getInputStream();

    BufferedReader br = new BufferedReader(new InputStreamReader(fileContent));
    String line;

    while((line = br.readLine()) != null){

        String[] data = line.split(",");

        String skill = data[0].trim();
        int demand = Integer.parseInt(data[1].trim());

        PreparedStatement ps = con.prepareStatement(
        "INSERT INTO market_demand(skill_name,demand_percentage) VALUES(?,?)");

        ps.setString(1,skill);
        ps.setInt(2,demand);
        ps.executeUpdate();

        inserted++;
    }

}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Upload Success</title>

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
    text-align:center;
    width:400px;
}

h2{
    color:#ffd166;
}

.btn{
    display:inline-block;
    margin-top:20px;
    padding:10px 20px;
    background:#ffd166;
    color:black;
    text-decoration:none;
    border-radius:8px;
    font-weight:bold;
    transition:0.3s;
}

.btn:hover{
    background:#ffb703;
}
</style>
</head>

<body>

<div class="card">
    <h2>Upload Successful ✅</h2>
    <p><%= inserted %> records inserted into Market Demand.</p>

    <a href="manageMarket.jsp" class="btn">
        Back to Manage Market
    </a>
</div>

</body>
</html>
