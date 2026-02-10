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
	const progressBar = document.querySelector('.scroll-progress-bar'); // finds the HTML eleent with the class .scroll-progress-bar and stores it in progressBar variable.

	window.addEventListener('scroll', () => { // calls the function every time the user scrolls.
	    const scrollTop = window.scrollY; // how many pixels from the top the user has scrolled. scrollHeight is the total height of the page. innerHeight is the visible area on the screen. 
	    const docHeight = document.documentElement.scrollHeight - window.innerHeight; // hence, docHeight is how much the user CAN scroll. 
	    const scrolled = (scrollTop / docHeight) * 100; // convert scroll to percentage.
	    
	    progressBar.style.width = scrolled + '%'; // update the bar width accordingly! so the bar's width visually changes as the user scrolls. 
	    progressBar.classList.add('glowing');
	});

	// the glow is removed when the scrolling stops. 
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