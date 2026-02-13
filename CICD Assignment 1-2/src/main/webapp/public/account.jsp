<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalTime"%>

<%
Object uidObj = session.getAttribute("id");
if (uidObj == null) {
	response.sendRedirect("login.jsp?errMsg=Please log in first.");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Account</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/public/assets/account.css?v=<%=System.currentTimeMillis()%>">

</head>

<body>
	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>
	<%@ include file="assets/scripts/restrictToLoggedIn.jsp"%>

	<%
	int hour = LocalTime.now().getHour();
	String greeting = (hour < 12) ? "Morning" : (hour < 18) ? "Afternoon" : "Evening";

	String sessName = (String) session.getAttribute("name");
	String sessEmail = (String) session.getAttribute("email");
	%>

	<main>
		<div class="container">

			<h1>
				Good
				<%=greeting%>!
			</h1>

			<%
			String successMsg = (String) session.getAttribute("successMsg");
			String errorMsg = (String) session.getAttribute("errorMsg");

			// remove immediately so it shows only once
			session.removeAttribute("successMsg");
			session.removeAttribute("errorMsg");
			%>

			<%
			if (successMsg != null) {
			%>
			<div class="toast toast-success"><%=successMsg%></div>
			<%
			}
			%>

			<%
			if (errorMsg != null) {
			%>
			<div class="toast toast-error"><%=errorMsg%></div>
			<%
			}
			%>

			<div class="profile">
				<div class="card">

					<%
					String profileImage = (String) session.getAttribute("profile_image");
					boolean hasProfileImage = profileImage != null && !profileImage.trim().isEmpty();
					%>

					<%
					if (!hasProfileImage) {
					%>
					<i class="bx bx-user-circle" id="account-icon"></i>
					<%
					} else {
					String imgSrc = profileImage.startsWith("http") ? profileImage : request.getContextPath() + "/public/" + profileImage;
					%>
					<img class="profile-pic" src="<%=imgSrc%>" alt="Profile Picture">
					<%
					}
					%>

					<div class="info">
						<h2><%=sessName == null ? "-" : sessName%></h2>
						<span><%=sessEmail == null ? "-" : sessEmail%></span>
						<%
						String phone = (String) session.getAttribute("phone");
						String address = (String) session.getAttribute("address");
						String residentialAreaCode = (String) session.getAttribute("residential_area_code");
						String emergencyName = (String) session.getAttribute("emergency_contact_name");
						String emergencyPhone = (String) session.getAttribute("emergency_contact_phone");

						String[] needsArr = (String[]) session.getAttribute("care_needs");
						String needsText = (needsArr != null && needsArr.length > 0) ? String.join(", ", needsArr) : "-";
						%>


						<p>
							<strong>Phone:</strong>
							<%=session.getAttribute("phone") == null ? "-" : session.getAttribute("phone")%>
						</p>

						<p>
							<strong>Residential Area Code:</strong>
							<%=session.getAttribute("residential_area_code") == null ? "-" : session.getAttribute("residential_area_code")%>
						</p>

						<p>
							<strong>Care Needs:</strong>
							<%=needsText%></p>
					</div>
				</div>

				<div class="buttons">
					<button type="button" id="viewFullBtn">View Full Profile</button>
					<button onclick="location.href='editDetails.jsp'">Edit
						Details</button>
					<button onclick="location.href='changePassword.jsp'">Change
						Password</button>
				</div>
			</div>

			<div class="modal-backdrop" id="profileModal" aria-hidden="true">
				<div class="modal" role="dialog" aria-modal="true"
					aria-labelledby="profileModalTitle">
					<div class="modal-head">
						<h2 class="modal-title" id="profileModalTitle">Full Profile
							Details</h2>
						<button class="modal-close" type="button" id="closeModalBtn"
							aria-label="Close">&times;</button>
					</div>

					<div class="modal-body">
						<div class="kv">
							<div class="k">Name</div>
							<div class="v"><%=sessName == null ? "-" : sessName%></div>
						</div>
						<div class="kv">
							<div class="k">Email</div>
							<div class="v"><%=sessEmail == null ? "-" : sessEmail%></div>
						</div>
						<div class="kv">
							<div class="k">Phone</div>
							<div class="v"><%=(phone == null || phone.trim().isEmpty()) ? "-" : phone%></div>
						</div>
						<div class="kv">
							<div class="k">Residential Postal Code</div>
							<div class="v"><%=(residentialAreaCode == null || residentialAreaCode.trim().isEmpty()) ? "-" : residentialAreaCode%></div>
						</div>
						<div class="kv">
							<div class="k">Address</div>
							<div class="v"><%=(address == null || address.trim().isEmpty()) ? "-" : address%></div>
						</div>

						<div class="kv">
							<div class="k">Emergency Contact Name</div>
							<div class="v"><%=(emergencyName == null || emergencyName.trim().isEmpty()) ? "-" : emergencyName%></div>
						</div>
						<div class="kv">
							<div class="k">Emergency Contact Phone</div>
							<div class="v"><%=(emergencyPhone == null || emergencyPhone.trim().isEmpty()) ? "-" : emergencyPhone%></div>
						</div>

						<div class="kv">
							<div class="k">Care Needs / Notes</div>
							<div class="v"><%=needsText%></div>
						</div>
					</div>

					<div class="modal-actions">
						<button type="button" class="btn-secondary-lite"
							id="closeModalBtn2">Close</button>
						<button type="button" onclick="location.href='editDetails.jsp'">Edit
							Details</button>
					</div>
				</div>
			</div>

			<div class="section-divider"></div>

			<h2>Upcoming Bookings</h2>

			<div class="section-divider"></div>

			<h1>Enjoying our website?</h1>
			<button id="feedback" onclick="location.href='feedback.jsp'">Feedback</button>
			<br> <span>Your feedback is greatly appreciated.</span>

			<div class="section-divider"></div>

			<h1>Danger Zone</h1>
			<button id="delete-account"
				onclick="location.href='deleteAccount.jsp'">Delete Account</button>
			<br> <span>This action is permanent and cannot be undone.</span>

		</div>
	</main>

	<%@ include file="assets/components/footer.jsp"%>

	<script>
(function () {
  const modal = document.getElementById("profileModal");
  const openBtn = document.getElementById("viewFullBtn");
  const closeBtn = document.getElementById("closeModalBtn");
  const closeBtn2 = document.getElementById("closeModalBtn2");

  if (!modal || !openBtn) return;

  const open = () => {
    modal.classList.add("is-open");
    modal.setAttribute("aria-hidden", "false");
    document.body.style.overflow = "hidden";

    // focus inside modal
    if (closeBtn) closeBtn.focus();
  };

  const close = () => {
    // move focus OUT of modal first (prevents aria-hidden warning)
    openBtn.focus();

    modal.classList.remove("is-open");
    modal.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";
  };

  openBtn.addEventListener("click", open);
  if (closeBtn) closeBtn.addEventListener("click", close);
  if (closeBtn2) closeBtn2.addEventListener("click", close);

  modal.addEventListener("click", function (e) {
    if (e.target === modal) close();
  });

  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape" && modal.classList.contains("is-open")) close();
  });
})();
</script>
</body>
</html>
