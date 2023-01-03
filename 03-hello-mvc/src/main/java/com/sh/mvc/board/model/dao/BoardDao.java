package com.sh.mvc.board.model.dao;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.sh.mvc.board.model.dto.Attachment;
import com.sh.mvc.board.model.dto.Board;
import com.sh.mvc.board.model.dto.BoardEntity;
import com.sh.mvc.board.model.exception.BoardException;
import com.sh.mvc.member.model.dao.MemberDao;
import com.sh.mvc.member.model.dto.Member;
import com.sh.mvc.member.model.exception.MemberException;

public class BoardDao {

	private Properties prop = new Properties();

	public BoardDao() {
		String path = MemberDao.class.getResource("/sql/board/board-query.properties").getPath();
		try {
			prop.load(new FileReader(path));
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println("[board query load 완료!] " + prop);
	}

	public List<Board> boradList(Connection conn, Map<String, Object> param) {
		String sql = prop.getProperty("selectBoardList");
		List<Board> boards = new ArrayList<>();
		int page = (int) param.get("page");
		int limit = (int) param.get("limit");
		int start = (page - 1) * limit + 1; 
		int end = page * limit;
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql);){
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			
			try(ResultSet rset = pstmt.executeQuery();){
				
				while(rset.next()) {
					Board board = new Board();
					board.setNo(rset.getInt("no"));
					board.setTitle(rset.getString("title"));
					board.setWriter(rset.getString("writer"));
					board.setContent(rset.getString("content"));
					board.setReadCount(rset.getInt("read_count"));
					board.setRegDate(rset.getDate("reg_date"));
					board.setAttachCnt(rset.getInt("attach_cnt"));
					boards.add(board);
					
				}
			}
			
			
		} catch (Exception e) {
			throw new BoardException("게시글 목록 조회 오류!", e);
		}
		
		return boards;
	}

	private Board handleBoardResultSet(ResultSet rset) throws SQLException {
		Board board = new Board();
		board.setNo(rset.getInt("no"));
		board.setTitle(rset.getString("title"));
		board.setWriter(rset.getString("writer"));
		board.setContent(rset.getString("content"));
		board.setReadCount(rset.getInt("read_count"));
		board.setRegDate(rset.getDate("reg_date"));
		return board;
		
	}
	
	
	private Attachment handleAttachmentResultSet(ResultSet rset) throws SQLException {
		Attachment attachment = new Attachment();
		attachment.setNo(rset.getInt("no"));
		attachment.setBoardNo(rset.getInt("board_no"));
		attachment.setOriginalFilename(rset.getString("original_filename"));
		attachment.setRenamedFilename(rset.getString("renamed_filename"));
		attachment.setRegDate(rset.getDate("reg_date"));
		return attachment;
		
	}

	public int selectTotalCount(Connection conn) {
		String sql = prop.getProperty("selectTotalCount"); 
		int totalCount = 0;
		
		try(
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rset = pstmt.executeQuery();	
		){
			while(rset.next())
				totalCount = rset.getInt(1); // 컬럼인덱스
	
		} catch (SQLException e) {
			throw new BoardException("전체 게시글수 조회 오류", e);
		}	
		
		return totalCount;
	}

	public int addBoardContent(Connection conn, Board board ) {
		int result = 0;
		String sql = prop.getProperty("insertBoard"); //insert into board(no,title,writer,content) values (seq_board_no.nextval,?,?,?)
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setString(1,board.getTitle());
			pstmt.setString(2, board.getWriter());
			pstmt.setString(3, board.getContent());
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			throw new BoardException("게시글 등록 오류",e);
		}
		return result;
	}

	public int selectLastBoardNo(Connection conn) {
		String sql = prop.getProperty("selectLastBoardNo");
		int boardNo = 0;
		try(
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rset = pstmt.executeQuery();
		){
			if(rset.next())
				boardNo = rset.getInt(1);
			
		} catch (SQLException e) {
			throw new BoardException("게시글번호 조회 오류!", e);
		}
		
		return boardNo;
	}

	public int insertAttachment(Connection conn, Attachment attach) {
		String sql = prop.getProperty("insertAttachment");
		// insert into attachment(no, board_no, original_filename, renamed_filename) values (seq_attachment_no.nextval, ?, ?, ?)
		int result = 0;
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setInt(1, attach.getBoardNo());
			pstmt.setString(2, attach.getOriginalFilename());
			pstmt.setString(3, attach.getRenamedFilename());
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			throw new BoardException("첨부파일 등록 오류!", e);
		}
		
		return result;
	}

	public Board boardView(Connection conn, int no) {
		String sql = prop.getProperty("boardView");
		Board board = null;
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setInt(1, no);
			
			try(ResultSet rset = pstmt.executeQuery()){
				
				while(rset.next()) {
					board = handleBoardResultSet(rset);
				}
			}
		} catch (SQLException e) {
			throw new BoardException("게시글 읽어오기 오류!", e);
		}
		return board;
	}

	public Attachment attachmentView(Connection conn, int no) {
		String sql = prop.getProperty("attachmentView");
		Attachment attachment = null;
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setInt(1, no);
			
			try(ResultSet rset = pstmt.executeQuery()){
				
				while(rset.next()) {
					attachment = handleAttachmentResultSet(rset);
				}
			}
		} catch (SQLException e) {
			throw new BoardException("첨부파일 읽어오기 오류!", e);
		}
		return attachment;
	}
	
	
	
	
}
