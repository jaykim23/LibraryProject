<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>MyBookReservation</title>
  <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:400,500,700,900&display=swap&subset=korean" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
  <link rel="stylesheet" href="../css/style.css">
  <link rel="stylesheet" href="../css/notice_list.css">
  <script src="http://code.jquery.com/jquery-latest.min.js"></script>
  <script type="text/javascript">
  function admin_reservationDelete(reser_id,bookid){
		alert("반납버튼클릭");
		var br_id = reser_id;
		var bk_id = bookid;
		alert(br_id);
		alert(bk_id);
		
		//컨트롤러에 보내서 저장하기 위해서 ajax를 쓰는것이다
	   	 $.ajax({
			url:"/reservation/reservation_Delete",
			type:"post",
			data:{
				"br_id":br_id,"bk_id":bk_id
			},
	 		success: function(data){
				//삭제여부
				alert("반납 완료했습니다.");
				location.href="./admin_Unpaidreservationlist";
			},
			error:function(){
				alert("삭제 실패!"); 
			}
		})
	}
  
  function admin_email(){
	  alert('개식');
	  var email1 = "${session_email1}";
	  var email2 = "${session_email2}";
		alert(email1);
		alert(email2);
		var email = email1+email2;
		alert(email);
		
		//컨트롤러에 보내서 저장하기 위해서 ajax를 쓰는것이다
	    $.ajax({
            url:"/admin/upEmailCheck",
            type:"post",
            data:{   'email': email },
            success:function(data){   
                  alert('메일을 전송하였습니다');                                 
            },
            error:function(){
               alert("에러");
            } 
            
         });//ajax
  }
  
  function test(){
  	  alert('전체발송테스트');
  	  var temail = "${email.list2[0].temail}";
  	  		//컨트롤러에 보내서 저장하기 위해서 ajax를 쓰는것이다
  	  		alert(temail);
  	   $.ajax({
              url:"/testemail",
              type:"post",
              data:{   'temail': temail },
              success:function(data){   
                    alert('메일을 전송하였습니다');                                 
              },
              error:function(){
                 alert("에러");
              } 
              
           });//ajax */
    }

  </script>
