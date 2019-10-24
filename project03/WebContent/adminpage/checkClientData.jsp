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
						<td><%=dto.getNum() %></td>
						<td><%=dto.getId() %></td>
						<td><%=dto.getEmail() %></td>
						<td><%=dto.getName() %></td>
						<td><%=dto.getPhonenum() %></td>
						<td><%=dto.getBirthdate() %></td>
						<td><%=dto.getReg() %></td>
					</tr>
			<%} %>
			</table>
			<input type="button" value="돌아가기" onclick="window.location.href='adminpage.jsp'"/>
<%
		}
	}
%>

</body>
</html>