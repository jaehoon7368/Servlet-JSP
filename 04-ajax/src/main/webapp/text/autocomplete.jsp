<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>jQueryUi-autocomplete</title>
<link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<script src="<%= request.getContextPath()%>/js/jquery-3.6.1.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
<script>
  $( function() {
    
    $( "#classmates" ).autocomplete({

    	  source(request,response){
    		  console.log(request); //사용자 입력데이터 {term : 사용자입력값}
    		  /* console.log(response); */ // 목록화할 데이터를 시각화할 함수. 하나의 목록은 {label : label, value : value} 객체 형태로 전달
    		  
    		  findClassmates(request,response);
    		  
    	  }, // source
    	  focus(event, selected){
    		  //커서 이동시 선택되는 걸 방지 
    		  return false;
    	  },
    	  select(event, selected){
    		  console.log(selected);
    		  const {item : {value}} = selected;
    		  alert(value);
    	  }
      
    });
  });
  
  const findClassmates = (request,response) =>{
	  $.ajax({
			 url : "<%=request.getContextPath() %>/csv/autocomplete",
			 method : "GET",
			 data : {
				 term : request.term
			 },
			 dataType : "text",
			 success(data){
				 console.log(data);
				 
				 if(data === "") return;
				 const _arr = data.split(",");
				 const arr = _arr.map((name,index) =>{
					 return {
						label : name,
						value : name
					 };
				 });
				 console.log(_arr);
				 console.log(arr);
				 
				 response(arr);
			 },
			 error(xhr, textStatus,err){
				 console.log(xhr, textStatus,err);
			 }
		  });
  };
  </script>
</head>
<body>
	<h1>jQueryUi-autocomplete</h1>
	
	
	<div class="ui-widget">
	  <label for="classmates">반친구 검색: </label>
	  <input id="classmates">
	</div>
	
</body>
</html>