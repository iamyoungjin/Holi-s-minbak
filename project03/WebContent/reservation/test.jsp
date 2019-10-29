<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>  
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>

<h2>코드 테스트용 페이지</h2>

<%
Calendar c = Calendar.getInstance();
String year = String.valueOf(c.get(Calendar.YEAR));
String month=null;
String day = null;
if(c.get(Calendar.MONTH)<10){
	month = "0"+String.valueOf(c.get(Calendar.MONTH));
}else{
	month = String.valueOf(c.get(Calendar.MONTH));
}
if(c.get(Calendar.DAY_OF_MONTH)<10){
	day = "0"+String.valueOf(c.get(Calendar.DAY_OF_MONTH));	
}else{
	day = String.valueOf(c.get(Calendar.DAY_OF_MONTH));	
}
String today =year+"/"+month+"/"+day;
System.out.println(today);
%>
