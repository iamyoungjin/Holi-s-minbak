<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %> 
<% 
request.setCharacterEncoding("UTF-8");
String re_name = (String)(session.getAttribute("s_re_name"));
String re_phone= (String)session.getAttribute("s_re_phone");
String roomname = (String)(session.getAttribute("s_roomname"));
                //String str = "check";
                //session.setAttribute("s_chkpayment",str);
                ReservationDAO dao = new ReservationDAO();
                dao.paycancel(re_name,re_phone,roomname);
%>
<script>
	window.location="../main/main.jsp";
</script>