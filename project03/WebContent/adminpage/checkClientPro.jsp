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
<jsp:setProperty property="*" name="dto"/>
<body>
<%
	String sAdmin = (String)session.getAttribute("sAdmin");
	String id = (String)request.getParameter("id");
	String pw = (String)request.getParameter("pw");
	if(sAdmin == null){%>
		<script>
			alert("권한이 없습니다.");
			history.go(-1);
		</script>
<%	}else{
		MemberDAO dao = MemberDAO.getInstance();
		String type = request.getParameter("type");
		boolean chk = false;
		
		if(type.equals("update")){
			chk = dao.modifyMember(id, dto);
			if(chk){
				response.sendRedirect("checkClientData.jsp");				
			}else{%>
				<script>
					alert("오류가 발생했습니다.");
					history.go(-1);
				</script>
			<%}
			
		}else if(type.equals("delete")){
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
			}
			response.sendRedirect("checkClientData.jsp");
		}else{%>
			<script>
				alert("에러가 발생했습니다. 다시 시도해주세요.");
				//history.go(-1);
			</script>
	<%	
		}
	}
%>
</body>
</html>