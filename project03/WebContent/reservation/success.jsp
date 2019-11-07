<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %> 
<% 
request.setCharacterEncoding("UTF-8");

int roomnumber = Integer.parseInt(request.getParameter("num"));
String re_name = (String)(session.getAttribute("s_re_name"));
String re_phone= (String)session.getAttribute("s_re_phone");
String roomname = (String)(session.getAttribute("s_roomname"));
                ReservationDAO dao = new ReservationDAO();
                dao.paycheck(roomnumber,re_name);
%>

<h2>예약 결제가 완료되었습니다.</h2>
<a href="../main/main.jsp" > 메인으로 돌아가기 </a>