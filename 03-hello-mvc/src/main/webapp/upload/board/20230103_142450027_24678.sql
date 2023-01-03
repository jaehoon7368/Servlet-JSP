--=========================================================
-- chun실습문제
--=========================================================
select * from tb_department; --학과테이블
select * from tb_student; --학생테이블
select * from tb_professor; --교수테이블
select * from tb_class; --과목테이블
select * from tb_class_professor; --과목-교수테이블
select * from tb_grade; --학점테이블


-- 1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열" 으로 표시하도록 한다.

select
    department_name 학과명,
    category 계열
from
    tb_department;
    
-- 2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.

select
    department_name || '의 정원은 ' || capacity || '명입니다.'
from
    tb_department;
    
-- 3. "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어왔다. 누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)

select
    student_name
from
    tb_student
where
    department_no = 001
    and
    substr(student_ssn,8,1) in ('2','4')
    and
    absence_yn = 'Y';

/*
4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오.
    A513079, A513090, A513091, A513110, A513119
*/
select
    student_name
from
    tb_student
where
    student_no in ('A513079','A513090','A513091','A513110','A513119');
    
-- 5. 입학정원이 20 명 이상 30 명 이하인 학과들의 학과 이름과 계열을 출력하시오.

select
    department_name 학과명,
    category 계열
from
    tb_department
where
    capacity >=20 and capacity <=30;
    
-- 6.춘기술대학교는총장을제외하고모든교수들이소속학과를가지고있다. 그럼춘 기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.

select 
    professor_name 
from 
    tb_professor
where
    department_no is null;
    
-- 7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다. 어떠한 SQL 문장을 사용하면 될 것인지 작성하시오.

select
    student_name
from
    tb_student
where
    department_no is null;
    
-- 8. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회해보시오.

select
    class_no
from
    tb_class
where
    preattending_class_no is not null;
    
-- 9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.

select distinct
    category
from
    tb_department;
    
-- 10. 02 학번 전주 거주자들의 모임을 만들려고 한다. 휴학한 사람들은 제외한 재학중인 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오.

select
    student_no,
    student_name,
    student_ssn
from
    tb_student
where
    absence_yn = 'N'
    and
    substr(entrance_date,1,2) = '02'
    and
    substr(student_address,1,2) = '전주';
    
------------------------------------------------------------------------------------------------------------------
/*
 1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른
순으로 표시하는 SQL 문장을 작성하시오.( 단, 헤더는 "학번", "이름", "입학년도" 가
표시되도록 한다.)
*/
select
    student_no 학번,
    student_name 이름,
    entrance_date 입학년도
from
    tb_student
where
    department_no = 002
order by
    entrance_date;
    
/*
2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 핚 명 있다고 핚다. 그 교수의
이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. (* 이때 올바르게 작성핚 SQL
문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)
*/
select
    professor_name,
    professor_ssn
from
    tb_professor
where
    length(professor_name) != 3;
    
/*
3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 단
이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 만드시오. (단, 교수 중
2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 한다. 나이는 ‘만’으로
계산한다.)
*/
select
    professor_name 교수이름,
    (extract(year from sysdate)) - (1900 + substr(professor_ssn,1,2)) 나이
from
    tb_professor
where
    substr(professor_ssn,8,1) = 1
order by
    professor_ssn desc;
    
/*
4. 교수들의 이름 중 성을 제외핚 이름맊 출력하는 SQL 문장을 작성하시오. 출력 헤더는 ‚이름‛ 이 찍히도록 핚다. (성이 2 자인 경우는 교수는 없다고 가정하시오)
*/
select
    nvl(substr(professor_name,2,3),null)
from
    tb_professor;
    
/*
5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 이때, 19 살에 입학하면 재수를 하지 않은 것으로 간주한다.
*/
select
    student_no,
    student_name
from
    tb_student
where
    (extract(year from entrance_date)) - (1900 + substr(student_ssn,1,2)) > 19;
    
/*
6. 2020 년 크리스마스는 무슨 요일인가?
*/
select
    
    to_char(to_date('2020/12/25','yyyy/mm/dd'),'day') 요일
from
    dual;
    
/*
7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD') 은 각각 몇 년 몇
월 몇 일을 의미할까? 또 TO_DATE('99/10/11','RR/MM/DD'),
TO_DATE('49/10/11','RR/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미할까?
*/
select
    to_char(to_date('99/10/11','fmyyyy/ mm/ dd')),
    to_char(to_date('49/10/11','fmyyyy/ mm/ dd')),
    to_char(to_date('99/10/11','fmrrrr/ mm/ dd')),
    to_char(to_date('49/10/11','fmrrrr/ mm/ dd'))
from
    dual;
    
/*
8. 춘 기술대학교의 2000 년도 이후 입학자들은 학번이 A 로 시작하게 되어있다. 2000 년도
이젂 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
*/
select
    student_no,
    student_name
