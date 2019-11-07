<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
  #footertable {
    width: 800px;
    height: 100px;
    margin-left: auto;
    margin-right: auto;
  }
</style>
</head>
<body>

<!-- footer페이지  -->
<br/>

<table border="1" id="footertable">
	<tr>
		<td align="center">호리네민박</td>
		<td align="center">연락처</td>
		<td align="center">계좌 </td>
		<td align="center">예약하기 </td>
	</tr>
	<tr>
		<td>
			업체명 : 호리네 민박 <br/>
			사업자번호 : 419-02-xx517 <br/>
			주소 : 경기 양평군 단월면 봉상리 xxx <br/>
		</td>
		<td>
			TEL : 031-792-xxxx<br/>
			HP : 010-9999-9999<br/>
			Email : EE@gmail.com<br/>
		</td>
		<td> (신한)110-351-111xxx 예금주 : xxx </td>
		<td><input type="button" value="예약하기" onclick="window.location.href='../reservation/reservationCalendar.jsp'"/> </td>
	</tr>
</table>

</body>
</html>