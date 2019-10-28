<%@page import="test.web.project03.BoardDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="test.web.project03.BoardDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 관리 페이지</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script>
	var check = false;
	function chkall(){
		var chk = document.getElementsByName("chkpost");
		if(check==false){
			check = true;
			for(var i=0; i<chk.length;i++){
				chk[i].checked = true;
			}
		}else{
			check = false;
			for(var i=0; i<chk.length;i++){
				chk[i].checked = false;
			}
		}
	}
	
	
	function selectDel(){
		var chk = document.getElementsByName("chkpost");
		var len = chk.length;
		var checkRow = '';
		var checkCount = 0;
		var uri = '';
		var cnt = 0;
		
		for(var i=0; i<len; i++){
			if(chk[i].checked == true){
				checkCount++;
			}else{
				cnt++;				
			}
		}
		
		for(var i=0; i<len; i++){
			if(chk[i].checked == true){
				checkRow = chk[i].value;
				uri += "&boardnum"+i+"="+checkRow
				checkRow = '';
			}
		}
		if(len == cnt){
			alert("하나 이상의 체크박스를 선택후 눌러주세요");
			return false;
		}else{
			window.location.href = "checkBoardPro.jsp?type=delete&length="+len+uri;
		}
	}

</script>
</head>
<body>
<form name="postform" method="post">
<%
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
	<script>
	alert("권한이 없습니다.");
	history.go(-1);
	</script>
	<%}else{
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
<%
	if(count == 0){
%>
	<b>게시판에 저장된 글이 없습니다.</b>
	<%}else{%>
	<table border="1">
		<tr>
			<td><input type="checkbox" id="checkall" name="checkall" onclick="chkall()"/></td>
			<td>게시글 번호</td>
			<td>제목</td>
			<td>작성자(아이디)</td>
			<td>작성일</td>
			<td>조회수</td>
		</tr>
			<script>
				$(".chkpost").click(function(){
					$("#checkall").prop("checked", false);
					console.log("1");
				});
			</script>
<%
	for(int i =0; i<postList.size(); i++){
		BoardDTO dto = (BoardDTO)postList.get(i);
%>		
		<tr>
			<input type="hidden" name="boardnum<%=i%>" value="<%=dto.getBoardnum() %>" />
			<td><input type="checkbox" name="chkpost" value="<%=dto.getBoardnum()%>"/>
			<td><%= number-- %></td>
			<td>
			<%
				int wid=0;
				if(dto.getRe_level()>0){
					wid = 10 * (dto.getRe_level());%>
				<b>└</b>
			<%}
			if(dto.getFileroot()!=null){%><img src="/project03/image/thum_<%=dto.getFileroot()%>"/><%}%>
			<a href ="content.jsp?boardnum=<%=dto.getBoardnum()%>&pageNum=<%=currentPage%>"><%=dto.getSubject() %></a>
			</td>
			<td><%=dto.getName() %>(<%=dto.getId()%>)</td>
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
<br/>
<input type="button" value="선택 삭제" onclick="selectDel()"/>
<input type="button" value="체크 해제"/>
<input type="button" value="게시판 설정" />
<input type="button" value="돌아가기" onclick="location.href='adminpage.jsp'"/>
</form>

</body>
</html>
	<%}

%>
	

</body>
</html>