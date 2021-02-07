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