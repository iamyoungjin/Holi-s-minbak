<%@page import="test.web.calendar.SetDTO"%>
<%@page import="test.web.calendar.SetDAO"%>
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
	// jQuery를 사용해 숫자만 입력 받기 위한 정규식 및 파악 메서드
	var regexp = /^[0-9]*$/
	v = $(this).val();
	if( !regexp.test(v) ) {
		alert("숫자만 입력하세요");
		$(this).val(v.replace(regexp,''));
	}
	
	// form 에도 적용할 함수를 추가로 만든다.
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
		SetDAO dao = SetDAO.getInstance();
		SetDTO dto = dao.getSetting();
		%>
		<form name="settingForm" action="boardSettingPro.jsp" method="post" onsubmit="return chkSize()">
		<table>
			<tr>
				<!-- board에 pageSize로 적용될 갯수를 number 타입으로 받는다. html5이상 부터 적용되는 number는 숫자만 받을수 있다. -->
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