from
    tb_student
where
    substr(student_no,1,1) != 'A';
    
/*
9. 학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 단,
이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한
자리까지만 표시한다.
*/
select
    round((avg(point)*10))/10 평점
from
    tb_grade
where
    student_no = 'A517178';
    
/*
10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 맊들어 결과값이
출력되도록 하시오.
*/
select
    department_no 학과번호,
    count(*) "학생수(명)"
from
    tb_student
group by
    department_no;

/*
11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을
작성하시오.
*/
select
    count(*)
from
    tb_student
where
    coach_professor_no is null;
    
/*
12. 학번이 A112113 인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 단,
이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여
소수점 이하 핚 자리까지맊 표시한다.
*/
select
    substr(term_no,1,4) 년도,
    round((avg(point)*10))/10 "년도 별 평점"
from
    tb_grade
where
    student_no = 'A112113'
group by
    substr(term_no,1,4);
    
/*
13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을
작성하시오.
*/
select
    department_no 학과코드명,
    sum(decode(absence_yn,'Y',1,'N',0)) "휴학생 수"
from
    tb_student
group by
    department_no
order by
    1;
    
/*
14. 춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 핚다. 어떤 SQL
문장을 사용하면 가능하겠는가?
*/
select
    student_name 동일이름,
    count(*) "동명인 수"
from
    tb_student
group by
    student_name
having
    count(*) > 1;
    
/*
15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총
평점을 구하는 SQL 문을 작성하시오. (단, 평점은 소수점 1 자리까지맊 반올림하여
표시한다.)
*/

select * from tb_grade;
select
    nvl(substr(term_no, 1, 4), '총 평점') 년도,
    nvl(substr(term_no, 5), '누적평점') 학기,
    round(avg(point), 1) 평점
from
    tb_grade
where
    student_no = 'A112113'
group by
    rollup(substr(term_no, 1, 4), substr(term_no, 5))
order by
    1, 2;

----------------------------------------------------------------
-- sh계정
-- 1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
select
    to_char(to_date('2020/12/25','yyyy/mm/dd'),'day') 요일
from
    dual;
    
/*
2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
사원명, 주민번호, 부서명, 직급명을 조회하시오.
*/
select
    emp_name 사원명,
    emp_no 주민번호,
    dept_code 부서명,
    job_code 직급명
from
    employee
where
    substr(emp_no,1,1) = '7'
    and substr(emp_no,8,1) in ('2','4')
    and substr(emp_name,1,1) = '전';
    
-- 3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.
select * from employee;
select
    e.emp_id "사번",
    e.emp_name "사원명",
    v.min_age 나이,
    e.dept_code 부서명,
    e.job_code 직급명
    
from
    employee e cross join 
    (select min(extract(year from sysdate) - (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2))) min_age from employee) v
where
    extract(year from sysdate) - (decode(substr(emp_no, 8, 1), '1', 1900, '2', 1900, 2000) + substr(emp_no, 1, 2)) = min_age;
 
-- 4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
select * from employee;
select
    emp_id 사번,
    emp_name 사원명,
    dept_code 부서명
from
    employee
where
    emp_name like '%형%';
    
-- 5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
select * from department;
select
    e.emp_name 사원명,
    j.job_name  직급명,
    e.dept_code 부서코드,
    d.dept_title  부서명
from
    employee e join department d
    on e.dept_code = d.dept_id
    join job j
    on e.job_code = j.job_code
where
    d.location_id in ('L2','L3','L4');

-- 6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
select * from location;
select * from department;
select
    e.emp_name 사원명,
    e.bonus 보너스포인트,
    d.dept_title 부서명,
    l.local_name 근무지역명
from
   employee e join department d
    on e.dept_code = d.dept_id
    join location l
    on d.location_id = l.local_code
where
    e.bonus is not null;
    
-- 7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
select
    e.emp_name 사원명,
    j.job_name 직급명,
    d.dept_title 부서명,
    l.local_name 근무지역명
from
    employee e join department d
    on e.dept_code = d.dept_id
    join location l
    on d.location_id = l.local_code
    join job j
    on e.job_code = j.job_code
where
    e.dept_code = 'D2';
    
/*
8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)
*/
select * from sal_grade;
select
    e.emp_name 사원명,
    j.job_name 직급명,
    e.salary 급여,
    e.salary * 12 연봉
from
    employee e join sal_grade s
    on e.sal_level = s.sal_level
    join job j
    on e.job_code = j.job_code
where
    e.salary > s.max_sal;
    
/*
9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
사원명, 부서명, 지역명, 국가명을 조회하시오.
*/
select * from job;
select
    e.emp_name 사원명,
    d.dept_title 부서명,
    l.local_name 지역명,
    l.national_code 국가명
