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
<jsp:setProperty property="email" name="dto"/>
<jsp:setProperty property="pw" name="dto"/>
<jsp:setProperty property="name" name="dto"/>
<jsp:setProperty property="phonenum" name="dto"/>
<jsp:setProperty property="birthdate" name="dto"/>

<%
	String sId = (String)session.getAttribute("sId");
	String id = request.getParameter("id");
	
	if(sId == null){%>
		<script>
			alert("잘못된 접근입니다.");
			history.go(-1);
		</script>
	
<%	}else{
		MemberDAO dao = MemberDAO.getInstance();
		boolean chk = dao.modifyMember(id, dto);
		if(chk){%>
			<script>
				alert("회원 정보 수정 완료");
			</script><%
			response.sendRedirect("mypage.jsp");
		}else{%>
			<script>
				alert("작업에 실패했습니다. 다시 시도해주세요.");
				history.go(-1);
			</script>
		<%}
	}
%>
<body>

</body>
</html>