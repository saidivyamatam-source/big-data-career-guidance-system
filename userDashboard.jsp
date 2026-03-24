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

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* ================= General Reset ================= */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body { height: 100%; font-family: 'Roboto', sans-serif; scroll-behavior: smooth; background: #0d1b2a; color: #fff; }

        /* ================= Dashboard Hero ================= */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            position: relative;
        }

        canvas#animated-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
        }

        .dashboard-box {
            position: relative;
            z-index: 1;
            background: rgba(255,255,255,0.05);
            padding: 30px 25px;
            border-radius: 20px;
            text-align: center;
            backdrop-filter: blur(10px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.4);
            max-width: 400px;
            width: 90%;
        }

        h2 {
            color: #ffd166;
            margin-bottom: 15px;
            font-weight: 700;
            font-size: 1.8rem;
        }

        p {
            color: rgba(255,255,255,0.8);
            margin-bottom: 10px;
        }

        .btn-login {
            background: linear-gradient(90deg,#ffd166,#ef476f);
            border: none;
            border-radius: 50px;
            padding: 10px 25px;
            font-weight: 600;
            margin-top: 20px;
            color: #fff;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 10px 25px rgba(0,0,0,0.5);
        }

        @media(max-width:768px){
            .dashboard-box { padding: 20px 15px; }
            h2 { font-size: 1.5rem; }
        }
    </style>
</head>
<body>

    <canvas id="animated-bg"></canvas>

    <div class="dashboard-box">
        <h2>Welcome, <%= userName %></h2>
        <p>Registration Successful!</p>
        <p>You are now part of Big Data Professionals.</p>

        <a href="userLogin.jsp" class="btn btn-login">Login</a>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Animated Background JS -->
    <script>
        const canvas = document.getElementById('animated-bg');
        const ctx = canvas.getContext('2d');
        let width = canvas.width = window.innerWidth;
        let height = canvas.height = window.innerHeight;

        const circles = [];
        const numCircles = 30;

        class Circle {
            constructor() { this.reset(); }
            reset() {
                this.x = Math.random() * width;
                this.y = Math.random() * height;
                this.radius = Math.random() * 50 + 20;
                this.speedX = (Math.random()-0.5) * 1.2;
                this.speedY = (Math.random()-0.5) * 1.2;
                this.color = `hsla(${Math.random()*360}, 80%, 60%, 0.2)`;
            }
            draw() {
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.radius, 0, Math.PI*2);
                ctx.fillStyle = this.color;
                ctx.fill();
            }
            update() {
                this.x += this.speedX;
                this.y += this.speedY;
                if(this.x < -this.radius || this.x > width + this.radius || this.y < -this.radius || this.y > height + this.radius){
                    this.reset();
                }
            }
        }

        for(let i=0;i<numCircles;i++){ circles.push(new Circle()); }

        function animate(){
            ctx.clearRect(0,0,width,height);
            circles.forEach(c => { c.update(); c.draw(); });
            requestAnimationFrame(animate);
        }

        animate();

        window.addEventListener('resize', () => {
            width = canvas.width = window.innerWidth;
            height = canvas.height = window.innerHeight;
        });
    </script>

</body>
</html>