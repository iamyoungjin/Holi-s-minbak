<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@page import="java.util.*" %>
<%@page import="test.web.calendar.ReservationDAO"%>


<jsp:useBean id="vo" class="test.web.calendar.ReservationVO"/>
<jsp:setProperty property="*" name="vo"/>


<%
	int res = 0; 
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
		<script>
			alert("권한이 없습니다.");
			history.go(-1);
		</script>
<%	}else{
		ReservationDAO dao = new ReservationDAO();
		String type = request.getParameter("type");
		
		//insert 
		if(type.equals("update")){
			dao.paycheck(vo.getRoomnumber(),vo.getRe_name());
			response.sendRedirect("checkClientReservation.jsp");
		}else if(type.equals("delete")){
			dao.remove(vo.getRoomnumber(),vo.getRe_name());
			response.sendRedirect("checkClientReservation.jsp");
		}else if(type.equals("refund")){
			res = dao.cancelRsv(vo.getRoomnumber(), vo.getRe_name());
			if(res==1){%>
				<script>
					alert("환불이 완료되었습니다.");
					window.location.href="checkclientReservation.jsp";
				</script>
			<%}else{%>
				<script>
					alert("에러가 발생했습니다. 다시 시도해주세요.");
					window.location.href="checkclientReservation.jsp";
				</script>
			<%}
		}else if(type.equals("cancel")){
			res = dao.refundRsv(vo.getRoomnumber(), vo.getRe_name());
			if(res==1){%>
				<script>
					alert("취소가 완료되었습니다.");
					window.location.href="checkclientReservation.jsp";
				</script>
			<%}else{%>
				<script>
					alert("에러가 발생했습니다. 다시 시도해주세요.");
					window.location.href="checkclientReservation.jsp";
				</script>
			<%}
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