package com.sh.mvc.member.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sh.mvc.member.model.dto.Gender;
import com.sh.mvc.member.model.dto.Member;
import com.sh.mvc.member.model.service.MemberService;

/**
 * Servlet implementation class MemberUpdateServlet
 */
@WebServlet("/member/memberUpdate")
public class MemberUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private MemberService memberService = new MemberService();

	/**
	 * sql 
	 * 
	 *
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		try {
			// 1. 인코딩처리
			request.setCharacterEncoding("utf-8");
			
			// 2. 사용자입력값 -> member
			String memberId = request.getParameter("memberId");
			String memberName = request.getParameter("memberName");
			String _birthday = request.getParameter("birthday"); // "" "1988-08-08"
			String email = request.getParameter("email");
			String phone = request.getParameter("phone");
			String _gender = request.getParameter("gender");
			String[] _hobby = request.getParameterValues("hobby");
			
			// 후처리
			Date birthday = !"".equals(_birthday) ? Date.valueOf(_birthday) : null;
			Gender gender = _gender != null ? Gender.valueOf(_gender) : null;
			String hobby = _hobby != null ? String.join(",", _hobby) : null;
			
			Member member = new Member(memberId, null, memberName, null, gender, birthday, email, phone, hobby, 0, null);
			System.out.println(member);
			
			// 3. 업무로직 - db update
			int result = memberService.updateMember(member);
			System.out.println("result = " + result);
			
			
			
			if(result > 0) {
				session.setAttribute("msg", "회원 정보를 성공적으로 수정했습니다.");
				
				// 세션정보도 갱신
				session.setAttribute("loginMember", memberService.selectOneMember(memberId));
				
			}
			
		} catch (Exception e) {
			session.setAttribute("msg", "회원 정보 수정중 오류가 발생했습니다.");
			e.printStackTrace();
		}
		
		// 4. 리다이렉트 - /member/memberView
		response.sendRedirect(request.getContextPath() + "/member/memberView");
		
		
		
	}

}
