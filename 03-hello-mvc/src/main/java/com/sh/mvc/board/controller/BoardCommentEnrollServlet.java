package com.sh.mvc.board.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sh.mvc.board.model.dto.BoardComment;
import com.sh.mvc.board.model.service.BoardService;

/**
 * Servlet implementation class BoardCommentEnrollServlet
 */
@WebServlet("/board/boardCommentEnroll")
public class BoardCommentEnrollServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	BoardService boardService = new BoardService();

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
		//1. 사용자입력값 처리
		int board_no = Integer.parseInt(request.getParameter("boardNo"));
		String writer = request.getParameter("writer");
		int commentLevel = Integer.parseInt(request.getParameter("commentLevel"));
		int commentRef = Integer.parseInt(request.getParameter("commentRef"));
		String content = request.getParameter("content");
		
		BoardComment bc = new BoardComment();
		bc.setBoardNo(board_no);
		bc.setWriter(writer);
		bc.setCommentLevel(commentLevel);
		bc.setCommentRef(commentRef);
		bc.setContent(content);
		System.out.println("bc =" + bc);
		//2. 업무로직 - board_comment 행추가 insert into board_comment values(seq_board_comment_no.nextval,?,?,?,?,?,default)
		//dao에서 comment_ref컬럼값 세팅시, 0이면 setObject를 사용해서 0이면 null을 대입할수 있도록 한다.
		int result = boardService.insertBoardComment(bc);
		
		//3. 리다이렉트 /board/boardView?no=
		response.sendRedirect(request.getContextPath() + "/board/boardView?no=" + bc.getBoardNo());
		}catch (Exception e) {
			e.printStackTrace();
			request.getSession().setAttribute("msg", "댓글 등록중 오류가 발생했습니다.");
		}
		
		
	}

}
