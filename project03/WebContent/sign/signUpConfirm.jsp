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
%>
<script>
	function setId(){
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