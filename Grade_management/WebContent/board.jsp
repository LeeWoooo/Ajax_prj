<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>성적관리</title>
  		<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	</head>
	<body>
		<%@include file="header.jsp"%>
			<div class="container" style="margin-top: 15px">
				<form id="form">
				    <div class="form-group">
				      <label for="name">이름:</label>
				      <input type="text" class="form-control stu" id="name" placeholder="Enter no" name="name">
				    </div>
				    <div class="form-group">
				      <label for="name">국어점수:</label>
				      <input type="text" class="form-control stu" id="korea" placeholder="Enter name" name="korea">
				    </div>
				    <div class="form-group">
				      <label for="math">수학점수:</label>
				      <input type="text" class="form-control stu" id="math" placeholder="Enter publisher" name="math">
				    </div>
				    <div class="form-group">
				      <label for="english">영어점수:</label>
				      <input type="text" class="form-control stu" id="english" placeholder="Enter price" name="english">
				    </div>
			  </form>
			</div>
			<div class="container" align="center" style="margin-top: 30px">
				<div class="row">
				  <div class="col-sm-3">
				  	<button class="btnAdd btn btn-dark">성적 추가</button>
				  </div>
				  <div class="col-sm-3">
				  	<button class="btnUpdate btn btn-dark">성적 수정</button>
				  </div>
				  <div class="col-sm-3">
				  	<button class="btnDelete btn btn-dark">성적 삭제</button>
				  </div>
				</div>
			</div>
			<div class="container" style="margin-top: 20px">
				  <h2>성적 조회 결과</h2>
				  <br>
				  <table class="table table-hover">
				    <thead>
				      <tr>
				        <th>학생이름</th>
				        <th>국어</th>
				        <th>수학</th>
				        <th>영어</th>
				        <th>총점</th>
				        <th>평균</th>
				      </tr>
				    </thead>
				    <tbody>
				    </tbody>
				  </table>
			  </div>
		<%@include file="footer.jsp"%>
		<script>
			$(function(){
				
				loadData();
			 	
				//앞으로 생길 tr에 이벤트 걸기
				//누르면 입력창에 값 가져오기
				$(document).on("click","tr",function(){
					let studentInfo = $(this).find("td");
					let inputList = $("input[type=text]");
					for(let i=0; i<inputList.length; i++){
						$(inputList[i]).val( $(studentInfo[i]).text() )
					}
				})
				
				//현재 입력된 학생 성적을 불러와 동적으로 노드를 생성해 테이블에 추가
				function loadData() {
					$.ajax({
						url:"http://localhost:8090/scoreManagement/ajaxloadAction.jsp",
						datatype:"json",
						type:"get"
					}).done(function (data) {
						$("tbody").empty(); //테이블 초기화 후 불러오기
						$.each(data,function(index,item){
							let tr = $("<tr></tr>");
							$.each(item,function(key,value){
								$("<td></td>").text(value).appendTo(tr);
							})//end each
							$("tbody").append(tr);
						})//end each
					})//done
					$("input").val("");//input 태그 초기화
				}//loadData
					
				
				//성적 추가 버튼 클릭 이벤트
				$(".btnAdd").click(function () {
					let inputData = $("#form").serializeArray();
					$.ajax({
						url:"http://localhost:8090/scoreManagement/ajaxInsertAction.jsp",
						data:inputData,
						dataType:"json",
						type:"get"
					}).done(function (data) {
						if(data.result === 1){
							loadData();
							$("input").val("");//input 태그 초기화
						}//end if
					})//done
				})//click
				
				//성적 수정 버튼 클릭 이벤트
				$(".btnUpdate").click(function () {
					let inputData = $("#form").serializeArray();
					$.ajax({
						url:"http://localhost:8090/scoreManagement/ajaxUpdateAction.jsp",
						data:inputData,
						datatype:"json",
						type:"get"
					}).done(function (data) {
						if(data.result===1){
							loadData();
							$("input").val("");//input 태그 초기화
						}//end if
					})//done
				})//click
				
				//성적 삭제 버튼 클릭 이벤트
				$(".btnDelete").click(function () {
					let inputName = $("#name").val();
					let inputData = {name:inputName};
					$.ajax({
						url:"http://localhost:8090/scoreManagement/ajaxDeleteAction.jsp",
						data:inputData,
						datatype:"json",
						type:"get"
					}).done(function (data) {
						if(data.result===1){
							loadData();
						}//end if
					})//done
				})//click
			});
		</script>
	</body>
</html>