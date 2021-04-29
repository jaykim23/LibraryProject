<%@page import="ch.qos.logback.core.recovery.ResilientSyslogOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% pageContext.setAttribute("br","<br>"); %>
<% pageContext.setAttribute("cn","\n"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link
	href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:400,500,700,900&display=swap&subset=korean"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
<link rel="stylesheet" href="../css/style.css">
<link rel="stylesheet" href="../css/read.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style>
.cursor {
	cursor: pointer;
}
</style>
<script type="text/javascript">
	function loginCheck(){
			alert("로그인을 필요로 합니다.");
			return false;
		}
	
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

</script>

</head>

<body>
	<%@ include file="../listhead.jsp" %>
	<section>
		<h1>도서상세내용</h1>

		<table>
			<colgroup>
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="20%">
			</colgroup>
			<tr>
				<th style="text-align:center" colspan="5">제목 | <span><strong>${map.bookDto.bk_bookname }</strong></span></th>
			</tr>
			<tr>
				<td>저자 | ${map.bookDto.bk_writer }</td>
				<td>식별자 | ${map.bookDto.bk_isbn } </td>
				<td>별점 | ${map.bookDto.bk_star}</td>
				<td>선호도 | ${map.bookDto.bk_hit }</td>
				<td id="bk_pub">출판사 /${map.bookDto.bk_pub }</td> 
			</tr>
			<tr>
				<td><img alt=""src="/upload/book/${map.bookDto.bk_filename}" width="350" height="450"></td>
				<td colspan="4" class="article" id="content_result" style="text-align:left">${map.bookDto.bk_content}</td>
			</tr>
			<%-- <tr>
				<td colspan="3"><strong>다음글</strong> <span class="separator">|</span>
					<a
					href="content_view?category=${map.category }&search=${map.search }&page=${map.page }&bid=${map.nextDto.bid }">${map.nextDto.btitle }</a>
				</td>
			</tr>
			<tr>
				<td colspan="3"><strong>이전글</strong> <span class="separator">|</span>
					<a href="content_view?category=${map.category }&search=${map.search }&page=${map.page }&bid=${map.preDto.bid }">${map.preDto.btitle }</a>
				</td>
			</tr> --%>
		
		</table>
		<c:choose>
			<c:when test="${session_flag == null || session_flag =='fail'}">
				<a href="book_list?category=${map.category }&search=${map.search }&page=${map.page }"><div class="list">목록</div></a>
			</c:when>
			<c:when test="${session_Name == '관리자' }">
				<a href="book_list?category=${map.category }&search=${map.search }&page=${map.page }"><div class="list">목록</div></a>
				<div class="list"><a href="../admin/admin_bookmodify_view?bk_id=${map.bookDto.bk_id}">수정</a></div> 
				<div onclick="delete_check('${map.bookDto.bk_id}')" class="list cursor">삭제</div>
			</c:when>
			<c:otherwise>
				<a href="book_list?category=${map.category }&search=${map.search }&page=${map.page }"><div class="list">목록</div></a>
			</c:otherwise>
			
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