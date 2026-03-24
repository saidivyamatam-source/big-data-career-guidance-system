<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Home - Big Data Professionals</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    html, body { height:100%; font-family:'Roboto', sans-serif; background:#0d1b2a; color:#fff; scroll-behavior:smooth; }

    .header { background: rgba(13, 59, 102, 0.95); backdrop-filter: blur(6px); position: sticky; top:0; z-index:1000; box-shadow:0 4px 20px rgba(0,0,0,0.2);}
    .header .container { display:flex; justify-content:space-between; align-items:center; padding:15px 0;}
    .header .logo h1 { font-size:2rem; font-weight:700; color:#ffd166;}
    .nav-links { list-style:none; display:flex; gap:2rem;}
    .nav-links a { color:#fff; text-decoration:none; font-weight:500; position:relative; }
    .nav-links a::after { content:''; position:absolute; width:0%; height:3px; bottom:-5px; left:0; background:#ffd166; transition:0.4s;}
    .nav-links a:hover::after { width:100%; }
    .nav-links .btn { border-radius:50px; padding:8px 25px; font-weight:600; }

    .hero { height:90vh; position:relative; display:flex; justify-content:center; align-items:center; text-align:center; overflow:hidden;}
    .hero canvas#animated-bg { position:absolute; top:0; left:0; width:100%; height:100%; z-index:0;}
    .hero-content { position:relative; z-index:1; width:100%; max-width:600px; color:#fff; }
    .hero-content h1 { font-size:2.5rem; margin-bottom:20px; color:#ffd166;}
    .hero-content p { font-size:1.1rem; margin-bottom:30px; }

    .hero-content .btn-primary { background:linear-gradient(90deg,#ffd166,#ef476f); border:none; padding:12px 30px; border-radius:50px; font-weight:700; transition:0.3s;}
    .hero-content .btn-primary:hover { transform:translateY(-3px); box-shadow:0 10px 25px rgba(0,0,0,0.5); }

    .footer { background:#0d3b66; color:#fff; text-align:center; padding:30px 15px; font-size:0.95rem; }

    @media(max-width:768px){ .hero-content h1 { font-size:2rem; } .hero-content p { font-size:1rem; } }
  </style>
</head>
<body>

  <!-- Header -->
  <header class="header">
    <div class="container d-flex justify-content-between align-items-center py-3">
      <div class="logo"><h1>Big Data Professionals</h1></div>
      <nav>
        <ul class="nav-links d-flex gap-3">
          <li><a href="userLogin.jsp" class="nav-link btn btn-primary text-white">User Login</a></li>
          <li><a href="adminLogin.jsp" class="nav-link btn btn-primary text-white">Admin Login</a></li>
          <li><a href="register.jsp" class="nav-link btn btn-primary text-white">Register</a></li>
          <li><a href="index.jsp" class="nav-link btn btn-primary text-white">Home</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <!-- Hero Section -->
  <section class="hero d-flex align-items-center justify-content-center">
    <canvas id="animated-bg"></canvas>
    <div class="hero-content">
      <h1>Welcome to Big Data Professionals</h1>
      <p>Analyze your skills, track growth, and align with industry demands in Big Data and Analytics.</p>
      <a href="register.jsp" class="btn btn-primary">Get Started</a>
    </div>
  </section>

  <!-- Footer -->
  <footer class="footer py-3">
    <p>&copy; 2026 Analyzing Big Data Professionals. All rights reserved.</p>
  </footer>

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
    class Circle { constructor(){ this.reset(); } reset(){ this.x=Math.random()*width; this.y=Math.random()*height; this.radius=Math.random()*50+20; this.speedX=(Math.random()-0.5)*1.2; this.speedY=(Math.random()-0.5)*1.2; this.color=`hsla(${Math.random()*360},80%,60%,0.2)`; } draw(){ ctx.beginPath(); ctx.arc(this.x,this.y,this.radius,0,Math.PI*2); ctx.fillStyle=this.color; ctx.fill(); } update(){ this.x+=this.speedX; this.y+=this.speedY; if(this.x<-this.radius||this.x>width+this.radius||this.y<-this.radius||this.y>height+this.radius){ this.reset(); } } }
    for(let i=0;i<numCircles;i++){ circles.push(new Circle()); }
    function animate(){ ctx.clearRect(0,0,width,height); circles.forEach(c=>{c.update();c.draw();}); requestAnimationFrame(animate); }
    animate();
    window.addEventListener('resize',()=>{ width=canvas.width=window.innerWidth; height=canvas.height=window.innerHeight; });
  </script>
</body>
</html>

