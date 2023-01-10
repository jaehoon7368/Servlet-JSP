package com.sh.ajax.js;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class JsServlet
 */
@WebServlet("/js")
public class JsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 사용자입력값처리
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		System.out.println("username = " + username);
		System.out.println("email = " + email);
		
		//2. 업무로직
		
		//3. view단처리 - text,html,json,xml
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter(); //문자기반 응답메세지 출력스트림
		out.append("username은 [" + username + "]이고,email은 [" + email + "]입니다.");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
