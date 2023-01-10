package com.sh.ajax.celeb.manager;

import java.util.ArrayList;
import java.util.List;

import com.sh.ajax.celeb.dto.Celeb;
import com.sh.ajax.celeb.dto.CelebType;

/*
 * 싱글턴 패턴 Singletone Pattern
 * - 프로그램 운영중에 딱 하나의 객체만 가지고 사용하는 것.
 * 
 * 1.private 생성자
 * 2. 객체 getter 역할을 하는 static method 제공
 * 3. 현재객체를 담은 static필드를 재사용
 */
public class CelebManager {
	
	private static CelebManager INSTANCE;
	
	private List<Celeb> celebList = new ArrayList<>();
	
	private CelebManager() {
		//클래스 외부에서는 생성자를 호출할 수 없음.
		celebList.add(new Celeb(1,"양세찬","양세찬.jpg",CelebType.COMEDIAN));
		celebList.add(new Celeb(2,"김고은","김고은.jpg",CelebType.ACTOR));
		celebList.add(new Celeb(3,"아이유","아이유.png",CelebType.SINGER));
		celebList.add(new Celeb(4,"조정석","조정석.png",CelebType.ACTOR));
		celebList.add(new Celeb(5,"강동원","강동원.jpg",CelebType.ACTOR));
		
	}
	
	public static CelebManager getInstance() {
		if(INSTANCE == null)
			INSTANCE = new CelebManager();
		return INSTANCE;
	}

	public List<Celeb> getCelebList() {
		return this.celebList;
	}
}
