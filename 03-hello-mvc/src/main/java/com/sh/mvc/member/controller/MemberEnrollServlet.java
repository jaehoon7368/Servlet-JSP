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
 * Servlet implementation class MemberEnrollServlet
 */
@WebServlet("/member/memberEnroll")
public class MemberEnrollServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private MemberService memberService = new MemberService();

	/*
	 * 회원가입 폼페이지 요청
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/views/member/memberEnroll.jsp")
			.forward(request, response);
	}

	/*
	 * 회원가입처리
	 * - db insert
	 * - redirect (url이 남아서 새로고침되지 않도록 index페이지로 리다이렉트)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		
		try {
		//0. 인코딩 처리
		request.setCharacterEncoding("utf-8");
		
		//1. 사용자입력값 가져오기 -> Member객체
		String memberId = request.getParameter("memberId");
		String password = request.getParameter("password");
		String memberName = request.getParameter("memberName");
		String _birthday = request.getParameter("birthday"); //"" "1988-08-08"
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String _gender = request.getParameter("gender");
		String[] _hobby = request.getParameterValues("hobby");
		
		Date birthday = !"".equals(_birthday) ? Date.valueOf(_birthday) : null;
		Gender gender = _gender != null ? Gender.valueOf(_gender) : null;
		String hobby = _hobby != null?  String.join(", ", _hobby) : null;
		
		Member member = new Member(memberId, password, memberName, null, gender, birthday, email, phone, hobby, 0, null);
		System.out.println(member);
		
		
		//2. 업무로직 - db insert
		int result = memberService.insertMember(member);
		
		//3. 사용자 피드백 준비
		//HttpSession session = request.getSession(true);
		
		if(result > 0) {
			//회원가입성공 메세지
			session.setAttribute("msg", "회원가입 축하드립니다.");
			
		}
	
		//4. 리다이렉트 - /mvc/
		response.sendRedirect(request.getContextPath() + "/");
		}catch(Exception e) {
			//회원가입실패 메세지
			session.setAttribute("msg", "회원가입 실패했습니다.");
			//예외로깅
			e.printStackTrace();
		}
	}

}
