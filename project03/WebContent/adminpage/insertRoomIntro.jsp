<%@page import="test.web.project03.RoomDTO"%>
<%@page import="test.web.project03.RoomDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 방 추가 페이지 -->
<%

	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
		<script>
			alert("잘못된 접근입니다");
			history.go(-1);
		</script>
	<%}else{
	int roomnum = Integer.parseInt(request.getParameter("num"));
	RoomDAO dao = RoomDAO.getInstance();
	RoomDTO dto = dao.getRoomData(roomnum);
	String oldImage = dto.getRoom_img();
%>
<title><%=dto.getRname() %></title>
</head>
<body>
<form name="updateRoomIntro" method="post" enctype="multipart/form-data" action="insertRoomIntroPro.jsp?num=<%=roomnum%>">
	<table border="1">
		<tr>
			<td>방 번호 : <%=dto.getNum() %> </td>
			<td>방 이름 : <%=dto.getRname() %></td>
		</tr>
		<tr>
			<td colspan="2">내용 <textarea rows="13" cols="40" name="intro"><%=dto.getIntro() %></textarea> </td>
		</tr>
		<tr>
			<td>사진 업로드 : <% if(oldImage!=null)out.print(oldImage); %> <input type="file" name="save"/>
			<input type="hidden" name="oldImage" value="<%=dto.getRoom_img()%>"/><br/> </td>
		</tr>
		<tr>
			<td>
			<input type="submit" value="글수정"/>
			<input type="reset" value="다시작성"/>
			<input type="button" value="목록으로" onclick="window.location.href='checkRoomData.jsp'"/>
			</td>
		</tr>
	</table>
</form>
<%} %>
</body>
</html>