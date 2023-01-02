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

import com.sh.mvc.board.model.dto.Board;
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
		String sql = prop.getProperty("boardList");
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
					boards.add(handleBoardResultSet(rset));
				}
			}
			
			
		} catch (Exception e) {
			throw new BoardException("관리자 회원목록조회 오류!", e);
		}
		
		return boards;
	}

	private Board handleBoardResultSet(ResultSet rset) throws SQLException {
		Board board = new Board();
		board.setNo(rset.getInt("no"));
		board.setTitle(rset.getString("title"));
		board.setWriter(rset.getString("writer"));
		board.setRegDate(rset.getDate("reg_date"));
		board.setAttachCnt(rset.getInt("attach_cnt"));
		board.setReadCount(rset.getInt("read_count"));
		
		return board;
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
	
	
	
	
}
