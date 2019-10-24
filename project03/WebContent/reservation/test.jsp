<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>  
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>

<h2>코드 테스트용 페이지</h2>

<%
String startday= "2019/10/24";
String endday = "2019/10/27";
ReservationVO vo = new ReservationVO();
List dates = vo.middate(startday,endday);
List totalprice = new ArrayList();
int tot =0;

for(int i=0;i<dates.size();i++){
	//성수기 가격 측정 
	//System.out.println(dates.get(i));
	if(vo.getday(dates.get(i).toString()).equals("토")||vo.getday(dates.get(i).toString()).equals("일") ){
		//주말가격 가져와서 list 에 저장 
		int k1 = 1;
		totalprice.add(k1);
		//System.out.println("주말");
	}else{
		int k2 = 2;
		totalprice.add(k2);
		//일반가격 가져오기 list에 저장 
		//System.out.println("주말아님");
	}
}
	for(int j =0;j<totalprice.size();j++){
		tot += Integer.parseInt(totalprice.get(j).toString());
	}
	System.out.println("총 숫자합 : "+tot);
%>
