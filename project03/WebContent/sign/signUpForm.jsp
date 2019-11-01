<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입</title>
<script>
	function confirmId(userinput){
		if(userinput.id.value == ""){
			alert("아이디를 입력하세요");
			return;
		}
		url="signUpConfirm.jsp?id="+userinput.id.value;
		window.open(url, "confirm", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizeable=no, width=300, height=200");
		// url = 주소, confirm 타이틀, resizeable 사이즈조절, scrollbars 스크롤바
	}
	
	var idChk =false;
	var idStr ="";
	function chkId(){
		if(document.signupform.id.value!=idStr){
			idChk=false;
		}
		if(idChk==false){
			alert("중복 검사를 하지 않았습니다");
			return false;
		}
	}

	function chkForm(){
		var ui = eval("document.signUpForm");
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
		return chkId();
	}
	
	

</script>
</head>
<body>
<header>
	<%@ include file="../main/header.jsp" %>
</header>

<form name="signUpForm" action="signUpPro.jsp" method="post" onsubmit="return chkForm()">
	<table>
		<tr>
			<td>아이디 : <input type="text" name="id"/><button type="button" onclick="return confirmId(this.form)">중복검사</button></td>
		</tr>
		<tr>
			<td>이메일 : <input type="email" name="email"/></td>
		</tr>
		<tr>
			<td>비밀번호 : <input type="password" name="pw"/></td>
		</tr>
		<tr>
			<td>비밀번호 확인 : <input type="password" name="pw2"/></td>
		</tr>
		<tr>
			<td>이름 : <input type="text" name="name"/></td>
		</tr>
		<tr>
			<td>휴대폰번호 : <input type="text" name="phonenum"/></td>
		</tr>
		<tr>
			<td>생년월일 : <input type="text" name="birthdate"/></td>
		</tr>
		<tr>
		<td>
			<input type="submit" value="제출하기"/>
			<button type="button" onclick="window.location.href='signUpMain.jsp'">돌아가기</button>
		</td>
		</tr>
	</table>
</form>

<footer>
	<%@ include file="../main/footer.jsp" %>
</footer>
</body>
</html>