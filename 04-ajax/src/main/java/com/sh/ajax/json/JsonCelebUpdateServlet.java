package com.sh.ajax.json;

import java.io.IOException;
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
 * Servlet implementation class JsonCelebUpdateServlet
 */
@WebServlet("/json/celeb/update")
public class JsonCelebUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String saveDirecory = getServletContext().getRealPath("/images");
		int maxPostSize = 10 * 1024 * 1024;
		String encoding = "utf-8";
		FileRenamePolicy policy = new DefaultFileRenamePolicy();
		MultipartRequest multiReq = new MultipartRequest(request, saveDirecory, maxPostSize, encoding, policy);
		
		//1.사용자입력값 처리
		int no = Integer.parseInt(multiReq.getParameter("no"));
		String name = multiReq.getParameter("name");
		CelebType type = CelebType.valueOf(multiReq.getParameter("type"));
		String profile = "default.png";
		if(multiReq.getFile("profile") != null) {
			profile = multiReq.getFilesystemName("profile");
		}
		Celeb celeb = new Celeb(no,name,profile,type);
		System.out.println(celeb);
		
		//2. 업무로직
		List<Celeb> celebList = CelebManager.getInstance().getCelebList();
		int index = no -1;
		celebList.set(index, celeb);
						
		System.out.println(celebList);
		//3. view단처리
		response.setContentType("application/json; charset=utf-8");
		Map<String, Object> map = new HashMap<>();
		map.put("result", "수정성공!");
		map.put("celebList",celebList);
		
		new Gson().toJson(map,response.getWriter());
	}

}
