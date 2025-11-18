<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<!-- import java.util.LocalDate -->
	<%@ page import="java.time.LocalDate"%>

	<div>
        <div class="footer">
            <span>Silver Care &copy;<%= LocalDate.now().getYear() %>. All rights reserved.</span>
        </div>
    </div>

</body>
</html>