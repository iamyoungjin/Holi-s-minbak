<%@page import="test.web.project03.MemberDAO"%>
<%@page import="java.net.CookieStore"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>펜션에 오신걸 환영합니다.</title>
</head>
<%	//test develop
	String boardType = "main";
	MemberDAO dao = MemberDAO.getInstance();
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") == null ){
		String id = null, pw = null, auto = null;
		Cookie [] coo = request.getCookies();
		if(coo!=null){
			for(Cookie c : coo){
				if(c.getName().equals("cId")) id= c.getValue();
				if(c.getName().equals("cPw")) pw= c.getValue();
				if(c.getName().equals("cAuto")) auto= c.getValue();
			}
		}
		if(id!=null && pw!=null && auto!=null){
			response.sendRedirect("../login/loginPro/jsp");
		}
%>
<body>
	<ul>
		<li><a href="../sign/signUpMain.jsp?boardType=<%=boardType%>">회원가입</a></li>
		<li><a href="../login/loginForm.jsp">로그인</a></li>
		<li><a href="../reservation/reservationCalendar.jsp">예약</a></li>
		<li><a href="../board/boardList.jsp">게시판</a></li>
		<li><a href="../etc/introRoom.jsp">방 소개</a></li>
		<li><a href="../etc/directions.jsp">찾아오는 길</a></li>
	</ul>
<%	}else if(session.getAttribute("sId")!=null){
		if(dao.chkInfoSnsLogin(sId)){%>
			<script>
				alert("개인 정보를 입력해주세요!");
				window.location.href="../mypage/modifyForm.jsp";
			</script>
		<%}

%>
	<ul>
		<li><%=(String)session.getAttribute("sName") %>님 환영합니다 </li>
		<li><a href="../mypage/mypage.jsp">마이페이지</a></li>
		<li><a href="../login/logout.jsp?boardType=<%=boardType%>">로그아웃</a></li>
		<li><a href="../reservation/reservationCalendar.jsp">예약</a></li>
		<li><a href="../board/boardList.jsp">게시판</a></li>
		<li><a href="../etc/introRoom.jsp">방 소개</a></li>
		<li><a href="../etc/directions.jsp">찾아오는 길</a></li>
	</ul>
<%	}else if(session.getAttribute("sAdmin")!= null){ %>
	<ul>
		<li><%=(String)session.getAttribute("sName") %>님 환영합니다 </li>
		<li><a href="../adminpage/adminpage.jsp">관리자 페이지 </a></li>
		<li><a href="../login/logout.jsp?boardType=<%=boardType%>">로그아웃</a></li>
		<li><a href="../reservation/reservationCalendar.jsp">예약</a></li>
		<li><a href="../board/boardList.jsp">게시판</a></li>
		<li><a href="../etc/introRoom.jsp">방 소개</a></li>
		<li><a href="../etc/directions.jsp">찾아오는 길</a></li>
	</ul>
<%	}
%>
</body>
</html>