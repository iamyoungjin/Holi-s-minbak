<%@page import="java.text.SimpleDateFormat"%>
<%@page import="test.web.qnaboard.QNABoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="test.web.qnaboard.QNABoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
</head>
<%
	//세션값 가져오기
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	String sName = (String)session.getAttribute("sName"); 
	String boardType = "board";
	//키워드 생성
	String search = request.getParameter("search");
	String keyword = request.getParameter("keyword");
	//글개수가 10개일때 페이지 이동
	int pageSize = 10;
	//날짜
	SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd HH:mm");
	
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	if(search == null){
		search = "0";
	}
	//페이지넘기기 만들며 글갯수 카운터로 설정하며 넘버로 글번호 순차적으로 만든다
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage -1) * pageSize +1;
	int endRow = currentPage * pageSize;
	int count = 0;
	int number = 0;
	
	List postList = null;
	QNABoardDAO bdao = QNABoardDAO.getInstance();
	count = bdao.getPostCount(search, keyword);
	if(count>0){
		postList = bdao.getPosts(startRow,endRow,search,keyword); 
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
		<td><a href="qnawriteForm.jsp">글쓰기</a></td>
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
			<td>작성일자</td>
			<td>조회수</td>
		</tr>
		
<%
	for(int i =0; i<postList.size(); i++){
		
		QNABoardDTO dto = (QNABoardDTO)postList.get(i);
		
%>	
		<tr>
			<td><%= number-- %></td>
			<td>
			<%	int wid=0;
				if(dto.getRe_level()>0){
					wid = 10 * (dto.getRe_level());%>
				<b>└</b>
			<%}%>
			<a href ="qnacontent.jsp?boardnum=<%=dto.getBoardnum()%>&pageNum=<%=currentPage%>"><%=dto.getSubject() %></a></td>
			<td><%=dto.getName() %></td>
			<td><%=sdf.format(dto.getReg_date()) %></td>
			<td><%=dto.getReadcount() %></td>
		</tr>
		<%}%>
	</table>
<%}%>
<%// 페이지 이동 %>
<%if(count >0){
		int pageCount = count / pageSize + (count % pageSize == 0? 0 : 1);
		int startPage = (int)(currentPage/10)*10+1;
		int pageBlock = 10;
		int endPage = startPage + pageBlock-1;
		if(endPage>pageCount) endPage = pageCount;
		
		if(startPage>10){%>
		<a href="qnaboardlist.jsp?pageNum=<%=startPage-10 %>">[이전]</a>
<%		}
		for(int i=startPage; i<= endPage; i++){%>
		<a href="qnaboardlist.jsp?pageNum=<%=i%>">[<%=i%>]</a>
<%		}
		if(endPage<pageCount){%>
		<a href="qnaboardlist.jsp?pageNum=<%=startPage+10 %>">[다음]</a>		
<%
		}
	}
%>
<%//키워드 목록  %>
<form name="searchForm">
<table>
	<tr>
		<td>
		<select name = "search">
			<option value="0">전체 </option>
			<option value="1">제목</option>
			<option value="2">내용</option>
			<option value="3">작성자</option>
		</select>
		</td>
		<td><input type="text" name="keyword" value=""/></td>
		<td><input type="submit" value="검색" /></td>
	</tr>
</table>
</form>

</body>
</html>