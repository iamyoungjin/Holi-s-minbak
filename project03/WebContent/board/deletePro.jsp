<%@page import="test.web.project03.BoardDAO"%>
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
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") == null){%>
	<script>
		alert("글 삭제는 작성자만 할 수 있습니다.");
		history.go(-1);
	</script>
	<%}else{
		int boardnum = Integer.parseInt(request.getParameter("boardnum"));
		String pageNum = request.getParameter("pageNum");
		if(session.getAttribute("sId") == null && session.getAttribute("sAdmin")!= null){ sId = sAdmin; }
	
		BoardDAO bdao = BoardDAO.getInstance();
		boolean chk = bdao.deletePost(boardnum, sId);
	
		if(chk){%>
		<script>
		alert("정상적으로 삭제 되었습니다.");
		window.location.href = "boardList.jsp?pageNum=<%=pageNum%>";
		</script>
<%		}else{%>
		<script>
		alert("글 삭제는 본인만 할 수 있습니다.")
		history.go(-1);
		</script>
<%		}
	}
%>

<body>

</body>
</html>