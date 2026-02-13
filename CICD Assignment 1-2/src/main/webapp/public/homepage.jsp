<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.time.*"%>
<%@ page import="java.time.format.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="servlets.postgresHelper"%>
<%@ page import="models.Promotion" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Welcome!</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/general.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/homepage.css">
</head>
<body>

	<!-- Header -->
	<%@ include file="assets/components/header.jsp"%>

	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<%@ include file="assets/scripts/loadStatistics.jsp"%>

	<%
	Connection conn = null;

	try {
		conn = postgresHelper.connect();
	%>

	<div class="scroll-progress-bar"></div>


	<main>

		<section class="hero">
			<div class="hero-content">
				<p class="hero-eyebrow">Caring for those who cared for us</p>

				<h1>Compassionate care, whenever you need it.</h1>

				<p class="hero-subtitle">Friendly caregivers providing support,
					companionship, and peace of mind for your loved ones.</p>

				<div class="hero-actions">
					<button class="btn-primary"
						onclick="location.href='<%=request.getContextPath()%>/services'">
						Explore Services</button>

					<%
					if (!isLoggedIn) {
					%>
					<button class="btn-secondary"
						onclick="location.href='<%=request.getContextPath()%>/public/login.jsp'">
						Become a Client</button>
					<%
					} else {
					%>
					<button class="btn-secondary"
						onclick="location.href='<%=request.getContextPath()%>/services'">Book
						a Service</button>
					<%
					}
					%>
				</div>
			</div>
		</section>
		
		<%
Promotion homePromo = (Promotion) request.getAttribute("homePromo");
if (homePromo != null) {
%>

<section class="promo-banner">
  <div class="promo-content">
    <div class="promo-text">
      <p class="promo-tag"><%= homePromo.getThemeTag() == null ? "Seasonal Promotion" : homePromo.getThemeTag() %></p>
      <h2><%= homePromo.getTitle() %></h2>
      <p class="promo-desc"><%= homePromo.getDescription() == null ? "" : homePromo.getDescription() %></p>

      <% if (homePromo.getCode() != null && !homePromo.getCode().trim().isEmpty()) { %>
        <div class="promo-code">
          Use code: <span><%= homePromo.getCode() %></span>
        </div>
      <% } %>

      <div class="promo-actions">
        <a class="promo-btn" href="<%=request.getContextPath()%>/services">Explore Services</a>
        <a class="promo-link" href="<%=request.getContextPath()%>/public/checkout.jsp">Go to Checkout</a>
      </div>
    </div>

    <% if (homePromo.getImagePath() != null && !homePromo.getImagePath().trim().isEmpty()) { %>
  <div class="promo-image">
    <img src="<%= request.getContextPath() + homePromo.getImagePath() %>" 
         alt="Promotion banner">
  </div>
<% } %>
  </div>
</section>

<% } %>
		


		<%
		if (isLoggedIn) {
			PreparedStatement pstmtNext = null;
			ResultSet rsNext = null;

			try {
				int memberId = (Integer) session.getAttribute("id");

				pstmtNext = conn.prepareStatement("SELECT * FROM get_upcoming_bookings(?)");
				pstmtNext.setInt(1, memberId);
				rsNext = pstmtNext.executeQuery();

				if (rsNext.next()) {
			LocalDate d = rsNext.getDate("scheduled_date").toLocalDate();
			LocalTime t = rsNext.getTime("scheduled_time").toLocalTime();
			DateTimeFormatter df = DateTimeFormatter.ofPattern("dd MMM yyyy");
			DateTimeFormatter tf = DateTimeFormatter.ofPattern("h:mm a");
		%>

		<section class="next-booking-bar">
			<div class="nb-info">
				<span class="nb-label">Your next booking</span> <span
					class="nb-main"> <%=rsNext.getString("service_name")%> • <%=rsNext.getString("package_name")%>
				</span> <span class="nb-meta"><%=d.format(df)%> • <%=t.format(tf)%></span>
			</div>

			<div class="nb-actions">
				<a href="<%=request.getContextPath()%>/bookings/upcoming"
					class="nb-btn-primary">View Upcoming</a> <a href="services.jsp"
					class="nb-btn-link">Book Another</a>
			</div>
		</section>

		<%
		}

		} catch (Exception e) {
		out.println("Error loading next booking: " + e.getMessage());
		} finally {
		if (rsNext != null)
		try {
			rsNext.close();
		} catch (Exception ignore) {
		}
		if (pstmtNext != null)
		try {
			pstmtNext.close();
		} catch (Exception ignore) {
		}
		}
		}
		%>

		<section class="popular-services">

			<h2 class="section-title">Popular Services</h2>
			<p class="section-subtitle">Families often choose these services
				for their comfort and reliability.</p>

			<div class="popular-services-grid">

				<div class="popular-card">
					<h3><%=stats.get("Most booked service")%></h3>
					<p class="tag">Most booked service</p>
				</div>

				<div class="popular-card">
					<h3><%=stats.get("Highest rated service")%></h3>
					<p class="tag">Best rated by families</p>
				</div>

				<div class="popular-card">
					<h3><%=stats.get("Least booked service")%></h3>
					<p class="tag">A hidden gem</p>
				</div>

			</div>

		</section>

		<section class="featured-services">

			<h2 class="fs-title">Explore Our Services</h2>
			<p class="fs-subtitle">A quick look at what families choose most
				in each care category.</p>

			<div class="featured-list">

				<%
				PreparedStatement pc = conn
						.prepareStatement("SELECT cat_id, cat_name, cat_description FROM service_category ORDER BY cat_name ASC");
				ResultSet rc = pc.executeQuery();

				while (rc.next()) {
					int categoryId = rc.getInt("cat_id");
					String catName = rc.getString("cat_name");
					String catDesc = rc.getString("cat_description");

					PreparedStatement ps = conn.prepareStatement("SELECT * FROM get_top_service_by_category(?)");
					ps.setInt(1, categoryId);
					ResultSet rs = ps.executeQuery();
				%>

				<div class="fs-item">

					<h3 class="fs-cat-name"><%=catName%></h3>
					<p class="fs-cat-desc"><%=catDesc%></p>

					<%
					if (rs.next()) {
					%>

					<div class="fs-service-box">
						<h4 class="fs-service-name"><%=rs.getString("service_name")%></h4>
						<p class="fs-service-desc"><%=rs.getString("service_description")%></p>
						<a
							href="serviceDetails.jsp?service_id=<%=rs.getInt("service_id")%>"
							class="fs-btn">View Service →</a>
					</div>

					<%
					} else {
					%>

					<div class="fs-service-box empty">
						<p>No bookings yet in this category.</p>
					</div>

					<%
					}
					%>

				</div>
				<!-- END OF fs-item -->

				<%
				rs.close();
				ps.close();
				} // END WHILE LOOP

				rc.close();
				pc.close();
				%>

			</div>
		</section>



		<section class="why-section">

			<h2 class="why-title">Why Families Choose Silver Care</h2>

			<div class="why-grid">

				<div class="why-item">
					<h3>❤️ Compassionate Care</h3>
					<p>Our caregivers provide support with warmth and genuine
						kindness.</p>
				</div>

				<div class="why-item">
					<h3>🛡️ Safe & Reliable</h3>
					<p>Professionals you can trust to support your loved ones
						daily.</p>
				</div>

				<div class="why-item">
					<h3>⭐ Trusted by Families</h3>
					<p>Highly rated by our clients for quality, comfort, and care.</p>
				</div>

				<div class="why-item">
					<h3>📞 We're Here for You</h3>
					<p>Friendly support whenever you need help or guidance.</p>
				</div>

			</div>

		</section>

	</main>

	<script>
document.addEventListener("DOMContentLoaded", function() {
    const progressBar = document.querySelector('.scroll-progress-bar');

    window.addEventListener('scroll', () => {
        const scrollTop = window.scrollY;
        const docHeight = document.documentElement.scrollHeight - window.innerHeight;

        if (docHeight > 0) {
            const scrolled = (scrollTop / docHeight) * 100;
            progressBar.style.width = scrolled + '%';
        }
    });
});
</script>

	<!-- Footer -->
	<%@ include file="assets/components/footer.jsp"%>

	<%
	} catch (Exception e) {
	out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
	} finally {
	try {
		if (conn != null)
			conn.close();
	} catch (Exception ignore) {
	}
	}
	%>

</body>
</html>