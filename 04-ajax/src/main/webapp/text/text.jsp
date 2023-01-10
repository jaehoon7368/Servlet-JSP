<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>jQuery Ajax - text</title>
<script src="<%= request.getContextPath()%>/js/jquery-3.6.1.js"></script>
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
</head>
<body>
	<h1>jQuery Ajax - text</h1>
	<button id="btn1">텍스트파일</button>
	<p id="target"></p>
	<script>
	document.querySelector("#btn1").onclick = () =>{
	
		$.ajax({
			url : "<%= request.getContextPath()%>/text/sample.txt",
			method : 'GET', //전송방식 (기본값 GET)
			dataType : 'text', //응답데이터타입 text | html | xml | json 생략시 jquery가 응답데이터를 확인해서 자동설정.
			beforeSend(){
				//전송전 호출 메소드
				console.log('beforeSend!');
			},
			success(data){
				//요청처리 성공시 호출되는 메소드, 응답데이터가 매개인자로 전달
				console.log('success!',data);
				target.innerHTML = data;
			},
			error(xhr, textStatus, err){
				//에러발생시 호출되는 메소드
				console.log('error!',xhr, textStatus, err);
			},
			complete(){
				//요청 성공 또는 실패시 마지막에 무조건 호출되는 메소드
				console.log('complete!');
			}
		});
	};
	</script>
	
	<h2>csv</h2>
	<button id="btn2">셀럽</button>
	<div id="target-celeb"></div>
	<script>
	btn2.onclick = () =>{
		$.ajax({
			url : "<%=request.getContextPath()%>/csv/celeb",
			method : "GET",
			dataType : "text", //csv없음
			success(data){
				console.log(data);
				document.querySelector("#target-celeb").innerHTML = renderCelebData(data);
			},
			error(xhr,textStatus,err){
				console.log(xhr,textStatus,err);
			}
		});	
	};
	
	/*
	1,양세찬,양세찬.jpg,Comedian
	2,김고은,김고은.jpg,Actor
	3,아이유,아이유.png,Singer
	4,조정석,조정석.png,Actor
	5,강동원,강동원.jpg,Actor
	*/
	const renderCelebData = (data) =>{
		let html = `
			<table>
				<thead>
					<tr>
						<th>No</th>
						<th>프로필</th>
						<th>이름</th>
						<th>직업</th>
					</tr>
				</thead>
				<tbody>
		`;
		
		//csv 데이터 처리
		const temp = data.split("\n");
		for(let i = 0; i < temp.length;i++){
			const celeb = temp[i].split(",");
			console.log(celeb);
			
			html += `
				<tr>
					<td>\${celeb[0]}</td>
					<td><img src="<%=request.getContextPath() %>/images/\${celeb[2]}" alt="" /></td>
					<td>\${celeb[1]}</td>
					<td>\${celeb[3]}</td>
				</tr>
			`;
		}
		
		html +=`
				</tbody>
			</tabel>
		`;
		console.log(html);
		return html;
	};
	</script>
	
</body>
</html>