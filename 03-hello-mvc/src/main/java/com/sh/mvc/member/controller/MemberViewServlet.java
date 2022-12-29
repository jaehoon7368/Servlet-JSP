package com.sh.mvc.member.controller;

import java.io.IOException;
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
 * Servlet implementation class MemberView
 */
@WebServlet("/member/memberView")
public class MemberViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private MemberService memberService = new MemberService();
       

	/**
	 * 
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/views/member/memberView.jsp")
			.forward(request, response);
	}

	/**
	 * 
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		
		try {
			//0.인코딩 처리
			request.setCharacterEncoding("utf-8");
			
			//1.사용자입력값 가져오기
			String memberId = request.getParameter("memberId");
			String password = request.getParameter("password");
			String memberName = request.getParameter("memberName");
			String _birthday = request.getParameter("birthday");
			String email = request.getParameter("email");
			String phone = request.getParameter("phone");
			String _gender = request.getParameter("gender");
			String[] _hobby = request.getParameterValues("hobby");
			
			Date birthday = !"".equals(_birthday) ? Date.valueOf(_birthday) : null;
			Gender gender = _gender != null ? Gender.valueOf(_gender) : null;
			String hobby = _hobby != null?  String.join(",", _hobby) : null;
			
			Member member = new Member(memberId, password, memberName, null, gender, birthday, email, phone, hobby, 0, null);
			System.out.println(member);
			
			int result = memberService.updateMember(member);
			
			if(result > 0) {
				session.setAttribute("msg", "회원정보가 수정되었습니다.");

				// 세션정보 갱신
				session.setAttribute("loginMember", memberService.selectOneMember(memberId));
			}
			
			
			
			
		}catch(Exception e) {
			session.setAttribute("msg", "회원정보 수정이 실패하였습니다.");
			e.printStackTrace();
		}
		
		response.sendRedirect(request.getContextPath() +"/member/memberView"); 
		
	}

}
