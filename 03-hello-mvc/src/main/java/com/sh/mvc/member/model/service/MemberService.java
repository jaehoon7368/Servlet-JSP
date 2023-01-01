package com.sh.mvc.member.model.service;

import static com.sh.mvc.common.JDBCTemplate.*;

import java.sql.Connection;
import java.util.List;

import com.sh.mvc.member.model.dao.MemberDao;
import com.sh.mvc.member.model.dto.Member;

public class MemberService {
	private MemberDao memberDao = new MemberDao();

	public Member selectOneMember(String memberId) {
		//1. Connection 생성
		Connection conn = getConnection();
		//2. dao 요청(Connection 전달)
		Member member = memberDao.selectOneMember(conn,memberId);
		//3.반환
		close(conn);
		return member;
			
	}
	
	public List<Member> selectAllMember() {
		Connection conn = getConnection();
		List<Member> members = memberDao.selectAllMember(conn);
		close(conn);
		
		return members;
	}

	public int insertMember(Member member) {
		// 1.Connection 생성
		Connection conn = getConnection();
		// 2.dao요청
		int result = 0;
		
		try {
			result = memberDao.insertMember(conn,member);
			commit(conn);
		}catch(Exception e) {
			rollback(conn);
			throw e;
		}finally {
			close(conn);			
		}
		
		return result;
	}

	public int updateMember(Member member) {
		Connection conn = getConnection();
		int result = 0;
		
		try {
			result = memberDao.updateMember(conn,member);
			commit(conn);
		}catch(Exception e) {
			rollback(conn);
			throw e;
		}finally {
			close(conn);
		}
		
		return result;
	}

	public int updatePassword(String memberId, String newPassword) {
		Connection conn = getConnection();
		int result = 0;
		
		try {
			result = memberDao.updatePassword(conn,memberId,newPassword);
			commit(conn);
		} catch (Exception e) {
			rollback(conn);
			throw e;
		}finally {
			close(conn);
		}
		
		return result;
	}

	public int updateMemberRole(String memberId, String memberRole) {
		int result = 0;
		Connection conn = getConnection();
		
		try {
			result = memberDao.updateMemberRole(conn,memberId,memberRole);
			commit(conn);
		} catch (Exception e) {
			rollback(conn);
			throw e;
		}finally {
			close(conn);
		}
		return result;
	}

	public int deleteMember(String memberId) {
		int result = 0;
		Connection conn = getConnection();
		
		try {
			result = memberDao.deleteMember(conn,memberId);
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
