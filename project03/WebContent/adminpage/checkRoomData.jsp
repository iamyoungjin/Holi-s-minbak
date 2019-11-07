<%@page import="test.web.project03.RoomDTO"%>
<%@page import="java.util.List"%>
<%@page import="test.web.project03.RoomDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>객실 정보</title>
<script>

	function updateRoom(userinput,num){
		// for문의 변수 i를 num으로 받는다.
		
		if(!document.getElementById("num"+num).value){
			alert("방번호를 입력해주세요");
			return false;
		}
		if(!document.getElementById("rname"+num).value){
			alert("방 이름을 입력해주세요");
			return false;
		}
		if(!document.getElementById("dpeople"+num).value){
			alert("기준 인원수를 입력해주세요");
			return false;
		}
		if(!document.getElementById("maxpeople"+num).value){
			alert("최대 인원수를 입력해주세요");
			return false;
		}
		if(!document.getElementById("addtionalcost"+num).value){
			alert("추가 금액을 입력해주세요");
			return false;
		}
		if(!document.getElementById("weekday_price"+num).value){
			alert("주중 가격을 입력해주세요");
			return false;
		}
		if(!document.getElementById("weekend_price"+num).value){
			alert("주말 가격을 입력해주세요");
			return false;
		}
		if(!document.getElementById("peakseason_price"+num).value){
			alert("성수기 가격을 입력해주세요");
			return false;
		}
		
		// 수정/삭제 테이블에서 필요한 행만을 뽑아오기 위해, 아래 테이블의 id,name 속성에 변수 i를 붙였다.
		// 이를 이용해 "속성값"+num 을 통해 원하는 행을 뽑아서 checkRoomPro.jsp에 전송한다.
		
		userinput.action="checkRoomPro.jsp?type=update"
			+"&num="+document.getElementById("num"+num).value
			+"&rname="+encodeURI(document.getElementById("rname"+num).value)
			// endodeURI("문자열")을 통해 한글이 들어갈 수 있는 영역에 추가적으로 인코딩처리를 해준다.
			+"&dpeople="+document.getElementById("dpeople"+num).value
			+"&maxpeople="+document.getElementById("maxpeople"+num).value
			+"&addtionalcost="+document.getElementById("addtionalcost"+num).value
			+"&weekday_price="+document.getElementById("weekday_price"+num).value
			+"&weekend_price="+document.getElementById("weekend_price"+num).value
			+"&peakseason_price="+document.getElementById("peakseason_price"+num).value ;
		userinput.submit();
		// 자바스크립트를 이용하여 action의 경로 지정후 submit 해준다.
		
	}
	
	function insertIntro(userinput,num){
		userinput.action="insertRoomIntro.jsp?num="+document.getElementById("num"+num).value;
		userinput.submit();
	}
	
	function deleteRoom(userinput,num){
		if(!confirm("객실을 삭제 하겠습니까?") ){
			return;
		}
		if(!document.getElementById("num"+num).value){
			alert("문제가 발생했으니 다시 시도해주세요.");
		}
		userinput.action="checkRoomPro.jsp?type=delete"
			+"&num="+document.getElementById("num"+num).value;
		userinput.submit();
	}

	function insertRoom(userinput){
		if(!userinput.newrname.value){
			alert("방 이름을 입력해주세요");
			return false;
		}
		if(!userinput.newdpeople.value){
			alert("기준 인원수를 입력해주세요");
			return false;
		}
		if(!userinput.newmaxpeople.value){
			alert("최대 인원수를 입력해주세요");
			return false;
		}
		if(!userinput.newaddtionalcost.value){
			alert("추가 금액을 입력해주세요");
			return false;
		}
		if(!userinput.newweekday_price.value){
			alert("주중 가격을 입력해주세요");
			return false;
		}
		if(!userinput.newweekend_price.value){
			alert("주말 가격을 입력해주세요");
			return false;
		}
		if(!userinput.newpeakseason_price.value){
			alert("성수기 가격을 입력해주세요");
			return false;
		}
		userinput.action="checkRoomPro.jsp?type=insert"
						+"&rname="+encodeURI(userinput.newrname.value)
						+"&dpeople="+userinput.newdpeople.value
						+"&maxpeople="+userinput.newmaxpeople.value
						+"&addtionalcost="+userinput.newaddtionalcost.value
						+"&weekday_price="+userinput.newweekday_price.value
						+"&weekend_price="+userinput.newweekend_price.value
						+"&peakseason_price="+userinput.newpeakseason_price.value
		userinput.submit();
	}
	
	