from
    employee e join department d
    on e.dept_code = d.dept_id
    join location l
    on d.location_id = l.local_code
where
    l.national_code in ('KO','JP');
    
/*
10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
self join 사용
*/
select dept_code from employee;

select
    e.emp_name 사원명,
    e.dept_code 부서코드,
    v.emp_name 동료이름
from
    employee e cross join (select emp_name,dept_code from employee) v
where
    e.dept_code = v.dept_code
    and e.emp_name != v.emp_name;
    
-- 11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
select
    e.emp_name 사원명,
    j.job_name 직급명,
    e.salary 급여
from
    employee e join job j
    on e.job_code = j.job_code
where
    j.job_name in ('차장', '사원')
    and
    e.bonus is null;
    
-- 12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
select * from employee;
select
    sum(decode(quit_yn,'N',1)) 재직중,
    sum(decode(quit_yn,'Y',1)) 퇴사
from
    employee;
--------------------------------------------------------------------------------
/*
--1. 학번, 학생명, 담당교수명을 출력하세요.
--담당교수가 없는 학생은 '없음'으로 표시
*/
select * from tb_student;
select * from tb_professor;
select
    s.student_no 학번,
    s.student_name 학생명,
    nvl(p.professor_name,'없음') 담당교수
    
from
    tb_student s left join tb_professor p
    on s.coach_professor_no = p.professor_no;
    
--2. 학과별 교수명과 인원수를 모두 표시하세요.
select * from tb_department; 
select * from tb_professor;    
select
    decode(grouping(department_name),0,nvl(department_name,'미지정'),1,'총계')학과명,
    decode(grouping(professor_name),0,professor_name,1,count(*))교수명
from
    tb_department d right join tb_professor p
    using(department_no)
group by
    rollup(department_name,professor_name)
order by
    d.department_name;
    
/*
-- 3. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
-- (동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.)
*/
select * from tb_student;
select * from tb_grade;
select
     s.student_name 학생명,
     s.student_no 학번,
     round(avg(point)*100)/100 평균학점
from
    tb_student s join tb_grade g
    on s.student_no = g.student_no
group by
    s.student_name,
    s.student_no
having
    s.student_name like '%람%';
   
--4. 학생별 다음정보를 구하라.
-- (group by 없는 단순 조회)
/*
--------------------------------------------
학생명  학기     과목명    학점
-------------------------------------------
감현제    200702    치과분자약리학    4.5
감현제    200701    구강회복학    4
            .
            .
--------------------------------------------
*/
select * from tb_student;
select * from tb_class; 
select * from tb_grade;
select
    s.student_name 학생명,
    g.term_no 학기,
    c.class_name 과목명,
    g.point 학점
from
    tb_student s join tb_grade g
    on s.student_no = g.student_no
    join tb_class c
    on g.class_no = c.class_no
order by
    1,2;
    
-----------------------------------------------------------------------------
/*
1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고,
정렬은 이름으로 오름차순 표시하도록 한다.
*/
select
    student_name "학생 이름",
    student_address 주소지
from
    tb_student;
    
--2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오
select
    student_name,
    student_ssn
from
    tb_student
where
    absence_yn = 'Y'
order by
    student_ssn desc;
    
/*
3. 주소지가 강원도나 경기도인 학생들 중 1900 년대 학번을 가진 학생들의 이름과 학번,
주소를 이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 "학생이름","학번",
"거주지 주소" 가 출력되도록 핚다.
*/
select
    student_name 학생이름,
    student_no 학번,
    student_address "거주지 주소"
from
    tb_student
where
    (student_address like '%경기_%' or student_address like '%강원_%')
    and substr(student_no,1,1) = '9';
    
/*
4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을
작성하시오. (법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아
내도록 하자)
*/
select * from tb_department;
select
    professor_name,
    professor_ssn
from
    tb_professor
where
    department_no = (select department_no from tb_department where department_name = '법학과')
order by
    professor_ssn asc;
    
/*
5. 2004 년 2 학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 학점이
높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을
작성해보시오.
*/
select * from tb_grade;   
select
    student_no,
    point
from
    tb_grade
where
    term_no = '200402' and class_no = 'C3118100'
order by
    point desc;

/*
6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL
문을 작성하시오.
*/
select
    student_no,
    student_name,
    (select department_name from tb_department where department_no = s.department_no)
from
    tb_student s
order by
    student_name;

--7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
select * from tb_class;
select
    c.class_name,
    d.department_name
from
    tb_class c join tb_department d
    on c.department_no = d.department_no;
    
/*
8. 과목별 교수 이름을 찾으려고 핚다. 과목 이름과 교수 이름을 출력하는 SQL 문을
작성하시오.
*/
select * from tb_class_professor;
select
    (select class_name from tb_class where class_no = p.class_no),
    (select professor_name from tb_professor where professor_no = p.professor_no)
