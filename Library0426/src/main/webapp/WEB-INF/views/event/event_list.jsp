<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
  <link rel="stylesheet" href="../css/event_list.css">
</head>
<body>
  <%@ include file="../listhead.jsp" %>

  <section>
    <h1>행사안내</h1>

    <article id="event_list">
      <ul>
      <c:forEach var="dto" items="${map.list }">
        <li>
          <a href="event_read?page=${map.page }&le_id=${dto.le_id }"><img src="/upload/event/${dto.le_filename }" alt="" class="event-img"></a>
          <fmt:parseDate value="${dto.le_enddate }" var="le_enddate" pattern="yyyy-MM-dd"/>
          <c:set var="enddate"><fmt:formatDate value="${le_enddate }" pattern="yyyy-MM-dd"/></c:set>
          <c:set var="now" value="<%=new java.util.Date()%>" />
		  <c:set var="sysYear"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set>
          <c:if test="${enddate > sysYear || enddate eq sysYear}">
          	<div class="event-now">진행중</div>
          </c:if>
          <c:if test="${enddate < sysYear }">
          	<div class="event-end">종료</div>
          </c:if>
          <a href="event_read?page=${map.page }&le_id=${dto.le_id }"><div class="event-title">${dto.le_title }</div></a>

          <div class="event-date">
          <fmt:parseDate value="${dto.le_date }" var="le_date" pattern="yyyy-MM-dd"/>
          <fmt:formatDate value="${le_date }" pattern="yyyy-MM-dd"/>
          ~ 
          <fmt:parseDate value="${dto.le_enddate }" var="le_enddate" pattern="yyyy-MM-dd"/>
          <fmt:formatDate value="${le_enddate }" pattern="yyyy-MM-dd"/>
          </div>
        </li>
      </c:forEach>
      </ul>
    </article>

    <ul class="page-num">
      <c:if test="${map.page==1}">
      	<li class="first"></li>
      </c:if>
      <c:if test="${map.page!=1}">
      	<a href="./event?page=1"><li class="first"></li></a>
      </c:if>
      
      <c:choose>
      	<c:when test="${map.page<=1 }">
      		<li class="prev"></li>
      	</c:when>
      	<c:otherwise>
      		<a href="./event?page=${map.page-1 }"><li class="prev"></li></a>
      	
      	</c:otherwise>
      </c:choose>
      
      
      <%-- 번호반복 --%>
      <c:forEach var="nowpage" begin="${map.startpage }" end="${map.endpage }">
      	<c:choose>
    		<c:when test="${map.page==nowpage }">
    			<li class="num"><div>${nowpage }</div></li>
    		</c:when>
    		<c:otherwise>
		      	<a href="./event?page=${nowpage }"><li class="num"><div>${nowpage }</div></li></a>
    		</c:otherwise>  	
      	</c:choose>
      </c:forEach>
      
      <c:choose>
      	<c:when test="${map.page>=map.maxpage }">
      		<li class="next"></li>
      	</c:when>
      	<c:otherwise>
		      <a href="./event?page=${map.page+1 }"><li class="next"></li></a>
      	</c:otherwise>
      </c:choose>
      
      <%-- page가 1인데 maxPage가 0인경우 --%>
      <c:if test="${map.page==map.maxpage}">
      	<li class="last"></li>
      </c:if>
      <c:if test="${map.page!=map.maxpage}">
      	<a href="./event?page=${map.maxpage}"><li class="last"></li></a>
      </c:if>
    </ul>
	<c:if test="${session_flag =='success' && session_user == 'admin'}">
    <div class="write" onclick="location.href='./event_write'">쓰기</div>
	</c:if>

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