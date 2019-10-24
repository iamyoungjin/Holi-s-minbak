<%@page import="test.web.project03.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이 페이지</title>
</head>
<%
	String sId = (String)session.getAttribute("sId");
	if(sId == null){%>
		<script>
			alert("잘못된 접근입니다.");
			history.go(-1);
		</script>
	<%}else{
		MemberDAO dao = MemberDAO.getInstance();
		String name = dao.searchName(sId);
	%>
<body>
	<table>
		<tr><td colspan="4"><%=name %>님의 마이페이지	</tr>
		<tr>
			<td><a href="">예약 확인</a></td>
			<td><a href="modifyForm.jsp">회원 정보 수정</a></td>
			<td><a href="deleteForm.jsp">회원 탈퇴</a></td>
			<td><a href="../main/main.jsp">메인으로</a></td>
		</tr>
	</table>
</body>
	<%}
%>
</html>