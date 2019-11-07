<%@page import="test.web.qnaboard.QNABoardDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<jsp:useBean id ="dto" class="test.web.qnaboard.QNABoardDTO"/>
<%
	String sId=(String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	
	if(session.getAttribute("sId") != null && session.getAttribute("sAdmin") !=null){%>
		<script>
			alert("비회원 작성입니다!!");
		</script>
	<%}else{
		String enc = "UTF-8";
		QNABoardDAO dao = QNABoardDAO.getInstance();
		
		int boardnum = Integer.parseInt(request.getParameter("boardnum"));
		int ref = Integer.parseInt(request.getParameter("ref"));
		int re_step = Integer.parseInt(request.getParameter("re_step"));
		int re_level = Integer.parseInt(request.getParameter("re_level"));
		String name = request.getParameter("name");
		String pw = request.getParameter("pw");
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");
		
		dto.setBoardnum(boardnum);//글번호
		dto.setRef(ref);//그룹넘버 같은것으로 num글의 댓글이 달릴 경우 같은 번호를 사용함
		dto.setRe_step(re_step);//원글은 0, 댓글은 0+1 재 댓글은 ref가 같은 번호가 있다면 앞 번호 = 1 + 1
		dto.setRe_level(re_level);//깊이(들여쓰기) 표시 순서 로 원글은 0, 댓글은 0+1, 댓글의 댓글은 0+1+1
		dto.setName(name);//작성자
		dto.setPw(pw);//비밀번호
		dto.setSubject(subject);//제목
		dto.setContent(content);//내용
		dto.setReg_date(new Timestamp(System.currentTimeMillis()));//글쓴날
		//게시물이 작성되었으면 리스트로 가게 만든다
		boolean postChk = dao.insertPost(dto);
		if(postChk){%>
			<script>
				alert("게시글이 작성 했습니다");
				window.location.href="qnaboardlist.jsp";
			</script>
		<%}
	}
%>

<body>

</body>
</html>
