<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %> 
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>

<%
	request.setCharacterEncoding("UTF-8");
	String re_id = (String)request.getParameter("re_id");
	String re_name = (String)request.getParameter("re_name");
	String re_phone= (String)request.getParameter("re_phone");
	String re_email = (String)request.getParameter("re_email");
	String roomname = (String)request.getParameter("roomname");
	String daterange = (String)request.getParameter("daterange");
	Integer usepeople = Integer.parseInt(request.getParameter("usepeople"));
	Integer price = Integer.parseInt(request.getParameter("price"));
	String paymentmethod = request.getParameter("paymentmethod");
	//String chkpayment =request.getParameter("chkpayment");
	String chkpayment= "waiting";
%>	

<%
	//기본 날짜 계산 
	int year=0;
	int month=0;
	int day=0;
	int arr_year[] = new int[2];
	int arr_month[] = new int[2];
	int arr_day[] = new int[2];
	
	String dr = daterange.replaceAll(" ","");
	String arr[]= dr.split("-");
	
	for(int i=0;i<arr.length;i++){
		arr_year[i] = Integer.parseInt(arr[i].split("/")[0]);
		arr_month[i] = Integer.parseInt(arr[i].split("/")[1]);
		arr_day[i] = Integer.parseInt(arr[i].split("/")[2]);	
	}

	year = arr_year[0];
	month = arr_month[0];
	day = arr_day[0];
	
	//arr[1]-arr[0]으로 숙박일수 계산 
	int usingday=0;
	String startday = (String)arr[0];
	String endday = (String)arr[1];
	
	if(arr_day[1] > arr_day[0]){
		usingday = (arr_day[1] - arr_day[0])+1;
	}
	if(arr_day[1]<arr_day[0]){
		Calendar c = Calendar.getInstance();
	    int maxday =c.getActualMaximum(Calendar.DAY_OF_MONTH);
		usingday = maxday - arr_day[0] + arr_day[1]+1;
	}
	if(arr_day[1] == arr_day[0]){
		usingday = 1;
	}
%>
<%	
	//오늘 기준으로 이전 날짜방 예약 못하게 하기 
	Calendar c = Calendar.getInstance();
	int nowday = c.get(Calendar.DAY_OF_MONTH);  //1일날 01인지 1인지 다시 확인할것 
	String now_day = null;
	if(nowday<10){
		 now_day="0"+nowday;
	}
	int now_month = c.get(Calendar.MONTH)+1;
	int now_year = c.get(Calendar.YEAR);
	String dday = (String)(now_year+"/"+now_month+"/"+now_day); //string 대소 비교 안됨 
	int start =Integer.parseInt(startday.replace("/",""));
	int d =Integer.parseInt(dday.replace("/",""));
	System.out.println(dday);
	System.out.println(start);
	System.out.println(d);
	if(d>start){%>
	<script>
		alert("이전 날짜에 예약불가");
		history.go(-1);
	</script>
	<% }%>


<% 
	//중복 체크 
	//방 이름이 같고 지정한 날짜 범위에서 하루라도 겹치면 예약 불가 
	ReservationDAO dao = new ReservationDAO();
		if(dao.roomchk(startday, endday,roomname)){
%>
	<script>
		alert("예약한 날짜에 해당 방을 예약할 수 없습니다 ");
		history.go(-1);
	</script>
	<% }%>
	


<% 
	
	//integer class
	session.setAttribute("s_re_id",re_id);
	session.setAttribute("s_re_name",re_name);
	session.setAttribute("s_re_phone",re_phone);
	session.setAttribute("s_re_email",re_email);
	session.setAttribute("s_roomname",roomname);
	session.setAttribute("s_daterange",daterange);
	session.setAttribute("s_usepeople",usepeople);
	session.setAttribute("s_price",price);
	session.setAttribute("s_paymentmethod",paymentmethod);
	session.setAttribute("s_chkpayment",chkpayment);

	session.setAttribute("s_year",year);
	session.setAttribute("s_month",month);
	session.setAttribute("s_day",day);
	session.setAttribute("s_usingday",usingday);
	session.setAttribute("s_startday",startday);
	session.setAttribute("s_endday",endday);
%>

<% 	
	if(paymentmethod.equals("bank")){%>
	<script>
		window.location = "nomalpayment.jsp";
	</script>
	<% }%>
	<% 
	if(paymentmethod.equals("card")){%>
	<script>
		//window.location = "reservationPro.jsp";
		window.location="paymentAPI.jsp";
	</script>
	<%}%>
	
	

