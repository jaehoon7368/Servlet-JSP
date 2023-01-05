package com.sh.mvc.board.model.service;

import static com.sh.mvc.common.JdbcTemplate.close;
import static com.sh.mvc.common.JdbcTemplate.commit;
import static com.sh.mvc.common.JdbcTemplate.getConnection;
import static com.sh.mvc.common.JdbcTemplate.rollback;

import java.sql.Connection;
import java.util.List;
import java.util.Map;

import com.sh.mvc.board.model.dao.BoardDao;
import com.sh.mvc.board.model.dto.Attachment;
import com.sh.mvc.board.model.dto.Board;
import com.sh.mvc.board.model.dto.BoardComment;

public class BoardService {

	private BoardDao boardDao = new BoardDao();

	public List<Board> selectBoardList(Map<String, Object> param) {
		Connection conn = getConnection();
		List<Board> boardList = boardDao.selectBoardList(conn, param);
		close(conn);
		return boardList;
	}

	public int selectTotalCount() {
		Connection conn = getConnection();
		int totalCount = boardDao.selectTotalCount(conn);
		close(conn);
		return totalCount;
	}

	/**
	 * 트랜잭션처리
	 * - 게시글등록
	 * - 첨부파일1등록
	 * - 첨부파일2등록
	 * 
	 * 
	 * @param board
	 * @return
	 */
	public int insertBoard(Board board) {
		Connection conn = getConnection();
		int result = 0;
		try {
			// 게시글등록
			result = boardDao.insertBoard(conn, board);
			
			// 방금 등록된 board.no컬럼값을 조회 - 시퀀스객체의 현재값
			int boardNo = boardDao.selectLastBoardNo(conn); // select seq_board_no.currval from dual
			System.out.println("boardNo = " + boardNo);
			
			board.setNo(boardNo); // 생성된 pk를 board객체에 다시 주입
			
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
		} finally {
			close(conn);
		}
		return result;
	}

	public Board selectOneBoard(int no) {
		return selectOneBoard(no, true);
	}
	
	public Board selectOneBoard(int no, boolean hasRead) {
		Connection conn = getConnection();
		// 조회수 증가 시키기
		if(!hasRead) updateReadCount(no, conn);
		
		Board board = boardDao.selectOneBoard(conn, no);
		List<Attachment> attachments = boardDao.selectAttachmentByBoardNo(conn, no);
		board.setAttachments(attachments);
		close(conn);
		return board;
	}

	private void updateReadCount(int no, Connection conn){
		try {
			int result = boardDao.updateReadCount(conn, no); 
			commit(conn);
		} catch(Exception e) {
			rollback(conn);
			throw e;
		}
	}

	public Attachment selectOneAttachment(int no) {
		Connection conn = getConnection();
		Attachment attach = boardDao.selectOneAttachment(conn, no);
		close(conn);
		return attach;
	}

	public List<Attachment> selectAttachmentByBoardNo(int boardNo) {
		Connection conn = getConnection();
		List<Attachment> attachments = boardDao.selectAttachmentByBoardNo(conn, boardNo);
		close(conn);
		return attachments;
	}

	public int deleteBoard(int no) {
		Connection conn = getConnection();
		int result = 0;
		try {
			// dao요청
			result = boardDao.deleteBoard(conn, no);
			commit(conn);
		} catch (Exception e) {
			rollback(conn);
			throw e;
		} finally {
			close(conn);
		}
		return result;
	}

	public int updateBoard(Board board) {
		Connection conn = getConnection();
		int result = 0;
		try {
			// 게시글등록
			result = boardDao.updateBoard(conn,board);
			
			// 첨부파일 등록
			List<Attachment> attachments = board.getAttachments();
			if(!attachments.isEmpty()) {
				for(Attachment attach : attachments) {
					attach.setBoardNo(board.getNo());
					result = boardDao.insertAttachment(conn, attach);
				}
			}
			
			commit(conn);
		} catch (Exception e) {
			rollback(conn);
			throw e;
		} finally {
			close(conn);
		}
		return result;
	}

	public int deleteAttachment(int attachNo) {
		Connection conn = getConnection();
		int result = 0;
		try {
			result = boardDao.deleteAttachment(conn, attachNo);
			commit(conn);
		} catch (Exception e) {
			rollback(conn);
			throw e;
		}finally {
			close(conn);
		}
		return result;
	}

	public List<BoardComment> selectBoardCommentList(int boardNo) {
		Connection conn = getConnection();
		List<BoardComment> comments = boardDao.selectBoardCommentList(conn,boardNo);
		close(conn);
		return comments;
	}

	public int insertBoardComment(BoardComment bc) {
		Connection conn = getConnection();
		int result = 0;
		try {
			commit(conn);
			result = boardDao.insertBoardComment(conn,bc);
		} catch (Exception e) {
			rollback(conn);
			throw e;
		}finally {
			close(conn);
		}
		return result;
	}

	public int deleteBoardComment(int no) {
		int result = 0;
		Connection conn = getConnection();
		try {
			result = boardDao.deleteBoardComment(conn,no);
			commit(conn);
		} catch (Exception e) {
			rollback(conn);
			throw e;
		}finally {
			close(conn);
		}
		return result;
	}
	
}







