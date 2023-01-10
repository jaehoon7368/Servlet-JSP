package com.sh.ajax.text;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sh.ajax.celeb.dto.Celeb;
import com.sh.ajax.celeb.manager.CelebManager;

/**
 * Servlet implementation class CsvCelebServlet
 */
@WebServlet("/csv/celeb")
public class CsvCelebServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * CSV Comma Separated Value
	 * - "1,2,3,4,5"
	 * - 
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1.사용자입력값 처리
		
		//2. 업무로직
		List<Celeb> celebList = CelebManager.getInstance().getCelebList();
		
		//csv 데이터 생성
		StringBuilder csv = new StringBuilder();
		for(int i = 0; i < celebList.size();i++) {
			//1. 양세찬,양세찬.jpg,Comedian
			//2. 김고은,김고은.jpg,Actor
			Celeb c = celebList.get(i);
			csv.append(c.getNo() + "," + c.getName() + "," + c.getProfile() + "," + c.getType());
			if(i < celebList.size() -1)
				csv.append("\n");
		}
		System.out.println(csv);
		
		//3. view단처리 - csv데이터를 직접 출력
		response.setContentType("text/csv; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.append(csv);
	}

}
