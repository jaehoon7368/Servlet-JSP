package com.sh.mvc.board.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sh.mvc.board.model.dto.Board;
import com.sh.mvc.board.model.service.BoardService;
import com.sh.mvc.common.HelloMvcUtils;

/**
 * Servlet implementation class BoardListServlet
 */
@WebServlet("/board/boardList")
public class BoardListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	BoardService boardService = new BoardService();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		final int limit = 5;
		int page = 1;
		try {
			page = Integer.parseInt(request.getParameter("page"));
		}catch (NumberFormatException e) {
			
		}
		Map<String,Object> param = new HashMap<>();
		param.put("page",page);
		param.put("limit",limit);
		System.out.println("param = " + param);
		
		List<Board> boards = boardService.boardList(param);
		System.out.println(boards);
		
		int totalCount = boardService.selectTotalCount();
		System.out.println("totalCount = " + totalCount);
		String url = request.getRequestURI();
		String pagebar = HelloMvcUtils.getPagebar(page, limit, totalCount, url);
		System.out.println(pagebar);
		
		request.setAttribute("boards", boards);
		request.setAttribute("pagebar", pagebar);
		
		request.getRequestDispatcher("/WEB-INF/views/board/boardList.jsp")
			.forward(request, response);
	}

}
