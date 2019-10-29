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
    val = "'"+val+"'";
	ReservationDAO dao = new ReservationDAO();
	List userlist = dao.reservation_search(method,val);
	
%>
		<form name="roomForm" method="post">
		<table border="1">
			<tr>
				<td>예약 번호</td>
				<td>예약 ID</td>
				<td>예약자명</td>
				<td>핸드폰번호 </td>
				<td>e-mail </td>
				
				<td>사용 인원</td>
				<td>방 이름</td>
				<td>총 가격</td>
				<td>사용 기간</td>
				<td>숙박 일수</td>
				<td>입실 일자</td>
				<td>퇴실 일자</td> 
				<td>예약신청 날짜</td>
				<td>결제 방식</td>
				<td>결제 유무</td>
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
						<td><input type="text" id="usepeople<%=i%>" name="usepeople<%=i%>" value="<%=vo.getUsepeople()%>" /></td>
						<td><input type="text" id="roomname<%=i%>" name="roomname<%=i%>" value="<%=vo.getRoomname()%>" /></td>
						<td><input type="text" id="price<%=i%>" name="price<%=i%>" value="<%=vo.getPrice()%>"/></td>
						<td><input type="text" id="daterange<%=i%>" name="daterange<%=i%>" value="<%=vo.getDaterange()%>"/></td>
						<td><input type="text" id="usingday<%=i%>" name="usingday<%=i%>" value="<%=vo.getUsingday()%>"/></td>
						<td><input type="text" id="startday<%=i%>" name="startday<%=i%>" value="<%=vo.getStartday()%>"/></td>
						<td><input type="text" id="endday<%=i%>" name="endday<%=i%>" value="<%=vo.getEndday()%>"/></td>
						<td><input type="text" id="reg_date<%=i%>" name="reg_date<%=i%>" value="<%=vo.getReg_date()%>"/></td>
						<td><input type="text" id="paymentmethod<%=i%>" name="paymentmethod<%=i%>" value="<%=vo.getPaymentmethod()%>"/></td>
						<td><input type="text" id="chkpayment<%=i%>" name="chkpayment<%=i%>" value="<%=vo.getChkpayment()%>"/></td>
						<td>
							<input type="button" value="결제 확인" onclick="updateReservation(this.form,<%=i%>)"/>
							<input type="button" value="예약 강제 삭제" onclick="deleteReservation(this.form,<%=i%>)"/>
						</td>
				<%}%>
			<%}else{ %>
					<td colspan = 15'>해당 데이터가 없습니다</td>
				</tr>
				</table>
			<%} %>
		</form>
