package com.sh.mvc.board.model.service;

import static com.sh.mvc.common.JdbcTemplate.*;

import java.sql.Connection;
import java.util.List;
import java.util.Map;


import com.sh.mvc.board.model.dao.BoardDao;
import com.sh.mvc.board.model.dto.Board;

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

	
}
