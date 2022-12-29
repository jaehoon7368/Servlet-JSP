package com.sh.mvc.member.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sh.mvc.member.common.HelloMvcUtils;
import com.sh.mvc.member.model.dto.Member;
import com.sh.mvc.member.model.service.MemberService;

/**
 * Servlet implementation class MemberUpdateServlet
 */
@WebServlet("/member/updatePassword")
public class MemberUpdatePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private MemberService memberService = new MemberService();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/views/member/updatePassword.jsp")
			.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		
			// 1. 사용자입력값 가져오기
			Member loginMember = (Member)session.getAttribute("loginMember");
			
			String memberId = loginMember.getMemberId();
			String loginPassword = loginMember.getPassword();
			String oldPassword = HelloMvcUtils.getEncryptedPassword(request.getParameter("oldPassword"), memberId);
			String newPassword = HelloMvcUtils.getEncryptedPassword(request.getParameter("newPassword"), memberId);
			System.out.println("loginPassword = " + loginPassword);
			System.out.println("oldPassword = " + oldPassword);
			System.out.println("newPassword = " + newPassword);
			
			
			//2. 기존비밀번호 일치여부 검사
			//db에 있는 비밀번호와 비교 / session의 비밀번호와 비교
			boolean passed = (oldPassword.equals(loginPassword)); //기존비밀번호가 일치하는가
			//3. 업무로직
			if(passed) {
				//신규비밀번호 업데이트 :update ... 
				int result = memberService.updatePassword(memberId,newPassword);
				
				if(result > 0) {
					//비밀번호 성공 메세지 & 리다이렉트 /member/memberView
					session.setAttribute("msg", "비밀번호 변경이 성공하였습니다.");
					
					//4. 세션의 정보는 db의 정보 일치하는가?
					session.setAttribute("loginMember", memberService.selectOneMember(memberId));
					
					response.sendRedirect(request.getContextPath() +"/member/memberView");	
				}
				else {
					session.setAttribute("msg", "비밀번호 변경이 실패하였습니다.");
				}
			}
			else {
				//기존비밀번호 틀림 메세지 & 리다이렉트 /member/updatePassword
				session.setAttribute("msg", "기존 비밀번호가 다릅니다.");
				response.sendRedirect(request.getContextPath() +"/member/updatePassword");				
			}	
				
	}

}
