package com.sh.ajax.html;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sh.ajax.celeb.dto.Celeb;
import com.sh.ajax.celeb.manager.CelebManager;

/**
 * Servlet implementation class HtmlCelebServlet
 */
@WebServlet("/html/celeb")
public class HtmlCelebServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 입력값처리
		
		// 2.업무로직 -- db에가 celeb테이블에서 목록 조회
		List<Celeb> celebList = CelebManager.getInstance().getCelebList();
		System.out.println(celebList);
		
		//3. view단처리 (비동기에는 dml요청시에도 redirect하지 않는다.)
		request.setAttribute("celebList", celebList);
		request.getRequestDispatcher("/WEB-INF/views/html/celeb.jsp")
			.forward(request, response);
	}

}
