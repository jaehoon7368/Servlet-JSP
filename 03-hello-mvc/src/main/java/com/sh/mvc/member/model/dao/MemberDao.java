package com.sh.mvc.member.model.dao;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("[query load 완료]" + prop);
	}

	/*
	 * 한건조회 - 존재하면 dto객체 반환, 존재하지 않으면 null 반환
	 * 여러건 조회 - 존재하면 List<T> 반환, 존재하지 않으면 비어있는 List<T>반환
	 */
	public Member selectOneMember(Connection conn, String memberId) {
		String sql = prop.getProperty("selectOneMember");
		Member member = null;
		
		//1. PreparedStatement 객체 생성 및 미완성쿼리 대입
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setString(1, memberId);
			
			//2. pstmt 실행 및 결과반환
			try(ResultSet rset = pstmt.executeQuery()){
				
				//3. ResultSet -> dto객체
				while(rset.next()) {
					member = new Member();
					member.setMemberId(memberId);
					member.setPassword(rset.getString("password"));
					member.setMemberName(rset.getString("member_name"));
					member.setMemberRole(MemberRole.valueOf(rset.getString("member_role"))); //"U" -> MemberRole.U, "A" -> MemberRole.A
					member.setGender(Gender.valueOf(rset.getString("gender"))); //"M" -> Gender.M, "F" -> Gender.F
					member.setBirthday(rset.getDate("birthday"));
					member.setEmail(rset.getString("email"));
					member.setPhone(rset.getString("phone"));
					member.setHobby(rset.getString("hobby"));
					member.setPoint(rset.getInt("point"));
					member.setEnrollDate(rset.getTimestamp("enroll_date"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return member;
	}

	public int insertMember(Connection conn, Member member) {
		String sql = prop.getProperty("insertMember");
		int result = 0;
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setString(1, member.getMemberId());
			pstmt.setString(2, member.getPassword());
			pstmt.setString(3, member.getMemberName());
			pstmt.setString(4, member.getGender().name());
			pstmt.setDate(5, member.getBirthday());
			pstmt.setString(6, member.getEmail());
			pstmt.setString(7, member.getPhone());
			pstmt.setString(8, member.getHobby());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			throw new MemberException("회원가입오류",e);
		}
		
		return result;
	}

	public int updateMember(Connection conn, Member member) {
		String sql = prop.getProperty("updateMember");
		int result = 0;
		
		try(PreparedStatement pstmt = conn.prepareStatement(sql)){
			pstmt.setString(1, member.getMemberName());
			pstmt.setDate(2, member.getBirthday());
			pstmt.setString(3, member.getEmail());
			pstmt.setString(4, member.getPhone());
			pstmt.setString(5, member.getGender().name());
			pstmt.setString(6, member.getHobby());
			pstmt.setString(7, member.getMemberId());

			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			throw new MemberException("회원정보수정오류",e);
		}
		
		return result;
	}

}
