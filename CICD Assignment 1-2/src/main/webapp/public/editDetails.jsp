<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/general.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/accountoptions.css?v=<%=System.currentTimeMillis()%>">
</head>
<body>

	<!-- header.jsp goes here -->
	<%@ include file="assets/components/header.jsp"%>

	<!-- load all scripts so that the pages do not need to add the script manually -->
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<%@ include file="assets/scripts/restrictToLoggedIn.jsp"%>

	<%
	String sessName = (String) session.getAttribute("name");
	String sessEmail = (String) session.getAttribute("email");

	String phone = (String) session.getAttribute("phone");
	String address = (String) session.getAttribute("address");
	String emergencyName = (String) session.getAttribute("emergency_contact_name");
	String emergencyPhone = (String) session.getAttribute("emergency_contact_phone");
	String residentialAreaCode = (String) session.getAttribute("residential_area_code");

	// care needs stored as String[] in session (we’ll set it later)
	String[] careNeeds = (String[]) session.getAttribute("care_needs");
	if (careNeeds == null)
		careNeeds = new String[]{};
	java.util.Set<String> needsSet = new java.util.HashSet<>(java.util.Arrays.asList(careNeeds));
	%>

	<main class="page-wrap">
		<div class="profile-shell">
			<h1 class="page-title">Edit Profile</h1>

			<div class="card">
				<div class="card-head">
					<div class="avatar" aria-hidden="true">
						<!-- simple user icon -->
						<svg viewBox="0 0 24 24" fill="none">
            <path
								d="M12 12c2.761 0 5-2.239 5-5S14.761 2 12 2 7 4.239 7 7s2.239 5 5 5Z"
								stroke="currentColor" stroke-width="2" />
            <path d="M20 22a8 8 0 1 0-16 0" stroke="currentColor"
								stroke-width="2" stroke-linecap="round" />
          </svg>
					</div>
					<div>
						<p class="card-title"><%=sessName == null ? "Your Profile" : sessName%></p>
						<p class="card-subtitle">Update your contact details and care
							preferences.</p>
					</div>
				</div>

				<%
				String errMsg = request.getParameter("errMsg");
				if (errMsg != null) {
				%>
				<div class="alert"><%=errMsg%></div>
				<%
				}
				%>

				<form action="<%=request.getContextPath()%>/editDetails"
					method="post">
					<div class="form-grid">

						<div class="field">
							<label for="name">Name</label> <input type="text" name="name"
								id="name" value="<%=sessName == null ? "" : sessName%>" required>
						</div>

						<div class="field">
							<label for="email">Email</label> <input type="email" name="email"
								id="email" value="<%=sessEmail == null ? "" : sessEmail%>"
								required>
						</div>


						<%
						String profileImage = (String) session.getAttribute("profile_image");
						boolean hasProfileImage = profileImage != null && !profileImage.trim().isEmpty();
						%>

						<div class="field full">
							<label>Profile Photo</label>

							<div class="profile-photo-row">

								<%
								if (!hasProfileImage) {
								%>
								<i class="bx bx-user-circle" id="account-icon"></i>
								<%
								} else {
								String imgSrc = profileImage.startsWith("http") ? profileImage : request.getContextPath() + "/public/" + profileImage;
								%>
								<img class="profile-pic" src="<%=imgSrc%>"
									alt="Profile Picture">
								<%
								}
								%>

								<div class="profile-photo-controls">
									<input type="text" name="profileImage" id="profileImage"
										value="<%=profileImage == null ? "" : profileImage%>"
										placeholder="e.g. images/default-profile.png or https://...">

									<button type="button" class="btn btn-secondary"
										id="removePhotoBtn">Remove Photo</button>

									<small class="hint"> Leave blank to use the default
										icon. </small>
								</div>

							</div>
						</div>


						<div class="field">
							<label for="phone">Phone (Singapore)</label> <input type="tel"
								name="phone" id="phone" value="<%=phone == null ? "" : phone%>"
								pattern="^[689][0-9]{7}$" maxlength="8" inputmode="numeric"
								title="Singapore phone number must be 8 digits and start with 6, 8, or 9.">
						</div>

						<div class="field">
							<label for="residentialAreaCode">Residential Postal Code</label>
							<input type="text" name="residentialAreaCode"
								id="residentialAreaCode"
								value="<%=residentialAreaCode == null ? "" : residentialAreaCode%>"
								pattern="^[0-9]{6}$" maxlength="6" inputmode="numeric"
								title="Please enter a valid 6-digit Singapore postal code.">
						</div>

						<div class="field full">
							<label for="address">Address</label>
							<textarea name="address" id="address" rows="3"
								placeholder="Optional"><%=address == null ? "" : address%></textarea>
						</div>

						<div class="field full">
							<label>Specific Care Needs</label>
							<div class="checkbox-grid">
								<label><input type="checkbox" name="careNeeds"
									value="Mobility Assistance"
									<%=needsSet.contains("Mobility Assistance") ? "checked" : ""%>>
									Mobility Assistance</label> <label><input type="checkbox"
									name="careNeeds" value="Dementia Care"
									<%=needsSet.contains("Dementia Care") ? "checked" : ""%>>
									Dementia Care</label> <label><input type="checkbox"
									name="careNeeds" value="Post-surgery Recovery"
									<%=needsSet.contains("Post-surgery Recovery") ? "checked" : ""%>>
									Post-surgery Recovery</label> <label><input type="checkbox"
									name="careNeeds" value="Medication Support"
									<%=needsSet.contains("Medication Support") ? "checked" : ""%>>
									Medication Support</label> <label><input type="checkbox"
									name="careNeeds" value="Companionship"
									<%=needsSet.contains("Companionship") ? "checked" : ""%>>
									Companionship</label> <label><input type="checkbox"
									name="careNeeds" value="Physiotherapy Support"
									<%=needsSet.contains("Physiotherapy Support") ? "checked" : ""%>>
									Physiotherapy Support</label>
							</div>
						</div>

						<div class="field">
							<label for="emergencyName">Emergency Contact Name</label> <input
								type="text" name="emergencyName" id="emergencyName"
								value="<%=emergencyName == null ? "" : emergencyName%>">
						</div>

						<div class="field">
							<label for="emergencyPhone">Emergency Contact Phone</label> <input
								type="tel" name="emergencyPhone" id="emergencyPhone"
								value="<%=emergencyPhone == null ? "" : emergencyPhone%>"
								pattern="^[689][0-9]{7}$" maxlength="8" inputmode="numeric"
								title="Singapore phone number must be 8 digits and start with 6, 8, or 9.">
						</div>

						<div class="field full">
							<label for="password">Enter current password to confirm
								changes</label> <input type="password" name="password" id="password"
								required>
						</div>

					</div>
					<!-- form-grid -->

					<div class="form-actions">
					<!-- DEBUG MARKER: EDIT DETAILS JSP LOADED -->
						<button type="submit" class="btn btn-primary">Save
							Changes</button>
					</div>

				</form>
			</div>
		</div>
	</main>


	<!-- footer.jsp goes here -->
	<%@ include file="assets/components/footer.jsp"%>

	<script>
  (function () {
    const form = document.querySelector("form");
    if (!form) return;

    const phone = document.getElementById("phone");
    const postal = document.getElementById("residentialAreaCode");
    const emergencyPhone = document.getElementById("emergencyPhone");
    const alertBox = document.getElementById("clientErr");

    const digitsOnly = (v) => (v || "").replace(/\D/g, ""); // remove all non-digits
    const sgPhone = (v) => /^[689]\d{7}$/.test(digitsOnly(v));
    const sgPostal = (v) => /^\d{6}$/.test(digitsOnly(v));

    form.addEventListener("submit", function (e) {
      let errors = [];

      if (phone) phone.value = digitsOnly(phone.value);
      if (emergencyPhone) emergencyPhone.value = digitsOnly(emergencyPhone.value);
      if (postal) postal.value = digitsOnly(postal.value);
      
      if (phone && phone.value.trim() !== "" && !sgPhone(phone.value)) {
        errors.push("Phone number must be 8 digits and start with 6, 8, or 9.");
      }

      if (postal && postal.value.trim() !== "" && !sgPostal(postal.value)) {
        errors.push("Residential area code must be a 6-digit Singapore postal code.");
      }

      if (emergencyPhone && emergencyPhone.value.trim() !== "" && !sgPhone(emergencyPhone.value)) {
        errors.push("Emergency contact phone must be 8 digits and start with 6, 8, or 9.");
      }

      if (errors.length > 0) {
        e.preventDefault();
        if (alertBox) {
          alertBox.style.display = "block";
          alertBox.textContent = errors[0]; // show first error only (clean)
        } else {
          alert(errors[0]);
        }
      }
    });
  })();
</script>
	<script>
  const removeBtn = document.getElementById("removePhotoBtn");
  const photoInput = document.getElementById("profileImage");

  if (removeBtn && photoInput) {
    removeBtn.addEventListener("click", function () {
      photoInput.value = "";
    });
  }
</script>

</body>
</html>