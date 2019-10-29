<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 설정</title>
</head>
<%
	String sAdmin = (String)session.getAttribute("UTF-8");
	if(sAdmin == null){
		%>
		<script>
			alert("잘못된 접근입니다.");
			history.go(-1);
		</script>
		<%
	}else{
		%>
		<table>
			<tr>
				<td>한 페이지에 보여줄 게시글 갯수 <input type="number" min="5", max="20" value="10"/> </td>
			</tr>
			<tr>
				<td>이미지 사이즈 용량 제한 <input type="number" min="5", max="20" value="10"/></td>
			</tr>
		</table>
		<%
	}
%>
<body>

</body>
</html>