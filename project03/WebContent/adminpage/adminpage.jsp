<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
</head>
<header>
	<%@ include file="../main/header.jsp" %>
</header>

<%
	// 기본 관리자 페이지
	boardType="admin";
	sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
		<script>
			alert("권한이 없습니다.");
			history.go(-1);
		</script>
	<%}else{%>
		<h2>관리자 페이지</h2>
		<ul>
			<li><a href="checkClientData.jsp">회원 관리 페이지</a></li>
			<li><a href="checkBoard.jsp">게시판 관리 페이지</a></li>
			<li><a href="checkRoomData.jsp">객실 관리 페이지</a></li>
			<li><a href="checkClientReservation.jsp">예약 관리 페이지</a></li>
			<li><a href="accounting.jsp">수입 관리 페이지</a></li>
			<li><a href="../main/main.jsp">메인으로</a></li>
		</ul>
		
	<%}

%>
<body>

</body>
</html>