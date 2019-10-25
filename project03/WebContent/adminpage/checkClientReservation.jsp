<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="test.web.project03.RoomDTO"%>
<%@page import="java.util.List"%>
<%@page import="test.web.project03.RoomDAO"%>
<%@page import="test.web.calendar.ReservationVO"%>
<%@page import="test.web.calendar.ReservationDAO"%>
<!DOCTYPE html>
<title>예약 관리 페이지</title>
<html>
<head>
<meta charset="UTF-8">
<title>예약 정보</title>
<script>
	function updateRoom(userinput,num){
		if(!document.getElementById("num"+num).value){
			alert("방번호를 입력해주세요");
			return false;
		}
		if(!document.getElementById("rname"+num).value){
			alert("방 이름을 입력해주세요");
			return false;
		}
		if(!document.getElementById("dpeople"+num).value){
			alert("기준 인원수를 입력해주세요");
			return false;
		}
		if(!document.getElementById("maxpeople"+num).value){
			alert("최대 인원수를 입력해주세요");
			return false;
		}
		if(!document.getElementById("addtionalcost"+num).value){
			alert("추가 금액을 입력해주세요");
			return false;
		}
		if(!document.getElementById("weekday_price"+num).value){
			alert("주중 가격을 입력해주세요");
			return false;
		}
		if(!document.getElementById("weekend_price"+num).value){
			alert("주말 가격을 입력해주세요");
			return false;
		}
		if(!document.getElementById("peakseason_price"+num).value){
			alert("성수기 가격을 입력해주세요");
			return false;
		}
		
		userinput.action="checkRoomPro.jsp?type=update"
			+"&num="+document.getElementById("num"+num).value
			+"&rname="+encodeURI(document.getElementById("rname"+num).value)
			+"&dpeople="+document.getElementById("dpeople"+num).value
			+"&maxpeople="+document.getElementById("maxpeople"+num).value
			+"&addtionalcost="+document.getElementById("addtionalcost"+num).value
			+"&weekday_price="+document.getElementById("weekday_price"+num).value
			+"&weekend_price="+document.getElementById("weekend_price"+num).value
			+"&peakseason_price="+document.getElementById("peakseason_price"+num).value ;
		userinput.submit();
	}
	
	function deleteRoom(userinput,num){
		if(!confirm("객실을 삭제 하겠습니까?") ){
			return;
		}
		if(!document.getElementById("num"+num).value){
			alert("문제가 발생했으니 다시 시도해주세요.");
		}
		userinput.action="checkRoomPro.jsp?type=delete"
			+"&num="+document.getElementById("num"+num).value;
		userinput.submit();
	}

	
	function insertRoom(userinput){
		if(!userinput.newnum.value){
			alert("방 번호를 입력해주세요");
			return false;
		}
		if(!userinput.newrname.value){
			alert("방 이름을 입력해주세요");
			return false;
		}
		if(!userinput.newdpeople.value){
			alert("기준 인원수를 입력해주세요");
			return false;
		}
		if(!userinput.newmaxpeople.value){
			alert("최대 인원수를 입력해주세요");
			return false;
		}
		if(!userinput.newaddtionalcost.value){
			alert("추가 금액을 입력해주세요");
			return false;
		}
		if(!userinput.newweekday_price.value){
			alert("주중 가격을 입력해주세요");
			return false;
		}
		if(!userinput.newweekend_price.value){
			alert("주말 가격을 입력해주세요");
			return false;
		}
		if(!userinput.newpeakseason_price.value){
			alert("성수기 가격을 입력해주세요");
			return false;
		}
		userinput.action="checkRoomPro.jsp?type=insert"
						+"&num="+userinput.newnum.value
						+"&rname="+encodeURI(userinput.newrname.value)
						+"&dpeople="+userinput.newdpeople.value
						+"&maxpeople="+userinput.newmaxpeople.value
						+"&addtionalcost="+userinput.newaddtionalcost.value
						+"&weekday_price="+userinput.newweekday_price.value
						+"&weekend_price="+userinput.newweekend_price.value
						+"&peakseason_price="+userinput.newpeakseason_price.value
		userinput.submit();
	}

