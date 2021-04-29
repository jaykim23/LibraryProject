<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>도서목록</title>
<link
	href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:400,500,700,900&display=swap&subset=korean"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
<link rel="stylesheet" href="../css/style.css">
<link rel="stylesheet" href="../css/notice_list.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
	function rsWriteCheck(bookid){
			var bk_id = bookid;
			var reservationFlag = '<%=(String)session.getAttribute("session_flag")%>';
		
		 // 1. 세션 비교.
	 	if(reservationFlag != "success"){
			alert("로그인이 필요합니다.");
			return false;
		}
	 	else{
			$.ajax({
				url:"/reservation/reservation_check",
				type:"post",
				data:{
					"bk_id":bk_id, "lm_id":${session_id}
				},
				success:function(data){
					alert('대여를 완료했습니다.');
	
					
				},
				error:function(){
					alert("에러");
				}
				 
			 });
		}
	}

  	function loginCheck(){
  		alert("로그인을 필요로 합니다.");
  	}
  	//onclick delete
	function delete_check(book_id) {
		var bk_id = book_id;
		if(confirm("정말로 삭제하시겠습니까?")){
	   		 $.ajax({
					url:"/admin/book_delete",
					type:"post",
					data:{ 
						"bk_id":bk_id},
					success:function(data){
						alert("도서 삭제가 완료되었습니다.");
						location.href="/book/book_list";
					},
					error:function(){
						alert("에러");
					}
					
				});  
		}else{
			return false;
		}

	}
  	
	function bookpop(bk_id){
  		var popurl = "../book/bookpop?bk_id="+bk_id;
  		var test = "pop";
  		var popupX = (window.screen.width / 2) - (500 / 2);
  		var popupY= (window.screen.height / 2) - (500 / 2);
  		var option = "width = 500, height = 500, top ="+popupY+", left ="+popupX+", location = no";
  		
  		window.open(popurl,test,option);
  		
  	}
  </script>
