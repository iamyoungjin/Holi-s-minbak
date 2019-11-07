<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>  
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %>
<%@ page import = "test.web.project03.AccountingDAO" %>
<%@ page import = "test.web.project03.AccountingVO" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.util.*" %>

<h2>코드 테스트용 페이지</h2>
<%

%>

<%
	//String startday = "2019/10/01";
	//String endday = "2019/10/31";
	//List dtot = new ArrayList();
	//List tot = new ArrayList();
	//int w_income =0;
	//AccountingDAO dao = new AccountingDAO();
	//ReservationVO vo = new ReservationVO();
	//dtot = vo.middate(startday, endday);
	//for(int i=0; i<dtot.size();i++){  //dot : 날짜들이 들어있는 배열 
	//	tot.add(dao.Room_M_income((String)dtot.get(i)));//tot :일별 가격들의 배열이 들어있음 
	//	for(int a=0;a<tot.size();a++){
	//		//int k =Integer.parseInt(tot.get(a).toString()); //tot.get(a)는 배열임 
	//		for(int b=0;b<tot.get(a).siz;b++){
	//			
	//		}
	//		System.out.println(k);
	//		w_income += k;
	//	}
	//}
	//System.out.println(w_income);
	//Calendar c = Calendar.getInstance();
	//int maxdate = c.getActualMaximum(Calendar.DAY_OF_MONTH);
	//for(int j= ; j<maxdate ; j++){
	int currYear = 0;
	int currMonth = 0;
	
	//Calendar c = Calendar.getInstance();
	Calendar cal = Calendar.getInstance();	
    //currMonth = c.get(Calendar.MONTH);
    //currYear = c.get(Calendar.YEAR);
    
    //System.out.println(currMonth); //#10
    //System.out.println(currYear); //#2019
    //System.out.println(cal.get(Calendar.DAY_OF_MONTH)); //#7
    //cal.set(currYear,currMonth,1);
    
    
    //System.out.println(currMonth); //#10
    //System.out.println(currYear); //#2019
    //System.out.println(Calendar.MONTH); //#2
    //System.out.println(c.get(Calendar.MONTH)); //#10
    //System.out.println(cal.get(Calendar.DAY_OF_MONTH)); //#1
	//System.out.println(cal.get(Calendar.DAY_OF_WEEK));	
    ReservationVO vo = new ReservationVO();
    //List lst = new ArrayList();
    //lst = vo.middate("2019/10/31","2019/11/08");
    //for(int i =0;i<lst.size();i++){
    //	System.out.println(lst.get(i));
    //}
	String k = vo.getday("2019/02/07");
	System.out.println(k);
%>
