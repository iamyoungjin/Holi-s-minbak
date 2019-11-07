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
<jsp:useBean id="dto" class="test.web.project03.MemberDTO"/>
<jsp:setProperty property="*" name="dto" />
<%	
	// form 페이지에서 넘어온 정보를 바탕으로 dao메서드를 사용하고 가입시킨다.
	MemberDAO dao = MemberDAO.getInstance();
	if(dao.insert(dto)){%>
	<script>
		alert("회원가입 완료");
		window.location.href="../main/main.jsp"
	</script>
	<%}else{%>
	<script>
		alert("가입에 문제가 발생했습니다.");
		history.go(-1);
	</script>
	<%}
%>
<body>
	
</body>
</html>