from
    tb_class_professor p;
    
/*
9. 8 번의 결과 중 ‘인문사회’ 계열에 속핚 과목의 교수 이름을 찾으려고 핚다. 이에
해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
*/
select
    c.class_name,
    p.professor_name
from
    tb_class_professor cp join tb_class c
    using(class_no)
    join tb_professor p
    using(professor_no)
where
    p.department_no in (select department_no from tb_department where category = '인문사회');

/*
10. ‘음악학과’ 학생들의 평점을 구하려고 한다. 음악학과 학생들의 "학번", "학생 이름",
"전체 평점"을 출력하는 SQL 문장을 작성하시오. (단, 평점은 소수점 1 자리까지만
반올림하여 표시한다.)
*/
select
    student_no 학번,
    (select student_name from tb_student where student_no = g.student_no) "학생이름",
    round(avg(g.point),1) 전체평점
from
    tb_grade g join tb_class c
    on g.class_no = c.class_no
where
    c.department_no = (select department_no from tb_department where department_name = '음악학과')
group by
    student_no;
    
/*
11. 학번이 A313047 인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기
위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 이때 사용할 SQL 문을
작성하시오. 단, 출력헤더는 ‚학과이름‛, ‚학생이름‛, ‚지도교수이름‛으로
출력되도록 한다.
*/
select
    (select department_name from tb_department where department_no = s.department_no) 학과이름,
    student_name 학생이름,
    (select professor_name from tb_professor where professor_no = s.coach_professor_no) 지도교수이름
from
    tb_student s
where
    student_no = 'A313047';
    
/*
12. 2007 년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기름 표시하는
SQL 문장을 작성하시오.
*/
select
    (select student_name from tb_student where student_no = g.student_no),
    term_no 
from
    tb_grade g
where
    substr(term_no, 1, 4) = '2007'
    and
    class_no = (select class_no from tb_class where class_name = '인간관계론');
    
/*
13. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못핚 과목을 찾아 그 과목
이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
*/
select * from tb_class;
select
    c.class_name,
    (select department_name from tb_department where department_no = c.department_no)
from
    tb_class c left join tb_class_professor cp
    on c.class_no = cp.class_no
    left join tb_professor p
    on cp.professor_no = p.professor_no
where
    cp.professor_no is null
    and
    c.department_no in (select department_no from tb_department where category = '예체능');
    
/*
14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 학생이름과
지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 "지도교수 미지정‛으로
표시하도록 하는 SQL 문을 작성하시오. 단, 출력헤더는 ‚학생이름‛, ‚지도교수‛로
표시하며 고학번 학생이 먼저 표시되도록 한다.
*/
select
    s.student_name 학생이름,
    nvl(p.professor_name,'지도교수 미지정')지도교수
from
    tb_student s left join tb_professor p
    on s.coach_professor_no = p.professor_no
where
    s.department_no = (select department_no from tb_department where department_name = '서반아어학과')
order by
    s.student_no;
    
/*
15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과
이름, 평점을 출력하는 SQL 문을 작성하시오.
*/
with avg_student
as(
    select
        student_no,
        avg(point) avg
    from
        tb_grade
    group by
        student_no
)
select
    s.student_no 학번,
    s.student_name 이름,
    (select department_name from tb_department where department_no = s.department_no) 학과,
    a.avg
from
    tb_student s join avg_student a
    on s.student_no = a.student_no
where
    avg >= 4.0
    and s.absence_yn = 'N';
    
-- 16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.
select
    c.class_no,
    c.class_name,
    avg(g.point)
from
    tb_class c join tb_grade g
    on c.class_no = g.class_no
where
    c.department_no = (select department_no from tb_department where department_name = '환경조경학과')
    and
    c.class_type like '%전공__%'
group by
    c.class_no, c.class_name;
    
/*
17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는
SQL 문을 작성하시오.
*/
select
    student_name,
    student_address
from
    tb_student
where
    department_no = (select department_no from tb_student where student_name = '최경희');
    
/*
18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을
작성하시오.
*/
select
    rownum,
    student_name,
    student_no
from(
    select
        s.student_no,
        s.student_name,
        avg(point)
    from
        tb_student s join tb_grade g
        on s.student_no = g.student_no
    where
        s.department_no = (select department_no from tb_department where department_name = '국어국문학과')
    group by
        s.student_no, s.student_name
    order by
        avg(point) desc
    )
where
    rownum = 1;
    
/*
19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을
파악하기 위한 적절한 SQL 문을 찾아내시오. 단, 출력헤더는 "계열 학과명",
"전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록
한다.
*/
select
    d.department_name "계열 학과명",
    round(avg(g.point), 1) 전공평점
from
    tb_grade g join tb_class c
    on g.class_no = c.class_no
    join tb_department d
    on c.department_no = d.department_no
where
    d.category = (select category from tb_department where department_name = '환경조경학과')
