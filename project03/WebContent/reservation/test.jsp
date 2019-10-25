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
String startday= "2019/10/24";
String endday = "2019/10/30";
ReservationVO vo = new ReservationVO();
List dates = vo.middate(startday,endday);
List arr = new ArrayList();
for(int i=0;i<dates.size();i++){
	System.out.println(dates.get(i).toString());
}
%>
