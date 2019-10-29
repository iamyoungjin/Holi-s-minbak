<%@page import="test.web.project03.MemberDTO"%>
<%@page import="test.web.project03.MemberDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리</title>
<script>
	function updateClient(userinput,num){
		if(!document.getElementById("email"+num).value){
			alert("이메일을 입력해주세요");
			return false;
		}
		if(!document.getElementById("name"+num).value){
			alert("이름을 입력해주세요");
			return false;
		}
		if(!document.getElementById("phonenum"+num).value){
			alert("전화번호를 입력해주세요");
			return false;
		}
		if(!document.getElementById("birthdate"+num).value){
			alert("생년월일을 입력해주세요");
			return false;
		}
		userinput.action="checkClientPro.jsp?type=update"
			+"&num="+document.getElementById("num"+num).value
			+"&id="+encodeURI(document.getElementById("id"+num).value)
			+"&pw="+encodeURI(document.getElementById("pw"+num).value)
			+"&email="+encodeURI(document.getElementById("email"+num).value)
			+"&name="+encodeURI(document.getElementById("name"+num).value)
			+"&phonenum="+encodeURI(document.getElementById("phonenum"+num).value)
			+"&birthdate="+encodeURI(document.getElementById("birthdate"+num).value)
		userinput.submit();
	}
	
	function deleteClient(userinput,num){
		if(!confirm("회원을 탈퇴 시키겠습니까?") ){
			return;
		}
		if(!document.getElementById("num"+num).value){
			alert("문제가 발생했으니 다시 시도해주세요.");
		}
		userinput.action="checkClientPro.jsp?type=delete"
			+"&id="+encodeURI(document.getElementById("id"+num).value)
			+"&pw="+encodeURI(document.getElementById("pw"+num).value);
		userinput.submit();
	}

</script>
</head>
<%
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
		<script>
			alert("권한이 없습니다.");
			history.go(-1);
		</script>
<%	}else{
		MemberDAO dao = MemberDAO.getInstance();
		List list = dao.showMember();
		if(list==null){
		%> <h1>가입한 사용자가 없습니다.</h1> <%			
		}else{
%>
<body>
	<form name="ClientData" method="post">
		<table border="1">
			<tr>
				<td>회원 번호</td>
				<td>아이디</td>
				<td>이메일</td>
				<td>이름</td>
				<td>휴대폰번호</td>
				<td>생년월일</td>
				<td>가입일</td>
			</tr>
			<%for(int i=0; i<list.size(); i++){
				MemberDTO dto = (MemberDTO)list.get(i);
			%>
			<tr>
				<input type="hidden" id="pw<%=i%>" name="pw<%=i%>" value="<%=dto.getPw() %>" readonly/>
				<td><input type="text" id="num<%=i%>" name="num<%=i%>" value="<%=dto.getNum()%>" readonly /></td>
				<td><input type="text" id="id<%=i%>" name="id<%=i%>" value="<%=dto.getId() %>" readonly /></td>
				<td><input type="text" id="email<%=i%>" name="email<%=i%>" value="<%=dto.getEmail() %>"/></td>
				<td><input type="text" id="name<%=i%>" name="name<%=i%>" value="<%=dto.getName() %>"/></td>
				<td><input type="text" id="phonenum<%=i%>" name="phonenum<%=i%>" value="<%=dto.getPhonenum() %>"/></td>
				<td><input type="text" id="birthdate<%=i%>" name="birthdate<%=i%>" value="<%=dto.getBirthdate() %>"/></td>
				<td><input type="text" id="reg<%=i%>" name="reg<%=i%>" value="<%=dto.getReg() %>" readonly/></td>
				<td>
				<%if(dto.getUser_type() == 3){%>
					<p style="font-size:12px">탈퇴 회원</p>
				<%}else{%>
					<input type="button" value="회원 정보 수정" onclick="updateClient(this.form,<%=i%>)"/>
					<input type="button" value="회원 탈퇴" onclick="deleteClient(this.form,<%=i%>)"/>
				<%}%>
				</td>
			</tr>
			<%} %>
		</table>
	</form>
			<input type="button" value="돌아가기" onclick="window.location.href='adminpage.jsp'"/>
<%
		}
	}
%>

</body>
</html>