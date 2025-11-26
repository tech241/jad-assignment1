<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<!-- this script adds all of the scripts needed to run the webpage -->
	<!-- if all the pages use the same set of code, add it to here -->
	<script>
	const progressBar = document.querySelector('.scroll-progress-bar');

	window.addEventListener('scroll', () => {
	    const scrollTop = window.scrollY;
	    const docHeight = document.documentElement.scrollHeight - window.innerHeight;
	    const scrolled = (scrollTop / docHeight) * 100;
	    
	    progressBar.style.width = scrolled + '%';
	    progressBar.classList.add('glowing');
	});

	let scrollTimeout;
	window.addEventListener('scroll', () => {
	    clearTimeout(scrollTimeout);
	    scrollTimeout = setTimeout(() => {
	        progressBar.classList.remove('glowing');
	    }, 500);
	});
	</script>

</body>
</html>