<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	String boardType = "main";
	String log = "";
	if(sId == null && sAdmin == null){
		log = "<a href='../login/loginForm.jsp'>로그인</a>";
	}else{
		log = "<a href='../login/loginout.jsp'>로그아웃</a>";
	}
	String mem ="";
	if(sId == null && sAdmin == null){
		log = "<a href='../sign/signUpMain.jsp'>회원가입</a>";
	}else if(sId != null && sAdmin == null){
		log = "<a href='../mypage/mypage.jsp'>마이페이지</a>";
	}else if(sId == null && sAdmin == null){
		log = "<a href='../adminpage/adminpage.jsp'>관리자 페이지</a>";
	}
	
%>
<table>
	<tr>
		<td>외똔집 페션</td>
		<td><img src="../image/logo.png"></td>
		<td><%=log %></td>
		<td><%=mem %></td>
	<tr>
	<tr>
		<td><a href="../etc/intro.jsp">인삿말</a></td>
		<td><a href="../etc/intro">객실보기</a></td>
		<td><a href="">교통 안내</a></td>
		<td><a href="">예약안내</a></td>
		<td><a href="">게시판</a></td>
	</tr>

</table>

</body>
</html>