</script>

</head>
<header>
	<%@ include file="../main/header.jsp" %>
</header>
<%
	sAdmin = (String)session.getAttribute("sAdmin");
	if(sAdmin == null){%>
		<script>
			alert("권한이 없습니다.");
			history.go(-1);
		</script>
<%	}else{
		RoomDAO dao = RoomDAO.getInstance();
		List list = dao.showRoom();
	%>
	<form name="roomForm" method="post">
		<table border="1">
			<tr>
				<td>객실 번호</td>
				<td>객실 이름</td>
				<td>기준 인원수</td>
				<td>최대 인원수</td>
				<td>추가 금액</td>
				<td>주중 가격</td>
				<td>주말 가격</td>
				<td>성수기 가격</td>
				<td>세부사항</td>
				<td>수정/삭제</td>
			</tr>
			<%
			// dao의 showRoom 메서드로 가져온 list를 for문에 넣는다
			for(int i=0; i<list.size(); i++ ){
				RoomDTO dto = (RoomDTO)list.get(i);
				// for문의 안에서 list의 원소를 빼낸다
			%>
				<!-- 가져온 데이터의 id,name에 for문의 변수 i를 붙여서, 각 방을 구분 할 수 있게 한다 -->
				<!-- 1번방의 데이터는 num0, rname0, dpeople0 ... 2번째는 num1, rname1 .. 이런식으로 명명된다 -->
				<tr>
					<td><input type="text" id="num<%=i%>" name="num<%=i%>" value="<%=dto.getNum()%>" readonly/></td>
					<td><input type="text" id="rname<%=i%>" name="rname<%=i%>" value="<%=dto.getRname()%>"/></td>
					<td><input type="text" id="dpeople<%=i%>" name="dpeople<%=i%>" value="<%=dto.getDpeople()%>"/></td>
					<td><input type="text" id="maxpeople<%=i%>" name="maxpeople<%=i%>" value="<%=dto.getMaxpeople()%>"/></td>
					<td><input type="text" id="addtionalcost<%=i%>" name="addtionalcost<%=i%>" value="<%=dto.getAddtionalcost()%>"/></td>
					<td><input type="text" id="weekday_price<%=i%>" name="weekday_price<%=i%>" value="<%=dto.getWeekday_price()%>"/></td>
					<td><input type="text" id="weekend_price<%=i%>" name="weekend_price<%=i%>" value="<%=dto.getWeekend_price()%>"/></td>
					<td><input type="text" id="peakseason_price<%=i%>" name="peakseason_price<%=i%>" value="<%=dto.getPeakseason_price()%>"/></td>
					<td><input type="button" value="방 소개 추가/수정" onclick="insertIntro(this.form,<%=i%>)" /></td>
					<!-- button 형식에 onclick으로 this.form과 변수i를 가지고 updateRoom, deleteRoom 함수를 실행한다. -->
					<td>
						<input type="button" value="객실 수정" onclick="updateRoom(this.form,<%=i%>)"/>
						<input type="button" value="객실 삭제" onclick="deleteRoom(this.form,<%=i%>)"/>
					</td>
				</tr>
			<%}%>
			<tr>
				<td colspan="10" style="text-align: center"><b>객실 추가</b></td>
			</tr>
			<tr>
				<td>객실 이름</td>
				<td>기준 인원수</td>
				<td>최대 인원수</td>
				<td>추가 금액</td>
				<td>주중 가격</td>
				<td>주말 가격</td>
				<td>성수기 가격</td>
				<td colspan="2">추가 및 취소</td>
			</tr>
			<!-- 객실 추가를 위한 입력폼. 위의 수정/삭제와 같은 table을 쓰기때문에 변수에 new를 붙여서 구분해준다. -->
			<tr>
				<td><input type="text" name="newrname"/></td>
				<td><input type="text" name="newdpeople"/></td>
				<td><input type="text" name="newmaxpeople"/></td>
				<td><input type="text" name="newaddtionalcost"/></td>
				<td><input type="text" name="newweekday_price"/></td>
				<td><input type="text" name="newweekend_price"/></td>
				<td><input type="text" name="newpeakseason_price"/></td>
				<td><input type="button" value="객실 추가" onclick="insertRoom(this.form)" /></td>
				<td><input type="reset" value="작성 취소"/></td>
			</tr>
		</table>
	</form>
	<input type="button" value="돌아가기" onclick="window.location.href='adminpage.jsp'"/>			
	<%}
%>
<body>

</body>
</html>