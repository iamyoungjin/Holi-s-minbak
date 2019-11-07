<%@page import="test.web.calendar.SetDTO"%>
<%@page import="test.web.calendar.SetDAO"%>
<%@page import="test.web.project03.BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="test.web.project03.BoardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>

<script>
	

</script>

</head>
<header>
	<%@ include file="../main/header.jsp" %>
</header>

<%
	sId = (String)session.getAttribute("sId");
	sAdmin = (String)session.getAttribute("sAdmin");
	String sName = (String)session.getAttribute("sName"); 
	boardType = "board";
		
	// 검색을 시도할 경우 생기는 속성값 search(분류), keyword(검색어)
	String search = request.getParameter("search");
	String keyword = request.getParameter("keyword");
	
	// 게시글 갯수 설정을 위한 SetDAO
	SetDAO stdao = SetDAO.getInstance();
	SetDTO stdto = stdao.getSetting();
	
	// pageSize를 setting_table 에서 꺼내와서 조절한다. 관리자 페이지에서 관리자가 조절가능
	int pageSize = stdto.getPagesize();
	SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd HH:mm");
	
	// boardList에서 페이지 이동시 사용할 변수. 게시판에 첫 접근시 1로 지정
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	// search 변수를 가지고 오지 않았을시 기본값
	if(search == null){
		search = "0";
	}
	// 현재 페이지
	int currentPage = Integer.parseInt(pageNum);
	// 현재 페이지의 첫글 지정, 10개씩 글을 보여주는 상황에서 첫페이지를 보여준다고 가정하면 (0*10)+1, 1번째글 부터 시작한다
	int startRow = (currentPage -1) * pageSize +1;
	// 현재 페이지의 마지막 글 지정. 10개씩 글을 보여주는 상황에서 첫페이지를 보여준다고 가정하면 1*10, 10번째 글까지 가져온다.
	int endRow = currentPage * pageSize;
	
	// 변수 선언
	int count = 0;
	int number = 0;
	
	List postList = null;
	BoardDAO bdao = BoardDAO.getInstance();
	
	// 게시판의 총 글 갯수를 나타낸다. search와 keyword 값이 존재하면 해당 조건으로 검색된 글의 총 갯수가 나온다.
	count = bdao.getPostCount(search, keyword);
	
	// 글이 1개이상 존재할 경우, 한페이지에 보여줄 글을 끊어서 가져온다.
	if(count>0){
		postList = bdao.getPosts(startRow,endRow,search,keyword); 
	}
	// 실제 게시글의 번호가 아닌, 게시판에서 보일 글 번호 
	number = count - (currentPage-1)*pageSize;
	
%>
<body>
<center><b>글 목록 (전체 글 : <%=count %>)</b></center>

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
	// 공지사항을 상단 노출하기 위해 따로 공지사항을 노출한다.
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
	
	// 글을 노출한다.
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
			<%}
			if(dto.getFileroot()!=null){%><img src="/project01/image/thum_<%=dto.getFileroot()%>"/><%}%>
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
	<br/>
	<input type="button" value="돌아가기" onclick="window.location.href='../main/main.jsp'"/>
	<input type="button" value="글쓰기" onclick="window.location.href='writeForm.jsp'"/>
	<br/>

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
<form name="searchForm">
<table>
	<tr>
		<td>
		<select name = "search">
			<option value="0">--선택-- </option>
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

<footer>
	<%@ include file="../main/footer.jsp" %>
</footer>
</body>
</html>