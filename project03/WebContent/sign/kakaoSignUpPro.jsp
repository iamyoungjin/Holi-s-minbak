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
	// form페이지에서 받아온 oauth 데이터를 변수에 담고, dao의 메서드를 실행한다
	boolean chk = dao.insertKakao(id);
	// 이후 chk 값에 따라서 메세지를 전송
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