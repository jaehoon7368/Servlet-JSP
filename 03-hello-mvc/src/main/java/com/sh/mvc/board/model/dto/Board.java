package com.sh.mvc.board.model.dto;

import java.sql.Date;

/**
 * 
 * BoardEntity에 확장된 속성/기능을 추가하는 클래스
 *
 */
public class Board extends BoardEntity {
	
	private int attachCnt;

	public Board() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Board(int no, String title, String writer, String content, int readCount, Date regDate, int attachCnt) {
		super(no, title, writer, content, readCount, regDate);
		this.attachCnt = attachCnt;
	}

	public int getAttachCnt() {
		return attachCnt;
	}

	public void setAttachCnt(int attachCnt) {
		this.attachCnt = attachCnt;
	}

	@Override
	public String toString() {
		return "Board [attachCnt=" + attachCnt + ", toString()=" + super.toString() + "]";
	}
	
	
	
	
	
}
