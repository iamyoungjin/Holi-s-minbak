<%@ page contentType="text/html;charset=euc-kr" %>

<%
  int boardnum = Integer.parseInt(request.getParameter("boardnum"));
  String pageNum = request.getParameter("pageNum");

%>
<html>
<head>
<title>게시판</title>

<script language="JavaScript">      
<!--      
  function deleteSave(){	
	if(document.deleteForm.passwd.value==''){
	alert("비밀번호를 입력하십시요.");
	document.deleteForm.pw.focus();
	return false;
 }
}    
// -->      
</script>
</head>

<body>
<center><b>글삭제</b>
<br>
<form method="POST" name="deleteForm"  action="qnadeletePro.jsp?pageNum=<%=pageNum%>" 
   onsubmit="return deleteSave()"> 
 <table border="1">
  <tr>
     <td >
       <b>비밀번호를 입력해 주세요.</b></td>
  </tr>
  <tr>
     <td>비밀번호 :   
     	<%if(session.getAttribute("sId") != null || session.getAttribute("sAdmin") !=null ){ %>
       <input type="password" name="pw" >
	   <input type="hidden" name="boardnum" value="<%=boardnum%>">
	   <%}else{ %>
	   <input type="password" name="pw" >
	   <input type="hidden" name="boardnum" value="<%=boardnum%>">
	   <%} %>
	   </td>
 </tr>
 <tr>
    <td>
      <input type="submit" value="글삭제"  >
      <input type="button" value="글목록"  onclick="document.location.href='qnaboardlist.jsp?pageNum=<%=pageNum%>'">     
   </td>
 </tr>  
</table> 
</form>
</body>
</html> 
