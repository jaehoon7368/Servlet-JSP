package com.sh.mvc.board.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.FileRenamePolicy;
import com.sh.mvc.board.model.dto.Attachment;
import com.sh.mvc.board.model.dto.Board;
import com.sh.mvc.board.model.service.BoardService;
import com.sh.mvc.common.HelloMvcFileRenamePolicy;

/**
 * Servlet implementation class BoardUpdateServlet
 */
@WebServlet("/board/boardUpdate")
public class BoardUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BoardService boardService = new BoardService();
	int no;
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 사용자입력 처리
		no = Integer.parseInt(request.getParameter("no"));
		System.out.println("no = " + no);
		
		// 2. 업무로직
		Board board = boardService.selectOneBoard(no);
		System.out.println("board = " + board);
		
		// 3. view단 처리
		request.setAttribute("board", board);
		request.getRequestDispatcher("/WEB-INF/views/board/boardUpdate.jsp").forward(request, response);
	}

	/**
	 * 첨부파일이 포함된 게시물 수정
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			// 0. MultipartRequest객체 생성 - 요청메세지에서 파일을 읽어(Input), 서버컴퓨터에 저장(Output)까지 처리
			String saveDirectory = getServletContext().getRealPath("/upload/board"); // 웹루트디렉토리(src/main/webapp)부터 탐색
			System.out.println(saveDirectory);
			
			int maxPostSize = 10 * 1024 * 1024; // byte단위 : 1kb-1024, 1mb-1024*1kb
			
			String encoding = "utf-8";
			
			FileRenamePolicy policy = new HelloMvcFileRenamePolicy(); // 년월일_시분초밀리초_난수.txt 
			
			// MultipartRequest(HttpServletRequest request, String saveDirectory, int maxPostSize, String encoding, FileRenamePolicy policy)
			MultipartRequest multiReq = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, policy);
		
			
			// 1. 사용자입력값 처리 - request가 아닌 MultipartRequest에서 값 꺼내기
			String title = multiReq.getParameter("title");
			String content = multiReq.getParameter("content");
			
			Board board = new Board();
			board.setNo(no);
			board.setTitle(title);
			board.setContent(content);
			
			// 업로드한 파일처리
			if(multiReq.getFile("upFile1") != null) {
				Attachment attach = new Attachment();
				attach.setOriginalFilename(multiReq.getOriginalFileName("upFile1"));
				attach.setRenamedFilename(multiReq.getFilesystemName("upFile1"));
				board.addAttachment(attach);
			}
			
			if(multiReq.getFile("upFile2") != null) {
				Attachment attach = new Attachment();
				attach.setOriginalFilename(multiReq.getOriginalFileName("upFile2"));
				attach.setRenamedFilename(multiReq.getFilesystemName("upFile2"));
				board.addAttachment(attach);
			}
			System.out.println(board);
			
			// 2. 업무로직 insert into board (no, title, writer, content) values (seq_board_no.nextval, ?, ?, ?)
			int result = boardService.updateBoard(board);

			// 3. 리다이렉트
			request.getSession().setAttribute("msg", "게시글 수정 완료!.");
			response.sendRedirect(request.getContextPath() + "/board/boardList");
			
		} catch (Exception e) {
			e.printStackTrace();
			request.getSession().setAttribute("msg", "게시글 수정중 오류가 발생했습니다.");
		}
		
		
	}

}
