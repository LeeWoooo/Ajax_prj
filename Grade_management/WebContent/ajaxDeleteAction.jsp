<%@page import="scoredao.ScoreDAO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String name = request.getParameter("name");
	ScoreDAO sDAO = ScoreDAO.getInstance();
	int result = sDAO.deleteScore(name);
%>

{"result":<%=result%>}