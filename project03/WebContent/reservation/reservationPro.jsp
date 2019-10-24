<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="test.web.calendar.ReservationVO" %>
<%@page import="test.web.calendar.ReservationDAO" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List" %>

<%
	request.setCharacterEncoding("UTF-8");
	String re_id = (String)session.getAttribute("s_re_id");
	String re_name = (String)(session.getAttribute("s_re_name"));
	String re_phone= (String)session.getAttribute("s_re_phone");
	String re_email = (String)(session.getAttribute("s_re_email"));
	String roomname = (String)session.getAttribute("s_roomname");
	String daterange = (String)session.getAttribute("s_daterange");
	int usepeople = (Integer)session.getAttribute("s_usepeople");
	int price = (Integer)session.getAttribute("s_price");
	String paymentmethod = (String)session.getAttribute("s_paymentmethod");
	String chkpayment = (String)session.getAttribute("s_chkpayment");	
	
	int year = (Integer)session.getAttribute("s_year");
	int month = (Integer)session.getAttribute("s_month");
	int day = (Integer)session.getAttribute("s_day");
	int usingday = (Integer)session.getAttribute("s_usingday");
	String startday = (String)session.getAttribute("s_startday");
	String endday = (String)session.getAttribute("s_endday");
%>


<jsp:useBean id = "vo" class="test.web.calendar.ReservationVO"/> 
<jsp:setProperty property="*" name="vo"/>

<%
	vo.setRe_id(re_id);
	vo.setRe_name(re_name);
	vo.setRe_phone(re_phone);
	vo.setRe_email(re_email);
	vo.setRoomname(roomname);
	vo.setDaterange(daterange);
	vo.setUsepeople(usepeople);
	vo.setPrice(price);
	vo.setPaymentmethod(paymentmethod);
	vo.setChkpayment(chkpayment);
	vo.setYear(year);
	vo.setMonth(month);
	vo.setDay(day);
	vo.setUsingday(usingday);
	vo.setStartday(startday);
	vo.setEndday(endday);
	
	ReservationDAO dao = new ReservationDAO(); 
	dao.reservation(vo);
	
%>	
<h2>예약 결제가 완료되었습니다.</h2>
<a href="../main/main.jsp" > 메인으로 돌아가기 </a>

		 