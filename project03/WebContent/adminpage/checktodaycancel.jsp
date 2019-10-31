<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="test.web.project03.RoomDTO"%>
<%@page import="java.util.List"%>
<%@page import="test.web.project03.RoomDAO"%>
<%@page import="test.web.calendar.ReservationVO"%>
<%@page import="test.web.calendar.ReservationDAO"%>

<%
	//오늘 날짜 
	Calendar c = Calendar.getInstance();
	String year = String.valueOf(c.get(Calendar.YEAR));
	String month=null;
	String day = null;
	if(c.get(Calendar.MONTH)+1<10){
		month = "0"+String.valueOf(c.get(Calendar.MONTH));
	}else{
		month = String.valueOf(c.get(Calendar.MONTH)+1);
	}
	if(c.get(Calendar.DAY_OF_MONTH)<10){
		day = "0"+String.valueOf(c.get(Calendar.DAY_OF_MONTH));	
	}else{
		day = String.valueOf(c.get(Calendar.DAY_OF_MONTH));	
	}
	String today =year+"/"+month+"/"+day;

	ReservationDAO dao = new ReservationDAO();
	//오늘 예약 /취소 건수 보여주기 
	List list = dao.countchktoday(today,"cancel");%>
	
			<table border="1">
			<tr>
				<td colspan="15" text-align="center"><b>오늘 입실 리스트</b></td>
			</tr>
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
	<% if(list.size() != 0){
		for(int i=0;i<list.size();i++){
			ReservationVO vo = (ReservationVO)list.get(i);%>
							<tr>
					<td><input type="text" id="roomnumber<%=i%>" name="roomnumber<%=i%>" value="<%=vo.getRoomnumber()%>" readonly/></td>
					<td><input type="text" id="re_id<%=i%>" name="re_id<%=i%>" value="<%=vo.getRe_id()%>" readonly/></td>
					<td><input type="text" id="re_name<%=i%>" name="re_name<%=i%>" value="<%=vo.getRe_name()%>" readonly/></td>
					<td><input type="text" id="re_phone<%=i%>" name="re_phone<%=i%>" value="<%=vo.getRe_phone()%>" readonly/></td>
					<td><input type="text" id="re_email<%=i%>" name="re_email<%=i%>" value="<%=vo.getRe_email()%>" readonly/></td>
					<td><input type="text" id="usepeople<%=i%>" name="usepeople<%=i%>" value="<%=vo.getUsepeople()%>" readonly /></td>
					<td><input type="text" id="roomname<%=i%>" name="roomname<%=i%>" value="<%=vo.getRoomname()%>" readonly/></td>
					<td><input type="text" id="price<%=i%>" name="price<%=i%>" value="<%=vo.getPrice()%>"readonly/></td>
					<td><input type="text" id="daterange<%=i%>" name="daterange<%=i%>" value="<%=vo.getDaterange()%>" readonly/></td>
					<td><input type="text" id="usingday<%=i%>" name="usingday<%=i%>" value="<%=vo.getUsingday()%>" readonly/></td>
					<td><input type="text" id="startday<%=i%>" name="startday<%=i%>" value="<%=vo.getStartday()%>" readonly/></td>
					<td><input type="text" id="endday<%=i%>" name="endday<%=i%>" value="<%=vo.getEndday()%>" readonly/></td>
					<td><input type="text" id="reg_date<%=i%>" name="reg_date<%=i%>" value="<%=vo.getReg_date()%>" readolny/></td>
					<td><input type="text" id="paymentmethod<%=i%>" name="paymentmethod<%=i%>" value="<%=vo.getPaymentmethod()%>" readonly/></td>
					<td><input type="text" id="chkpayment<%=i%>" name="chkpayment<%=i%>" value="<%=vo.getChkpayment()%>"/></td>
					
					<td>
						<input type="button" value="결제 확인" onclick="updateReservation(this.form,<%=i%>)"/>
						<input type="button" value="예약 강제 삭제" onclick="deleteReservation(this.form,<%=i%>)"/>
					</td>
				</tr>
			
		<%}
		}else{%>
				<td colspan="15">오늘 예약한 사람이 없습니다</td>
		</table>
	<%} %>