</head>
<body>
	<%@ include file="../listhead.jsp" %>

	<section>
		<h1>도서목록</h1>
		<div class="wrapper">
			<form action="./book_list" name="search" method="post">
				<select name="category" id="category">
					<option value="all" ${map.category eq 'all'? 'selected':''}>전체</option>
					<option value="title" ${map.category eq 'title'? 'selected':'' }>제목</option>
					<option value="content"
						${map.category eq 'content'? 'selected':'' }>내용</option>
				</select>

				<div class="title">
					<input type="text" size="16" name="search" value="${map.search}">
				</div>

				<button type="submit">
					<i class="fas fa-search"></i>
				</button>
			</form>
		</div>

		<table style="text-align: center;">

			<colgroup>

				<col width="8%">
				<!-- 도서번호 -->
				<col width="12%">
				<!-- 표지 -->
				<col width="10%">
				<!-- 도서명 -->
				<col width="7%">
				<!-- 작가 -->
				<col width="10%">
				<!-- 출판사 -->
				<col width="10%">
				<!-- ISBN -->
				<col width="7%">
				<!-- 도서구분 -->
				<col width="3%">
				<!-- 별점 -->
				<col width="3%">
				<!-- 수량 -->
				<col width="4%">
				<!-- 추천수 -->
				<col width="4%">
				<!-- 수정 -->
				<col width="4%">
				<!-- 삭제 -->
			</colgroup>
			<tr>
				<th>도서번호</th>
				<th>표지</th>
				<th>도서명</th>
				<th>작가</th>
				<th>출판사</th>
				<th>식별자</th>
				<th>국내외구분</th>
				<th>별점</th>
				<th>수량</th>
				<th>추천수</th>
				<c:choose>
					<c:when test="${session_Name == '관리자'}">
					<th>수정</th>
					<th>삭제</th>
					</c:when>
					<c:otherwise>
					<th>대여하기</th>
					<th></th>
					</c:otherwise>
				</c:choose>
			</tr>
			<c:forEach var="bookDto" items="${map.list}" varStatus="status">
				<tr>
					<td><span class="table-notice">${bookDto.bk_id }</span></td>
					<td><span><a
						href="./book_content_view?category=${map.category }&search=${map.search }&page=${map.page }&bk_id=${bookDto.bk_id }">
						<img
							src="/upload/book/${bookDto.bk_filename}" width="95" height="125"></a></span></td>
					<!--  <input type="hidden" id="bk_id" name="bk_id" value="${bookDto.bk_id }">-->
					<td class="table-title" id="bk_bookname"><a
						href="./book_content_view?category=${map.category }&search=${map.search }&page=${map.page }&bk_id=${bookDto.bk_id }">${bookDto.bk_bookname }</a>
					</td>
					<c:choose>
						<c:when test="${fn:length(bookDto.bk_writer) > 4}">
							<td id="bk_writer"><c:out
									value="${fn:substring(bookDto.bk_writer,0,4)}" />..</td>
						</c:when>
						<c:otherwise>
							<td id="bk_writer"><c:out value="${bookDto.bk_writer }" /></td>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${fn:length(bookDto.bk_pub) > 4}">
							<td id="bk_pub"><c:out
									value="${fn:substring(bookDto.bk_pub,0,4)}" />..</td>
						</c:when>
						<c:otherwise>
							<td id="bk_pub"><c:out value="${bookDto.bk_pub }" /></td>
						</c:otherwise>
					</c:choose>
					<td id="bk_isbn">${bookDto.bk_isbn }</td>
					<td id="bk_nara">${bookDto.bk_nara }</td>
					<td id="bk_star">${bookDto.bk_star }</td>
					<td id="bk_amount">${bookDto.bk_amount }</td>
					<td id="bk_hit">${bookDto.bk_hit }</td>
					<c:choose>
						<c:when test="${session_Name == '관리자'}">
							<td><div class="table-button"><a href="../admin/admin_bookmodify_view?bk_id=${bookDto.bk_id}"   >수정</a></div></td>
							<td><div class="table-button" onclick="delete_check('${bookDto.bk_id}')" style="cursor:pointer;"><a>삭제</a></div></td>
						</c:when>
						<c:when test="${bookDto.bk_amount > 0 }">
							<td>
							<div class="table-button" onclick="bookpop(${bookDto.bk_id})">대여</div>
							</td>
							<td></td>
						</c:when>
						<c:otherwise>
							<td>
							<div class="table-button" onclick="style:alert('대여 불가능합니다.')">대여</div>
							</td>
							<td></td>
						</c:otherwise>
					</c:choose>
			</c:forEach>
		</table>

		<ul class="page-num">
			<c:if test="${map.page==1}">
				<li class="first"></li>
			</c:if>
			<c:if test="${map.page!=1}">
				<a href="./book_list?category=${map.category }&search=${map.search }&page=1"><li class="first"></li></a>
			</c:if>
			<c:choose>
				<c:when test="${map.page<=1 }">
					<li class="prev"></li>
				</c:when>
				<c:otherwise>
					<a href="./book_list?category=${map.category }&search=${map.search }&page=${map.page-1 }"><li class="prev"></li></a>
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
							href="./book_list?category=${map.category }&search=${map.search }&page=${nowpage }">
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
						href="./book_booklist?category=${map.category }&search=${map.search }&page=${map.page+1 }"><li class="next"></li></a>
				</c:otherwise>
			</c:choose>

			<%-- page가 1인데 maxPage가 0인경우 --%>
			<c:if test="${map.page==map.maxpage}">
				<li class="last"></li>
			</c:if>
			<c:if test="${map.page!=map.maxpage}">
				<a
					href="./book_list?category=${map.category }&search=${map.search }&page=${map.maxpage}"><li class="last"></li></a>
			</c:if>
		</ul>
		<c:choose>
			<c:when test="${session_Name == '관리자'}">
				<a href="../admin/admin_bookwrite"><div class="write" >쓰기</div></a>
			</c:when>
		</c:choose>
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

				<div id="check">
					고객님은 안전거래를 위해 현금등으로 결제시 LG U+ 전자 결제의 매매보호(에스크로) 서비스를 이용하실 수 있습니다. <span
						class="check">가입 사실 확인</span>
				</div>
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