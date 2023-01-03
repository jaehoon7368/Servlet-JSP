package com.sh.mvc.board.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sh.mvc.board.model.dto.Attachment;
import com.sh.mvc.board.model.dto.Board;
import com.sh.mvc.board.model.service.BoardService;

/**
 * Servlet implementation class BoardViewServlet
 */
@WebServlet("/board/boardView")
public class BoardViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	BoardService boardService = new BoardService();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		int no = Integer.parseInt(request.getParameter("no"));
		System.out.println("no = " + no);
		
		Board board = boardService.boardView(no);
		System.out.println(board);
		
		Attachment attachment = boardService.attachmentView(no);
		System.out.println("attachment = " + attachment);
		
		request.setAttribute("board", board);
		request.setAttribute("attachment", attachment);
		
		request.getRequestDispatcher("/WEB-INF/views/board/boardView.jsp")
		.forward(request, response);
	}

}
