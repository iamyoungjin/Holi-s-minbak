<%@page import="test.web.project03.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>탈퇴</title>
</head>
<%
	String sId = (String)session.getAttribute("sId");
	if(sId == null){%>
		<script>
			alert("잘못된 접근입니다");
			history.go(-1);
		</script>
	<%}else{
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		MemberDAO dao = MemberDAO.getInstance();
		int res = dao.deleteMember(id, pw);
		if(res==0){%>
			<script>
				alert("처리과정에서 오류가 발생했습니다.");
				history.go(-1);
			</script>	
		<%}else if(res==2){%>
			<script>
				alert("해당하는 회원 정보가 없습니다.");
				history.go(-1);
			</script>
		<%}else if(res==1){%>
			<script>
				alert("성공적으로 회원탈퇴가 이루어졌습니다.");
			</script>
		<%
			response.sendRedirect("../login/logout.jsp");
		}
	}
%>
<body>

</body>
</html>