<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>  
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %>
<title>예약 취소 요청 게시판 </title>

<center><h1>cancel</h1>
<form action = "../reservation/cancelPro.jsp" methd = "post">
	<table width="400" border="1" cellspacing="0" cellpadding="0" align="center">
		<tr>
		<td align="center">제목 <input type="text" name="subject" placeholder="예약 취소 요청합니다."/></td>
		</tr>
		<tr>
		<td align="center">사유 <select name='cancel_reason'>
				<option value="r1">날짜변경</option>
				<option value="r2">방 변경 </option>
				<option value="r3">기타</option>
			</select></td>
		</tr>
		<tr>
		<td align="center">내용 <textarea row = "10" cols ="50" name="content"></textarea></td>
		</tr>
		<tr>
		<td align="center"><input type="submit" value = "요청"/></td>
		</tr>
	</table>
</form>
</center>

