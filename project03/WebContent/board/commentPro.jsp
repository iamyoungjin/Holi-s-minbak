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
	
	// 해당 게시글로 돌려보내기 위해 boardnum과 pageNum을 받아두고, 처리에 따라 쓰기위한 type 역시 받는다
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
		// boolean 선언
		boolean chk = false;
		
		if(type.equals("insert")){
			// content페이지에서 type을 insert로 지정되어 왔을시, insertComment 메서드를 실행한다.
			// 이를 boolean으로 메서드의 정상 작동 여부를 파악한다.
			chk = cdao.insertComment(dto);
			if(chk == false){
				// chk 값이 false일 경우, 에러메세지 출력
				%><script>alert("에러가 발생했습니다. 다시 시도해주세요.");history.go(-1);</script><%
			}else{
				// 메서드가 정상 작성시 다시 content로 보냄
				response.sendRedirect("content.jsp?boardnum="+boardnum+"&pageNum="+pageNum);
			}
		}else if(type.equals("delete")){
			// 삭제 메서드 시행. 메서드내에서 본인 확인을 하기때문에 sAdmin의 세션값 조정
			if(session.getAttribute("sId") == null && session.getAttribute("sAdmin")!= null){ sId = sAdmin; }
			// 매개변수로 아이디값을 들고 메서드 실행
			chk = cdao.deleteComment(dto.getCommentnum(), sId);
			if(chk == false){
				%><script>alert("에러가 발생했습니다. 다시 시도해주세요.");history.go(-1);</script><%
			}else{
				response.sendRedirect("content.jsp?boardnum="+boardnum+"&pageNum="+pageNum);
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