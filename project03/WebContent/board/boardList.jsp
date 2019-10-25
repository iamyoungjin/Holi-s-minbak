<%@page import="test.web.project03.BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="test.web.project03.BoardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
</head>
<%
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	String sName = (String)session.getAttribute("sName"); 
	String boardType = "board";
	
	int pageSize = 10;
	SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd HH:mm");
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage -1) * pageSize +1;
	int endRow = currentPage * pageSize;
	int count = 0;
	int number = 0;
	
	List postList = null;
	BoardDAO bdao = BoardDAO.getInstance();
	count = bdao.getPostCount();
	if(count>0){
		postList = bdao.getPosts(startRow,endRow); 
	}
	number = count - (currentPage-1)*pageSize;
	
%>
<body>
<center><b>글 목록 (전체 글 : <%=count %>)</b></center>
<table>
	<tr align="right">
		<%if((String)session.getAttribute("sId") == null && (String)session.getAttribute("sAdmin") == null){ %>
		<td><a href="../login/loginForm.jsp?boardType=<%=boardType%>">로그인</a>
		<%}else{ %>
		<td><%if( sName != null){out.print(sName);}%>님 안녕하세요
			<a href="../login/logout.jsp?boardType=<%=boardType%>">로그아웃</a>
		<%}%>
		<td><a href="../main/main.jsp">돌아가기</a></td>
		<td><a href="writeForm.jsp">글쓰기</a></td>
	</tr>
</table>
<%
	if(count == 0){
%>
	<b>게시판에 저장된 글이 없습니다.</b>
	<%}else{%>
	<table border="1">
		<tr>
			<td>게시글 번호</td>
			<td>제목</td>
			<td>작성자</td>
			<td>작성일</td>
			<td>조회수</td>
		</tr>
		
<%
	List noticeList = bdao.getNotice();
	if(noticeList!=null){
		for(int i = 0; i<noticeList.size(); i++){
			BoardDTO notice = (BoardDTO)noticeList.get(i);%>
			<tr>
				<td><strong>공지</strong></td>
				<td><a href ="content.jsp?boardnum=<%=notice.getBoardnum()%>&pageNum=<%=currentPage%>"><%=notice.getSubject() %></a></td>
				<td><%=notice.getName() %></td>
				<td><%=sdf.format(notice.getReg_date()) %></td>
				<td><%=notice.getReadcount() %></td>
			</tr>
		<%}
	}
	
	 
	for(int i =0; i<postList.size(); i++){
		BoardDTO dto = (BoardDTO)postList.get(i);
		
%>	
		<tr>
			<td><%= number-- %></td>
			<td>
			<%
				int wid=0;
				if(dto.getRe_level()>0){
					wid = 10 * (dto.getRe_level());%>
				<b>└</b>
			<%}%>
			<a href ="content.jsp?boardnum=<%=dto.getBoardnum()%>&pageNum=<%=currentPage%>"><%=dto.getSubject() %></a>
			</td>
			<td><%=dto.getName() %></td>
			<td><%=sdf.format(dto.getReg_date()) %></td>
			<td><%=dto.getReadcount() %></td>
		</tr><%		
	}
%>
	</table>
<%}%>
<%
	if(count >0){
		int pageCount = count / pageSize + (count % pageSize == 0? 0 : 1);
		int startPage = (int)(currentPage/10)*10+1;
		int pageBlock = 10;
		int endPage = startPage + pageBlock-1;
		if(endPage>pageCount){
			endPage = pageCount;
		}
		if(startPage>10){%>
		<a href="boardList.jsp?pageNum=<%=startPage-10 %>">[이전]</a>
<%		}
		for(int i=startPage; i<= endPage; i++){%>
		<a href="boardList.jsp?pageNum=<%=i%>">[<%=i%>]</a>
<%		}
		if(endPage<pageCount){%>
		<a href="boardList.jsp?pageNum=<%=startPage+10 %>">[다음]</a>		
<%
		}
	}
%>
</body>
</html>