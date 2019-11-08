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
				// dto.getRe_level로 답글의 단계를 파악후, 그 값에 10을 곱하는것으로 그만큼 간격을 두고, └를 통해 답글임을 표시해준다.
				int wid=0;
				if(dto.getRe_level()>0){
					wid = 10 * (dto.getRe_level());%>
				<b>└</b>
			<%}
			// 이미지가 잇을시, 생성해둔 썸네일을 불러온다
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
	//게시글이 존재할 경우(count>0), 페이징 처리
	if(count >0){
		// pageCount는 count를 pageSize로 나눈것에, 글 갯수가 페이지 사이즈와 딱 맞아떨어지지 않으면 여분의 페이지를 하나 더 만들어 페이징 처리한다
		int pageCount = count / pageSize + (count % pageSize == 0? 0 : 1);
		// startPage는 페이지를 1,11 단위로 끊기 위해 사용한다.
		int startPage = (int)(currentPage/10)*10+1;
		// pageBlock = 아래 목록을 최대 10페이지씩 노출
		int pageBlock = 10;
		// 마지막으로 노출될 페이지. 이 이후는 [다음]이 뜬다
		int endPage = startPage + pageBlock-1;
		
		// 총 페이지 수가 endpage 기본값보다 적을시, endpage에 새값 대입
		if(endPage>pageCount){
			endPage = pageCount;
		}
		// if문을 통해 돌아가기 구현
		if(startPage>10){%>
		<a href="boardList.jsp?pageNum=<%=startPage-10 %>">[이전]</a>
<%		}
		// for문으로 각 페이지생성
		for(int i=startPage; i<= endPage; i++){%>
		<a href="boardList.jsp?pageNum=<%=i%>">[<%=i%>]</a>
<%		}
		// pageBlock에 지정된 수를 넘어가면 [다음] 으로 넘어가게 설정.
		if(endPage<pageCount){%>
		<a href="boardList.jsp?pageNum=<%=startPage+10 %>">[다음]</a>		
<%
		}
	}
%>
<form name="searchForm">
<table>
	<tr>
		<!-- 검색을 위한 value 값 -->
		<td>
		<select name = "search">
			<option value="0">--선택-- </option>
			<option value="1">제목</option>
			<option value="2">내용</option>
			<option value="3">작성자</option>
		</select>
		</td>
		<!-- 검색 키워드를 입력 받기위한 text. 초기값으로 ""를 집어넣어둔다 -->
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