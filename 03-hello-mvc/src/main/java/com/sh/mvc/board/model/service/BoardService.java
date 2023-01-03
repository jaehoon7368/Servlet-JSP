package com.sh.mvc.board.model.service;

import static com.sh.mvc.common.JdbcTemplate.*;

import java.sql.Connection;
import java.util.List;
import java.util.Map;


import com.sh.mvc.board.model.dao.BoardDao;
import com.sh.mvc.board.model.dto.Attachment;
import com.sh.mvc.board.model.dto.Board;
import com.sh.mvc.board.model.dto.BoardEntity;

public class BoardService {
	private BoardDao boardDao = new BoardDao(); 

	public List<Board> boardList(Map<String, Object> param) {
		Connection conn = getConnection();
		List<Board> boards = boardDao.boradList(conn,param);
		close(conn);
		return boards;
	}

	public int selectTotalCount() {
		Connection conn = getConnection();
		int totalCount = boardDao.selectTotalCount(conn);
		close(conn);
		return totalCount;
	}

	/*
	 * 트랜잭션
	 * - 게시글 등록
	 * - 첨부파일1등록
	 * - 첨부파일2등록
	 */
	public int addBoardContent(Board board) {
		int result = 0;
		Connection conn = getConnection();
		try {
			//게시글 등록
			result = boardDao.addBoardContent(conn,board);
			
			//방금등록된 board.no컬럼값을 조회 - 시퀀스객체의 현재값
			int boardNo = boardDao.selectLastBoardNo(conn); // select seq_board_no.currval from dual
			System.out.println("boardNo = " + boardNo);
			
			// 첨부파일 등록
			List<Attachment> attachments = board.getAttachments();
			if(!attachments.isEmpty()) {
				for(Attachment attach : attachments) {
					attach.setBoardNo(boardNo); // fk컬럼값 세팅
					result = boardDao.insertAttachment(conn, attach);
				}
			}
			
			commit(conn);
		} catch (Exception e) {
			rollback(conn);
			throw e;
		}finally {
			close(conn);
		}
		return result;
	}

	public Board boardView(int no) {
		Connection conn = getConnection();
		Board board = boardDao.boardView(conn,no);
		close(conn);
		return board;
	}

	public Attachment attachmentView(int no) {
		Connection conn = getConnection();
		Attachment attachment = boardDao.attachmentView(conn,no);
		close(conn);
		return attachment;
	}

	

	
}
