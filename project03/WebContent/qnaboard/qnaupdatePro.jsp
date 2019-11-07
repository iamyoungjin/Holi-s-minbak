<%@page import="test.web.qnaboard.QNABoardDAO"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<% request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="dto" class="test.web.qnaboard.QNABoardDTO"/>
<jsp:setProperty property="*" name="dto"/>
<%  
  QNABoardDAO dao = QNABoardDAO.getInstance(); 	
  boolean check = dao.updatePost(dto);
  //폼값이 일치하면 수정하기 비밀번호가 틀리면 다시 입력해야됨.
  if(check){%>
  <script>
  alert("수정되었습니다.");
  window.location.href="qnaboardlist.jsp";
  </script>
<% }else{ %>
   <script>
   alert("비밀번호가 틀렸습니다.");
   history.go(-1);
   </script>
<% } %>