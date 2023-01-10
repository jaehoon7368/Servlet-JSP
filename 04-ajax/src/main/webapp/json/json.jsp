<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>json</title>
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
	<h1>json</h1>
	
	<button id="btn1">전체조회</button>
	<div id="target1">
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
	window.addEventListener('load',() =>{
		findAll();
	});
	document.querySelector("#btn1").addEventListener('click',()=>{
		findAll();
	});
	
	const findAll = () =>{
		$.ajax({
			url : "<%= request.getContextPath()%>/json/celeb/findAll",
			dataTpye : "json",
			success(data){
				console.log(data);
				
				//html태그를 문자열이 아닌 js태그객체
				//{} => tr>td+(td>img)+td+td
				const tbody = document.querySelector("#target1 tbody");
				tbody.innerHTML = "";
				
				data.forEach((celeb)=>{
					console.log(celeb);
					
					const tr = document.createElement("tr");
					tr.onclick = (e) =>{
						console.log(e.target); //td, img에서 발생한 click이벤트 발생
						findOne(celeb.no);	
					};
					
					const tdNo = document.createElement("td");
					tdNo.append(celeb.no);// append(Node | Text, ...)
					
					const tdProfile = document.createElement("td");
					const img = document.createElement("img");
					img.src = "<%= request.getContextPath()%>/images/" + celeb.profile;
					tdProfile.append(img);
					
					const tdName = document.createElement("td");
					tdName.append(celeb.name);
					
					const tdType = document.createElement("td");
					tdType.append(celeb.type);
					
					tr.append(tdNo,tdProfile,tdName,tdType);
					tbody.append(tr);
					
				});
				
			},
			error : console.log
		});
	};
	
	const findOne = (no) =>{
		console.log(no);	
		
		$.ajax({
			url : "<%= request.getContextPath()%>/json/celeb/findOne",
			data : {no},
			success(data){
				console.log(data);
				const {no, name, profile, type} = data;
				const frm = document.celebUpdateFrm;
				frm.no.value = no;
				frm.name.value = name;
				frm.type.value = type;
				frm.querySelector("#celeb-update-profile-viewer").src = `<%= request.getContextPath()%>/images/\${profile}`;
			},
			error : console.log
		});
	};
	
	
	</script>
	
	<h2>Celeb 수정</h2>
	<form name="celebUpdateFrm">
        <fieldset>
            <legend>Celeb 수정폼</legend>
            <table>
                <tbody>
                    <tr>
                        <th>
                            <label for="celeb-update-no">No</label>
                        </th>
                        <td>
                            <input type="text" name="no" id="celeb-update-no" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <label for="celeb-update-name">Name</label>
                        </th>
                        <td>
                            <input type="text" name="name" id="celeb-update-name" />
                        </td>
                    </tr>
                     <tr>
				        <th>
				            <label for="celeb-update-profile">Profile</label>
				        </th>
				        <td>
				            <div>
				                <img src="" alt="" id="celeb-update-profile-viewer"/>
				            </div>
				            <input type="file" name="profile" id="celeb-update-profile" />
				        </td>
				    </tr>
                    <tr>
                        <th>
                            <label for="celeb-update-type">Type</label>
                        </th>
                        <td>
                            <select name="type" id="celeb-update-type">
                                <option value="ACTOR">ACTOR</option>
                                <option value="SINGER">SINGER</option>
                                <option value="MODEL">MODEL</option>
                                <option value="COMEDIAN">COMEDIAN</option>
                                <option value="ENTERTAINER">ENTERTAINER</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <button>수정</button>
                        </td>
                    </tr>
                </tbody>
            </table>        
        </fieldset>
    </form>    
   <script>
   document.celebUpdateFrm.addEventListener("submit", (e) => {
	    e.preventDefault(); //폼제출 방지(폼이 제출되면 안된다.)
	   
		const frmData = new FormData(e.target);
		
		$.ajax({
			url : "<%= request.getContextPath() %>/json/celeb/update",
			method : "POST",
			data : frmData,
			dataType : "json",
			contentType : false,
			processData : false,
			success(data){
				console.log(data);
				alert(data.result);
			},
			error : console.log,
			complete(){
				e.target.reset();
				findAll();
			}
		});
	});
   </script>
	
	<br /><br />
	
	<h2>Celeb 등록</h2>
	<form name="celebEnrollFrm">
		<fieldset>
			<legend>Celeb 등록폼</legend>
			<table>
				<tbody>
					<tr>
						<th>
							<label for="celeb-enroll-name">Name</label>
						</th>
						<td>
							<input type="text" name="name" id="celeb-enroll-name" required/>
						</td>
					</tr>
					<tr>
						<th>
							<label for="celeb-enroll-type">Type</label>
						</th>
						<td>
							<select name="type" id="celeb-enroll-type" required>
								<option value="ACTOR">ACTOR</option>
								<option value="SINGER">SINGER</option>
								<option value="MODEL">MODEL</option>
								<option value="COMEDIAN">COMEDIAN</option>
								<option value="ENTERTAINER">ENTERTAINER</option>
							</select>
						</td>
					</tr>
					 <tr>
						<th>
							<label for="celeb-enroll-profile">Profile</label>
						</th>
						<td>
							<input type="file" name="profile" id="celeb-enroll-profile" />
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<button type="submit">등록</button>
						</td>
					</tr>
				</tbody>
			</table>		
		</fieldset>
	</form>
	<script>
	/*
		파일업로드가 포함된 POST 요청
		- FormData객체 사용
		
		- ajax 호출시
		- contentType : false // application/x-www-form-urlencoded 기본값을 사용하지 않음. -> multipart/ form-data 사용
		- processData : false // 전송하는 데이터를 직렬화처리 하지 않음.
	*/
	
	document.celebEnrollFrm.addEventListener("submit",(e)=>{
		e.preventDefault(); //폼제출 방지
		
		//FormData객체 생성
		const frmData = new FormData(e.target);
		
		/* 
		const keys = frmData.keys();
		for(let key of keys){
			console.log(key, frmData.get(key));
		} */
		
		
		//등록 POST
		$.ajax({
			url : "<%= request.getContextPath()%>/json/celeb/enroll",
			method : "post",
			data : frmData,
			dataType : "json",
			contentType : false,
			processData : false,
			success(data){
				console.log(data);
				alert(data.result);
			},
			error : console.log,
			complete(){
				e.target.reset();
			}
		});
		
	});
	</script>
</body>
</html>