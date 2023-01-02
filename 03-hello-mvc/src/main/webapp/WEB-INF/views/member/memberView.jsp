<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="com.sh.mvc.member.model.dto.Gender"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<section id=enroll-container>
	<h2>회원 정보</h2>
	<form name="memberUpdateFrm" method="post" action="<%= request.getContextPath() %>/member/memberView">
		<table>
			<tr>
				<th>아이디<sup>*</sup></th>
				<td>
					<input type="text" name="memberId" id="memberId" value="<%= loginMember.getMemberId() %>" readonly>
				</td>
			</tr>
			<tr>
				<th>이름<sup>*</sup></th>
				<td>	
				<input type="text"  name="memberName" id="memberName" value="<%= loginMember.getMemberName() %>"  required><br>
				</td>
			</tr>
			<tr>
				<th>생년월일</th>
				<td>	
				<input type="date" name="birthday" id="birthday" value="<%= loginMember.getBirthday() %>"><br>
				</td>
			</tr> 
			<tr>
				<th>이메일</th>
				<td>	
					<input type="email" placeholder="abc@xyz.com" name="email" id="email" value="<%= loginMember.getEmail() != null ? loginMember.getEmail() : ""%>"><br>
				</td>
			</tr>
			<tr>
				<th>휴대폰<sup>*</sup></th>
				<td>	
					<input type="tel" placeholder="(-없이)01012345678" name="phone" id="phone" maxlength="11" value="<%= loginMember.getPhone() %>" required><br>
				</td>
			</tr>
			<tr>
				<th>포인트</th>
				<td>	
					<input type="text" placeholder="" name="point" id="point" value="<%= loginMember.getPoint() %>" readonly><br>
				</td>
			</tr>
			<tr>
				<th>성별 </th>
				<td>
			       		 <input type="radio" name="gender" id="gender0" value="M" <%= loginMember.getGender() == Gender.M ? "checked" : "" %>>
						 <label for="gender0">남</label>
						 <input type="radio" name="gender" id="gender1" value="F" <%= loginMember.getGender() == Gender.F ? "checked" : "" %> >
						 <label for="gender1">여</label>
				</td>
			</tr>
<%
	String hobby = loginMember.getHobby();
	List<String> hobbyList = null;
	if(hobby != null){
		hobbyList = Arrays.asList((hobby.split(",")));
	}
%>
			<tr>
				<th>취미 </th>
				<td>
					<input type="checkbox" name="hobby" id="hobby0" value="운동" <%= hobbyList != null && hobbyList.contains("운동") ? "checked" : "" %> ><label for="hobby0">운동</label>
					<input type="checkbox" name="hobby" id="hobby1" value="등산" <%= hobbyList != null && hobbyList.contains("등산") ? "checked" : "" %> ><label for="hobby1">등산</label>
					<input type="checkbox" name="hobby" id="hobby2" value="독서" <%= hobbyList != null && hobbyList.contains("독서") ? "checked" : "" %> ><label for="hobby2">독서</label><br />
					<input type="checkbox" name="hobby" id="hobby3" value="게임" <%= hobbyList != null && hobbyList.contains("게임") ? "checked" : "" %> ><label for="hobby3">게임</label>
					<input type="checkbox" name="hobby" id="hobby4" value="여행" <%= hobbyList != null && hobbyList.contains("여행") ? "checked" : "" %> ><label for="hobby4">여행</label><br />


				</td>
			</tr>
		</table>
        <input type="submit" value="정보수정"/>
        <input type="button" value="비밀번호변경"  onclick="updatePassword();"/>
        <input type="button" onclick="deleteMember();" value="탈퇴"/>
	</form>
<form action="<%= request.getContextPath() %>/member/deleteMember" name="deleteMemberFrm" method = "post"></form>
</section>
<script>
/*
 * 기존비밀번호입력
 * 새비밀번호/비밀번호 확인
 * 
 * 기존비밀번호가 일치하면, 새비밀번호 업데이트
 * 기존비밀번호가 일치하지 않으면, 새비밀번호 업데이트 취소
 *
 * GET / mvc/member/updatePassword 비밀번호 변경폼 요청
 * POST mvc/member/updatePassword db비밀번호 변경 요청
 */
const updatePassword = () =>{
	location.href = "<%= request.getContextPath() %>/member/updatePassword";
};

const deleteMember = () =>{
	if(confirm("회원님 탈퇴하시겠습니까?")){
		const frm = document.deleteMemberFrm;
		frm.submit();
	}
};

window.addEventListener('load', () => {
	const gender0 = document.querySelector("#gender0");
	const gender1 = document.querySelector("#gender1");
	const hobbyVal = document.getElementsByName("hobby");
	
	console.log(hobbyVal);
	<%-- const hobby = "<%=loginMember.getHobby()%>";
	const hobbies = hobby.split(",");
	 --%>
<%
	String gender = loginMember.getGender().name();


	switch(gender){
		case "M" : %> gender0.checked = true; <%break;
		case "F" : %> gender1.checked = true; <%break;
	};
%>
	/* for(let i = 0; i < hobbyVal.length;i++){
		console.log(hobbyVal[i].value);
		for(let j = 0; j < hobbies.length;j++){
			console.log("hobbies = " + hobbies[j]);
		if(hobbyVal[i].value == hobbies[j])
			hobbyVal[i].checked = true;
			
		}
	} */
	
});
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