</head>
<body>
  <%@ include file="../listhead.jsp" %>

  <section>
    <h1>관리자 전체 미납도서 목록</h1>
    <div class="wrapper">
      <form action="./admin_Unpaidreservationlist" name="search" method="post">
        <select name="category" id="category">
          <option value="all" ${map.category eq 'all'? 'selected':''}>전체</option>
		  <option value="title" ${map.category eq 'title'? 'selected':'' }>도서명</option>
		  <option value="name" ${map.category eq 'name'? 'selected':'' }>대여자</option>
        </select>

        <div class="title">
          <input type="text" size="16" name="search" value="${map.search}">
        </div>
  
        <button type="submit"><i class="fas fa-search"></i></button>
      </form>
    </div>
    <div class="temail">
	<button type="button" onclick="test()" id="temail">전체발송</button>
    </div>
    <table style="text-align: center;">
    
      <colgroup>
        <col width="10%">
        <col width="10%">
        <col width="10%">
        <col width="20%">
        <col width="20%">
        <col width="10%">
        <col width="10%">
        <col width="10%">
      </colgroup>
      <tr>
        <th>대여번호</th>
        <th>도서명</th>
        <th>대여자명</th>
        <th>대여일</th>
        <th>반납일</th>
        <th>남은일수</th>
        <th>반납</th>
        <th>이메일</th>
      </tr>
      <c:forEach var = "dto" items="${map.list}" varStatus="status">
	      <tr>
	        <td><span class="table-notice" id="br_id" name="br_id">${dto.br_id }</span></td>
	        <td id="bk_bookname">${dto.bk_bookname }</td>
	        <td id="lm_name">${dto.lm_name }</td>
	        <td id="br_sdate">
	        <fmt:parseDate value="${dto.br_sdate }" var="br_sdate" pattern="yyyy-MM-dd"/>
	        <fmt:formatDate value="${br_sdate }" pattern="yyyy-MM-dd"/></td>
	        <td id="br_edate">
	        <fmt:parseDate value="${dto.br_edate }" var="br_edate" pattern="yyyy-MM-dd"/>
	        <fmt:formatDate value="${br_edate }" pattern="yyyy-MM-dd"/></td>
	        <td>
	     
			<fmt:parseDate value="${dto.br_edate }" var="br_edate" pattern="yyyy-MM-dd"/>
			<fmt:parseNumber value="${br_edate.time / (1000*60*60*24)}" integerOnly="true" var="strDate"></fmt:parseNumber>
			<c:set var="now" value="<%=new java.util.Date()%>" />
			<fmt:parseNumber value="${now.time / (1000*60*60*24)}" integerOnly="true" var="endDate"></fmt:parseNumber>
			<c:choose>
				<c:when test="${strDate < endDate }">
					<c:out value="${strDate - endDate + 1}일 지났습니다."/>
				</c:when>
				<c:when test="${strDate >= endDate }">
					<c:out value="${strDate - endDate + 1 }일 남았습니다."/>
				</c:when>
			</c:choose>

	        </td>
		    <td><a class="table-return" onclick="admin_reservationDelete(${dto.br_id},${dto.bk_id })">반납</a></td>
		    <td><a class="table-return" onclick="admin_email()">이메일 전송</a></td>
	       <%--  <td><div class="admin_button" onclick="admin_bookDelete()"><a href="">취소</a></div></td> --%>
	        <!-- <td><a class="admin_button" href="" name="" id=""><button>수정</button></a></td>
	        <td><a class="admin_button" href="" name="" id=""><button>삭제</button></a></td> -->
			</tr>
      </c:forEach>
    </table>
    

    <ul class="page-num">
			<c:if test="${map.page==1}">
				<li class="first"></li>
			</c:if>
			<c:if test="${map.page!=1}">
				<a href="./admin_Unpaidreservationlist?category=${map.category }&search=${map.search }&page=1"><li class="first"></li></a>
			</c:if>
			<c:choose>
				<c:when test="${map.page<=1 }">
					<li class="prev"></li>
				</c:when>
				<c:otherwise>
					<a href="./admin_Unpaidreservationlist?category=${map.category }&search=${map.search }&page=${map.page-1 }"><li class="prev"></li></a>
				</c:otherwise>
			</c:choose>


			<%-- 번호반복 --%>
			<c:forEach var="nowpage" begin="${map.startpage }"
				end="${map.endpage }">
				<c:choose>
					<c:when test="${map.page==nowpage }">
						<li class="num"><div>${nowpage }</div></li>
					</c:when>
					<c:otherwise>
						<a
							href="./admin_Unpaidreservationlist?category=${map.category }&search=${map.search }&page=${nowpage }">
							<li class="num"><div>${nowpage }</div></li>
						</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>

			<c:choose>
				<c:when test="${map.page>=map.maxpage }">
					<li class="next"></li>
				</c:when>
				<c:otherwise>
					<a
						href="./admin_Unpaidreservationlist?category=${map.category }&search=${map.search }&page=${map.page+1 }"><li class="next"></li></a>
				</c:otherwise>
			</c:choose>

			<%-- page가 1인데 maxPage가 0인경우 --%>
			<c:if test="${map.page==map.maxpage}">
				<li class="last"></li>
			</c:if>
			<c:if test="${map.page!=map.maxpage}">
				<a
					href="./admin_Unpaidreservationlist?category=${map.category }&search=${map.search }&page=${map.maxpage}"><li class="last"></li></a>
			</c:if>
		</ul>

   <!--  <div class="write">쓰기</div> -->
  </section>
   <!-- 여기부터 끝 -->

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