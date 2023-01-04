<%@page import="com.sh.mvc.board.model.dto.Attachment"%>
<%@page import="com.sh.mvc.board.model.dto.Board"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Board board = (Board) request.getAttribute("board");
%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/board.css" />
<section id="board-container">
	<h2>게시판</h2>
	<table id="tbl-board-view">
		<tr>
			<th>글번호</th>
			<td><%= board.getNo() %></td>
		</tr>
		<tr>
			<th>제 목</th>
			<td><%= board.getTitle() %></td>
		</tr>
		<tr>
			<th>작성자</th>
			<td><%= board.getWriter() %></td>
		</tr>
		<tr>
			<th>조회수</th>
			<td><%= board.getReadCount() %></td>
		</tr>
		<% 
			if(!board.getAttachments().isEmpty()) {
				for(Attachment attach : board.getAttachments()){
		%>
		<tr>
			<th>첨부파일</th>
			<td>
				<%-- 첨부파일이 있을경우만, 이미지와 함께 original파일명 표시 --%>
				<img alt="첨부파일" src="<%=request.getContextPath() %>/images/file.png" width=16px>
				<a href="<%= request.getContextPath() %>/board/fileDownload?no=<%= attach.getNo() %>"><%= attach.getOriginalFilename() %></a>
			</td>
		</tr>
		
		<% 
				}
			} 
		%>
		<tr>
			<th>내 용</th>
			<td><%= board.getContent() %></td>
		</tr>
		<% 
			boolean canEdit = loginMember != null && 
								(loginMember.getMemberRole() == MemberRole.A ||
									loginMember.getMemberId().equals(board.getWriter()));
			if(canEdit){
		%>
		<tr>
			<%-- 작성자와 관리자만 마지막행 수정/삭제버튼이 보일수 있게 할 것 --%>
			<th colspan="2">
				<input type="button" value="수정하기" onclick="updateBoard()">
				<input type="button" value="삭제하기" onclick="deleteBoard()">
			</th>
		</tr>
		<% 
			}
		%>
	</table>
</section>

<% if(canEdit){ %>
<form action="<%= request.getContextPath() %>/board/boardDelete" name="boardDeleteFrm" method="POST">
	<input type="hidden" name="no" value="<%= board.getNo() %>" />
</form>
<script>
const updateBoard = () => {
	location.href = "<%= request.getContextPath() %>/board/boardUpdate?no=<%= board.getNo() %>";
};
const deleteBoard = () => {
	if(confirm("정말 게시글을 삭제하겠습니까?")){
		document.boardDeleteFrm.submit();
	}
};
</script>
<% } %>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
