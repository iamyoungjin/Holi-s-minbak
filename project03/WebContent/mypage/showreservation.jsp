<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="test.web.calendar.ReservationVO"%>
<%@page import="test.web.calendar.ReservationDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약확인 페이지</title>
</head>
<header>
	<%@ include file="../main/header.jsp" %>
</header>

<%
	sId = (String)session.getAttribute("sId");
	if(sId == null){%>
		<script>
			alert("잘못된 접근입니다.");
			history.go(-1);
		</script>	
	<%}else{
		ReservationDAO dao = new ReservationDAO();
		
		List list = dao.reservation_user(sId);
		// 해당 유저의 예약정보를 받아온다.
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
		String currentTime = sdf.format(new Date());
		//현재 시간을 String 타입으로 담아둔다
		
		if(list.size()==0){
			out.print("예약 내역이 없습니다.");
		}else if(list.size()>0){%>
			<form>
			<table border="1">
				<tr>
					<td>예약한 방</td>
					<td>예약자 명</td>
					<td>예약 인원</td>
					<td>예약 기간</td>
					<td>결제 금액</td>
					<td>예약 신청일</td>
					<td>결제 방식</td>
					<td>결제 확인</td>
				</tr>
				<%for(int i=0; i<list.size(); i++){
					ReservationVO vo = (ReservationVO)list.get(i);%>
				<tr>
					<td><%= vo.getRoomname() %></td>
					<td><%= vo.getRe_name() %></td>
					<td><%= vo.getUsepeople() %></td>
					<td><%= vo.getDaterange() %></td>
					<td><%= vo.getPrice() %></td>
					<td><%= vo.getReg_date() %></td>
					<td><%= vo.getPaymentmethod() %></td>
					<td><%= vo.getChkpayment() %></td>
					<%if(dao.checkCanclePossible(vo) == 1 ){
					//dao의 메서드로, 현재시간과 비교해 취소가 가능한 시간일때 button 이 생성되게 한다 
					%>
					<td><input type="button" value="예약취소" onclick="location.href=
					'showReservationPro.jsp?roomnumber=<%=vo.getRoomnumber()%>&re_id=<%=vo.getRe_id()%>&currentTime=<%=currentTime%>'"/></td>
					<%
					// 취소가 가능할 경우, onclick을 통해 Pro페이지로 넘어간다.
					} %>
				</tr>
					<%
					// 입금대기+무통장입금으로 예약 진행시 입금정보를 띄워준다.
					if(vo.getChkpayment().equals("waiting") && vo.getPaymentmethod().equals("bank")){%>
					<tr>
						<td colspan="7" text-align="center"> (신한)110-351-111123 으로 입금 바랍니다. </td>
					</tr>
					<%}%>
				<%}%>
			</table>
			</form>
		<%}%>
		<input type="button" value="돌아가기" onclick="window.location.href='mypage.jsp'"/>
	<%}
%>
</html>