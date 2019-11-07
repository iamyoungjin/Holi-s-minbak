<%@page import="test.web.project03.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	MemberDAO dao = MemberDAO.getInstance();
	// 콜백 페이지에서 보낸 정보를 변수에 담고, 해당 정보들을 이용해 dao의 메서드 사용
	String id = "naver_"+request.getParameter("id");
	String email = request.getParameter("email");
	String name = request.getParameter("name");
	boolean chk = dao.insertNaver(id, email, name);
	// 이후 메서드의 작동 여부에 따라 메세지 출력
	if(chk){%>
		<script>
			alert("회원 가입에 성공하였습니다.");
			window.location.href="../main/main.jsp";
		</script>
	<%}else{%>
		<script>
			alert("이미 가입된 아이디입니다.");
			window.location.href="signUpMain.jsp";
		</script>
	<%}
%>
</body>
</html>