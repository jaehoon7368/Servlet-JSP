package com.sh.mvc.admin.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sh.mvc.member.model.service.MemberService;

/**
 * Servlet implementation class AdminUpdateMemberRoleServlet
 */
@WebServlet("/admin/updateMemberRole")
public class AdminUpdateMemberRoleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	MemberService memberService = new MemberService();

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		try {
			//1. 사용자 입력값 가져오기
			String memberId = request.getParameter("memberId");
			String memberRole = request.getParameter("memberRole");
			//2. 업무로직 - sql = update member set member_role = ? where member_id = ?
			int result = memberService.updateMemberRole(memberId,memberRole);
			
			session.setAttribute("msg", "권한이 성공적으로 변경되었습니다.");
			
			
			//3. 리다이렉트
			response.sendRedirect(request.getContextPath() +"/admin/memberList");	
			
		} catch (Exception e) {
			session.setAttribute("msg", "권한변경이 실패하였습니다.");
			e.printStackTrace();
		}
	}

}
