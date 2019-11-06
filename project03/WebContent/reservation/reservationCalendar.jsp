<%@page import="test.web.project03.RoomDTO"%>
<%@page import="test.web.project03.RoomDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.List" %>
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("euc-kr");%>

<jsp:useBean id = "dto" class = "test.web.calendar.ReservationVO"/>
<jsp:setProperty property="*" name="dto"/>

<%

int action = 0; 
int currYear = 0;
int currMonth = 0;
String boxSize = "70";

Calendar c = Calendar.getInstance();
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
          currYear = Integer.parseInt(request.getParameter("year"));
         //액션(1) 다음달로 넘어갈 때 다음달 파라미터로 변경 
          if(Integer.parseInt(request.getParameter("action"))==1) {
               cal.set(currYear, currMonth, 1); //현재 년 현재 월에 1일 로 셋팅 
               //cal.add(Calendar.MONTH, 1); // 달 하나 증가 
               currMonth = cal.get(Calendar.MONTH); //증가한 값으로 현재 달 설정 
               currYear = cal.get(Calendar.YEAR); //현재 년 설정
               
          //액션(-1) 전달로 넘어갈 때    
          } else {              
               cal.set(currYear, currMonth, 1); //현재 년 현재 월에 1일 로 셋팅 
               //cal.add(Calendar.MONTH, -1); //달 하나 감소 
               currMonth = cal.get(Calendar.MONTH);//감소한 값으로 현재 달 설정 
               currYear = cal.get(Calendar.YEAR);  //현재 년 설정 
          }
         
     }
}

//확인을 위해 저장 된 년 월 파라미터 출력 
//System.out.println(currYear);
//System.out.println(currMonth+1); //month를 0으로 설정했기 때문에 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>예약 달력</title>
<style>
	
	#calendarTable, #calendarTable th, #calendarTable td   {
		border-collapse: collapse;
	} 
	
	#calendarTable {
		border:2px solid #000;
		width:650px; 
		
	}
	
	#calendarTable th, #calendarTable td {
		width: <%=boxSize%>px;
		border:1px solid #000;		
		border-collapse: collapse;
		padding: 5px;		
	}
	
	#calendarTable th {		
		background-color: #666;
		color: #fff;
		
	}	
	#calendarTable td {		
		height: <%=boxSize%>px;
		text-align : left;			
	}
	
	#calendarTable td.empty {
		background-color: #DFDCD8;
	}
	
	#calendarTable td.toDayColor {
		background-color: #491;
	}
	
	
</style>
</head>

<body bgcolor='white'>
<header>
	<%@ include file="../main/header.jsp" %>
</header>
<table border='0' width='521' border-collapse:collapse >
  <tr >
     <td width='150' align='right' valign='middle'>
     	<a href="../reservation/reservationCalendar.jsp?month=<%=currMonth-1%>&year=<%=currYear%>&action=0">
     		<font size="2">이전달</font>
     	</a>
     </td>
     <td width='260' align='center' valign='middle'>
     	<b><%= dto.getTitle(cal)%></b>
     </td>
     <td width='173' align='left' valign='middle'>
     	<a href="reservationCalendar.jsp?month=<%=currMonth+1%>&year=<%=currYear%>&action=1">
     		<font size="2">다음달</font>     		
     	</a>
    </td>
  </tr>
</table>

<table>
  <tr>         
  <td width="100%"  >
    <table id="calendarTable" >
       <tr>
              <th>Sun</th>
              <th>Mon</th>
              <th>Tue</th>
              <th>Wed</th>
              <th>Thu</th>
              <th>Fri</th>
              <th>Sat</th>                      
       </tr>
<%//'Calendar loop
     int currDay;
     String todayColor="#6C7EAA";
     int count = 1;
     int dispDay = 1;
	 currMonth+=1;
     for(int w=1;w<7;w++){  //행 %>  
    <tr>
		<% for(int d=1;d<8;d++){	//
        	  	//get : 현재 객체의 주어진 값의 필드에 해당하는 상수값 반환 
        	  	if(!(count >= cal.get(Calendar.DAY_OF_WEEK))){	//DAY_OF_WEEK : 현재 요일 (1:일 7:) ##########
            		//현재 월 요일에 맞게 시작점(1) 계산%>		
       			   <td class="empty"></td>
					<%count+=1;			
				}else{ 
					if(dto.isDate(currYear, currMonth,dispDay)){
						if(dispDay == c.get(Calendar.DAY_OF_MONTH) && c.get(Calendar.MONTH) == cal.get(Calendar.MONTH) && c.get(Calendar.YEAR) == cal.get(Calendar.YEAR) ){  
	                     	todayColor = "class='toDayColor'";
						}else{   
	                        todayColor = "";
	                    }%>		
	        	   	<td <%=todayColor%>><%=dispDay%><br>
	        	   
					<%ReservationDAO dao = new ReservationDAO(); 
					List list = dao.list();
					
					int year_t = (currYear);
					int month_t = currMonth;

					String date_t =null;
					if(dispDay<10){  
						date_t = '0'+String.valueOf(dispDay);
					}  
					else{  
					    date_t = String.valueOf(dispDay);
					}  
					String startday= (String)(year_t+"/"+month_t+"/"+date_t);
					String endday= startday;
					List roomtodaycheck = dao.roomtodaycheck(startday, endday);
					List roomtodaywaiting = dao.roomtodaywaiting(startday, endday);
					if(roomtodaycheck!= null){
					for(int i=0; i<roomtodaycheck.size();i++){
						String roomname = (String)roomtodaycheck.get(i);
						RoomDAO roomdao = RoomDAO.getInstance();
						List roomList = roomdao.showRoom();
						for(int j=0; j<roomList.size(); j++){
							RoomDTO roomdto = (RoomDTO)roomList.get(j);
							if(roomname.equals(roomdto.getRname())){%>
								<a href="../introduce/roomIntro.jsp?num=<%=roomdto.getNum()%>">
							<%}
							
						}%>
						<%=roomtodaycheck.get(i) %></a><br/>
					<%}
					}
						//waiting 인 상태의 방도 달력에 보여지도록 추가
					if(roomtodaywaiting!=null){
						for(int i=0; i<roomtodaywaiting.size();i++){
						String roomname = (String)roomtodaywaiting.get(i);
						RoomDAO roomdao = RoomDAO.getInstance();
						List roomList = roomdao.showRoom();
						for(int j=0; j<roomList.size(); j++){
							RoomDTO roomdto = (RoomDTO)roomList.get(j);
							if(roomname.equals(roomdto.getRname())){%>
								<a href="../introduce/roomIntro.jsp?num=<%=roomdto.getNum()%>">
							<%}
							
						}%>
						<%=roomtodaywaiting.get(i) %></a><br/>
					<%	}
					}%>
					
					
					
					</td>  
					 <% count+=1;
	          			dispDay +=1;	         			  
	                }else{%>  
	   					<td class="empty"></td>
					<%}  
	               }
	       		}%>		
       </tr>
	<%} %> 
     </table>
     </td>
     </tr>
  </table>
 <button onclick="window.location.href = '../main/main.jsp'"> 메인으로 가기 </button>
 <button onclick="window.location.href = '../reservation/reservationForm.jsp'"> 예약하러 가기 </button>

</body>
</html>