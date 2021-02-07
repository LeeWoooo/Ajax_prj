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
