<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>  
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>
<% 
	String rname = request.getParameter("rname");
    String dr = request.getParameter("dr");
	ReservationDAO dao = new ReservationDAO();
	//int price = dao.roomprice(rname);
	
	
	int year=0;
	int month=0;
	int day=0;
	int arr_year[] = new int[2];
	int arr_month[] = new int[2];
	int arr_day[] = new int[2];
	
    dr = dr.replaceAll(" ","");
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
	
	//특정 날짜 구분해서가격 구하기

	ReservationVO vo = new ReservationVO();
	List dates = vo.middate(startday,endday);
	List totalprice = new ArrayList();
	int tot =0;
	for(int i=0;i<dates.size();i++){
		//성수기  6 7 8월 
		if(Integer.parseInt(dates.get(i).toString().split("/")[1])==6 ||Integer.parseInt(dates.get(i).toString().split("/")[1])==7 || Integer.parseInt(dates.get(i).toString().split("/")[1])==8){
			int k0 = dao.roomprice_peakseason(rname);
			totalprice.add(k0);
		}
		else if(vo.getday(dates.get(i).toString()).equals("토")||vo.getday(dates.get(i).toString()).equals("일") ){
			int k1 = dao.roomprice_weekend(rname);
			totalprice.add(k1);
		}else{
			int k2 = dao.roomprice_weekday(rname);
			totalprice.add(k2);
		}
	}
		for(int j =0;j<totalprice.size();j++){
			tot += Integer.parseInt(totalprice.get(j).toString());
		}
%>
	<%=tot %>
