<%@page import="test.web.qnaboard.QNABoardDAO"%>
<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.sql.Timestamp" %>

<% request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="dto" class="test.web.qnaboard.QNABoardDTO"/>
<jsp:setProperty property ="*" name ="dto"/>
<%
  String pageNum = request.getParameter("pageNum");
  QNABoardDAO dao = QNABoardDAO.getInstance();
  boolean chk = dao.deletePost(dto);

  if(chk){%>
  <script>
  alert("삭제되었습니다.");
  window.location.href = "qnaboardlist.jsp";
  </script>
<%}else{%>
   <script>
   alert("비밀번호가 틀렸습니다.");
   history.go(-1);
   </script>
<%}%>