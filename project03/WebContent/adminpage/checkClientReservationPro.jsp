<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@page import="test.web.calendar.ReservationDAO"%>

<title>예약 관</title>

<jsp:useBean id="vo" class="test.web.calendar.ReservationVO"/>
<jsp:setProperty property="*" name="vo"/>
<%
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
		<script>
			alert("권한이 없습니다.");
			history.go(-1);
		</script>
<%	}else{
		ReservationDAO dao = new ReservationDAO();
		String type = request.getParameter("type");
		if(type.equals("insert")){
			boolean chk = dao.insertRoom(vo);
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