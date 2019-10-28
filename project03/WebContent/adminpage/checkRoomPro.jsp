<%@page import="test.web.project03.RoomDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>객실 추가/수정/제거</title>
</head>
<jsp:useBean id="dto" class="test.web.project03.RoomDTO"/>
<jsp:setProperty property="*" name="dto"/>

<%
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
		<script>
			alert("권한이 없습니다.");
			history.go(-1);
		</script>
<%	}else{
		RoomDAO dao = RoomDAO.getInstance();
		String type = request.getParameter("type");
		
		if(type.equals("insert")){
			boolean chk = dao.insertRoom(dto);
			if(chk == false){%>
				<script>
					alert("방 번호나 방의 이름이 중복되었습니다.");
					history.go(-1);
				</script>
			<%}else{response.sendRedirect("checkRoomData.jsp");}
		}else if(type.equals("update")){
			dao.updateRoom(dto);
			response.sendRedirect("checkRoomData.jsp");
		}else if(type.equals("delete")){
			dao.deleteRoom(dto);
			response.sendRedirect("checkRoomData.jsp");
		}else{%>
			<script>
				alert("에러가 발생했습니다. 다시 시도해주세요.");
				history.go(-1);
			</script><%
		}%>
		
	<%}
%>
<body>


</body>
</html>