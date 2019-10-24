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
	String id = "naver_"+request.getParameter("id");
	String email = request.getParameter("email");
	String name = request.getParameter("name");
	boolean chk = dao.insertNaver(id, email, name);
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