<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>js로 XMLHttpRequest 제어하기</title>
</head>
<body>
	<h1>js로 XMLHttpRequest 제어하기</h1>
	<form action="">
		<fieldset>
			<legend>폼</legend>
			<div>
				<input type="text" name="username" id="username" placeholder="아이디 입력"/>
			</div>
			<div>
				<input type="email" name="email" id="email" placeholder="이메일 입력" />
			</div>
			<div>
				<button type="button" onclick="submitGet()">GET</button>
				<button type="button" onclick="submitPost()">POST</button>
			</div>
		</fieldset>
	</form>
	<div id="target"></div>
	
	<script>
	let xhr;
	
	const submitPost = () => {
		// 1. XMLHttpRequest객체 생성
		xhr = new XMLHttpRequest();
		
		// 2. readystatechange 이벤트핸들러 바인딩
		xhr.onreadystatechange = readyStateChangeHandler;
		
		// 3. open
		xhr.open("POST", "<%= request.getContextPath() %>/js");
		xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded;'); // POST 전용설정
		
		// 4. send
		xhr.send(`username=\${username.value}&email=\${email.value}`);
	};
	
	
	const submitGet = () => {
		// console.log(XMLHttpRequest);
		// console.log(new XMLHttpRequest());
		
		// 1. XMLHttpRequest객체 생성
		xhr = new XMLHttpRequest();
		
		// 2. 핸들러 readystatechange
		xhr.onreadystatechange = readyStateChangeHandler;
		
		// 3. open
		xhr.open("GET", `<%= request.getContextPath() %>/js?username=\${username.value}&email=\${email.value}`);
		
		// 4. send - message body에 작성될 내용
		xhr.send(null);
		
		
		
	};
	
	const readyStateChangeHandler = (e) => {
		switch(xhr.readyState){
		case 1 : console.log("readyState 1 : loading"); break; 		// open이후 send호출전
		case 2 : console.log("readyState 2 : loaded"); break; 		// send호출
		case 3 : console.log("readyState 3 : interactive"); break;	// 응답도착 시작
		case 4 : 
			console.log("readyState 4 : completed");	// 응답도착 완료
			if(xhr.status == 200) {
				console.log('요청처리 성공!');
				console.log(xhr.responseText); // 응답데이터
				
				target.innerHTML = xhr.responseText;
			}
			else {
				console.log('요청처리 실패!');
				console.log(xhr.status); 
			}
			
		}
	};
	</script>

</body>
</html>