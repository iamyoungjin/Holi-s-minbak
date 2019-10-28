<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>  
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>
<% 
	String method = request.getParameter("method");
    String val = request.getParameter("val");
	ReservationDAO dao = new ReservationDAO();
	dao.reservation_search(method,val);
%>
<%= method %>
<%= val %>