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
		// DAO에서 deleteMember 작동 
		int res = dao.deleteMember(id, pw);
		// int 타입으로 받아서 체크한다
		// 메서드가 제대로 작동하지 않을시 0값이 리턴
		if(res==0){%>
			<script>
				alert("처리과정에서 오류가 발생했습니다.");
				history.go(-1);
			</script>	
		<%// 메서드가 작동은 했으나 id,pw가 일치하지 않을때 작동
		}else if(res==2){%>
			<script>
				alert("해당하는 회원 정보가 없습니다.");
				history.go(-1);
			</script>
		<%// 메서드 정상 작동
		}else if(res==1){%>
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