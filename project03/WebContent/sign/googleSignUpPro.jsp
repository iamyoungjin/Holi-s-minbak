<%@page import="test.web.project03.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	MemberDAO dao = MemberDAO.getInstance();
	String id = request.getParameter("id");
	String email = request.getParameter("email");
	
	// Form 에서 받아온 oauth 정보를 변수에 담아서 dao의 메서드를 실행
	boolean chk = dao.insertGoogle(id, email);
	// 이후 반환되는 값을 통해 메서드의 작동 여부를 파악후 메세지 출력
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