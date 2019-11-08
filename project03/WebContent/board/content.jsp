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
	// boardList에서 글을 보려고 누를시, 그 당시 페이지와 게시글 번호를 가지고온다.
	int boardnum = Integer.parseInt(request.getParameter("boardnum"));
	String pageNum = request.getParameter("pageNum");
%>
<script>
	
	
	var pageNum = <%= pageNum %>;
	var boardnum = <%= boardnum %>;
	// 덧글 입력을 위한 함수
	// submit 형식을 위해 action에 url을 만들고, 이를 submit한다
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
				+"&name="+encodeURI(userinput.newname.value)
				+"&comment_content="+encodeURI(userinput.newcomment_content.value);
		userinput.submit();
	}
	
	// 덧글 삭제를 위한 함수
	// delete와 insert 모두 type 값을 지정해서, 이를 이용해서 하나의 pro페이지에서 처리한다.
	function deleteComment(userinput, num){
		if(!confirm("덧글을 삭제하시겠습니까?")){
			return;
		}
		userinput.action="commentPro.jsp?type=delete"
				+"&pageNum="+pageNum
				+"&boardnum="+boardnum
				+"&commentnum="+document.getElementById("commentnum"+num).value;
		userinput.submit();
		
	}
	

	function chkDelete(userinput){
		if(!confirm("게시글을 삭제하시겠습니까?")){
			return;
		}
		userinput.action="deletePro.jsp?boardnum="+document.getElementById("boardnum").value
				+"&pageNum="+pageNum
				+"&id="+document.getElementById("id").value
		userinput.submit();
	}
	
</script>


<head>
<header>
	<%@ include file="../main/header.jsp" %>
</header>

<meta charset="UTF-8">
<%
	sId = (String)session.getAttribute("sId");
	sAdmin = (String)session.getAttribute("sAdmin");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	MemberDAO mdao = MemberDAO.getInstance();
	try{	
		BoardDAO dao = BoardDAO.getInstance();
		// DB에서 게시글을 글번호를 통해 가져온다.
		BoardDTO dto = dao.getPost(boardnum);
		
		// 해당 글에서 답글달기를 사용할 경우 해당 글에서 답글의 단계를 지정해야 되기 때문에 ref, re_step, re_level 역시 받아온다.
		int ref = dto.getRef();
		int re_step = dto.getRe_step();
		int re_level = dto.getRe_level();
%>
<title><%=dto.getSubject() %></title>
</head>
<body>
<form method="post">
	<table>
		<tr>
			<td>글번호</td>
			<%if(dto.getCategory()==1){ %>
			<td><%=dto.getBoardnum() %><input type="hidden" name="boardnum" id="boardnum" value="<%=dto.getBoardnum() %>"/></td>
			<%}else if(dto.getCategory() == 2){ %>
			<td>공지</td>
			<%}%>
			<td>조회수</td>
			<td><%=dto.getReadcount() %></td>
		</tr>
		<tr>
			<td>작성자</td>
			<td><%=dto.getName() %><input type="hidden" name="id" id="id" value="<%=dto.getId() %>"/></td>
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
			<%
			// 글에 사진이 있을시에만 노출한다. 글은 <pre>타입으로 설정해 엔터키 등이 적용된 글이 읽히도록 설정한다.
			if(dto.getFileroot()!=null){ %><img src="/project01/image/<%=dto.getFileroot()%>"/><br> <%} %>
			<pre><%=dto.getContent() %></pre></td>
		</tr>
		<tr>
			<!-- 글수정은 게시글 작성자의 아이디값 등을 가져가서 Form페이지에서 유효성검사를 한다 -->
			<td colspan="4"><input type="button" value="글수정" onclick="window.location.href='updateForm.jsp?boardnum=<%=dto.getBoardnum()%>&pageNum=<%=pageNum%>&id=<%=dto.getId()%>'"/>
		  	&nbsp;
		  	<!-- 삭제는 해당 폼을 가지고 삭제 메서드를 실행한다. -->
			<input type="button" value="글삭제" onclick="chkDelete(this.form);"/>
			&nbsp;
			<!-- 답글은 이 글의 ref/re_step/re_level 을 가지고 간다. 이를 통해 답글을 구현한다. -->
			<input type="button" value="답글" onclick="window.location.href='writeForm.jsp?boardnum=<%=boardnum%>&ref=<%=ref%>&re_step=<%=re_step%>&re_level=<%=re_level%> '"/>
			&nbsp;
			<!-- 목록으로 돌아갈시 원래 보던 페이지로 돌리는 기능을 위해 pageNum을 사용 -->
			<input type="button" value="글목록" onclick="window.location.href='boardList.jsp?pageNum=<%=pageNum%>'"/></td>
		</tr>	
	</table>
</form>
<form name="commentForm" method="post">

	<table>
		<%
		// 덧글 기능
		CommentDAO cdao = CommentDAO.getInstance();
		// 해당 게시글의 덧글을 List타입으로 받아온다.
		List commentList = cdao.getComment(boardnum);
		// 해당글에 덧글이 있을 경우에만 출력
		if(commentList != null){
			for(int i=0; i<commentList.size(); i++){
				CommentDTO cdto = (CommentDTO)commentList.get(i);
			%>
			<tr>
				<input type="hidden" id="commentnum<%=i%>" name="commentnum<%=i%>" value="<%=cdto.getCommentnum()%>"/>
				<td><%=cdto.getName() %></td>
				<td><%=cdto.getComment_content() %></td>
				<td><%= sdf.format(cdto.getReg()) %></td>
				<!-- 세션으로 받는 아이디값이 덧글 작성자와 같거나, 관리자의 세션일경우 덧글 삭제 버튼 생성 -->
				<td><%if(cdto.getId().equals(sId) || session.getAttribute("sAdmin") != null){%><input type="button" value="x" onclick="deleteComment(this.form, <%=i%>)"/></td><%} %>
			</tr>
			<%	}
		}
		%>
		<%
		// 로그인 한 상태(세션 존재)시, 덧글 작성탭 생성
		if(session.getAttribute("sId") != null || session.getAttribute("sAdmin") != null){
			if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") != null){ sId = sAdmin; }
			MemberDTO mdto = mdao.getMember(sId);
			%>
			<input type="hidden" name="newpostnum" value="<%=boardnum%>"/>
			<input type="hidden" name="newid" value="<%=sId%>"/>
			<input type="hidden" name="newpw" value="<%= mdto.getPw() %>"/>
			<tr>
				<td><%=mdto.getName()%><input type="hidden" name="newname" value="<%=mdao.searchName(sId)%>"/></td>
				<td><textarea name="newcomment_content" rows="2" cols="20"></textarea></td>
				<td><input type="button" value="덧글작성" onclick="insertComment(this.form)"/></td>
			</tr>
		<%}%>
	</table>
</form>
</body>
<footer>
	<%@ include file="../main/footer.jsp" %>
</footer>
		<%
	}catch(Exception e){}
%>
</html>