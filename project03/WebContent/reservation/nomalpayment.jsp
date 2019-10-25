<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "test.web.calendar.ReservationDAO" %>  
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
	String chkpayment=(String)session.getAttribute("s_chkpayment");
	String paymentmethod = (String)session.getAttribute("s_paymentmethod");
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
	ReservationDAO dao = new ReservationDAO();
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
	dao.reservation(vo);
%>	

<h1>무통장 입금</h1>  계좌번호: (신한)110-351-111123<br/>
<h5>24시간내로 입금이 완료되어야 하며, 입금 확인이 안되면 예약 요청은 취소됩니다. </h5>
<%= roomname%>
<%= price%> 으로 예약 되었습니다. 
 <input type="button" value="메인으로 돌아가기" OnClick="window.location='../main/main.jsp'">