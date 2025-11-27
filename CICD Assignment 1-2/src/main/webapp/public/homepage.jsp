<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Welcome!</title>
<link rel="stylesheet" href="assets/homepage.css">
</head>
<body>

	<!-- Header -->
	<%@ include file="assets/components/header.jsp"%>
	<div class="scroll-progress-bar"></div>

	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<main>
		<div class="hero">
			<div class="hero-content">
				<h1>Welcome to Silver Care!</h1>
				<p>Compassionate support for your loved ones. Anytime, anywhere.</p>

				<button class="btn-primary" onclick="location.href='services.jsp'">View
					Our Services</button>
				<button class="btn-primary" onclick="location.href='login.jsp'">Become
					Client</button>
			</div>

			<%@ include file="assets/components/sectiondivider.jsp"%>
		</div>

		<div class="services-preview">
			<div class="services-preview-left">
				<img src="assets/images/elderly-img.jpg" alt="Elderly Care">
			</div>

			<div class="services-preview-right">
				<h2>Our Care Services</h2>
				<p>From in-home care to specialised support, we provide a wide
					range of services to ensure your loved ones receive the comfort,
					safety, and assistance they deserve.</p>

				<button class="btn-primary" onclick="toggleServices()">View
					Services</button>
			</div>
		</div>

		<!-- EXPANDABLE SECTION -->
		<div id="expand-services" class="expandable">
			<h2 style="text-align: center;">Our Services</h2>
			<div class="service-cards">

				<!-- SAMPLE SERVICE CARD – duplicate & replace -->
				<div class="service-card">
					<h3>In-Home Care</h3>
					<p>Daily assistance with tasks like bathing, meals, and
						mobility.</p>
				</div>

				<div class="service-card">
					<h3>Dementia Care</h3>
					<p>Specialised support for seniors with memory-related
						conditions.</p>
				</div>

				<div class="service-card">
					<h3>Transportation</h3>
					<p>Safe travel for appointments, errands, and social visits.</p>
				</div>

				<!-- Add more cards here -->
			</div>
		</div>

		<div class="colour-section-divider-colour">
			<%@ include file="assets/components/sectiondivider.jsp"%>
		</div>

		<div class="guardians-section">
			<h2>Meet Our Silver Guardians</h2>
			<p>Experienced, compassionate, and dedicated to providing the
				best care.</p>

			<div class="guardian-cards">
				<!-- Sample Card -->
				<div class="guardian-card">
					<img src="assets/images/caregiver1.jpg" alt="">
					<h3>Mary Tan</h3>
					<p>Senior Care Specialist</p>
				</div>

				<div class="guardian-card">
					<img src="assets/images/caregiver2.jpg" alt="">
					<h3>Lucas Ong</h3>
					<p>Home Support Caregiver</p>
				</div>

				<!-- Add more cards -->
			</div>
		</div>

		<div class="colour-section-divider-colour-invert">
			<%@ include file="assets/components/sectiondivider.jsp"%>
		</div>

		<div class="why-section">
			<h2>Why Choose Silver Care?</h2>

			<div class="reviews">
			
				<!-- Sample Reviews — replace with dynamic JSP later -->
				<!-- <div class="review-card">
					<p>"The caregivers are patient and attentive. My mother loves
						them!"</p>
					<strong>- Sarah L.</strong>
				</div>

				<div class="review-card">
					<p>"Their dementia support truly helped our family. Highly
						recommended."</p>
					<strong>- Kelvin W.</strong>
				</div>

				<div class="review-card">
					<p>"Professional, trustworthy and always kind. Silver Care is a
						blessing."</p>
					<strong>- Mei Yun</strong>
				</div> -->
			
				<%
				ResultSet rsReview = null;

				try {
					Class.forName("org.postgresql.Driver");
					Connection connReview = DriverManager.getConnection(
					"jdbc:postgresql://ep-frosty-sky-a1prx4gp-pooler.ap-southeast-1.aws.neon.tech:5432/neondb?sslmode=require",
					"neondb_owner", "npg_iCobAxPw5z4X");

					Statement stmtReview = connReview.createStatement();
					rsReview = stmtReview.executeQuery("SELECT name, rating, comments FROM feedback JOIN member ON member_id = id WHERE rating = 5 ORDER BY RANDOM() LIMIT 3;");

				} catch (Exception e) {
					out.println("Error in header DB: " + e);
				}
				
				while (rsReview != null && rsReview.next()) {
				%>
				
				<div class="review-card">
					<h1>
					<%
					for (int i = 0; i < rsReview.getInt("rating"); i ++) {
						out.print("★");
					}
					for (int i = rsReview.getInt("rating"); i < 5; i ++) {
						out.print("☆");
					}
					%>
					</h1>
					<p><%= rsReview.getString("comments") %></p>
					<strong>- <%= rsReview.getString("name") %></strong>
				</div>
				
				<% } %>
				
			</div>
		</div>
		<div class="scroll-indicator">
			<span id="scroll-percent">0</span>%
		</div>
	</main>

	<script>
		function toggleServices() {
			const section = document.getElementById("expand-services");
			const button = document
					.querySelector(".services-preview-right button");

			const isOpen = section.style.display === "block";

			section.style.display = isOpen ? "none" : "block";
			button.textContent = isOpen ? "View Services" : "Hide Services";

			if (!isOpen) {
				section.scrollIntoView({
					behavior : "smooth"
				});
			}
		}
	</script>

	<!-- Footer -->
	<%@ include file="assets/components/footer.jsp"%>


</body>
</html>