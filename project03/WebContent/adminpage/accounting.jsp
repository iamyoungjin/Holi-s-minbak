<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="test.web.project03.RoomDTO"%>
<%@page import="java.util.List"%>
<%@page import="test.web.project03.RoomDAO"%>
<%@page import="test.web.project03.AccountingVO"%>
<%@page import="test.web.project03.AccountingDAO"%>
<%@page import="test.web.calendar.ReservationVO"%>
<%@page import="test.web.calendar.ReservationDAO"%>
<script src= https://code.jquery.com/jquery-3.4.1.min.js></script>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<%
	//오늘 날짜 
	Calendar c = Calendar.getInstance();
	String year = String.valueOf(c.get(Calendar.YEAR));
	String month=null;
	String day = null;
	if(c.get(Calendar.MONTH)+1<10){
		month = "0"+String.valueOf(c.get(Calendar.MONTH));
	}else{
		month = String.valueOf(c.get(Calendar.MONTH)+1);
	}
	if(c.get(Calendar.DAY_OF_MONTH)<10){
		day = "0"+String.valueOf(c.get(Calendar.DAY_OF_MONTH));	
	}else{
		day = String.valueOf(c.get(Calendar.DAY_OF_MONTH));	
	}
	String today =year+"/"+month+"/"+day;
%>

</head>

<%
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
		<script>
			alert("권한이 없습니다.");
			history.go(-1);
		</script>
<%	}else{

		
%>--------------------------------------------------------------------------------------
<%ReservationVO vo = new ReservationVO();
  AccountingVO dto = new AccountingVO();
  
int action = 0; 
int currYear = 0;
int currMonth = 0;
String boxSize = "70";

Calendar cal = Calendar.getInstance();

//액션이 null 지금년도, 지금월 ,1일로 세팅 
if(request.getParameter("action") == null) {
     currMonth = c.get(Calendar.MONTH);
     currYear = c.get(Calendar.YEAR);
     cal.set(currYear,currMonth,1);
} else {
   	//액션 이 있을 때 날짜 파라미터로 초기화 
     if(request.getParameter("action") != null){
          currMonth = Integer.parseInt(request.getParameter("month"));
          System.out.println(currMonth);
          currYear = Integer.parseInt(request.getParameter("year"));
         //액션(1) 다음달로 넘어갈 때 다음달 파라미터로 변경 
          if(Integer.parseInt(request.getParameter("action"))==1) {
               cal.set(currYear, currMonth, 1); //현재 년 현재 월에 1일 로 셋팅                                                                                                                                                                                                                                                                                                                                                                                                                                            
               //cal.add(Calendar.MONTH, 1); // 달 하나 증가 
               currMonth = cal.get(Calendar.MONTH); //증가한 값으로 현재 달 설정 
               currYear = cal.get(Calendar.YEAR); //현재 년 설정
               System.out.println(cal.get(Calendar.MONTH));
          //액션(-1) 전달로 넘어갈 때    
          } else {              
               cal.set(currYear, currMonth, 1); //현재 년 현재 월에 1일 로 셋팅 
               //cal.add(Calendar.MONTH, -1); //달 하나 감소 
               currMonth = cal.get(Calendar.MONTH);//감소한 값으로 현재 달 설정 
               currYear = cal.get(Calendar.YEAR);  //현재 년 설정 
          }
         
     }
}

%>
<table border='0' width='521' border-collapse:collapse >
  <tr >
     <td width='150' align='right' valign='middle'>
     	<a href="../adminpage/accounting.jsp?month=<%=currMonth-1%>&year=<%=currYear%>&action=0">
     		<font size="2"><<<</font>
     	</a>
     </td>
     <td width='260' align='center' valign='middle'>
     	<b><%= vo.getTitle(cal)%>월</b>
     </td>
     <td width='173' align='left' valign='middle'>
     	<a href="../adminpage/accounting.jsp?month=<%=currMonth+1%>&year=<%=currYear%>&action=1">
     		<font size="2">>>></font>     		
     	</a>
    </td>
  </tr>
</table>
			<%
			//월 총 액
			
			Calendar cc = Calendar.getInstance();
			AccountingDAO dao = new AccountingDAO();
			List lst = new ArrayList();
			String yearmonth= currYear+"/"+(currMonth+1);
			System.out.println(yearmonth);
			int tot=0;
			//lst = dao.month_income(currYear,currMonth+1);
			//lst = dao.month_income(cc.get(Calendar.YEAR),(cc.get(Calendar.MONTH)+1));
			lst = dao.month_income(yearmonth);
			for(int i=0;i<lst.size();i++){
				tot+=Integer.parseInt(lst.get(i).toString());
			}
			%>



		<table border="1">
			<tr>
				<td colspan="15" text-align="center"><b><%=vo.getTitle(cal)%>월 입금액 계산</b></td>
			</tr>
			<tr>
				<td>총 수입 </td>
				<td>산들방</td>
				<td>매화방</td>
				<td>들꽃방</td>
				<td>소나무방</td>
				<td>해뜰방</td>
				<td>민들레방</td>
			</tr>
			<tr>
				<td><%= tot %>원</td>
				<td><%= dto.room_totprice(yearmonth,"산들방")%>원</td>
				<td><%= dto.room_totprice(yearmonth,"매화방")%>원</td>
				<td><%= dto.room_totprice(yearmonth,"들꽃방")%>원</td>
				<td><%= dto.room_totprice(yearmonth,"소나무방")%>원</td>
				<td><%= dto.room_totprice(yearmonth,"해뜰방")%>원</td>
				<td><%= dto.room_totprice(yearmonth,"민들레방")%>원</td>
				
			</tr>
		</table>
	
	<br/>
	<br/>



<script>
function search(){
	var x = document.getElementById("searchacc").value;

	$.ajax({
		type: "post",
		url : "accountingPro.jsp",

		data : {method:x},
		success:function(data){
			data = data.trim();
			$("#tester").html(data);
			data = data.trim();
			
		},
	});
}
</script>

------------------------------------------------------------------------------
	<div id="searchForm">
		<table border="1">
			<tr>
			<td colspan="9" text-align="center"><b>블랙리스트 관리</b></td>
			<td>
				<select id="searchacc" onchange="search()" name="selectmethod" value="search()">
					<option value=""> 블랙 리스트 검색 </option>
					<option value="blacklistcancel">취소 3회이상 </option>
					<option value="blacklistwaiting">미입금 3회이상 </option>
				</select>
			</td>
			</tr>
		</table>
		
	</div>
<br/>
<br/>
	<div id = "tester"></div>
	<input type="button" value="돌아가기" onclick="window.location.href='adminpage.jsp'"/>			
	<%}%>
		
<body>

</body>
<footer>
	<%@ include file="../main/footer.jsp" %>
</footer>
</html>