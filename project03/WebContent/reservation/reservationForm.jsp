<%@page import="java.util.List"%>
<%@page import="test.web.project03.RoomDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "test.web.calendar.ReservationVO" %>
<%@ page import = "test.web.calendar.ReservationDAO" %>  
<%@ page import = "test.web.project03.MemberDAO" %> 
<%@ page import = "test.web.project03.MemberDTO" %> 
<% request.setCharacterEncoding("UTF-8"); %>
<script src= https://code.jquery.com/jquery-3.4.1.min.js></script>    

<%//jQuery datepicker UI를 사용하여 날짜 입력 받기 %>
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>

<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
<!-- <input type="text" name="daterange" value="11/01/2019 - 11/15/2019" />-->
<script>
url="reservationCalendar.jsp";
window.open(url, "reservationCalendar", "toolbar=no, location=no, status=no, menubar=no, scrollbars=no, resizeable=no, width=50, height=50");
// url = 주소, confirm 타이틀, resizeable 사이즈조절, scrollbars 스크롤
</script>
<%
	String roomname = request.getParameter("roomname");
%>

<script>
$(function() {
	
  $('input[name="daterange"]').daterangepicker({
    opens: 'left',
    locale: {
        format: 'YYYY/MM/DD'
    },
  });
});

// 룸인트로에서 예약하기 누를시 방이름을 가지고 온다.
$("document").ready(function(){
    //say you have got 555 from the JSP as selcted value
    var selValue = "<%=roomname%>";
    $("#mySel").val(selValue).attr("selected","selected")   
});

</script>

<script>
	function formcheck(){
		if(!document.getElementById("re_id").value){
			alert("아이디를 입력해주세요");
			return false;
		}
		if(!document.getElementById("re_name").value){
			alert("예약자를 입력해주세요");
			return false;
		}
		if(!document.getElementById("re_phone").value){
			alert("연락처를 입력해주세요");
			return false;
		}
		if(!document.getElementById("re_email").value){
			alert("이메일을 입력해주세요");
			return false;
		}
		if(!document.getElementById("mySel").value){
			alert("방을 선택해주세요");
			return false;
		}
		if(!document.getElementById("dr").value){
			alert("사용 기간을 입력해주세요");
			return false;
		}
		if(!document.getElementById("usepeople").value){
			alert("숙박 인원을 입력해 주세요");
			return false;
		}
		
	}
	// radio 타입 유효성 검사 
	$(function(){
		$('#reservationSubmit').click(function() {
			if($(':radio[name="paymentmethod"]:checked').length < 1){
				alert("결제 방식을 선택해주세요.");
				return false;
			}
		});
	});
		
</script>


<% 
	String sId = (String)session.getAttribute("sId");
	String sAdmin = (String)session.getAttribute("sAdmin");
	if(sId == null && sAdmin == null){%>
		<script>
			alert("로그인을 먼저 해주세요");
			window.location= '../login/loginForm.jsp';
		</script>
<% }else if(sAdmin != null){%>
		<script>
		window.location= '../adminpage/checkClientReservation.jsp';
		</script>
<%
	}else{%>

<% String id = (String)session.getAttribute("sId");
   String name = (String)session.getAttribute("sName");
   String phonenum= (String)session.getAttribute("sPhonenum");
   String email= (String)session.getAttribute("sEmail");
   MemberDAO dao = MemberDAO.getInstance();
   MemberDTO getInformation = dao.getMember(id);
   String phone = getInformation.getPhonenum();
   String e_mail = getInformation.getEmail();
   
   RoomDAO roomdao = RoomDAO.getInstance();
   List roomList = roomdao.getRoomList();
%> 


<center>
<h2> 예약 하기 </h2>
<form action = "../reservation/payment.jsp" method="post" name = "form" onsubmit="return formcheck()">
	<table width="400" border="1" cellspacing="0" cellpadding="0" align="center">
	<br/>
	<tr>
	<td align="center">아이디 :<input type="text" id="re_id" name="re_id" value=<%=id %> readonly></td>
	</tr>
	<tr>
	<td align="center">예약자 :<input type="text" id="re_name" name="re_name" value=<%=name %> readonly></td>
	</tr>
	<tr>
	<td align="center">핸드폰 :<input type="text" id="re_phone" name="re_phone" value=<%=phone %> readonly></td>
	</tr>
	<tr>
	<td align="center">E-mail:<input type="email"" id="re_email" name="re_email" value=<%= e_mail%> readonly></td>
	</tr>
	<tr>
	<td align="center">예약할 방 선택 :<select id="mySel" onchange="sel()" name="roomname" value="sel()">
		<option value="">선택</option><%
		for(int i=0; i<roomList.size(); i++){%>
			<option value="<%=roomList.get(i)%>"><%=roomList.get(i)%></option>
		<%}
		%>
	</select></td>
	</tr>
	<tr>
	<td align="center">이용 기간 :<input type="text" id = "dr" name="daterange" onchange="sel()"></td>
	</tr>
	<tr>
    <td align="center">숙박 인원 :<input type="text" id="usepeople" name="usepeople" /></td>
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
	<input type="submit" id="reservationSubmit" value=" 결제하러가기" >
	
</form>
</center>
<%	}
	%>

<footer>
	<%@ include file="../main/footer.jsp" %>
</footer>
