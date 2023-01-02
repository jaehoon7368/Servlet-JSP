package com.sh.mvc.member.model.dao;

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

import com.sh.mvc.member.model.dto.Gender;
import com.sh.mvc.member.model.dto.Member;
import com.sh.mvc.member.model.dto.MemberRole;
import com.sh.mvc.member.model.exception.MemberException;

public class MemberDao {
	
	private Properties prop = new Properties();
	
	public MemberDao() {
		String path = MemberDao.class.getResource("/sql/member/member-query.properties").getPath();
		try {
			prop.load(new FileReader(path));
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println("[query load 완료!] " + prop);
	}

	/**
	 * 한건 조회 - 존재하면 dto객체 반환, 존재하지 않으면 null 반환
	 * 여러건 조회 - 존재하면 List<T> 반환, 존재하지 않으면 비어있는 List<T> 반환
	 * 
	 * 
	 * @param conn
	 * @param memberId
	 * @return
	 */
	public Member selectOneMember(Connection conn, String memberId) {
		String sql = prop.getProperty("selectOneMember");
		Member member = null;
		
		// 1. PreparedStatement 객체 생성 및 미완성쿼리 값대입
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setString(1, memberId);
			
			// 2. pstmt 실행 및 결과반환
			try(ResultSet rset = pstmt.executeQuery()){
				
				// 3. ResultSet -> dto객체 
				while(rset.next()) {
					member = handleMemberResultSet(rset);
				}
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return member;
	}
	
	public List<Member> selectAllMember(Connection conn, Map<String, Object> param) {
		String sql = prop.getProperty("selectAllMember"); // select * from (select row_number() over(order by enroll_date desc) rnum, m.* from member m) where rnum between ? and ?
		List<Member> members = new ArrayList<>();
		int page = (int) param.get("page");
		int limit = (int) param.get("limit");
		int start = (page - 1) * limit + 1; 
		int end = page * limit;
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql);){
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			
			try(ResultSet rset = pstmt.executeQuery();){
				
				while(rset.next()) {
					Member member = handleMemberResultSet(rset);
					members.add(member);
				}
			}
			
			
		} catch (SQLException e) {
			throw new MemberException("관리자 회원목록조회 오류!", e);
		}
				
		return members;
	}

	private Member handleMemberResultSet(ResultSet rset) throws SQLException {
		Member member = new Member();
		member.setMemberId(rset.getString("member_id"));
		member.setPassword(rset.getString("password"));
		member.setMemberName(rset.getString("member_name"));
		member.setMemberRole(MemberRole.valueOf(rset.getString("member_role")));
		member.setGender(rset.getString("gender") != null ? 
							Gender.valueOf(rset.getString("gender")) : 
								null);
		member.setBirthday(rset.getDate("birthday"));
		member.setEmail(rset.getString("email"));
		member.setPhone(rset.getString("phone"));
		member.setHobby(rset.getString("hobby"));
		member.setPoint(rset.getInt("point"));
		member.setEnrollDate(rset.getTimestamp("enroll_date"));
		return member;
	}

	public int insertMember(Connection conn, Member member) {
		String sql = prop.getProperty("insertMember"); // insert into member values (?, ?, ?, default, ?, ?, ?, ?, ?, default, default)
		int result = 0;
		
		// 1. PreparedStatement 생성 및 미완성sql 값대입
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setString(1, member.getMemberId());
			pstmt.setString(2, member.getPassword());
			pstmt.setString(3, member.getMemberName());
			pstmt.setString(4, member.getGender().name());
			pstmt.setDate(5, member.getBirthday());
			pstmt.setString(6, member.getEmail());
			pstmt.setString(7, member.getPhone());
			pstmt.setString(8, member.getHobby());
			
			// 2. 실행 -> int
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			throw new MemberException("회원가입오류", e);
		}
		return result;
	}

	public int updateMember(Connection conn, Member member) {
		// update member set member_name = ?, gender = ?, birthday = ?, email = ?, phone = ?, hobby = ? where member_id = ?
		String sql = prop.getProperty("updateMember");
		int result = 0;
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setString(1, member.getMemberName());
			pstmt.setString(2, member.getGender().name());
			pstmt.setDate(3, member.getBirthday());
			pstmt.setString(4, member.getEmail());
			pstmt.setString(5, member.getPhone());
			pstmt.setString(6, member.getHobby());
			pstmt.setString(7, member.getMemberId());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			throw new MemberException("회원정보 수정 오류", e);
		}
		
		return result;
	}

	public int updatePassword(Connection conn, Member member) {
		int result = 0;
		String sql = prop.getProperty("updatePassword");

		try (PreparedStatement pstmt = conn.prepareStatement(sql);){
			pstmt.setString(1, member.getPassword());
			pstmt.setString(2, member.getMemberId());

			result = pstmt.executeUpdate();

		} catch (SQLException e) {
			throw new MemberException("비밀번호 수정 오류!", e);
		}

		return result;
	}

	public int updateMemberRole(Connection conn, String memberId, String memberRole) {
		String sql = prop.getProperty("updateMemberRole");
		int result = 0;
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setString(1, memberRole);
			pstmt.setString(2, memberId);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			throw new MemberException("관리자 회원권한수정 오류", e);
		}
		
		return result;
	}

	public int deleteMember(Connection conn, String memberId) {
		int result = 0;
		String sql = prop.getProperty("deleteMember");

		try(PreparedStatement pstmt = conn.prepareStatement(sql);){
			pstmt.setString(1, memberId);
			result = pstmt.executeUpdate();

		} catch (SQLException e) {
			throw new MemberException("회원탈퇴 오류", e);
		}

		return result;
	}

	public List<Member> searchMember(Connection conn, Map<String, String> param) {
		List<Member> members = new ArrayList<>();
		String searchType = param.get("searchType"); // member_id | member_name | gender
		String searchKeyword = param.get("searchKeyword");
		String sql = prop.getProperty("searchMember"); // select * from member where # like ?
		sql = sql.replace("#", searchType);
		System.out.println(sql);
		
		// 1. PreaparedStatement 객체 생성 & 미완성쿼리 값대입
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setString(1, "%" + searchKeyword + "%"); 
			// 2. 실행 & ResultSet 반환
			try(ResultSet rset = pstmt.executeQuery()){				
				// 3. ResultSet -> List<Member>
				while(rset.next())
					members.add(handleMemberResultSet(rset));
			}
		} catch (SQLException e) {
			throw new MemberException("관리자 회원검색 오류", e);
		}
	
		
		
		return members;
	}

	public int selectTotalCount(Connection conn) {
		String sql = prop.getProperty("selectTotalCount"); // select count(*) from member
		int totalCount = 0;
		
		try(
			PreparedStatement pstmt = conn.prepareStatement(sql);
			ResultSet rset = pstmt.executeQuery();	
		){
			while(rset.next())
				totalCount = rset.getInt(1); // 컬럼인덱스
	
		} catch (SQLException e) {
			throw new MemberException("전체 사용자수 조회 오류", e);
		}	
		
		return totalCount;
	}


}










