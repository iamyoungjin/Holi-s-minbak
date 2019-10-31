<%@page import="test.web.calendar.SettingDTO"%>
<%@page import="test.web.calendar.SettingDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 설정</title>
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	var regexp = /^[0-9]*$/
	v = $(this).val();
	if( !regexp.test(v) ) {
		alert("숫자만 입력하세요");
		$(this).val(v.replace(regexp,''));
	}
	
	function chkSize(){
        if(!document.getElementById("pageSize").value.match(/^[0-9]*$/)){
        	alert("숫자만 입력해주세요");
        	return false;
        }
        if(!document.getElementById("imgSize").value.match(/^[0-9]*$/)){
        	alert("숫자만 입력해주세요");
        	return false;
        }
    }
	
</script>
</head>
<%
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){
		%>
		<script>
			alert("잘못된 접근입니다.");
			history.go(-1);
		</script>
		<%
	}else{
		SettingDAO dao = SettingDAO.getInstance();
		SettingDTO dto = dao.getSetting();
		%>
		<form name="settingForm" action="boardSettingPro.jsp" method="post" onsubmit="return chkSize()">
		<table>
			<tr>
				<td>한 페이지에 보여줄 게시글 갯수 <input type="number" name="pageSize" id="pageSize" min="5" max="20" value="<%=dto.getPagesize()%>"/> </td>
			</tr>
			<tr>
				<td>이미지 사이즈 용량 제한 <input type="number" id="imgSize" name="imgSize" min="5" max="20" value="<%=dto.getImgsize()%>"/></td>
			</tr>
			<tr>
				<td>
				<input type="submit" value="설정하기"/>
				<input type="button" value="닫기" onclick="window.close()"/>
				</td>
			</tr>
		</table>
		</form>
		<%
	}
%>
<body>

</body>
</html>