group by
    d.department_name
order by
    d.department_name;
    
--------------------------------------------------------------------
-- DDL
-- 1. 계열 정보를 저장핛 카테고리 테이블을 맊들려고 핚다. 다음과 같은 테이블을
-- 작성하시오.
create table tb_category(
    name varchar2(10),
    use_yn char(1) default 'Y'
);

/*
2. 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
*/
create table tb_class_type(
    no varchar2(5),
    name varchar2(10),
    constraint pk_class_type_name primary key(name)
);

/*
3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY 를 생성하시오.
(KEY 이름을 생성하지 않아도 무방함. 맊일 KEY 이를 지정하고자 핚다면 이름은 본인이
알아서 적당핚 이름을 사용핚다.)
*/
alter table tb_category
add constraint pk_category_name primary key(name);

/*
4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.
*/
alter table tb_category
modify name not null;

/*
5. 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10 으로, 컬럼명이
NAME 인 것은 마찪가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.
*/
alter table 
    tb_class_type
modify
    (no varchar2(10),name varchar2(20));
    
alter table 
    tb_category
modify
    name varchar2(20);
    
/*
6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_ 를 제외한 테이블 이름이 앞에
붙은 형태로 변경한다.
(ex. CATEGORY_NAME)
*/
alter table
    tb_category
rename column use_yn to category_use_yn;

alter table
    tb_category
rename column name to category_name;

alter table
    tb_class_type
rename column no to class_type_no;

alter table
    tb_class_type
rename column name to class_type_name;

/*
7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이
변경하시오.
Primary Key 의 이름은 ‚PK_ + 컬럼이름‛으로 지정하시오. (ex. PK_CATEGORY_NAME )
*/
alter table
    tb_category
rename constraint pk_category_name to pk_category_name;

alter table
    tb_class_type
rename constraint pk_class_type_name to pk_class_type_name;

/*
8. 다음과 같은 INSERT 문을 수행한다.
*/
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT; 

/*
9.TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모
값으로 참조하도록 FOREIGN KEY 를 지정하시오. 이 때 KEY 이름은
FK_테이블이름_컬럼이름으로 지정핚다. (ex. FK_DEPARTMENT_CATEGORY )
*/
alter table
    tb_department
add constraint fk_department_category foreign key(category) references tb_category(category_name);

/*
10. 춘 기술대학교 학생들의 정보맊이 포함되어 있는 학생일반정보 VIEW 를 맊들고자 핚다.
아래 내용을 참고하여 적젃핚 SQL 문을 작성하시오
*/
grant create view to chun;
create or replace view vw_학생일반정보
as
select
    student_no 학번,
    student_name 학생이름,
    student_address 주소
from
    tb_student;
    
/*
11. 춘 기술대학교는 1 년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행핚다.
이를 위해 사용핛 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW 를 맊드시오.
이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오 (단, 이 VIEW 는 단순 SELECT
만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.)
*/
select * from tb_department;
create or replace view vw_지도면담
as
select
    student_name 학생이름,
    (select department_name from tb_department where department_no = s.department_no) 학과이름,
    nvl((select nvl(professor_name,'지도교수없음') from tb_professor where professor_no =s.coach_professor_no),'지도교수없음') 지도교수이름
from
    tb_student s
order by
    학과이름;
    
/*
12. 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW 를 작성해 보자.
*/
create or replace view vw_학과별학생수
as
select
    (select department_name from tb_department where department_no = s.department_no) DEPARTMENT_NAME,
    count(*) STUDENT_COUNT
from
    tb_student s
group by
    department_no
order by
    department_name;
    
/*
13. 위에서 생성핚 학생일반정보 View 를 통해서 학번이 A213046 인 학생의 이름을 본인
이름으로 변경하는 SQL 문을 작성하시오.
*/
select * from vw_학생일반정보;

update
    vw_학생일반정보
set
    학생이름 = '유재훈'
where
    학번 = 'A213046';
    
/*
14. 13 번에서와 같이 VIEW 를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW 를
어떻게 생성해야 하는지 작성하시오.
*/
create or replace view vw_학생일반정보
as
select
    student_no 학번,
    student_name 학생이름,
    student_address 주소
from
    tb_student
with read only;


-- 15.최근 5년은 특정년도를 기술하지 않고, 년도값 추출후 rownum을 이용해 선택함.
--데이터상 최근 5년 2009, 2008, 2007, 2006, 2005
SELECT 년도
FROM (
    SELECT DISTINCT SUBSTR(TERM_NO, 1, 4) 년도
    FROM TB_GRADE
    ORDER BY 1 DESC
    )
WHERE ROWNUM <= 3;

--과목번호, 과목이름 -> tb_class
--수강생수 -> tb_grade

SELECT 
    *
