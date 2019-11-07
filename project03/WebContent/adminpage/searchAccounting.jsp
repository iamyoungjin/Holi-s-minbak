<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="test.web.project03.RoomDTO"%>
<%@page import="java.util.List"%>
<%@page import="test.web.project03.RoomDAO"%>
<%@page import="test.web.calendar.ReservationVO"%>
<%@page import="test.web.calendar.ReservationDAO"%>
<script src= https://code.jquery.com/jquery-3.4.1.min.js></script>    

<h3>수정중</h3>
<% 	
    String method = request.getParameter("method");
    String val = request.getParameter("val");
    val = "'"+val+"'";
	ReservationDAO dao = new ReservationDAO();
	List userlist = dao.reservation_search(method,val);
	
%>
		<form name="roomForm" method="post">
		<table border="1">
			<tr>
				<td>산들방</td>
				<td>매화방</td>
				<td>들꽃방</td>
				<td>소나무방</td>
				<td>해뜰방</td>
				<td>민들레방</td>
			</tr>
			<%if(userlist.size() != 0){ %>
			<%System.out.println(userlist.size()); %>
				<%for(int i=0; i<userlist.size(); i++ ){
					ReservationVO vo =(ReservationVO)userlist.get(i);
				%>
					<tr>
						<td><input type="text" id="roomnumber<%=i%>" name="roomnumber<%=i%>" value="<%=vo.getRoomnumber()%>" readonly/></td>
						<td><input type="text" id="re_id<%=i%>" name="re_id<%=i%>" value="<%=vo.getRe_id()%>" readonly/></td>
						<td><input type="text" id="re_name<%=i%>" name="re_name<%=i%>" value="<%=vo.getRe_name()%>" readonly/></td>
						<td><input type="text" id="re_phone<%=i%>" name="re_phone<%=i%>" value="<%=vo.getRe_phone()%>" readonly/></td>
						<td><input type="text" id="re_email<%=i%>" name="re_email<%=i%>" value="<%=vo.getRe_email()%>" readonly/></td>
						<td><input type="text" id="re_email<%=i%>" name="re_email<%=i%>" value="<%=vo.getRe_email()%>" readonly/></td>

				<%}%>
			<%}else{ %>
					<td colspan = 15'>해당 데이터가 없습니다</td>
				</tr>
				</table>
			<%} %>
		</form>