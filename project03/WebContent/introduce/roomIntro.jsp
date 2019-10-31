<%@page import="java.util.List"%>
<%@page import="test.web.project03.RoomDTO"%>
<%@page import="test.web.project03.RoomDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>방 소개</title>
</head>
<body>
<!-- 방 소개 페이지 -->
<header>
	<%@ include file="../main/header.jsp" %>
</header>
<%
	RoomDAO dao = RoomDAO.getInstance();
	List roomList = dao.showRoom();
	if(roomList == null){%>
		<h1>현재 등록된 방이 없습니다!</h1>
	<%}else{
%>
<aside>
	<ul>
<%
	for(int i=0; i<roomList.size(); i++){
		RoomDTO dto = (RoomDTO)roomList.get(i);
	%>
		<li><a href="roomIntro.jsp?num=<%=dto.getNum()%>"><%=dto.getRname()%></a>
		</li>	
	<%}
%>
	</ul>
</aside>
<section>
<%
	String roomnum = request.getParameter("num");
	if(roomnum == null){
		roomnum = "1";
	}
	RoomDTO dto = dao.getRoomData(Integer.parseInt(roomnum));
%>
	<table border="1">
		<tr>
			<td colspan="3"><img src="../image/<%=dto.getRoom_img()%>"/>  </td>
		</tr>
		<tr>
			<td colspan="3"><pre><%=dto.getIntro() %></pre></td>
		</tr>
	</table>
	<table>
		<tr>
			<td colspan="3"><%=dto.getRname() %></td>
		</tr>
		<tr >
			<td>기준인원 <%=dto.getDpeople()%><br/>
				최대인원 <%=dto.getMaxpeople() %>
			</td>
			<td>
				<table style="width:150px; height:100px">
					<tr>
						<td colspan="2">객실 요금표</td>
					</tr>
					<tr>
						<td>주중</td>
						<td><%=dto.getWeekday_price() %></td>
					</tr>
					<tr>
						<td>주말</td>
						<td><%=dto.getWeekend_price() %></td>
					</tr>
					<tr>
						<td>성수기</td>
						<td><%=dto.getPeakseason_price() %></td>
					</tr>
				</table>
			</td>
			<td>예약 안내<br/>
				<input type="button" value="예약하기" onclick="window.location.href='../reservation/reservationCalendar.jsp'"/>	
			</td>
		</tr>
	</table>
</section>

</body>
<%} %>
<footer>
	<%@ include file="../main/footer.jsp" %>
</footer>
</html>