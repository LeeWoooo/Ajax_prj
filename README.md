Ajax을 이용한 학생 성적 관리
===

## project 목표

1. ajax을 이용한 DB 연결
2. JSP를 이용해 간단한 페이지를 구성하고 JDBC를 활용한 CRUD

* 디자인은 bootstrap을 이용하였으며 js는 jquery를 이용하였습니다.
* DB와 관련된 작업은 DAO에서 데이터 관리는 VO를 이용하였습니다.
* Connection은 getConnection method를 만들어서 가져다 사용하였습니다.

<br>

---

<br>

## 페이지 흐름도

* 흐름도 

    <img src = https://user-images.githubusercontent.com/74294325/107009419-6466fd00-67d8-11eb-9658-b99a8f63c452.png>

<br>

application이 동작하면 index페이지가 실행되고 index페이지에서 sendRedirect를 이용하여 main.jsp로 이동합니다. 이 후 성적관리 버튼을 클릭하면 board로 이동하며 성적을 할 수 있습니다.

<br>

---

<br>

## 구현 화면

<Strong>이미지를 클릭하면 구현 영상을 확인하실 수 있습니다:)</strong>

[![ajax](https://user-images.githubusercontent.com/74294325/107151562-93cb6480-69a6-11eb-85d4-6a9842ce3159.JPG)](https://www.youtube.com/watch?v=kSbJ-v-TR24&feature=youtu.be)

<Br>

### main

header(nav)와 footer는 따로 jsp파일을 만들어 include하는 방식을 사용하여 코드의 중복을 제거하였습니다.<br>

프로젝트를 실행 하면 바로 main page로 리다이렉트 되어 이동됩니다. 프로젝트에 관한 간단한 설명이 적혀있으며 성적관리 버튼을 클릭하면 성적관리 페이지로 이동됩니다. 위에 nav에 있는 성적관리를 클릭해도 동일하게 이동합니다. 

<br>


### board


#### Connection, tr event

CRUD마다 Connection이 필요하기 때문에 getConnection method를 만들어 가져다 사용합니다.
```java
public Connection getConnection() throws SQLException{
    try {
        Class.forName("oracle.jdbc.OracleDriver");
    }catch(ClassNotFoundException e) {
        e.printStackTrace();
    }
    String url = "jdbc:oracle:thin:@localhost:1521:orcl";
    String user = "scott";
    String password = "tiger";
    return DriverManager.getConnection(url, user, password);
}
```

<br>

또한 동적으로 생성되는 tr에 이벤트를 추가합니다. tr을 클릭하게 되면 이름과 각각의 점수가 입력창에 채워진다.
```javascript
//앞으로 생길 tr에 이벤트 걸기
//누르면 입력창에 값 가져오기
$(document).on("click","tr",function(){
    let studentInfo = $(this).find("td");
    let inputList = $("input[type=text]");
    for(let i=0; i<inputList.length; i++){
        $(inputList[i]).val( $(studentInfo[i]).text() )
    }
})
```

<br>

#### SELECT

```java
public List<ScoreVO> selectAll() {
    List<ScoreVO> list = new ArrayList<>();
    String sql = "SELECT * FROM SCORE ORDER BY NAME ASC";
    try(Connection con = sDAO.getConnection();
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery()){
        ScoreVO sVO = null;
        while(rs.next()) {
            sVO = new ScoreVO(rs.getString("NAME"),
                rs.getInt("KOREA"), rs.getInt("MATH"),
                rs.getInt("ENGLISH"), rs.getInt("TOTAL"),
                rs.getInt("AVERAGE"));
            list.add(sVO);
        }
    }catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}//select All
```
```jsp
<%@page import="scoreVO.ScoreVO"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.List"%>
<%@page import="scoredao.ScoreDAO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	ScoreDAO sDAO = ScoreDAO.getInstance();
	List<ScoreVO> list = sDAO.selectAll();
	Gson gson = new Gson();
	String strJson = gson.toJson(list);
%>
<%=strJson%>
```
```javascript
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
```

<br>


board.jsp 페이지가 열리면 바로 ajax통신을 하여 학생 성적을 조회합니다. Action page에서 DB에 있는 학생 정보를 검색후 GSON라이브러리를 이용하여 json형태로 응답하게 됩니다. 응답을 받은 json데이터를 board.jsp에서 동적으로 노드를 생성하여 테이블에 추가합니다.

<br>

#### INSERT

```javascript
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
        }//end if
    })//done
})//click
```
```java
public int insertScore(ScoreVO sVO) {
    int flag = -1;
    String sql = "INSERT INTO SCORE VALUES (?,?,?,?,?,?)";
    
    try(Connection con = sDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
        pstmt.setString(1, sVO.getName());
        pstmt.setInt(2, sVO.getKorea());
        pstmt.setInt(3, sVO.getMath());
        pstmt.setInt(4, sVO.getEnglish());
        pstmt.setInt(5, sVO.getTotal());
        pstmt.setInt(6, sVO.getAverage());
        flag = pstmt.executeUpdate();
    }catch(SQLException e) {
        e.printStackTrace();
    }
    return flag;
}//insertScore
```
```jsp
<%@page import="scoredao.ScoreDAO"%>
<%@page import="scoreVO.ScoreVO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String name = request.getParameter("name");
	int korea = Integer.parseInt(request.getParameter("korea"));
	int math = Integer.parseInt(request.getParameter("math"));
	int english = Integer.parseInt(request.getParameter("english"));
	int total = korea + math + english;
	int average = total / 3;

	ScoreVO sVO = new ScoreVO(name,korea,math,english,total,average);
	ScoreDAO sDAO = ScoreDAO.getInstance();
	int result = sDAO.insertScore(sVO);
%>
{"result":<%=result%>}
```

<Br>

form태그에서 값을 가져와서 VO에 저장 후 DB와 연결을 하여 입력받은 값을 DB에 저장합니다. 저장이 완료되면 result값으로 1이 반환되고 요청한 board.jsp에 json형태로 응답하게 됩니다. 
성적 추가가 완료되면 ajax통신을 하였기 때문에 추가된 성적이 바로 조회가 됩니다. 

<br>

#### UPDATE

```javascript
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
```
```java
public int updateScore(ScoreVO sVO) {
    int flag = -1;
    String sql = "UPDATE SCORE SET KOREA=?, MATH=?, ENGLISH=?,TOTAL=?,AVERAGE=? WHERE NAME=?";
    try(Connection con = sDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
        pstmt.setInt(1, sVO.getKorea());
        pstmt.setInt(2, sVO.getMath());
        pstmt.setInt(3, sVO.getEnglish());
        pstmt.setInt(4, sVO.getTotal());
        pstmt.setInt(5, sVO.getAverage());
        pstmt.setString(6, sVO.getName());
        flag = pstmt.executeUpdate();
    }catch(SQLException e) {
        e.printStackTrace();
    }//end catch
    return flag;
}//updateScore
```
```jsp
<%@page import="scoredao.ScoreDAO"%>
<%@page import="scoreVO.ScoreVO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String name = request.getParameter("name");
	int korea = Integer.parseInt(request.getParameter("korea"));
	int math = Integer.parseInt(request.getParameter("math"));
	int english = Integer.parseInt(request.getParameter("english"));
	int total = korea + math + english;
	int average = total / 3;	
	
	ScoreVO sVO = new ScoreVO(name,korea,math,english,total,average);
	ScoreDAO sDAO = ScoreDAO.getInstance();
	int result = sDAO.updateScore(sVO);
%>
{"result":<%=result%>}
```

<br>

생성된 tr에 click이벤트를 추가하여 tr이 선택되면 tr의 각 td의 값이 input 태그에 text값으로 들어갑니다. 거기서 점수를 수정한 후 성적 수정 버튼을 누르면 ajax통신을 하여 성적이 수정되고 바로 조회가 되는 것을 확인 할 수 있습니다.

<br>

#### DELETE

```javascript
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
```
```java
public int deleteScore(String name) {
    int flag = -1;
    String sql="DELETE FROM SCORE WHERE NAME = ?";
    try(Connection con = sDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
        pstmt.setString(1, name);
        flag = pstmt.executeUpdate();
    }catch(SQLException e) {
        e.printStackTrace();
    }//end catch
    return flag;
}//deleteScore
```
```jsp
<%@page import="scoredao.ScoreDAO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String name = request.getParameter("name");
	ScoreDAO sDAO = ScoreDAO.getInstance();
	int result = sDAO.deleteScore(name);
%>

{"result":<%=result%>}
```

<br>

사용자의 이름을 입력하고 성적 삭제 버튼을 누르면 ajax통신을 서버와 연결을 하여 해당 학생의 성적 정보를 삭제한 후 성적을 조회해줍니다.

