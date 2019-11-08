<%@page import="java.nio.charset.Charset"%>
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
	// DAO를 통해 방 정보를 가져오고, 정보가 있을시 리스트 형식으로 출력
	List roomList = dao.showRoom();
	if(roomList == null){%>
		<h1>현재 등록된 방이 없습니다!</h1>
	<%}else{
%>
<aside>
	<ul>
<%
	// 방 정보가 존재할시, for문을 통해 있는 만큼 반복하고, dto의 정보를 이용해 각 방의 num값을 가지고 roomIntro 페이지로 접근할 수 있는 a태그를 만든다
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
	// 위에서 만든 a태그를 통해 왔을시 가져오는 num의 값을 roomnum에 담는다.
	String roomnum = request.getParameter("num");
	// 만일, 이게 없을 경우 1로 지정
	if(roomnum == null){
		roomnum = "1";
	}
	// 위의 변수 roomnum으로 dao에서 방의 정보를 가져와서 아래에 출력한다.
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
				<%
					// rname을 인코딩 후, 아래의 button을 작동시킬시 해당 방을 예약할 수 있도록 rname을 가지고 reservationForm으로 가져간다.
					byte[] stringBuffer = dto.getRname().getBytes(Charset.forName("UTF-8"));
					String roomname = new String(stringBuffer, "UTF-8");
				%>
				<input type="button" value="예약하기" onclick="window.location.href='../reservation/reservationForm.jsp?roomname=<%=roomname%>'"/>
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