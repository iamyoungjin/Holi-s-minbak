<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<script>
	function chkForm(){
		var ui = eval("document.deleteChk");
		if(!ui.id.value){
			alert("아이디를 입력하지 않았습니다.");
			return false;
		}
		if(!ui.pw.value){
			alert("비밀번호를 입력하지 않았습니다.");
			return false;
		}
		if(!ui.agree.checked){
			alert("계정 탈퇴에 동의해주세요.");
			return false;
		}
	}
</script>
<header>
	<%@ include file="../main/header.jsp" %>
</header>

</head>
<%
	sId = (String)session.getAttribute("sId");
	if(sId == null){%>
		<script>
			alert("잘못된 접근입니다");
			history.go(-1);
		</script>
		
	<%}else{%>
<body>
	<form name="deleteChk" action="deletePro.jsp" method="post" onsubmit="return chkForm()">
		아이디 : <input type="text" name="id"/> <br/> 
		비밀번호 : <input type="password" name="pw"/><br/>
		정말 삭제하시겠습니까? <input type="checkbox" name="agree"/> <br/>
		<input type="submit" value="회원탈퇴"/>
		<input type="button" value="돌아가기" onclick="window.location.href='mypage.jsp'"/>	
	</form>
	
</body>
	<%}
%>
<footer>
	<%@ include file="../main/footer.jsp" %>
</footer>
</html>