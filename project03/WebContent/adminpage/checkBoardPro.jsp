<%@page import="test.web.project03.BoardDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
	<script>
		alert("권한이 없습니다.");
		history.go(-1);
	</script>
<%	}else{
		boolean chk = false;
		String type = request.getParameter("type");
		int len = Integer.parseInt(request.getParameter("length"));
		List<Integer> list = new ArrayList<Integer>();
		BoardDAO dao = BoardDAO.getInstance();
		
		if(type.equals("delete")){
			for(int i=0; i<len; i++){
				if(request.getParameter("boardnum"+i) != null){
					list.add(Integer.parseInt(request.getParameter("boardnum"+i)));
				}
			}
			chk = dao.selectDel(list);
			if(chk){
				response.sendRedirect("checkBoard.jsp");
			}else{%>
				<script>
					alert("삭제에 실패하였습니다.");
					history.go(-1);
				</script>
			<%}
		}else if(type.equals("?")){
			
		}
	
	}
%>

</body>
</html>