FROM (
        SELECT 
            CLASS_NO 과목번호, 
            CLASS_NAME 과목이름, 
            COUNT(STUDENT_NO) "수강생수(명)"
        FROM TB_CLASS 
            LEFT JOIN TB_GRADE  
                USING (CLASS_NO)
        WHERE 
            SUBSTR(TERM_NO, 1, 4) IN ( 
                                        SELECT 년도
                                        FROM (
                                                SELECT DISTINCT SUBSTR(TERM_NO, 1, 4) 년도
                                                FROM TB_GRADE
                                                ORDER BY 1 DESC
                                            )
                                        WHERE ROWNUM <= 3
                                    )
        GROUP BY CLASS_NO, CLASS_NAME
        ORDER BY 3 DESC, 1)
WHERE ROWNUM <= 3;


------------------------------------------------------------------------------
--DML
/*
1. 과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오
*/
insert into tb_class_type values ('01', '전공필수');
insert into tb_class_type values ('02', '전공선택');
insert into tb_class_type values ('03', '교양필수');
insert into tb_class_type values ('04', '교양선택');
insert into tb_class_type values ('05', '논문지도');

/*
2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생일반정보 테이블을 만들고자 한다.
아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (서브쿼리를 이용하시오)
*/
create table tb_학생일반정보
as(
select
    student_no 학번,
    student_name 학생이름,
    student_address 주소
from
    tb_student);
    
/*
3. 국어국문학과 학생들의 정보만이 포함되어 있는 학과정보 테이블을 만들고자 한다.
아래 내용을 참고하여 적절한 SQL 문을 작성하시오. (힌트 : 방법은 다양함, 소신껏
작성하시오)
*/
select * from tb_student;
create table tb_국어국문학과
as(
select
    student_no 학번,
    student_name 학생이름,
    decode(substr(student_ssn,8,1),'1',1900,'2',1900,2000) + substr(student_ssn,1,2) 출생년도,
    (select professor_name from tb_professor where professor_no = s.coach_professor_no) 교수이름
from
    tb_student s
where
    department_no = (select department_no from tb_department where department_name = '국어국문학과')
);

/*
4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용한 SQL 문을 작성하시오. (단,
반올림을 사용하여 소수점 자릿수는 생기지 않도록 한다)
*/
update
    tb_department
set
    capacity = capacity + round(capacity * 0.1);
    
/*
5. 학번 A413042 인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21 "로 변경되었다고
한다. 주소지를 정정하기 위해 사용할 SQL 문을 작성하시오.
*/
update
    tb_student
set
    student_address = '서울시 종로구 숭인동 181-21'
where
    student_no = 'A413042';
    
/*
6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로
결정하였다. 이 내용을 반영할 적절한 SQL 문장을 작성하시오.
(예. 830530-2124663 ==> 830530 )
*/
update
    tb_student
set
    student_ssn = substr(student_ssn,1,6);
    
/*
7. 의학과 김명훈 학생은 2005 년 1 학기에 자신이 수강한 '피부생리학' 점수가
잘못되었다는 것을 발견하고는 정정을 요청하였다. 담당 교수의 확인 받은 결과 해당
과목의 학점을 3.5 로 변경키로 결정되었다. 적절한 SQL 문을 작성하시오.
*/
update
    tb_grade
set
    point = 3.5
where
    student_no = (
            select 
                student_no
            from
                 tb_student
            where
                student_name = '김명훈'
                and
                department_no = (select department_no from tb_department where department_name = '의학과'))
    and
    class_no = (select class_no from tb_class where class_name = '피부생리학')
    and
    term_no = '200501';
    
/*
8. 성적 테이블(TB_GRADE) 에서 휴학생들의 성적항목을 제거하시오.
*/
delete from
    tb_grade
where
    student_no in (select student_no from tb_student where absence_yn = 'Y');
    
-------------------------------------------------------------------------------
set serveroutput on; --출력 활성화
/*
--1. EX_EMPLOYEE테이블에서 사번 마지막번호를 구한뒤, +1한 사번에 사용자로 부터 입력받은 이름, 주민번호, 전화번호, 직급코드(J5), 급여등급(S5)를
    등록하는 PL/SQL을 작성하세요.
*/
select * from ex_employee;
    
declare
    ex_emp_id ex_employee.emp_id%type;
    ex_emp_name ex_employee.emp_name%type := '&이름';
    ex_emp_no ex_employee.emp_no%type := '&주민번호';
    ex_phone ex_employee.phone%type := '&전화번호';
    ex_job_code ex_employee.job_code%type := 'J5';
    ex_sal_level ex_employee.sal_level%type := 'S5';
