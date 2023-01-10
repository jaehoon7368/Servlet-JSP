<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ajax</title>
</head>
<body>
	<h1>Ajax</h1>
	<h2>Javascript</h2>
	<a href="<%=request.getContextPath() %>/js/js.jsp">js로 XMLHttpRequest 객체 직접 제어하기</a>
	
	<h2>jQuery Ajax</h2>
	<h3>text</h3>
		<ul>
			<li><a href="<%=request.getContextPath()%>/text/text.jsp">text</a></li>
			<li><a href="<%=request.getContextPath()%>/text/autocomplete.jsp">autocomplete</a></li>
		</ul>
		
	<h3>html</h3>
		<ul>
			<li><a href="<%=request.getContextPath()%>/html/html.jsp">html</a></li>
		</ul>
	<h3>xml</h3>
		<ul>
			<li><a href="<%=request.getContextPath()%>/xml/xml.jsp">xml</a></li>
		</ul>
	<h3>json</h3>
		<ul>
			<li><a href="<%=request.getContextPath()%>/json/json.jsp">json</a></li>
		</ul>
</body>
</html>