<%@page import="test.web.project03.CommentDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<jsp:useBean id="dto" class="test.web.project03.CommentDTO"/>
<jsp:setProperty property="*" name="dto"/>

<%
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	
	String boardnum = request.getParameter("boardnum");
	String pageNum = request.getParameter("pageNum");
	String type = request.getParameter("type");
	
	if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") == null ){%>
	<script>
		alert("권한이 없습니다.");
		history.go(-1);
	</script>
<%	}else{
		CommentDAO cdao = CommentDAO.getInstance();
		boolean chk = false;
		if(type.equals("insert")){
			chk = cdao.insertComment(dto);
			if(chk == false){
				%><script>alert("에러가 발생했습니다. 다시 시도해주세요.");history.go(-1);</script><%
			}else{
				response.sendRedirect("qnacontent.jsp?boardnum="+boardnum+"&pageNum="+pageNum);
			}
		}else if(type.equals("delete")){
			if(session.getAttribute("sId") == null && session.getAttribute("sAdmin")!= null){ sId = sAdmin; }
			chk = cdao.deleteComment(dto.getCommentnum(), sId);
			if(chk == false){
				%><script>alert("에러가 발생했습니다. 다시 시도해주세요.");history.go(-1);</script><%
			}else{
				response.sendRedirect("qnacontent.jsp?boardnum="+boardnum+"&pageNum="+pageNum);
			}
			
		}else{%>
			<script>
				alert("에러가 발생했습니다. 다시 시도해주세요.");
				history.go(-1);
			</script>
		<%}
	
	}
%>
<body>

</body>
</html>