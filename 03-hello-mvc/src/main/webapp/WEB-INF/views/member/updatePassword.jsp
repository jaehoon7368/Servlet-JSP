<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

	<section id=enroll-container>
		<h2>비밀번호 변경</h2>
		<form 
			name="passwordUpdateFrm" 
			method="post" >
			<table>
				<tr>
					<th>현재 비밀번호</th>
					<td><input type="password" name="oldPassword" id="oldPassword" required></td>
				</tr>
				<tr>
					<th>변경할 비밀번호</th>
					<td>
						<input type="password" name="newPassword" id="newPassword" required>
					</td>
				</tr>
				<tr>
					<th>비밀번호 확인</th>
					<td>	
						<input type="password" id="newPasswordCheck" required><br>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center;">
						<input type="submit"  value="변경" />
					</td>
				</tr>
			</table>
		</form>
	</section>
	
<script>
document.passwordUpdateFrm.onsubmit = (e) =>{
	const newPassword = document.querySelector("#newPassword");
	const newPasswordCheck = document.querySelector("#newPasswordCheck");
	if(!/^[A-Za-z0-9!@#$%]{4,}$/.test(newPassword.value)){
		alert("비밀번호는 영문자/숫자/특수문자!@#$%로 구성된 4글자이상이어야합니다.");
		newPassword.select();
		return false;
	}
	
	//비밀번호/비밀번호확인 동일
	if(newPassword.value !== newPasswordCheck.value){
		alert("두 비밀번호가 일치하지 않습니다.");
		newPassword.select();
		return false;
	}
}
</script>
	
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
