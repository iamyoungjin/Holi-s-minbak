<%@page import="test.web.calendar.SetDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<jsp:useBean id="dto" class="test.web.calendar.SetDTO"/>

<%
	int pageSize = Integer.parseInt(request.getParameter("pageSize"));
	int imgSize = Integer.parseInt(request.getParameter("imgSize"));
	
	String sAdmin = (String)session.getAttribute("UTF-8");
	if(sAdmin == null){%>
		<script>
			alert("잘못된 접근입니다.");
			history.go(-1);
		</script>
	<%}else{
		SetDAO dao = SetDAO.getInstance();
		boolean chk = dao.sizeSetting(pageSize, imgSize);
		if(chk){%>
			<script>
				alert("정상적으로 처리되었습니다");
				window.close();
			</script>
		<%}else{%>			
			<script>
				alert("설정에 실패했습니다. 다시시도해주세요");
				history.go(-1);
			</script>
		<%}
	}
	%>
</body>
</html>