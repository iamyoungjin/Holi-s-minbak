<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입</title>
<script>
	// 아이디 중복검사를 실행시킬 자바스크립트 함수
	function confirmId(userinput){
		if(userinput.id.value == ""){
			alert("아이디를 입력하세요");
			return;
		}
		url="signUpConfirm.jsp?id="+userinput.id.value;
		window.open(url, "confirm", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizeable=no, width=300, height=200");
		// url = 주소, confirm 타이틀, resizeable 사이즈조절, scrollbars 스크롤바
	}
	
	// 아이디 중복검사 체크를 위한 함수
	// 자식창 (signUpConfirm)에서 부모창(현재창,form페이지)로 값을 전송시킨다
	var idChk =false;
	// 중복검사를 시행하고 올시에 true가 된다.
	var idStr ="";
	function chkId(){
		// 자식창에서 검사한 아이디가 현재 입력된 아이디와 다를경우, false가 된다
		if(document.signUpForm.id.value != idStr){
			idChk=false;
		}
		// idChk가 false일시 return도 false출력
		if(idChk==false){
			alert("중복 검사를 하지 않았습니다");
			return false;
		}
		
	}
	
	// 양식 유효성 검사를 위한 함수
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
		if(document.signUpForm.phonenum.value.length>11 || document.signUpForm.phonenum.value.length<9){
			alert("휴대폰 번호 길이를 재확인해주세요");
			return false;
		}
		// 입력된 값에 -가 포함되어있지 않을 경우 -1의 값이다.
		// 이를 통해 0보다 같거나 클시 ( 포함되어있는 경우) 메세지 출력과 false
		if(document.signUpForm.phonenum.value.indexOf("-")>=0){
			alert("전화번호에 -를 뺀 상태로 입력해주세요");
			return false;
		}
		if(!ui.birthdate.value){
			alert("생년월일을 입력하지 않았습니다")
			return false;
		}
		if(document.signUpForm.birthdate.value.length!=6){
			alert("생년월일 입력 양식이 잘못되었습니다. 950101과 같은 양식으로 작성해주세요");
			return false;
		}
		// 생년월일 입력 양식(yyMMdd)에서, 월이 1~12 사이인지 파악
		if(parseInt(document.signUpForm.birthdate.value.substring(2,4))>12 || parseInt(document.signUpForm.birthdate.value.substring(2,4))<=0 ){
			alert("생년월일 양식이 잘못되었습니다.");
			return false;
		}
		// 생년월일 입력 양식에서 일이 1~31 사이인지 파악
		if(parseInt(document.signUpForm.birthdate.value.substring(4,6))>31 || parseInt(document.signUpForm.birthdate.value.substring(2,4))<=0 ){
			alert("생년월일 양식이 잘못되었습니다.");
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
<%
	sId = (String)session.getAttribute("sId"); 
	sAdmin = (String)session.getAttribute("sAdmin");
	if(sId!=null || sAdmin!=null){
		response.sendRedirect("../main/main.jsp");
	}else{
	
%>

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
			<td>휴대폰번호 : <input type="text" name="phonenum" maxlength="12" placeholder="휴대전화 번호를 숫자로만 입력"/></td>
		</tr>
		<tr>
			<td>생년월일 : <input type="text" name="birthdate" maxlength="6" placeholder="예시)910101"/></td>
		</tr>
		<tr>
		<td>
			<input type="submit" value="제출하기"/>
			<button type="button" onclick="window.location.href='signUpMain.jsp'">돌아가기</button>
		</td>
		</tr>
	</table>
</form>
<%} %>
</body>
</html>