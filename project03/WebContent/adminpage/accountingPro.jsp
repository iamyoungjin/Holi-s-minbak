<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.util.List"%>
<%@page import="test.web.project03.AccountingVO"%>
<%@page import="test.web.project03.AccountingDAO"%>
<script src= https://code.jquery.com/jquery-3.4.1.min.js></script>    
<%
	String method = request.getParameter("method");
	AccountingDAO dao =  new AccountingDAO();
	List blacklist = new ArrayList();
	List list = new ArrayList();
	
	
	if(method.equals("blacklistcancel")){
		list = dao.blacklist_c("cancel");
		if(list.size()!= 0){
			for(int i=0;i<list.size();i++){
				AccountingVO avo = (AccountingVO)list.get(i);
				if(avo.getCnt()>2){
					blacklist.add(avo.getRe_id());%>
					
					<h2>블랙 리스트</h2>
					<table border="1">
						<tr>
							<td>id</td>
							<td>예약 취소 횟수</td>
						</tr>
						
						<tr>
							<td><%=avo.getRe_id()%></td>
							<td><%=avo.getCnt()%></td>
						</tr>
					</table>
				<% }
		}
	}else{%>
		<td>해당 정보가 없습니다 </td>
<% 	}
	}else if(method.equals("blacklistwaiting")){
		list = dao.blacklist_c("waiting");
	
		if(blacklist.size()!= 0){
			for(int i=0;i<list.size();i++){
				AccountingVO avo = (AccountingVO)list.get(i);
				if(avo.getCnt()>2){
					blacklist.add(avo.getRe_id());%>
					
					<h2>블랙 리스트</h2>
					<table border="1">
						<tr>
							<td>id</td>
							<td>예약 대기 갯수</td>
						</tr>
						
						<tr>
							<td><%=avo.getRe_id()%></td>
							<td><%=avo.getCnt()%></td>
						</tr>
					</table>
				<% }
			}
		}else{%>
			<tr>
				<td>해당 정보가 없습니다 </td>
			</tr>	
		<% }
	}else{%>
		<tr>
			<td>해당 정보가 없습니다 </td>
		</tr>	
	<%}
	
%>	
	

