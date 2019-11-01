<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>  
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>



<script>

	function updateReservation(userinput,roomnumber){
		if(!document.getElementById("roomnumber"+roomnumber).value){
			alert("방번호를 입력해주세요");
			return false;
		}
		if(!document.getElementById("re_id"+roomnumber).value){
			alert("예약자 아이디를 입력해주세요");
			return false;
		}
		if(!document.getElementById("re_name"+roomnumber).value){
			alert("기준 인원수를 입력해주세요");
			return false;
		}
		if(!document.getElementById("re_name"+roomnumber).value){
			alert("핸드폰 번호를 입력해주세요");
			return false;
		}
		if(!document.getElementById("usepeople"+roomnumber).value){
			alert("사용 인원을 입력해주세요");
			return false;
		}
		if(!document.getElementById("price"+roomnumber).value){
			alert("추가 금액을 입력해주세요");
			return false;
		}
		if(!document.getElementById("daterange"+roomnumber).value){
			alert("사용 기간을 입력해주세요");
			return false;
		}
		if(!document.getElementById("usingday"+roomnumber).value){
			alert("숙박일 수 입력해주세요");
			return false;
		}
		if(!document.getElementById("roomname"+roomnumber).value){
			alert("방 이름을 입력해주세요");
			return false;
		}
		if(!document.getElementById("startday"+roomnumber).value){
			alert("시작 날짜를 입력해주세요");
			return false;
		}
		if(!document.getElementById("endday"+roomnumber).value){
			alert("종료 날짜를 입력해주세요");
			return false;
		}
		if(!document.getElementById("reg_date"+roomnumber).value){
			alert("등록 날짜를 입력해주세요");
			return false;
		}
		if(!document.getElementById("paymentmethod"+roomnumber).value){
			alert("결제 방식을 입력해주세요");
			return false;
		}
		if(!document.getElementById("chkpayment"+roomnumber).value){
			alert("결제 여부를 입력해주세요");
			return false;
		}
		
		userinput.action="checkClientReservationPro.jsp?type=update"
			+"&roomnumber="+document.getElementById("roomnumber"+roomnumber).value
			+"&re_id="+document.getElementById("re_id"+roomnumber).value
			+"&re_name="+document.getElementById("re_name"+roomnumber).value
			+"&re_phone="+document.getElementById("re_phone"+roomnumber).value
			+"&usepeople="+document.getElementById("usepeople"+roomnumber).value
			+"&roomname="+document.getElementById("roomname"+roomnumber).value
			+"&price="+document.getElementById("price"+roomnumber).value
			+"&daterange="+document.getElementById("daterange"+roomnumber).value
			+"&usingday="+document.getElementById("usingday"+roomnumber).value
			+"&startday="+document.getElementById("startday"+roomnumber).value 
			+"&endday="+document.getElementById("endday"+roomnumber).value 
			+"&paymentmethod="+document.getElementById("paymentmethod"+roomnumber).value 
			+"&chkpayment="+document.getElementById("chkpayment"+roomnumber).value 
			+"&re_email="+document.getElementById("re_email"+roomnumber).value 
			
		userinput.submit();
	}
	
	function deleteReservation(userinput,roomnumber){
		if(!confirm("예약을 삭제 하겠습니까?") ){
			return;
		}
		if(!document.getElementById("roomnumber"+roomnumber).value){
			alert("문제가 발생했으니 다시 시도해주세요.");
		}
		userinput.action="checkClientReservationPro.jsp?type=delete"
			+"&re_name="+document.getElementById("re_name"+roomnumber).value
			+"&re_phone="+document.getElementById("re_phone"+roomnumber).value
			+"&roomname="+document.getElementById("roomname"+roomnumber).value
			+"&roomnumber="+document.getElementById("roomnumber"+roomnumber).value
		userinput.submit();
	}
</script>

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