begin
    select
        max(emp_id) +1
    into
        ex_emp_id
    from
        ex_employee;
        
    insert into
        ex_employee(emp_id,emp_name,emp_no,phone,job_code,sal_level)
    values
        (ex_emp_id,ex_emp_name,ex_emp_no,ex_phone,ex_job_code,ex_sal_level);
    
    commit;
    
    dbms_output.put_line('사번 : ' || ex_emp_id);
    dbms_output.put_line('이름 : ' || ex_emp_name);
    dbms_output.put_line('주민번호 : ' || ex_emp_no);
    dbms_output.put_line('전화번호 : ' || ex_phone);
    dbms_output.put_line('직급코드 : ' || ex_job_code);
    dbms_output.put_line('급여등급 : ' || ex_sal_level);
    
end;
/


/*
-- 2. 동전 앞뒤맞추기 게임 익명블럭을 작성하세요.
    -- dbms_random.value api 참고해 난수 생성할 것.
*/

declare
    user number := &1_앞_0_뒤;
    com number;
begin
    select
        floor(dbms_random.value(0,2)) --0,1
    into
        com
    from
        dual;
        
    if com = 1 then
        dbms_output.put_line('컴퓨터가 앞을 선택했습니다.');
    elsif com = 0 then
        dbms_output.put_line('컴퓨터가 뒤를 선택했습니다.');
    end if;
    
    if user = 1 then
        dbms_output.put_line('유저가 앞을 선택했습니다.');
    elsif user = 0 then
        dbms_output.put_line('유저가 뒤를 선택했습니다.');
    else
        dbms_output.put_line('앞(1),뒤(0)만 선택 가능합니다.');
    end if;
    
    if user = com then
        dbms_output.put_line('성공!');
    else
        dbms_output.put_line('실패!');
    end if;
end;
/

-------------------------------------------------------------------------------
/*
1. 사번을 입력받고, 관리자에 대한 성과급을 지급하려하는 익명블럭 작성
    - 관리하는 사원이 5명이상은 급여의 15% 지급 : '성과급은 ??원입니다.'
    - 관리하는 사원이 5명미만은 급여의 10% 지급 : ' 성과급은 ??원입니다.'
    - 관리하는 사원이 없는 경우는 '대상자가 아닙니다.'
*/
select * from employee;
select manager_id,count(*) from employee group by manager_id;

declare
    e_emp_id employee.emp_id%type := '&사번';
    cnt_emp_id number;
    e_manager_sal employee.salary%type;
    e_manager_total_sal employee.salary%type;
begin
    select
        manager_id,
        count(*)
    into
        e_emp_id,
        cnt_emp_id
    from
        employee
    where
        manager_id = e_emp_id
    group by
        manager_id;
        
    select
        salary
    into
        e_manager_sal
    from
        employee
    where
        emp_id = e_emp_id;
        
    case
        when cnt_emp_id >= 5 then 
            e_manager_total_sal := e_manager_sal * 1.15;
            dbms_output.put_line('성과급은 ' || e_manager_total_sal || '원입니다.');
       when cnt_emp_id < 5 then 
            e_manager_total_sal := e_manager_sal * 1.1;
            dbms_output.put_line('성과급은 ' || e_manager_total_sal || '원입니다.');
    end case;

exception
    when no_data_found then dbms_output.put_line('대상자가 아닙니다.');
    
end;
/
set serveroutput on; -- 출력 활성화

/*
2. TBL_NUMBER 테이블에 0~99사이의 난수를 100개 저장하고, 입력된 난수의 합계를 출력하는 익명블럭을 작성하세요.

TBL_NUMBER테이블(sh 계정)을 먼저 생성후 작업하세요.
- id number pk : sequence객체 생성후 채번할것.
- num number : 난수
- reg_date date : 기본값 현재시각
*/
create table tbl_number(
    id number,
    num number,
    reg_date date default sysdate,
    constraint pk_tbl_number_id primary key (id)
);

create sequence seq_tbl_number_id
start with 1
increment by 1;

declare
    ran number;
    sum_no number := 0;
begin
    for i in 1..100 loop
            ran := trunc(dbms_random.value(0, 100));
            
            insert into tbl_number values(seq_tbl_number_id.nextval, ran, default);
            
            sum_no := sum_no + ran;

        end loop;
    commit;
    dbms_output.put_line('합계 : '|| sum_no);
    
end;
/
select * from tbl_number;

/*
3.주민번호를 입력받아 나이를 리턴하는 저장함수 fn_age를 사용해서 사번, 이름, 성별, 연봉, 나이를 조회
*/
create or replace function fn_age(
    emp_no employee.emp_no%type
)
return number
is
    age number;
    emp_year number;
begin
    case substr(emp_no,8,1)
        when '1' then emp_year := 1900;
        when '2' then emp_year := 1900;
        else emp_year := 2000;
    end case;
    age := extract(year from sysdate) - emp_year - substr(emp_no,1,2) +1;
    return age;
end;
/

