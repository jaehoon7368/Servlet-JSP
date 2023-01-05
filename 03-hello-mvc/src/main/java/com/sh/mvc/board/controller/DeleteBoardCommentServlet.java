package com.sh.mvc.board.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sh.mvc.board.model.service.BoardService;

/**
 * Servlet implementation class DeleteBoardCommentServlet
 */
@WebServlet("/board/boardCommentDelete")
public class DeleteBoardCommentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BoardService boardService= new BoardService();

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			int boardNo = Integer.parseInt(request.getParameter("deleteBoardNo"));
			int no = Integer.parseInt(request.getParameter("deleteNo"));
			System.out.println("no = " + no);
		
			int result = boardService.deleteBoardComment(no);
		
			response.sendRedirect(request.getContextPath() + "/board/boardView?no=" + boardNo);
		}catch(Exception e) {
			e.printStackTrace();
			request.getSession().setAttribute("msg", "게시글 댓글 삭제중 오류가 발생했습니다.");
		}
		
	}

}
