package com.sh.ajax.xml;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sh.ajax.celeb.dto.Celeb;
import com.sh.ajax.celeb.manager.CelebManager;

/**
 * Servlet implementation class XmlCelebServlet
 */
@WebServlet("/xml/celeb")
public class XmlCelebServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 업무로직
		List<Celeb> celebList = CelebManager.getInstance().getCelebList();
		
		//2. view단처리 - xml처리를 위해 jsp위임
		request.setAttribute("celebList", celebList);
		request.getRequestDispatcher("/WEB-INF/views/xml/celeb.jsp")
			.forward(request, response);
	}

}
