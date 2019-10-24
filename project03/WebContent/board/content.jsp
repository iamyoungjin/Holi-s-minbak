<%@page import="test.web.project03.MemberDTO"%>
<%@page import="test.web.project03.MemberDAO"%>
<%@page import="test.web.project03.CommentDTO"%>
<%@page import="java.util.List"%>
<%@page import="test.web.project03.CommentDAO"%>
<%@page import="test.web.project03.BoardDTO"%>
<%@page import="test.web.project03.BoardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	int boardnum = Integer.parseInt(request.getParameter("boardnum"));
	String pageNum = request.getParameter("pageNum");
%>
<script>

	var pageNum = <%= pageNum %>;
	var boardnum = <%= boardnum %>;
	function insertComment(userinput){
		if(userinput.newcomment_content.value.length == 0){
			alert("덧글 내용을 입력해주세요");
			return false;
		}
		userinput.action="commentPro.jsp?type=insert"
				+"&pageNum="+pageNum
				+"&boardnum="+boardnum
				+"&postnum="+userinput.newpostnum.value
				+"&id="+userinput.newid.value
				+"&pw="+userinput.newpw.value
				+"&name="+userinput.newname.value
				+"&comment_content="+userinput.newcomment_content.value;
		userinput.submit();
	}
	function deleteComment(userinput){
		if(!confirm("덧글을 삭제하시겠습니까?")){
			return;
		}
		userinput.action="commentPro.jsp?type=delete"
				+"&pageNum"+pageNum
				+"&boardnum="+boardnum
				+"&commentnum"+document.getElementById("commentnum"+num).value;
		userinput.submit();
		
	}
	
	function chkDelete(userinput){
		if(!confirm("게시물을 지우시겠습니까?")){
			return;
		}
	}
	
</script>


<head>
<meta charset="UTF-8">
<%
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	MemberDAO mdao = MemberDAO.getInstance();
	try{	
		BoardDAO dao = BoardDAO.getInstance();
		BoardDTO dto = dao.getPost(boardnum);
		
		int ref = dto.getRef();
		int re_step = dto.getRe_step();
		int re_level = dto.getRe_level();
%>
<title><%=dto.getSubject() %></title>
</head>
<body>
<form>
	<table>
		<tr>
			<td>글번호</td>
			<%if(dto.getCategory()==1){ %>
			<td><%=dto.getBoardnum() %></td>
			<%}else if(dto.getCategory() == 2){ %>
			<td>공지</td>
			<%}%>
			<td>조회수</td>
			<td><%=dto.getReadcount() %></td>
		</tr>
		<tr>
			<td>작성자</td>
			<td><%=dto.getName() %></td>
			<td>작성일</td>
			<td><%= sdf.format(dto.getReg_date()) %></td>
		</tr>
		<tr>
			<td>글제목</td>
			<td colspan="3"><%=dto.getSubject() %></td>
		</tr>
		<tr>
			<td>글내용</td>
			<td colspan="3">
			<%if(dto.getFileroot()!=null){ %><img src="/project03/image/<%=dto.getFileroot()%>"/><br> <%} %>
			<pre><%=dto.getContent() %></pre></td>
		</tr>
		<tr>
			<td colspan="4"><input type="button" value="글수정" onclick="window.location.href='updateForm.jsp?boardnum=<%=dto.getBoardnum()%>&pageNum=<%=pageNum%>&id=<%=dto.getId()%>'"/>
		  	&nbsp;
			<input type="button" value="글삭제" onclick="chkDelete(); window.location.href='deletePro.jsp?boardnum=<%=dto.getBoardnum()%>&pageNum=<%=pageNum%>&id=<%=dto.getId()%>'"/>
			&nbsp;
			<input type="button" value="답글" onclick="window.location.href='writeForm.jsp?boardnum=<%=boardnum%>&ref=<%=ref%>&re_step=<%=re_step%>&re_level=<%=re_level%> '"/>
			&nbsp;
			<input type="button" value="글목록" onclick="window.location.href='boardList.jsp?pageNum=<%=pageNum%>'"/></td>
		</tr>	
	</table>
</form>
<form name="commentForm" method="post">

	<table>
		<%
		CommentDAO cdao = CommentDAO.getInstance();
		List commentList = cdao.getComment(boardnum);
		if(commentList != null){
			for(int i=0; i<commentList.size(); i++){
				CommentDTO cdto = (CommentDTO)commentList.get(i);
			%>
			<tr>
				<input type="hidden" id="commentnum<%=i%>" name="commentnum<%=i%>" value="cdto.getCommentnum()"/>
				<td><%=cdto.getName() %></td>
				<td><%=cdto.getComment_content() %></td>
				<td><%= sdf.format(cdto.getReg()) %></td>
				<!-- 덧글 삭제 -->
				<td><%if(cdto.getId().equals(sId) || session.getAttribute("sAdmin") != null){%><input type="button" value="x" onclick="deleteComment(this.form)"/></td><%} %>
			</tr>
			<%	}
		}
		%>
		<%
		if(session.getAttribute("sId") != null || session.getAttribute("sAdmin") != null){
			if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") != null){ sId = sAdmin; }
			MemberDTO mdto = mdao.getMember(sId);
			%>
			<input type="hidden" name="newpostnum" value="<%=boardnum%>"/>
			<input type="hidden" name="newid" value="<%=sId%>"/>
			<input type="hidden" name="newpw" value="<%= mdto.getPw() %>"/>
			<tr>
				<td><%=mdto.getName()%><input type="hidden" name="newname" value="<%=mdao.searchName(sId)%>"/></td>
				<td><textarea name="newcomment_content" rows="1" cols="20"></textarea></td>
				<td><input type="button" value="덧글작성" onclick="insertComment(this.form)"/></td>
			</tr>
		<%}%>
	</table>
</form>
</body>
		<%
	}catch(Exception e){}
%>
</html>