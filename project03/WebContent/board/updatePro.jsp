<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="test.web.project03.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<jsp:useBean id="dto" class="test.web.project03.BoardDTO"/>
<body>
<%
	String path=request.getRealPath("/image");
	int size = 1024*1024*10;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, size, enc, dp);
	
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	String id = request.getParameter("id");
	
	
	if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") == null){%>
	<script>
		alert("잘못된 접근입니다.");
		history.go(-1);
	</script>
	<%}else if(!(id.equals(sId) || id.equals(sAdmin))){%>
		<script>
		alert("작성자만 수정 할 수 있습니다.");
		history.go(-1);
		</script>
	<%}else{
		BoardDAO bdao = BoardDAO.getInstance();
		String oldImage = mr.getParameter("oldImage");
		if(mr.getFilesystemName("save")==null){
			// 신규 파일이 없을때
			if(!mr.getParameter("oldImage").equals("null")){
				dto.setFileroot(oldImage);
			}
		}else if(mr.getFilesystemName("save") != null){
			String fileType = mr.getContentType("save");
			String [] ft = fileType.split("/");
			File imagefile = mr.getFile("save");
			long s = imagefile.length();
			
			boolean imagechk = bdao.imageChk(imagefile, ft, s);
			if(imagechk==false){
				imagefile.delete();
				%><script>
				alert("파일의 형식과 크기를 다시 체크하고 업로드 해주세요");
				history.go(-1);
				</script> <%
			}
			String sys = mr.getFilesystemName("save");
			dto.setFileroot(sys);
		}
		
		
		int boardnum = Integer.parseInt(mr.getParameter("boardnum"));
		String pageNum = request.getParameter("pageNum");
		String subject = mr.getParameter("subject");
		String content = mr.getParameter("content");
		
		dto.setBoardnum(boardnum);
		dto.setSubject(subject);
		dto.setContent(content);
		
		
		boolean chk = bdao.updatePost(dto);
		
		if(chk){%>
			<script>
			alert("수정 완료.");
			<%response.sendRedirect("content.jsp?boardnum="+boardnum+"&pageNum="+pageNum);%>
			</script>
		<%}else{%>
			<script>
			alert("수정 도중 오류가 발생했습니다. 다시 시도해주세요.")
			history.go(-1);
			</script>
		<%}
	}
%>
</body>
</html>