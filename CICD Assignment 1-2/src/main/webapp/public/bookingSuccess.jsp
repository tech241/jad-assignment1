<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/general.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/public/assets/bookingSuccess.css">
</head>
<body>

	<%@ include file="assets/components/header.jsp"%>
	<%@ include file="assets/scripts/loadScripts.jsp"%>

	<div class="page-content">
		<div class="success-wrapper">
			<div class="success-card">
				<h1>Booking Added!</h1>
				<p>Your booking has been added to your cart successfully.</p>
				<div class="success-actions">
					<a href="bookingSummary.jsp" class="btn-view-cart">View Cart</a>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="assets/components/footer.jsp"%>
</body>

</html>