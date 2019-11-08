<%@page import="test.web.project03.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>중복검사</title>
</head>
<%
	MemberDAO dao = MemberDAO.getInstance();
	String id = request.getParameter("id");
	// Form 페이지에서 request를 받아온다
%>
<script>
	function setId(){
		// 아이디 중복검사가 끝나고 창을 닫을때 작동하는 메서드
		// 부모창 Form의 변수를 바꿔서 중복검사 시행 여부와 아이디 값을 넘긴다
		opener.document.signUpForm.id.value = "<%=id%>";
		opener.idChk = true;
		opener.idStr = "<%=id%>";
		window.close();
	}
</script>
<body>
<form name="confirmId">
	<%
		if(dao.confirmId(id)){
			out.print("해당하는 아이디는 이미 사용중인 아이디입니다.");%>
			<br/><br/>
			<form action="signUpConfirm.jsp">
			이메일: <input type="text" name="id"> <input type="submit" value="확인">
			</form>
		<%}else{
		out.print(id + "은 사용 가능한 아이디 입니다."); %>
		<input type="button" value="닫기" onclick="setId()"/>
	<%}
%>
</form>

</body>
</html>