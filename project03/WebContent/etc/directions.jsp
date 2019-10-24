<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찾아 오시는 길</title>
</head>
<body>
	<div id="map" style="width:500px;height:400px;"></div>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b607f149ec3e12abaff481e0ec56f3bb"></script>
	<script>
		var container = document.getElementById('map');
		var options = {
			center: new kakao.maps.LatLng(37.5209411, 127.6618429),
			level: 3
		};

		var map = new kakao.maps.Map(container, options);
		var markerPosition = new kakao.maps.LatLng(37.5209411, 127.6618429);
		
		var marker = new kakao.maps.Marker({
			position: markerPosition
		});
		
		marker.setMap(map);
		
		var iwContent = '<div style="padding:5px;">외똔집펜션 <br><a href="https://map.kakao.com/link/map/Hello World!,37.5209411, 127.6618429" style="color:blue" target="_blank">큰지도보기</a> <a href="https://map.kakao.com/link/to/Hello World!,33.450701,126.570667" style="color:blue" target="_blank">길찾기</a></div>', // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
			iwPosition = new kakao.maps.LatLng(37.5209411, 127.6618429);
		
		var infowindow = new kakao.maps.InfoWindow({
			postion : iwPosition,
			content : iwContent
		})
		infowindow.open(map,marker);
		
	</script>
	<input type="button" value="메인으로" onclick="window.location.href='../main/main.jsp'"/>

</body>
</html>