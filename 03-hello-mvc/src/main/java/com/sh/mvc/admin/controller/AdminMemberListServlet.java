package com.sh.mvc.admin.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sh.mvc.member.model.dto.Member;
import com.sh.mvc.member.model.service.MemberService;

/**
 * Servlet implementation class AdminMemberListServlet
 */
@WebServlet("/admin/memberList")
public class AdminMemberListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private MemberService memberService = new MemberService();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 사용자입력값 처리
		
		// 2.업무로직 - sql = select * from member order by enroll_date desc
		List<Member> members = memberService.selectAllMember();
		System.out.println(members);
		
		//3. view단 처리
		request.setAttribute("members", members);
		request.getRequestDispatcher("/WEB-INF/views/admin/memberList.jsp")
			.forward(request, response);
	}

}
