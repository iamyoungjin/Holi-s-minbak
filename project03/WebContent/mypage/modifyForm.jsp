<%@page import="test.web.project03.MemberDTO"%>
<%@page import="test.web.project03.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	function chkForm(){
		var ui = eval("document.modifyForm");
		if(!ui.email.value){
			alert("이메일을 입력하지 않았습니다");
			return false;
		}
		if(!ui.pw.value || !ui.pw2.value ){
			alert("비밀번호를 입력하지 않았습니다.")
			return false;
		}
		if(ui.pw.value != ui.pw2.value){
			alert("비밀번호가 일치하지 않습니다.")
			return false;
		}
		if(ui.pw.value.length<6 || ui.pw.value.legnth>10){
			alert("비밀번호의 길이는 6자 이상 10자 이하로 해주세요");
	        return false;
		}
		if(!ui.name.value){
			alert("이름을 입력하지 않았습니다")
			return false;
		}	
		if(!ui.phonenum.value){
			alert("핸드폰 번호를 입력하지 않았습니다")
			return false;
		}
		if(!ui.birthdate.value){
			alert("생년월일을 입력하지 않았습니다")
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
	MemberDAO dao = MemberDAO.getInstance();
 	if(sId == null){%>
 		<script>
 			alert("잘못된 접근입니다.");
 			history.go(-1);
 		</script>
	<%}else{
		MemberDTO dto = dao.getMember(sId);
		int user_type = dto.getUser_type();
		
		if(user_type!=1 && user_type!=4){%>
<body>
		<form name="modifyForm" action="modifyPro.jsp" method="post" onsubmit="return chkForm()">
			아이디 : <input type="text" name="id" value="<%=dto.getId() %>" readonly/><br/>
			이메일 : <input type="email" name="email" value="<%=dto.getEmail()%>"/> <br/>
			비밀번호 : <input type="password" name="pw" value="<%=dto.getPw()%>"/> <br/>
			비밀번호 확인 : <input type="password" name="pw2" value="<%=dto.getPw()%>"/> <br/> 
			이름 : <input type="text" name="name" value="<%=dto.getName()%>"/> <br/>
			핸드폰번호 : <input type="text" name="phonenum" value="<%=dto.getPhonenum()%>"/> <br/>
			생년월일 : <input type="text" name="birthdate" value="<%=dto.getBirthdate()%>"/> <br/>
			<input type="submit" value="수정하기"/>
			<input type="button" value="돌아가기" onclick="window.location.href='mypage.jsp'"/>
		</form>
	<%	}else{%>
		<form name="modifyForm" action="modifyPro.jsp" method="post" onsubmit="return chkForm()">
			<input type="hidden" name="pw" value="<%=dto.getPw()%>" readonly/>
			<input type="hidden" name="pw2" value="<%=dto.getPw()%>" readonly/> <br/> 
			아이디 : <input type="text" name="id" value="<%=dto.getId() %>" readonly/><br/>
			이메일 : <input type="text" name="email" value="<%=dto.getEmail()%>"/>
			이름 : <input type="text" name="name" value="<%=dto.getName()%>"/> <br/>
			핸드폰번호 : <input type="text" name="phonenum" value="<%=dto.getPhonenum()%>"/> <br/>
			생년월일 : <input type="text" name="birthdate" value="<%=dto.getBirthdate()%>"/> <br/>
			<input type="submit" value="수정하기"/>
			<input type="button" value="돌아가기" onclick="window.location.href='mypage.jsp'"/>
		</form>
	
 	<%	}
	}
%>
<footer>
	<%@ include file="../main/footer.jsp" %>
</footer>
</body>
</html>