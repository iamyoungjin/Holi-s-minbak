<%@page import="test.web.project03.BoardDAO"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.Graphics2D"%>
<%@page import="javax.media.jai.JAI"%>
<%@page import="javax.media.jai.RenderedOp"%>
<%@page import="java.awt.image.renderable.ParameterBlock"%>
<%@page import="java.awt.image.RenderedImage"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.awt.Image"%>


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

<%	
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(session.getAttribute("sId") == null && session.getAttribute("sAdmin") == null){%>
		<script>
			alert("잘못된 접근입니다");
			history.go(-1);		
		</script>
	<%}else{
		String path = request.getRealPath("/image");
		int size = 1024*1024*10;
		String enc = "UTF-8";
		DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
		MultipartRequest mr = new MultipartRequest(request, path, size, enc, dp);
		BoardDAO dao = BoardDAO.getInstance();
		
		if(mr.getFilesystemName("save") != null){
			String fileType = mr.getContentType("save");
			
			String [] ft = fileType.split("/");
			File imagefile = mr.getFile("save");
			long s = imagefile.length();
			
			boolean imagechk = dao.imageChk(imagefile, ft, s);
			if(imagechk==false){
				imagefile.delete();
				%><script>
				alert("파일의 형식과 크기를 다시 체크하고 업로드 해주세요");
				history.go(-1);
				</script> <%
			}
			String sys = mr.getFilesystemName("save");
			dto.setFileroot(sys);
			ParameterBlock pb = new ParameterBlock();
			pb.add(path+"/"+sys);
			RenderedOp rOp =  JAI.create("fileload", pb);
			BufferedImage bi = rOp.getAsBufferedImage();
			BufferedImage thumb = new BufferedImage(50, 50, BufferedImage.TYPE_INT_RGB);
			Graphics2D g = thumb.createGraphics();
			g.drawImage(bi, 0, 0, 50, 50, null);
			File file = new File(path+ "/thum_" + sys);
			ImageIO.write(thumb, "jpg", file);
		}
		
		
		int boardnum = Integer.parseInt(mr.getParameter("boardnum"));
		int ref = Integer.parseInt(mr.getParameter("ref"));
		int re_step = Integer.parseInt(mr.getParameter("re_step"));
		int re_level = Integer.parseInt(mr.getParameter("re_level"));
		int category = Integer.parseInt(mr.getParameter("category"));
		String name = mr.getParameter("name");
		String id = mr.getParameter("id");
		String pw = mr.getParameter("pw");
		String subject = mr.getParameter("subject");
		String content = mr.getParameter("content");
		
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
				window.location.href="boardList.jsp";
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