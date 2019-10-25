
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %>   
<script src= https://code.jquery.com/jquery-3.4.1.min.js></script>    

<%//jQuery datepicker UI를 사용하여 날짜 입력 받기 %>
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>

<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<!-- <input type="text" name="daterange" value="11/01/2019 - 11/15/2019" />-->



<script>
$(function() {
	
  $('input[name="daterange"]').daterangepicker({
    opens: 'left',
    locale: {
        format: 'YYYY/MM/DD'
    },
  });
});

</script>

<h2> 유효성 검사 해야함 </h2>
<% 
	String sId = (String)session.getAttribute("sId");
	if(sId == null){%>
		<script>
			alert("로그인을 먼저 해주세요");
			window.location= '../login/loginForm.jsp';
		</script>
<% }%>

<% String id = (String)session.getAttribute("sId");
   String name = (String)session.getAttribute("sName");
   String phonenum= (String)session.getAttribute("sPhonenum");
   String email= (String)session.getAttribute("sEmail");
%> 


<center><h2> 예약 하기 </h2>
<form action = "../reservation/payment.jsp" method="post" name = "form">
	<table width="400" border="1" cellspacing="0" cellpadding="0" align="center">
	<br/>
	<tr>
	<td align="center">아이디 :<input type="text" name="re_id" value=<%=id %>></td>
	</tr>
	<tr>
	<td align="center">예약자 :<input type="text" name="re_name" value=<%=name %>></td>
	</tr>
	<tr>
	<td align="center">핸드폰 :<input type="text" name="re_phone" value=<%=phonenum %>></td>
	</tr>
	<tr>
	<td align="center">E-mail:<input type="text" name="re_email" value=<%= email%>></td>
	</tr>
	<tr>
	<td align="center">예약할 방 선택 :<select id="mySel" onchange="sel()" name="roomname" value="sel()">
		<option value="">선택</option>
		<option value="산들방">산들방</option>
		<option value="매화방">매화방</option>
		<option value="들꽃방">들꽃방</option>
		<option value="소나무방">소나무방</option>
		<option value="해뜰방">해뜰방</option>
		<option value="민들레방">민들레방</option>
	</select></td>
	</tr>
	<tr>
	<td align="center">이용 기간 :<input type="text" id = "dr" name="daterange" onchange="sel()"></td>
	</tr>
	<tr>
    <td align="center">숙박 인원 :<input type="text" name="usepeople" /></td>
    </tr>
	<input type="hidden"  id = "picprice" name ="price" /><br/>
	<tr>
	<td align="center">결제 방식 : 무통장송금<input type="radio" name="paymentmethod" value="bank"/>
				kakaopay<input type="radio" name="paymentmethod" value="card"/></td>
	</tr>
	</table>
	
	
	<script>
		function sel(){
			var x = document.getElementById("mySel").value;
			var y = document.getElementById("mySel").value;
			var z = document.getElementById("dr").value;
			document.getElementById("show").value = x;
			document.getElementById("show").innerHTML = y;
			document.getElementById("dr").value = z;
		
		$.ajax({
			type:"post",
			url : "reservationFormjQuery.jsp",
			data : {rname:$("#show").val(), dr:$("#dr").val()}, 
			success:function(data){
				$("#rprice").html(data);
				data = data.trim();
				document.getElementById("picprice").value= data;
			},
		});

		}
	</script>
	
	<br/>
	<br/>
	<h2>선택 정보</h2>
	<h3><div id="show"></div></h3>
	<h3><div id = "rprice"></div><br/></h3>
	<h3><div id = "dr"></div><br/></h3>
	<input type="submit" value=" 결제하러가기" >
	
</form>
</center>

