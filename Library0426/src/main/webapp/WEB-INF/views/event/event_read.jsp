<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:400,500,700,900&display=swap&subset=korean" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
  <link rel="stylesheet" href="../css/style.css">
  <link rel="stylesheet" href="../css/read.css">
  <script src="http://code.jquery.com/jquery-latest.min.js"></script>
  <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
  <script type="text/javascript">
  function delete_check() {
		 if (confirm("삭제하시겠습니까?")) {
			location.href = "event_delete?page=${map.page }&le_id=${map.dto.le_id}";
		} else {
		return false;
		}
   }
  
//댓글등록
	function commentWrite(){
	 alert("등록 버튼 클릭");
	 var html="";
	 var lm_user = "${session_user}";  //섹션 아이디 적용
	 var le_id = "${map.dto.le_id}";
	 var lcheck = "${session_flag}";
	 if(lcheck!="success"){
		 alert("로그인을 해주세요.");
		 return false;
	 }
	 
	 $.ajax({
		url:"/event/commentWrite_check",
		type:"post",
		data:{
			"le_id":le_id,"lm_user":lm_user,
			"evcom_pw":$("#evcom_pw").val(),"evcom_content":$("#evcom_content").val()
		},
		success:function(data){   //data.dto.id
			
			alert("댓글등록 완료했습니다 ");
			
			 html +='<ul id="'+data.dto.evcom_no+'">';
		     /* 자바스크립트 날짜 포맷 변경 함수 : 상단에 moment날짜함수 선언을 해야 함 */
			 html +='<li class="name"> '+data.dto.lm_user+'<span>&nbsp;&nbsp;['+moment(data.dto.evcom_date).format("YYYY-MM-DD HH:mm:ss")+']</span></li>';
			 html +='<li class="txt">'+data.dto.evcom_content+'</li>';
			 html +='<li class="cbtn">';
			 html +='<a href="#" class="rebtn"';
			 html +='onclick="commentUpdate('+data.dto.evcom_no+',\''+data.dto.lm_user+'\',\''+data.dto.evcom_content+'\',\''+data.dto.evcom_date+'\')">수정</a>';
			 html +='<a href="#" class="rebtn" onclick="commentDelete('+data.dto.evcom_no+')">삭제</a>';
			 html +='</li>';
			 html +='</ul>';
			
			 $('.replyBox').append(html); 
			 $('#evcom_pw').val('');
			 $('#evcom_content').val('');
			 
		},
		error:function(){
			alert("에러");
		}
		 
	 });  
 }
 
	/* 댓글삭제 체크 */
	 function commentDelete(evcom_no){
		 alert("삭제 버튼 클릭");
		 if(confirm("삭제하시겠습니까?")){
			 $.ajax({
					url:"/event/commentDelete",
					type:"post",
					data:{
						"evcom_no":evcom_no
					},
					success:function(data){   
					     alert(data.msg);
						 // 해당 태그 삭제
					     $('#'+evcom_no).remove();
						 location.reload();
					},
					error:function(){
						alert("에러");
					}
				 }); 
		 }else{
			 return false; 
		 }
	 }
	 
	 /* 댓글수정 체크 */
	 function commentUpdate_check(evcom_no,lm_user){
		 alert("수정 저장 버튼 클릭");
		 var html="";
		 
		 $.ajax({
			url:"/event/commentUpdate_check",
			type:"post",
			data:{
				"evcom_no":evcom_no,"lm_user":lm_user,"evcom_content":$("#evcomContentUpdate").val()
			},
			success:function(data){   //data.dto.id
			     /* 자바스크립트 날짜 포맷 변경 함수 : 상단에 moment날짜함수 선언을 해야 함 */
				 html +='<li class="name"> '+data.dto.lm_user+'<span>&nbsp;&nbsp;['+moment(data.dto.evcom_date).format("YYYY-MM-DD HH:mm:ss")+']</span></li>';
				 html +='<li class="txt">'+data.dto.evcom_content+'</li>';
				 html +='<li class="cbtn">';
				 html +='<a href="#" class="rebtn"';
				 html +='onclick="commentUpdate('+data.dto.evcom_no+',\''+data.dto.lm_user+'\',\''+data.dto.evcom_content+'\',\''+data.dto.evcom_date+'\')">';
				 html +='수정</a>';
				 html +='<a href="#" class="rebtn" onclick="commentDelete('+data.dto.evcom_no+')">삭제</a>';
				 html +='</li>';
				 
				 $('#'+evcom_no).html(html); 
				 location.reload();
				
			},
			error:function(){
				alert("에러");
			}
		 });  
		 
	 }
	 
	 
	 
	 /* 댓글수정 */
	 function commentUpdate(evcom_no,lm_user,evcom_content,evcom_date){
		 alert("수정 버튼 클릭");
		 
		 var html="";
		 

		 html +='<li class="name">'+lm_user+' <span>&nbsp;&nbsp;['+moment(evcom_date).format("YYYY-MM-DD HH:mm:ss")+']</span></li>';
		 html +='<li class="txt"><textarea class="replyType" id="evcomContentUpdate" name="evcomContentUpdate">'+evcom_content+'</textarea></li>';
		 html +='<li class="cbtn">';
		 html +='<a href="#" class="rebtn" ';
		 html +='onclick="commentUpdate_check('+evcom_no+',\''+lm_user+'\')">';
		 html +='저장</a>';
		 html +='<a href="#" class="rebtn">취소</a>';
		 html +='</li>';
		
		 
		 $('#'+evcom_no).html(html); 
		 
		 
	 }
  </script>
  
