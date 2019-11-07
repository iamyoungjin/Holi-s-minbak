<%@page import="test.web.qnaboard.QNABoardDTO"%>
<%@page import="test.web.qnaboard.QNABoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글수정</title>
<script>
	function writeSave(){
		if(!document.writeForm.subject.value){
		  alert("제목을 입력하십시요.");
		  return false;
		}
		
		if(!document.writeForm.content.value){
		  alert("내용을 입력하십시요.");
		  document.writeform.content.focus();
		  return false;
		}
	 }   
</script>
</head>
<%
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	String id = request.getParameter("id");

	int boardnum = Integer.parseInt(request.getParameter("boardnum"));
	String pageNum = request.getParameter("pageNum");

  
	QNABoardDAO dao = QNABoardDAO.getInstance();
	QNABoardDTO dto = dao.updateGetPost(boardnum);
			
%>

<body>
	<center> 게시글 수정
	
	<form action="qnaupdatePro.jsp?pageNum=<%=pageNum%>&id=<%=id%>" method="post" onsubmit="return writeSave()">
		<input type="hidden" name="boardnum" value="<%=boardnum %>"  />
		<table border="1">
			<tr>
				<td>작성자 <input type="text" name="name" value="<%=dto.getName()%>" readonly/> </td>
			</tr>
			<tr>
				<td>제목 <input type ="text" name="subject" value="<%=dto.getSubject()%>"/></td>
			</tr>
			<tr>
				<td>내용 <textarea rows="13" cols="40" name="content"><%=dto.getContent()%></textarea></td>
			</tr>
			<tr>
				<td>비밀번호          
			       <%if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") == null){%>
			       <input type="password" name="pw" >
				   <input type="hidden" name="boardnum" value="<%=boardnum%>">
				   <%} %>
				</td>
			</tr>
			<tr>
				<td>
				<input type="submit" value="글수정"/>
				<input type="reset" value="다시작성"/>
				<input type="button" value="목록으로" onclick="window.location.href='qnaboardlist.jsp?pageNum=<%=pageNum%>'"/>
				</td>
			</tr>
		</table>
	</form>
</body>

</html>