<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="test.web.calendar.ReservationVO" %>
<%@page import="test.web.calendar.ReservationDAO" %>

<%
	
	request.setCharacterEncoding("UTF-8");
	String re_id = (String)session.getAttribute("s_re_id");
	String re_name = (String)(session.getAttribute("s_re_name"));
	String re_phone= (String)session.getAttribute("s_re_phone");
	String re_email = (String)(session.getAttribute("s_re_email"));
	String roomname = (String)session.getAttribute("s_roomname");
	String daterange = (String)session.getAttribute("s_daterange");
	int usepeople = (Integer)session.getAttribute("s_usepeople");
	int price = (Integer)session.getAttribute("s_price");
	String paymentmethod = (String)session.getAttribute("s_paymentmethod");
	String chkpayment=(String)session.getAttribute("s_chkpayment");
	//object타입이므로 string>int
	
	
		
	int year = (Integer)session.getAttribute("s_year");
	int month =(Integer)session.getAttribute("s_month");
	int day = (Integer)session.getAttribute("s_day");
	int usingday= (Integer)session.getAttribute("s_usingday");
	String startday = (String)session.getAttribute("s_startday");
	String endday = (String)session.getAttribute("s_endday");
	
	%>
	<jsp:useBean id = "vo" class="test.web.calendar.ReservationVO"/> 
	<jsp:setProperty property="*" name="vo"/>

<%
	ReservationDAO dao = new ReservationDAO();
	vo.setRe_id(re_id);
	vo.setRe_name(re_name);
	vo.setRe_phone(re_phone);
	vo.setRe_email(re_email);
	vo.setRoomname(roomname);
	vo.setDaterange(daterange);
	vo.setUsepeople(usepeople);
	vo.setPrice(price);
	vo.setPaymentmethod(paymentmethod);
	vo.setChkpayment(chkpayment);
	vo.setYear(year);
	vo.setMonth(month);
	vo.setDay(day);
	vo.setUsingday(usingday);
	vo.setStartday(startday);
	vo.setEndday(endday);
	dao.reservation(vo);
	int res = dao.getReservationNum(vo);
	
	
%>	
	
<h2><%=roomname%></h2>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
</head>

<body>
    <script>
    $(function(){
        var IMP = window.IMP; // 생략가능
        IMP.init("imp96207400"); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
        var msg;
        
        IMP.request_pay({
            pg : 'kakaopay',
            pay_method : 'card',
            merchant_uid : 'merchant_' + new Date().getTime(),
            name : '(주)효리네 민박',
            buyer_email:'n@naver.com',
            buyer_tel:'010-1234-5678',
			amount :<%=price%>,
            buyer_postcode : '123-456',
            //m_redirect_url : 'http://www.naver.com'
        }, function(rsp) {
            if ( rsp.success ) {
                //[1] 서버단에서 결제정보 조회를 위해 jQuery ajax로 imp_uid 전달하기
                jQuery.ajax({
                    url: "/payments/complete", //cross-domain error가 발생하지 않도록 주의해주세요
                    type: 'POST',
                    dataType: 'json',
                    data: {
                        imp_uid : rsp.imp_uid
                        //기타 필요한 데이터가 있으면 추가 전달
                    }
                }).done(function(data) {
                    //[2] 서버에서 REST API로 결제정보확인 및 서비스루틴이 정상적인 경우
                    if ( everythings_fine ) {
                        msg = '결제가 완료되었습니다.';
                        msg += '\n고유ID : ' + rsp.imp_uid;
                        msg += '\n상점 거래ID : ' + rsp.merchant_uid;
                        msg += '\결제 금액 : ' + rsp.paid_amount;
                        msg += '카드 승인번호 : ' + rsp.apply_num;
                        
                        alert(msg);
                    } else {
                        //[3] 아직 제대로 결제가 되지 않았습니다.
                        //[4] 결제된 금액이 요청한 금액과 달라 결제를 자동취소처리하였습니다.
                    }
                });
                //성공시 이동할 페이지
        		window.location = "success.jsp?num=<%=res%>";
            } else {
                msg = '결제에 실패하였습니다.';
                msg += '에러내용 : ' + rsp.error_msg;
                //실패시 이동할 페이지
                alert(msg);
                history.go(-1);
                window.location = "fail.jsp";
            }
        });
        
    });
    </script>
</body>
<a href="reservationPro.jsp" > 예약확인 </a>
</html>


