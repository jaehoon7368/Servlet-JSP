<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>xml</title>
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
	<h1>xml</h1>
	<button id="btn1">실행</button>
	<div id="target1">
		<table>
			<thead>
				<tr>
					<th>주제</th>
					<th>제목</th>
					<th>저자</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
	<script>
	document.querySelector("#btn1").addEventListener('click',() =>{
			
		$.ajax({
			url : "<%= request.getContextPath()%>/xml/sample.xml",
			method : "GET",
			dataType : "xml",
			success(data){
				console.log(data); //DOM Tree로 변환해서 전달
				const tbody = document.querySelector("#target1 tbody");
				tbody.innerHTML = ""; //초기화
				
				const root = data.querySelector(":root"); //books
				console.log(root);
				console.log(root.id); //속성명 가져오기
				console.log(root.myattr);
				console.log(root.getAttribute('myattr'));
				
				const books = [...root.children]; //유사배열 -> 찐배열
				console.log(books);
				
				books.forEach((book,index) =>{
					//console.log(book,index);
					//console.log(book.children);
					const [subject,title,author] = book.children;
					tbody.innerHTML += `
						<tr>
							<td>\${subject.textContent}</td>
							<td>\${title.textContent}</td>
							<td>\${author.textContent}</td>
						</tr>
					`;
				});
			},
			error : console.log //error호출할때 전달된 인자 모두를 console.log에 전달하며 출력됨 (xhr, textStatus,err)
		});
	});
	</script>
	
	<hr />
	
	<button id="btn2">셀럽</button>
	<div id="target2">
		<table>
			<thead>
				<tr>
					<th>No</th>
					<th>Profile</th>
					<th>Name</th>
					<th>Type</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
	<script>
	document.querySelector("#btn2").addEventListener('click',()=>{
		$.ajax({
			url : "<%=request.getContextPath()%>/xml/celeb",
			method : "GET",
			success(data){
				console.log(data);
				const tbody = document.querySelector("#target2 tbody");
				tbody.innerHTML = "";
				
				const celebs = data.querySelectorAll("celeb");
				console.log(celebs);
				
				celebs.forEach((celeb,index)=>{
					const [no,name,profile,type] = celeb.children;
					tbody.innerHTML += `
						<tr>
							<th>\${no.textContent}</th>
							<th>
								<img src="<%=request.getContextPath()%>/images/\${profile.textContent}" alt="" />
							</th>
							<th>\${name.textContent}</th>
							<th>\${type.textContent}</th>
						</tr>
					`;
				});
				
			},
			error : console.log
		});
	});
	</script>
	
	<hr />
	
	<input type="date" id="date"/>
	<button id="btn3">일별 박스오피스</button>
	<div id="target3">
		<table>
			<thead>
				<tr>
					<th>순위</th>
					<th>영화제목</th>
					<th>누적관객수</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
	<script>
	window.addEventListener('load', () => {
		getDailyBoxOffice();
	});
	
	
	/**
	 * 두자리수 맞추기 함수
	 */
	const f = (n) => n >= 10 ? n : '0' + n;
	
	/**
	 * 페이지로딩시 어제날짜로 조회
	 * 1. 페이지 로딩시 getDailyBoxOffice 호출
	 * 2. 날짜가 세팅되지 않았다면, 기본값을 어제날짜로 처리
	 */
	const getDailyBoxOffice = () => {
		// 1. 날짜 조회
		const date = document.querySelector("#date");
		console.log(date.value);
		
		// 기본값 어제 날짜
		if(!date.value){
			const now = new Date();
			const yesterday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 1); // 어제 날짜
			console.log(yesterday);
			console.log(yesterday.toISOString()); // yyyy-MM-ddThh:mi:ss.SSSZ UTC - KST +09:00
			
			// 지역대 반영된 isoString
			console.log(new Date(yesterday.getTime() + (9 * 60 * 60 * 1000)).toISOString());
			
			
			date.value = `\${yesterday.getFullYear()}-\${f(yesterday.getMonth() + 1)}-\${f(yesterday.getDate())}`;
		}
		
		
		// 2. 영화 api 요청
		const url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml";
		
		$.ajax({
			url : url,
			method : "GET",
			data : {
				key : '5397bef069c00fb3d0aacb578f7cd067',
				targetDt : date.value.replace(/-/g, '')
			},
			success(data){
				console.log(data);
				const tbody = document.querySelector("#target3 tbody");
				tbody.innerHTML = "";
				
				const dailyBoxOffices = data.querySelectorAll("dailyBoxOffice");
				console.log(dailyBoxOffices);
				dailyBoxOffices.forEach((dailyBoxOffice) => {
					const rank = dailyBoxOffice.children[1];
					const movieNm = dailyBoxOffice.children[5];
					const audiAcc = dailyBoxOffice.children[15];
					console.log(rank, movieNm, audiAcc);
					
					tbody.innerHTML += `
						<tr>
							<td>\${rank.textContent}</td>
							<td>\${movieNm.textContent}</td>
							<td>\${Math.floor(audiAcc.textContent / 10000)}만</td>
						</tr>
					`;
					
				});
				
			},
			error : console.log
		});
	}
	
	document.querySelector("#btn3").addEventListener('click', () => {
		getDailyBoxOffice();
	});
	
	</script>
	
</body>
</html>