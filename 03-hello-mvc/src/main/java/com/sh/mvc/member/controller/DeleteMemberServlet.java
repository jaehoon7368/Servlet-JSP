package com.sh.mvc.member.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sh.mvc.member.model.dto.Member;
import com.sh.mvc.member.model.service.MemberService;

/**
 * Servlet implementation class DeleteMemberServlet
 */
@WebServlet("/member/deleteMember")
public class DeleteMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	MemberService memberService = new MemberService();

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		try{
			Member loginMember = (Member)session.getAttribute("loginMember");
			
			String memberId = loginMember.getMemberId();
			
			int result = memberService.deleteMember(memberId);
			
			if(result > 0) {
				session.setAttribute("msg", "회원 탈퇴 성공!.");
				
				// 세션정보도 갱신
				session.setAttribute("loginMember", null);
				
			}
			
		} catch (Exception e) {
			session.setAttribute("msg", "회원 탈퇴 실패.");
			e.printStackTrace();
		}
		
		// 4. 리다이렉트 - /member/memberView
		response.sendRedirect(request.getContextPath() + "/");
		
	}

}
