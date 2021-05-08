<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대여확인</title>
<link rel="stylesheet" href="../css/pop_list.css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
   function rsWriteCheck(bookid){
         var bk_id = bookid;
         var reservationFlag = '<%=(String)session.getAttribute("session_flag")%>';
      
       //세션 비교.
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
               window.close();
               window.opener.location.reload();
            },
            error:function(){
               alert("에러");
            }
             
          });
      }
   }
</script>
</head>
<body>
<table>
   <tr>
      <td rowspan="5"><img src="/upload/book/${map.bookDto.bk_filename}" width="250" height="450"></td>
      <td>책이름</td>
      <td>${map.bookDto.bk_bookname }</td>
   </tr>
   <tr>
      <td>식별자</td>
      <td>${map.bookDto.bk_isbn }</td>
   </tr>
   <tr>
      <td>대여자명</td>
      <td>${session_Name }</td>
   </tr>
   
   
   <!-- 대여일과 반납일을 계산해서 보여주기 DB저장은 query로 -->
   <tr>
      <!-- 데이트 함수를 가져와 대여일 formatting을 한다. 이건 보여주는 값일 뿐이다. 실제 데이터는 impl에서 저장 -->
      <td>대여일</td>
      <td>
      	<!-- 현재 시간을 가져온다. -->
         <c:set var="now" value="<%=new Date()%>" />
         <c:set var="sysYear"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set>
         <!-- 대여일 출력 -->
         <c:out value="${sysYear }"/>
      </td>
   </tr>
   <tr>
      <!-- 데이트 함수를 가져와 반납일 formatting을 한다. 이건 보여주는 값일 뿐이다. 실제 데이터는 impl에서 저장 -->
      <td>반납일</td>
      <td>
      	<!-- 시간을 가져와 60초 60분 24시간 millisecond를 곱하고 14를 곱해서 2주를 계산한다. -->
         <c:set var="now2" value="<%=new Date(new Date().getTime() + 60*60*24*1000*14)%>" />
         <c:set var="sysYear2"><fmt:formatDate value="${now2}" pattern="yyyy-MM-dd" /></c:set>
         <!-- 반납일 출력 -->
         <c:out value="${sysYear2 }"/>
      </td>
   </tr>
   <!-- 여기까지 -->
   
</table>
   <div>
   <div class="check" onclick="rsWriteCheck('${map.bookDto.bk_id}')">확인</div>
   <div class="close" onclick="style:window.close()">취소</div>
   </div>
</body>
</html>