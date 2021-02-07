<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>main</title>
	</head>
	<body>
		<%@include file="header.jsp"%>
		<div class="container" align="center" style="margin-top: 30px">
		  <div class="jumbotron">
		    <h3>학생 성적을 기록하고 관리하는 페이지 입니다.</h3>
		    <hr>
		    <p>ajax 통신을 이용한 CRUD를 구현한 페이지 입니다.</p>     
		    <p>학생의 성적을 조회,추가,수정,삭제를 할 수 있습니다.</p>     
		    <a href="board.jsp" class="btn btn-info btn-dark" role="button">성적 관리</a> 
		  </div>
		</div>
		<%@include file="footer.jsp" %>
	</body>
</html>