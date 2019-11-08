<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.Graphics2D"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="javax.media.jai.JAI"%>
<%@page import="javax.media.jai.RenderedOp"%>
<%@page import="java.awt.image.renderable.ParameterBlock"%>
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
	// 이미지 업로드를 위한 메서드.
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
	<%}else if(!id.equals(sId) && sAdmin == null){%>
		<script>
		alert("작성자만 수정 할 수 있습니다.");
		history.go(-1);
		</script>
	<%}else{
		BoardDAO bdao = BoardDAO.getInstance();
		String oldImage = mr.getParameter("oldImage");
			// 신규 파일이 없을때는 기존 이미지가 있을시에만 fileroot를 갱신한다
		if(mr.getFilesystemName("save")==null){
			// null값이 아닐경우만 dto를 통해 지정.
			if(!mr.getParameter("oldImage").equals("null")){
				dto.setFileroot(oldImage);
			}
		}else if(mr.getFilesystemName("save") != null){
			// 신규 파일이 있을경우, 새로 save에 담긴 파일을 저장후 DB에 담는다
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
			// 여기서부터 썸네일
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
		
		// multipart로 지정된 form 에서 넘어오는 데이터를 받기 위한 mr.getParameter()
		int boardnum = Integer.parseInt(mr.getParameter("boardnum"));
		String pageNum = request.getParameter("pageNum");
		String subject = mr.getParameter("subject");
		String content = mr.getParameter("content");
		
		// dto에 바뀔 값인 제목과 내용, 그리고 해당 글을 특정할 수 있는 기본키인 boardnum을 dto에 저장
		dto.setBoardnum(boardnum);
		dto.setSubject(subject);
		dto.setContent(content);
		
		// 메서드 실행
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