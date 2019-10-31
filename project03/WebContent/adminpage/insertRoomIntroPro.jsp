<%@page import="test.web.project03.BoardDAO"%>
<%@page import="java.io.File"%>
<%@page import="test.web.project03.RoomDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>방 정보 수정</title>
</head>
<jsp:useBean id="dto" class="test.web.project03.RoomDTO"/>
<body>
<%
	int roomnum = Integer.parseInt(request.getParameter("num"));
	String path = request.getRealPath("/image");
	int size = 1024 * 1024 * 10;
	String enc = "UTF-8";
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	MultipartRequest mr = new MultipartRequest(request, path, size, enc, dp);
	
	
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
		<script>
			alert("잘못된 전근입니다.");
			history.go(-1);
		</script>
	<%}else{
		RoomDAO dao = RoomDAO.getInstance();
		String oldImage = mr.getParameter("oldImage");
		if(mr.getFilesystemName("save")==null){
			// 신규 파일이 없을때
			if(!mr.getParameter("oldImage").equals("null")){
				dto.setRoom_img(oldImage);
			}
		}else if(mr.getFilesystemName("save") != null){
			String fileType = mr.getContentType("save");
			String [] ft = fileType.split("/");
			File imagefile = mr.getFile("save");
			long s = imagefile.length();
			BoardDAO bdao = BoardDAO.getInstance();
			boolean imagechk = bdao.imageChk(imagefile, ft, s);
			if(imagechk==false){
				imagefile.delete();
				%><script>
				alert("파일의 형식과 크기를 다시 체크하고 업로드 해주세요");
				history.go(-1);
				</script> <%
			}
			String sys = mr.getFilesystemName("save");
			dto.setRoom_img(sys);
		}
		String intro = mr.getParameter("intro");
		dto.setIntro(intro);
		
		boolean chk = dao.updateIntro(roomnum, dto);
		if(chk){%>
			<script>
				alert("수정이 완료되었습니다.");
				window.location.href="checkRoomData.jsp";
			</script>
		<%}else{%>
			<script>
				alert("오류가 발생했습니다.");
				history.go(-1);
			</script>
		<%}
	}
	
%>

</body>
</html>