select
    emp_id 사번,
   emp_name 이름,
    fn_gender(emp_no) 성별,
    fn_calc_annual_pay(salary,nvl(bonus,0)) 연봉,
    fn_age(emp_no) 나이
from
    employee;
    
/*
4. 특별상여금을 계산하는 함수 fn_calc_incentive(salary, hire_date)를 생성하고, 사번, 사원명, 입사일, 근무개월수(n년 m월), 특별상여금 조회
* 입사일 기준 10년이상이면, 급여 150%
* 입사일 기준 10년 미만 3년이상이면, 급여 125%
* 입사일 기준 3년미만, 급여 50%
*/
select months_between(sysdate,hire_date) /12 from employee;
create or replace function fn_calc_incentive(
    salary employee.salary%type,
    hire_date employee.hire_date%type
)
return number
is
    fn_year number;
    fn_incentive number;
begin
    fn_year := months_between(sysdate,hire_date) /12;
    
    if fn_year < 3 then fn_incentive := salary *0.5;
    elsif fn_year < 10 then fn_incentive := salary * 1.25;
    elsif fn_year >= 10 then fn_incentive := salary * 1.5;
    end if;
    return fn_incentive;
end;
/

select
    emp_id 사번,
    emp_name 사원명,
    hire_date 입사일,
    trunc(months_between(sysdate,hire_date) /12) || '년' || trunc(mod(months_between(sysdate,hire_date) /12,1) *12) || '월' 근무개월,
    fn_calc_incentive(salary, hire_date) 특별상여금
from
    employee;
    
    
/*
1. EMPLOYEE테이블의 퇴사자관리를 별도의 테이블 TBL_EMP_QUIT에서 하려고 한다.
다음과 같이 TBL_EMP_JOIN, TBL_EMP_QUIT테이블을 생성하고, TBL_EMP_JOIN에서 DELETE시 자동으로 퇴사자 데이터가 
TBL_EMP_QUIT에 INSERT되도록 트리거를 생성하라.
*/
-- TBL_EMP_JOIN 테이블 생성 : QUIT_DATE, QUIT_YN 제외

    CREATE TABLE TBL_EMP_JOIN
    AS
    SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE
    FROM EMPLOYEE
    WHERE QUIT_YN = 'N';

    SELECT * FROM TBL_EMP_JOIN;
    
--TBL_EMP_QUIT : EMPLOYEE테이블에서 QUIT_YN 컬럼제외하고 복사

    CREATE TABLE TBL_EMP_QUIT
    AS
    SELECT EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, QUIT_DATE
    FROM EMPLOYEE
    WHERE QUIT_YN = 'Y';

    SELECT * FROM TBL_EMP_QUIT; 
    
create or replace trigger trig_tbl_emp_quit
    before
    delete on TBL_EMP_JOIN
    for each row
begin
    if deleting then
        insert into
            TBL_EMP_QUIT(EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, QUIT_DATE)
        values(
             :old.emp_id, :old.emp_name, :old.emp_no, :old.email, :old.phone, :old.dept_code, :old.job_code, :old.sal_level, :old.salary, :old.bonus,
            :old.manager_id, :old.hire_date, sysdate
        );
    end if;
end;
/

delete from tbl_emp_join where emp_id = '200';

/*
2. 사원변경내역을 기록하는 emp_log테이블을 생성하고, ex_employee 사원테이블의 insert, update가 있을 때마다 신규데이터를 기록하는 트리거를 생성하라.
* 로그테이블명 emp_log : 컬럼 log_no(시퀀스객체로부터 채번함. pk), log_date(기본값 sysdate, not null), ex_employee테이블의 모든 컬럼
* 트리거명 trg_emp_log
*/
create table emp_log
as
select * from ex_employee where 1=2;

alter table emp_log
add(
    log_no number,
    log_date date default sysdate not null,
    constraint pk_emp_log_no primary key(log_no)
);



create sequence seq_emp_log;

create or replace trigger trg_emp_log
    before
    insert or update on ex_employee
    for each row
begin
    if inserting then
        insert into
            emp_log
        values(
            :new.emp_id, :new.emp_name, :new.emp_no, :new.email, :new.phone, :new.dept_code, :new.job_code, :new.sal_level, 
            :new.salary, :new.bonus, :new.manager_id, :new.hire_date, :new.quit_date, :new.quit_yn, seq_emp_log.nextval, sysdate
        );
                
    elsif updating then
        insert into
            emp_log
        values(
            :new.emp_id, :new.emp_name, :new.emp_no, :new.email, :new.phone, :new.dept_code, :new.job_code, :new.sal_level, 
            :new.salary, :new.bonus, :new.manager_id, :new.hire_date, :new.quit_date, :new.quit_yn, seq_emp_log.nextval, sysdate
        );
    end if;
end;
/

select * from emp_log;
select * from ex_employee;

update ex_employee set dept_code = 'D7' where emp_id = '202';

    