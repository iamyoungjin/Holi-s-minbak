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
	// 카카오 로그인 성공시 세션부여
	MemberDAO dao = MemberDAO.getInstance();
	
	String id = request.getParameter("id");
	String pw = id;
	String auto = "1";
	String boardType = request.getParameter("boardType");
	boolean loginChk = dao.loginKakao(id);
	if(loginChk){

		
		session.setAttribute("sId", id);
		String name = dao.searchName(id);
		session.setAttribute("sName", name);
		%>
		<script>
			alert("로그인 하셨습니다.");
		</script><%
		if(boardType.equals("board")){
			response.sendRedirect("../board/boardList.jsp");
		}else if(boardType.equals("main")){
			response.sendRedirect("../main/main.jsp");
		}else if(boardType.equals("reservation")){
			response.sendRedirect("../reservation/reservationMain.jsp");
		}else{
			response.sendRedirect("../main/main.jsp");
		}
		
	}else{%>
		<script>alert("해당하는 회원 정보가 없습니다."); history.go(-1);</script>
	<%}
%>
<body>
</body>
</html>