</script>

</head>
<%
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
		<script>
			alert("권한이 없습니다.");
			history.go(-1);
		</script>
<%	}else{
		ReservationDAO dao = new ReservationDAO();
		List list = dao.reservation_list();%>
		
		
	<form name="roomForm" method="post">
		<table border="1">
			<tr>
				<td>예약 번호</td>
				<td>예약 ID</td>
				<td>예약자명</td>
				<td>사용 인원</td>
				<td>총 가격</td>
				<td>사용 기간</td>
				<td>숙박 일수</td>
				<td>입실 일자</td>
				<td>퇴실 일자</td>
				<td>예약신청 날짜</td>
				<td>결제 방식</td>
				<td>결제 유무</td>
			</tr>
			<%for(int i=0; i<list.size(); i++ ){
				ReservationVO vo = (ReservationVO)list.get(i);
			%>
				<tr>
					<td><input type="text" id="roomnumber<%=i%>" name="roomnumber<%=i%>" value="<%=vo.getRoomnumber()%>" readonly/></td>
					<td><input type="text" id="re_id<%=i%>" name="re_id<%=i%>" value="<%=vo.getRe_id()%>"/></td>
					<td><input type="text" id="re_name<%=i%>" name="re_name<%=i%>" value="<%=vo.getRe_name()%>"/></td>
					<td><input type="text" id="usepeople<%=i%>" name="usepeople<%=i%>" value="<%=vo.getUsepeople()%>"/></td>
					<td><input type="text" id="price<%=i%>" name="price<%=i%>" value="<%=vo.getPrice()%>"/></td>
					<td><input type="text" id="daterange<%=i%>" name="daterange<%=i%>" value="<%=vo.getDaterange()%>"/></td>
					<td><input type="text" id="usingday<%=i%>" name="usingday<%=i%>" value="<%=vo.getUsingday()%>"/></td>
					<td><input type="text" id="startday<%=i%>" name="startday<%=i%>" value="<%=vo.getStartday()%>"/></td>
					<td><input type="text" id="endday<%=i%>" name="endday<%=i%>" value="<%=vo.getEndday()%>"/></td>
					<td><input type="text" id="reg_date<%=i%>" name="reg_date<%=i%>" value="<%=vo.getReg_date()%>"/></td>
					<td><input type="text" id="paymentmethod<%=i%>" name="paymentmethod<%=i%>" value="<%=vo.getPaymentmethod()%>"/></td>
					<td><input type="text" id="chkpayment<%=i%>" name="chkpayment<%=i%>" value="<%=vo.getChkpayment()%>"/></td>
					
					<td>
						<input type="button" value="객실 수정" onclick="updateRoom(this.form,<%=i%>)"/>
						<input type="button" value="객실 삭제" onclick="deleteRoom(this.form,<%=i%>)"/>
					</td>
				</tr>
			<%}%>
		</table>
	</form>
	<form>
		<table border="1">
			<tr>
				<td colspan="9" text-align="center"><b>객실 추가</b></td>
			</tr>
			<tr>
				<td>객실 번호</td>
				<td>객실 이름</td>
				<td>기준 인원수</td>
				<td>최대 인원수</td>
				<td>추가 금액</td>
				<td>주중 가격</td>
				<td>주말 가격</td>
				<td>성수기 가격</td>
				<td>추가</td>
			</tr>
			<tr>
				<td><input type="text" name="newnum"/></td>
				<td><input type="text" name="newrname"/></td>
				<td><input type="text" name="newdpeople"/></td>
				<td><input type="text" name="newmaxpeople"/></td>
				<td><input type="text" name="newaddtionalcost"/></td>
				<td><input type="text" name="newweekday_price"/></td>
				<td><input type="text" name="newweekend_price"/></td>
				<td><input type="text" name="newpeakseason_price"/></td>
				<td><input type="button" value="객실 추가" onclick="insertRoom(this.form)" /></td>
			</tr>
		</table>
	</form>
	<input type="button" value="돌아가기" onclick="window.location.href='adminpage.jsp'"/>			
	<%}
%>
<body>

</body>
</html>