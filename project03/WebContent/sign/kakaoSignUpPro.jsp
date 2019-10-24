<%@page import="test.web.project03.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<%
	MemberDAO dao = MemberDAO.getInstance();
	String id = request.getParameter("id");
	boolean chk = dao.insertKakao(id);
	
	if(chk){%>
		<script>
			alert("회원 가입이 완료되었습니다.");
			window.location.href="../main/main.jsp";
		</script>
	<%}else{%>
		<script>
			alert("중복된 아이디가 있습니다.");
			window.location.href="signUpMain.jsp";
		</script>
	<%}
%>
<body>
</body>
</html>