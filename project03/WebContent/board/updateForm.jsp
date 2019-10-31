<%@page import="com.oreilly.servlet.MultipartFilter"%>
<%@page import="com.oreilly.servlet.multipart.MultipartParser"%>
<%@page import="test.web.project03.BoardDTO"%>
<%@page import="test.web.project03.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
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
	if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") == null){%>
	<script>
		alert("글쓰기는 로그인 후 사용할 수 있습니다.");
		history.go(-1);
	</script>
	<%}else if(!id.equals(sId) && sAdmin == null){%>
	<script>
		alert("작성자만 수정 할 수 있습니다.");
		history.go(-1);
	</script>
	<%}else if(sAdmin != null || id.equals(sId)){
		int boardnum = Integer.parseInt(request.getParameter("boardnum"));
		String pageNum = request.getParameter("pageNum");
		try{
			BoardDAO bdao = BoardDAO.getInstance();
			BoardDTO dto = bdao.updateGetPost(boardnum);
			String oldImage = dto.getFileroot();
			
%>
<body>
	<center> 게시글 수정
	
	<form name="updateForm" action="updatePro.jsp?pageNum=<%=pageNum%>&id=<%=id%>" method="post" onsubmit="return writeSave()" enctype="multipart/form-data">
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
				<td>사진 업로드 : <% if(oldImage!=null)out.print(oldImage); %> <input type="file" name="save"/>
					<input type="hidden" name="oldImage" value="<%=dto.getFileroot()%>"/><br/> </td>
			</tr>
			<tr>
				<td>
				<input type="submit" value="글수정"/>
				<input type="reset" value="다시작성"/>
				<input type="button" value="목록으로" onclick="window.location.href='boardList.jsp?pageNum=<%=pageNum%>'"/>
				</td>
			</tr>
		</table>
	</form>
</body>
		<%}catch(Exception e){}
	}
%>
</html>