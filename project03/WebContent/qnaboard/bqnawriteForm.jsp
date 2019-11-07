<%@page import="test.web.project03.MemberDTO"%>
<%@page import="test.web.project03.MemberDAO"%>
<%@page import="sun.security.jca.GetInstance"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비회원 작성</title>
<script>
	function bwriteSave(){
		if(!document.bqnawriteForm.bname.value){
			alert("이름을 입력하세요");
			return false;
		}
		if(!document.bqnawriteForm.subject.value){
			alert("제목을 입력하세요");
			return false;
		}
		if(!document.bqnawriteForm.content.value){
			alert("내용을 입력하세요");
			return false;
		}	
		if(!document.bqnawriteForm.pw.value){
			alert("비밀번호를 입력하세요");
			document.bqnawriteForm.pw.focus();
			return false;	
		}
	}
</script>
</head>
<%
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	int boardnum=0,ref=1,re_step=0,re_level=0;
	try{
		if(request.getParameter("boardnum") !=null){
			if(session.getAttribute("sAdmin") == null){%>
				<script>
					alert("관리자만 작성할수있습니다.");
					history.go(-1);
				</script>
			<%}
			boardnum = Integer.parseInt(request.getParameter("boardnum"));
			ref = Integer.parseInt(request.getParameter("ref"));
			re_step = Integer.parseInt(request.getParameter("re_step"));
			re_level = Integer.parseInt(request.getParameter("re_level"));
		}
		MemberDAO dao = MemberDAO.getInstance();
		if(session.getAttribute("sAdmin")!=null){sId = sAdmin;}
		MemberDTO dto = dao.getMember(sId);

  %>			
<body>
	<cemter>글쓰기<br/><br/>

	<form name ="bqnawriteForm" action="bqnawritePro.jsp" method="post" onsubmit="return bwriteSave()">
		<input type="hidden" name="boardnum" value="<%=boardnum %>"  />
		<input type="hidden" name="ref" value="<%=ref%>" />
		<input type="hidden" name="re_step" value="<%=re_step%>" />
		<input type="hidden" name="re_level" value="<%=re_level%>" />
		<%if(sId != null || sAdmin != null){%>
		<input type="hidden" name="name" value="<%=dto.getName()%>"/>
		<%}	%>
	<tabale boarder="1">
			<tr>
				<td>작성자 :
				<%if(sId != null || sAdmin != null){ %>			
				<input type="text" name="name">
				<%}else{ %>
				<input type ="text" name ="name" />
				<%} %></td><br/>	
			</tr>
			<tr>
				<td>제목:
				<%if(request.getParameter("boardnum")==null){%>
					<input type ="text" name="subject"/>
				<%}else{ %>
					<input type="text" name="subject" value="RE:"/>
				<%}%>
				</td><br/>
			</tr>
			<tr>
				<td>내용:<textarea rows="13" cols="40" name="content"></textarea></td><br/>
			</tr>
			<tr>
				<td>비밀번호:
				<input type="password" name="pw"/> 
				</td><br/>
			</tr>
			<tr>
				<td>
				<input type="submit" value="글쓰기"/>
				<input type="reset" value="다시작성"/>
				<input type="button" value="목록으로" onclick="window.location.href='qnaboardlist.jsp'"/>
				</td>
			</tr>
	</tabale>	
	<%}catch(Exception e){
			e.printStackTrace();
	}%>
	</form>
</body>
</html>