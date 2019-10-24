<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 삭제</title>
<script>
	function deleteChk(){
		if(!document.deleteForm.pw.value){
			alert("비밀번호를 입력하세요");
			return false;
		}
		if(!document.deleteForm.agree.checked){
			alert("글 삭제 동의를 체크해주세요.");
			return false;
		}
	}
</script>
</head>
<%
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") == null){%>
	<script>
		alert("글 삭제는 작성자만 할 수 있습니다.");
		history.go(-1);
	</script>
	<%}else{
		int boardnum = Integer.parseInt(request.getParameter("boardnum"));
		String pageNum = request.getParameter("pageNum");
	%>
		<form name="deleteForm" action="deletePro.jsp?pageNum=<%=pageNum%>" method="post" onsubmit="return deleteChk()">
		
		
			<input type="hidden" name="boardnum" value="<%=boardnum %>"/>
			<table>
				<tr><td calspan="2">게시글 삭제</td></tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" name="pw"/></td>
				</tr>
				<tr>
					<td>정말로 삭제하시겠습니까?</td>
					<td><input type="checkbox" name="agree"/></td>
				</tr>
				<tr>
					<td><input type="submit" value="글삭제"/></td>
					<td><input type="button" value="돌아가기" onclick="history.go(-1)"/></td>
				</tr>
			</table>
		
		</form>
		
	<%}
%>
<body>

</body>
</html>