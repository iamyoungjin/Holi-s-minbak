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
		
		userinput.action="checkRoomPro.jsp?type=update"
			+"&num="+document.getElementById("num"+num).value
			+"&rname="+encodeURI(document.getElementById("rname"+num).value)
			+"&dpeople="+document.getElementById("dpeople"+num).value
			+"&maxpeople="+document.getElementById("maxpeople"+num).value
			+"&addtionalcost="+document.getElementById("addtionalcost"+num).value
			+"&weekday_price="+document.getElementById("weekday_price"+num).value
			+"&weekend_price="+document.getElementById("weekend_price"+num).value
			+"&peakseason_price="+document.getElementById("peakseason_price"+num).value ;
		userinput.submit();
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
		if(!userinput.newnum.value){
			alert("방 번호를 입력해주세요");
			return false;
		}
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
						+"&num="+userinput.newnum.value
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
			<%for(int i=0; i<list.size(); i++ ){
				RoomDTO dto = (RoomDTO)list.get(i);
			%>
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
				<td>객실 번호</td>
				<td>객실 이름</td>
				<td>기준 인원수</td>
				<td>최대 인원수</td>
				<td>추가 금액</td>
				<td>주중 가격</td>
				<td>주말 가격</td>
				<td>성수기 가격</td>
				<td colspan="2">추가 및 취소</td>
			</tr>
			<tr>
				<td><input type="text" name="newnum"/></td>
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
<footer>
	<%@ include file="../main/footer.jsp" %>
</footer>
</html>