<%@page import="test.web.qnaboard.QNABoardDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<title>Insert title here</title>
</head>
<jsp:useBean id="dto" class="test.web.qnaboard.QNABoardDTO"/>

<%	
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") == null){%>
		<script>
			alert("잘못된 접근입니다");
			history.go(-1);		
		</script>
	<%}else{
		String enc = "UTF-8";
		QNABoardDAO dao = QNABoardDAO.getInstance();
		
	
		int boardnum = Integer.parseInt(request.getParameter("boardnum"));
		int ref = Integer.parseInt(request.getParameter("ref"));
		int re_step = Integer.parseInt(request.getParameter("re_step"));
		int re_level = Integer.parseInt(request.getParameter("re_level"));
		int category = Integer.parseInt(request.getParameter("category"));
		String name = request.getParameter("name");
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");
		
		dto.setBoardnum(boardnum);
		dto.setRef(ref);
		dto.setRe_step(re_step);
		dto.setRe_level(re_level);
		dto.setCategory(category);
		dto.setName(name);
		dto.setId(id);
		dto.setPw(pw);
		dto.setSubject(subject);
		dto.setContent(content);
		dto.setReg_date(new Timestamp(System.currentTimeMillis()));
		
		boolean postChk = dao.insertPost(dto);
		if(postChk){%>
			<script>
				alert("게시글이 작성되었습니다.")
				window.location.href="qnaboardlist.jsp";
			</script>
		<%}else{%>
			<script>
				alert("게시글 작성에 실패했습니다.")
				history.go(-1);
			</script>
	<%	}
	}
%>
<body>
</body>
</html>