<%@page import="test.web.project03.MemberDTO"%>
<%@page import="test.web.project03.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그아웃</title>
</head>
<%	
	String boardType = request.getParameter("boardType");
	session.invalidate();
	Cookie[] coo = request.getCookies();
	String cId = null, cPw = null, cAuto= null;
	for(Cookie c : coo){
		if(c.getName().equals("cId") || c.getName().equals("cPw") || c.getName().equals("cAuto")){
			c.setMaxAge(0);
			response.addCookie(c);
		}
	}
	
	if(boardType.equals("board")){
		response.sendRedirect("../board/boardList.jsp");
	}else if(boardType.equals("main")){
		response.sendRedirect("../main/main.jsp");
	}else if(boardType.equals("reservation")){
		response.sendRedirect("../reservation/reservationMain.jsp");
	}else{
		response.sendRedirect("../main/main.jsp");
	}
%>
<body>

</body>
</html>