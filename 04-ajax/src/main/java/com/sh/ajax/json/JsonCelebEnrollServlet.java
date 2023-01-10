package com.sh.ajax.json;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.oreilly.servlet.multipart.FileRenamePolicy;
import com.sh.ajax.celeb.dto.Celeb;
import com.sh.ajax.celeb.dto.CelebType;
import com.sh.ajax.celeb.manager.CelebManager;

/**
 * Servlet implementation class JsonCelebEnrollServlet
 */
@WebServlet("/json/celeb/enroll")
public class JsonCelebEnrollServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//0.MultipartRequest객체 생성
		String saveDirectory = getServletContext().getRealPath("/images");
		int maxPostSize = 10 * 1024 * 1024; //byte단위
		String encoding = "utf-8";
		FileRenamePolicy policy = new DefaultFileRenamePolicy();
		MultipartRequest multiReq = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, policy);
		
		
		// 1.사용자입력값 처리
		String name = multiReq.getParameter("name");
		CelebType type = CelebType.valueOf(multiReq.getParameter("type"));
		String profile = "default.png";
		if(multiReq.getFile("profile") != null) {
			String filename = multiReq.getFilesystemName("profile");
			System.out.println(filename);
			filename = new String(filename.getBytes(), Charset.forName("utf-8"));
			System.out.println(filename);
			profile = multiReq.getFilesystemName("profile"); //실제 저장된 이름 가져오기
		}
		Celeb celeb = new Celeb(0,name,profile,type);
		System.out.println(celeb);
		
		// 2. 업무로직 : CelebManager#celebList 추가(tomcat이 reload되면 삭제)
		List<Celeb> celebList = CelebManager.getInstance().getCelebList();
		int no = celebList.get(celebList.size()-1).getNo() +1;
		celeb.setNo(no);
		celebList.add(celeb);
		
		// 3. 응답처리 : Map<String,String>처리결과, insert된 celeb객체 반환
		response.setContentType("application/json; charset=utf-8");
		Map<String, Object> map = new HashMap<>();
		map.put("result", "등록성공!");
		map.put("celeb",celeb);
		
		//void com.google.gson.Gson.toJson(Object src, Appendable writer) throws JsonIOException
		new Gson().toJson(map,response.getWriter());
	}

}
