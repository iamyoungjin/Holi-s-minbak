<%@page import="test.web.project03.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<%
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String auto = request.getParameter("auto");
	String boardType = request.getParameter("boardType");
	
	Cookie[] coo = request.getCookies();
	if(coo!= null){
		for(Cookie c : coo){
			if(c.getName().equals("cId")) id = c.getValue();
			if(c.getName().equals("cPw")) pw = c.getValue();
			if(c.getName().equals("cAuto")) auto = c.getValue();
		}
	}
	MemberDAO dao = MemberDAO.getInstance();
	boolean loginChk = dao.login(id,pw);
	
	if(loginChk){
		if(auto!=null){
			Cookie c1 = new Cookie("cId", id);
			Cookie c2 = new Cookie("cPw", pw);
			Cookie c3 = new Cookie("cAuto", auto);
			
			c1.setMaxAge(60*60*24);
			c2.setMaxAge(60*60*24);
			c3.setMaxAge(60*60*24);
			
			response.addCookie(c1);
			response.addCookie(c2);
			response.addCookie(c3);
		}
		
		
		if(id.equals("admin")){ session.setAttribute("sAdmin", id); }
		else{ session.setAttribute("sId", id); }
		String name = dao.searchName(id);
		session.setAttribute("sName", name);%>
		<script>
		alert("로그인 하셨습니다.")
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