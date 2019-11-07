<%@page import="test.web.qnaboard.QNABoardDTO"%>
<%@page import="test.web.qnaboard.QNABoardDAO"%>
<%@page import="test.web.project03.MemberDTO"%>
<%@page import="test.web.project03.MemberDAO"%>
<%@page import="test.web.project03.CommentDTO"%>
<%@page import="java.util.List"%>
<%@page import="test.web.project03.CommentDAO"%>
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
		QNABoardDAO dao = QNABoardDAO.getInstance();
		QNABoardDTO dto = dao.getPost(boardnum);
		
		int ref = dto.getRef();
		int re_step = dto.getRe_step();
		int re_level = dto.getRe_level();
%>
<%//게시물 내용 불러와서 확인 할수있도록 출력문들을 입력함 %>
<title><%=dto.getSubject() %></title>
</head>
<body>
<form>
	<table border ="1">
		<tr>
			<td>글번호</td>
			<td><%=dto.getBoardnum() %></td>
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
			<pre><%=dto.getContent() %></pre></td>
		</tr>	
	</table>
	<%//수정은 업데이트 삭제 딜리트 댓글은 로그인 비회원 구분해서 쓰며 목록은 리스트로 이동한다 %>
	<tr>	
			<td colspan="4">
			<input type="button" value="글수정" onclick="window.location.href='qnaupdateForm.jsp?boardnum=<%=dto.getBoardnum()%>&pageNum=<%=pageNum%>&id=<%=dto.getId()%>'"/>
		  	&nbsp;
			<input type="button" value="글삭제" onclick="chkDelete(); window.location.href='qnadeleteForm.jsp?boardnum=<%=dto.getBoardnum()%>&pageNum=<%=pageNum%>&id=<%=dto.getId()%>'"/>
			&nbsp;
			<%if(session.getAttribute("sId") != null || session.getAttribute("sAdmin") != null){ %>
			<input type="button" value="답글" onclick="window.location.href='qnawriteForm.jsp?boardnum=<%=boardnum%>&ref=<%=ref%>&re_step=<%=re_step%>&re_level=<%=re_level%> '"/>
			<%}else{ %>
			<input type="button" value="답글" onclick="window.location.href='bqnawriteForm.jsp?boardnum=<%=boardnum%>&ref=<%=ref%>&re_step=<%=re_step%>&re_level=<%=re_level%> '"/>
			<%} %>
			&nbsp;
			<input type="button" value="글목록" onclick="window.location.href='qnaboardlist.jsp?pageNum=<%=pageNum%>'"/></td>
		</tr>
</form>

</body>
		<%
	}catch(Exception e){}
%>
</html>