<%@page import="test.web.project03.MemberDTO"%>
<%@page import="test.web.project03.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<script>
	function writeSave(){
		if(!document.qnawriteForm.subject.value){
		  alert("제목을 입력하십시요.");
		  return false;
		}
		if(!document.qnawriteForm.content.value){
		  alert("내용을 입력하십시요.");
		  document.qnawriteForm.content.focus();
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
			alert("로그인이 안되어 있습니다. 비회원으로 작성하시겠습니까.?");
			window.location.href="bqnawriteForm.jsp"
		</script>
	<%}else{
		int boardnum=0,ref=1,re_step=0,re_level=0;
		try{
			if(request.getParameter("boardnum")!= null){
				boardnum = Integer.parseInt(request.getParameter("boardnum"));
				ref = Integer.parseInt(request.getParameter("ref"));
				re_step = Integer.parseInt(request.getParameter("re_step"));
				re_level = Integer.parseInt(request.getParameter("re_level"));
			}
			int category = 0;
			if(session.getAttribute("sAdmin")!=null){ category = 2; }
			else{category = 1;} 
			
			MemberDAO dao = MemberDAO.getInstance();
			if(session.getAttribute("sAdmin")!=null){sId = sAdmin;}
			MemberDTO dto = dao.getMember(sId);
	%>
	<body>
	<center>글쓰기
	
	<form name="qnawriteForm" action="qnawritePro.jsp" method="post" onsubmit="return writeSave()" >
		<input type="hidden" name="boardnum" value="<%=boardnum %>"  />
		<input type="hidden" name="ref" value="<%=ref%>" />
		<input type="hidden" name="re_step" value="<%=re_step%>" />
		<input type="hidden" name="re_level" value="<%=re_level%>" />
		<input type="hidden" name="name" value="<%=dto.getName() %>" />
		<input type="hidden" name="id" value="<%=dto.getId() %>" />
		<input type="hidden" name="pw" value="<%=dto.getPw() %>" />
		<input type="hidden" name="category" value="<%=category %>" />
		<table border="1">
			<tr>
				<td>작성자
				 <input type="text" name="name" value="<%=dto.getName()%>" readonly/> </td>
			</tr>
			<tr>
				<td>제목<%
				if(request.getParameter("boardnum")==null){%>
					<input type ="text" name="subject"/>
				<%}else{ %>
					<input type="text" name="subject" value="RE:"/>
				<%}%>
				</td>
			</tr>
			<tr>
				<td>내용 <textarea rows="13" cols="40" name="content"></textarea></td>
			</tr>
			<tr>
				<td>
				<input type="submit" value="글쓰기"/>
				<input type="reset" value="다시작성"/>
				<input type="button" value="목록으로" onclick="window.location.href='qnaboardlist.jsp'"/>
				</td>
			</tr>
		</table>
		<%}catch(Exception e){
			e.printStackTrace();
		}%>
		
	</form>
	<%}
%>
</body>
</html>