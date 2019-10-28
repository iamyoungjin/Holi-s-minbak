<%@page import="test.web.calendar.ReservationDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 취소</title>
</head>
<body>
<%
	int roomnumber = Integer.parseInt(request.getParameter("roomnumber"));
	String re_id = request.getParameter("re_id");
	String sId = (String)session.getAttribute("sId");
	if(sId == null){%>
		<script>
			alert("잘못된 접근입니다. 로그인 후 접근해주세요");
			history.go(-1);
		</script>
	<%}else{
		if(!sId.equals(re_id)){%>
			<script>
				alert("예약 취소에 문제가 발생했습니다. 다시 접근해주세요.");
				history.go(-1);
			</script>
		<%}else{
			ReservationDAO dao = new ReservationDAO();
			boolean chk = dao.cancleReservation(re_id, roomnumber);
			if(chk){%>
				<script>
					alert("성공적으로 삭제되었습니다.");
					window.location.href="showreservation.jsp";
				</script>
			<%}else{%>
				<script>
					alert("삭제 도중 에러가 발생했습니다. 다시시도해주세요");
					history.go(-1);
				</script>
			<%}
			
		}
	}
%>



</body>
</html>