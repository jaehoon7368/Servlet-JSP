package com.sh.ajax.json;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.sh.ajax.celeb.dto.Celeb;
import com.sh.ajax.celeb.manager.CelebManager;

/**
 * Servlet implementation class JsonCelebFindAllServlet
 */
@WebServlet("/json/celeb/findAll")
public class JsonCelebFindAllServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 사용자입력값 처리
		
		// 2. 업무로직 - celeb 목록조회
		List<Celeb> celebList = CelebManager.getInstance().getCelebList();
		// [{"no" : 1, "name" : "양세찬","profile" : "양세찬.jpg", "type : " "Comedian"}]
		
		
		//3. view단 처리 - json문자열을 응답에 직접 출력
		//헤더설정
		response.setContentType("application/json; charset=utf-8");
		
		Gson gson = new Gson();
		String jsonStr = gson.toJson(celebList);
		System.out.println(jsonStr);
		
		response.getWriter().append(jsonStr);
		
		
	}

}