</head>

<body>
   <%@ include file="../listhead.jsp" %>

  <section>
    <h1>행사안내</h1>

    <table>
      <tr>
        <th>${map.dto.le_title }</th>
      </tr>
      <tr>
        <td>
        <fmt:parseDate value="${map.dto.le_date }" var="le_date" pattern="yyyy-MM-dd"/>
        <fmt:formatDate value="${le_date }" pattern="yyyy-MM-dd"/> ~ 
        <fmt:parseDate value="${map.dto.le_enddate }" var="le_enddate" pattern="yyyy-MM-dd"/>
        <fmt:formatDate value="${le_enddate }" pattern="yyyy-MM-dd"/></td>
      </tr>
      <tr>
        <td class="article">
          <img src="/upload/event/${map.dto.le_filename }" alt="" width="80%" >
          </td>
      </tr>
      <tr>
        <td><strong>다음글</strong> <span class="separator">|</span> <a href="event_read?page=${map.page }&le_id=${map.nextDto.le_id}">${map.nextDto.le_title }</a></td>
      </tr>
      <tr>
        <td><strong>이전글</strong> <span class="separator">|</span> <a href="event_read?page=${map.page }&le_id=${map.preDto.le_id}">${map.preDto.le_title }</a></td>
      </tr>
      <tr>
		<td colspan="3" class="article">
			<!-- 댓글-->
			<div class="replyWrite">
				<ul>
					<li class="in">
						<p class="ctxt">총 <span class="orange">${map.count}</span> 개의 댓글이 달려있습니다.</p>
						<p class="password">비밀번호&nbsp;&nbsp;<input type="password" class="replynum" id="evcom_pw" name="evcom_pw"/></p>
						<textarea class="replyType" id="evcom_content" name="evcom_content"></textarea>
					</li>
					<li class="btn"><a href="#" onclick="commentWrite()" class="replyBtn" >등록</a></li>
				</ul>
				<p class="ntic">※ 비밀번호를 입력하시면 댓글이 비밀글로 등록 됩니다.</p>
			</div>
			 
		</td>
	  </tr>
	  <tr>
	  	<td>
			<!-- 댓글이 추가되는 곳  -->
			<div class="replyBox">
			<!-- 댓글 반복 -->
			<c:forEach var="dto" items="${map.list }">
					<ul id="${dto.evcom_no}">
						<li class="name">${dto.lm_user} <span>&nbsp;&nbsp;[${dto.evcom_date }]</span></li>
						<li class="txt">${dto.evcom_content } </li>
						<li class="cbtn">	    
						    <!-- if -->
						    <c:if test="${session_user eq dto.lm_user}">
								<a href="#" class="rebtn" onclick="commentUpdate(${dto.evcom_no},'${dto.lm_user}','${dto.evcom_content }','${dto.evcom_date }')">수정</a>
								<a href="#" class="rebtn" onclick="commentDelete(${dto.evcom_no})">삭제</a>
						    </c:if> 
						</li>
					</ul>
			    </c:forEach>
			</div>
			<!-- //댓글 -->
		 </td>
	</tr>
			<!-- //댓글 -->
    </table>

    <a href="event?page=${map.page }"><div class="list">목록</div></a>
    <c:choose>
    	<c:when test="${session_flag =='success' && session_user == 'admin'}">
	    	<div class="list" onclick="delete_check()" style="cursor:pointer;">삭제</div>
    		<a href="event_modify_view?page=${map.page }&le_id=${map.dto.le_id}"><div class="list">수정</div></a>
    	</c:when>
    </c:choose>
  </section>

  <footer>
    <div class="wrapper">
      <div class="footer-left">
        <div class="footer-logo"></div>
        <div class="copyright">© COOKIT ALL RIGHTS RESERVED</div>
      </div>
  
      <div class="footer-center">
        <ul class="footer-nav">
          <li class="first-list">이용약관</li>
          <li class="green">개인정보처리 방침</li>
          <li>법적고지</li>
          <li>사업자정보 확인</li>
        </ul>
  
        <ul class="footer-info">
          <li class="first-list">씨제이제일제당(주)</li>
          <li>대표이사 : 손경식,강신호,신현재</li>
          <li>사업자등록번호 : 104-86-09535</li>
          <li class="first-list">주소 : 서울 중구 동호로 330 CJ제일제당 센터 (우) 04560</li>
          <li>통신판매업신고 중구 제 07767호</li>
          <li class="first-list">개인정보보호책임자 : 조영민</li>
          <li>이메일 : cjon@cj.net</li>
          <li>호스팅제공자 : CJ올리브네트웍스㈜</li>
        </ul>
  
        <div id="check">고객님은 안전거래를 위해 현금등으로 결제시 LG U+ 전자 결제의 매매보호(에스크로) 서비스를 이용하실 수 있습니다. <span class="check">가입 사실 확인</span></div>
      </div>
  
      <div class="footer-right">
        <div id="shortcut">
          <span>CJ그룹계열사 바로가기</span>
          <div class="shortcut"></div>
        </div>
  
        <div class="call">고객행복센터 1668-1920</div>
        <div class="inquery">1:1 문의</div>
      </div>
  
    </div>
  </footer>
</body>
</html>