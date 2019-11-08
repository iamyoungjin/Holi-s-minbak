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
	String currentTime = request.getParameter("currentTime");
	int roomnumber = Integer.parseInt(request.getParameter("roomnumber"));
	String re_id = request.getParameter("re_id");
	String sId = (String)session.getAttribute("sId");
	
	if(sId == null){%>
		<script>
			alert("잘못된 접근입니다. 로그인 후 접근해주세요");
			history.go(-1);
		</script>
	<%}else{
		// 세션은 있으나, 세션값이 예약자와 일치하지 않을경우 if문으로 뒤로간다
		if(!sId.equals(re_id)){%>
			<script>
				alert("예약 취소에 문제가 발생했습니다. 다시 접근해주세요.");
				history.go(-1);
			</script>
		<%}else{
			ReservationDAO dao = new ReservationDAO();
			int res = dao.cancelReservation(re_id, roomnumber,currentTime);
			// cancelReservation 메서드를 실행, 예약자, 예약번호, 현재 시간을 매개변수로 사용한다
			
			// 정상적으로 메서드가 작동시 res값은 1, currentTime이 예약일에서 하루 이내일 경우 res값이 2, 메서드가 정상적으로 작동안할시 0
			if(res==1){%>
				<script>
					alert("예약이 취소되었습니다.");
					window.location.href="showreservation.jsp";
				</script>
<%			}else if(res==2){%>
				<script>
					alert("예약 하루 전날은 취소할 수 없습니다. 문의게시판을 이용하거나 글을 써주세요");
					window.location.href="showreservation.jsp";
				</script>
<%			}else if(res==0){%>
				<script>
					alert("예약 취소 도중 에러가 발생했습니다. 다시시도해주세요");
					history.go(-1);
				</script>
			<%}else{
				
			}
			
		}
	}
%>



</body>
</html>