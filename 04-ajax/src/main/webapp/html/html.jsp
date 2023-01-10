<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<style>
table{
	border : 1px solid #000;
	border-collapse : collapse;
	margin-top:10px;
	}
th,td{
	border : 1px solid #000;
	text-align:center;
	padding: 5px;
}
img{
	width:100px;
}
</style>
<html>
<head>
<meta charset="UTF-8">
<title>jQuery ajax - html</title>
<script src="<%= request.getContextPath()%>/js/jquery-3.6.1.js"></script>
</head>
<body>
	<h1>jQuery ajax - html</h1>
	<button id="btn1">셀럽</button>
	<div id="target"></div>
	<script>
	btn1.onclick = () =>{
		$.ajax({
			url : "<%= request.getContextPath()%>/html/celeb",
			method : "GET",
			dataType : "html",
			success(data){
				console.log(data);
				document.querySelector("#target").innerHTML = data;
			},
			error(xhr, textStatus, err){
				console.log(xhr, textStatus, err);
			}
		});	
	};
	</script>
</body>
</html>