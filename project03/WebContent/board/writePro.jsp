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
		// 웹 서버의 폴더 경로를 읽어온다
		String path = request.getRealPath("/image");
		// 이미지 사이즈 지정
		int size = 1024*1024*10;
		// 인코딩 타입 지정
		String enc = "UTF-8";
		// 파일명이 중복시 처리
		DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
		// 멀티파트리퀘스트 객체 생성
		MultipartRequest mr = new MultipartRequest(request, path, size, enc, dp);
		BoardDAO dao = BoardDAO.getInstance();
		
		// Form에서 업로드한 파일이 null값이 아닐때는 파일 저장을 하지 않는다.
		if(mr.getFilesystemName("save") != null){
			// save(업로드한 이미지)의 파일 타입을 문자열로 받는다
			String fileType = mr.getContentType("save");
			// 위의 파일 타입은 image/jpeg 와 같은 형식으로 되어있으므로, 이를 배열에 담는다
			String [] ft = fileType.split("/");
			// 해당 파일을 File 타입으로 담은후, length로 용량을 담는다.
			File imagefile = mr.getFile("save");
			long s = imagefile.length();
			
			// imageChk 메서드를 통해 파일, 타입, 용량을 검사한다.
			// 10MB를 넘을경우 false, image 파일이 아닐경우도 false 출력
			boolean imagechk = dao.imageChk(imagefile, ft, s);
			if(imagechk==false){
				imagefile.delete();
				%><script>
				alert("파일의 형식과 크기를 다시 체크하고 업로드 해주세요");
				history.go(-1);
				</script> <%
			}
			// 업로드한 파일이 저장된 실제 이름을 sys에 담는다.
			String sys = mr.getFilesystemName("save");
			// dto에 설정.
			dto.setFileroot(sys);
			
			// 여기서부터는 라이브러리의 썸네일을 만드는 메서드를 활용한다. 
			ParameterBlock pb = new ParameterBlock();
			// 실제 파일 명 (경로 + 파일명)을 더하고, 50*50 사이즈로 만든다.  
			pb.add(path+"/"+sys);
			RenderedOp rOp =  JAI.create("fileload", pb);
			BufferedImage bi = rOp.getAsBufferedImage();
			BufferedImage thumb = new BufferedImage(50, 50, BufferedImage.TYPE_INT_RGB);
			Graphics2D g = thumb.createGraphics();
			g.drawImage(bi, 0, 0, 50, 50, null);
			// 실제 파일의 이름 앞에 thum_이 붙도록 지정
			File file = new File(path+ "/thum_" + sys);
			ImageIO.write(thumb, "jpg", file);
		}
		
		
		// form 에서 multipart를 선언시 request를 사용하여 값을 받을수 없고, mr(multipartrequest)를 통해 받아와야한다.
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
		
		if(content==null){
			response.sendRedirect("boardList.jsp");
		}
		
		// 현재 시간과 작성한 내용을 모두 dto에 담는다.
		// multipart기 때문에 jsp의 셋프로퍼티  * 가 불가능하기에 일일히 지정해주어야함.
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
		
		// boolean 타입으로 메서드를 실행해 유효성 검사를 진행후 return
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