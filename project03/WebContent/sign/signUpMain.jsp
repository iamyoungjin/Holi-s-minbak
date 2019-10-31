<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
<!-- 카카오  -->
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<!-- 네이버 -->
<script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js" charset="utf-8"></script>
<!-- 구글 -->
<meta name="google-signin-scope" content="profile email">
<script src="https://apis.google.com/js/platform.js" async defer></script>
<meta name="google-signin-client_id" content="320557608369-9srdo4fso2icfd704v837fql0jnh10cl.apps.googleusercontent.com">



</head>
<body>
	<input type="button" value="회원가입" onclick="window.location.href='signUpForm.jsp'">
	<input type="button" value="메인으로" onclick="window.location.href='../main/main.jsp'"><br/>
	
	
	<!--  카카오 -->
	<a id="kakao-login-btn"></a>
	<a href="http://developers.kakao.com/logout"></a>
	<script type='text/javascript'>
	  //<![CDATA[
	    // 사용할 앱의 JavaScript 키를 설정해 주세요.
	    Kakao.init('b607f149ec3e12abaff481e0ec56f3bb');
	    // 카카오 로그인 버튼을 생성합니다.
	    Kakao.Auth.createLoginButton({
			container: '#kakao-login-btn',
			success: function(authObj) {
				Kakao.API.request({
					url: '/v1/user/me',
					success: function(res) {
						console.log(res);
						var userID = "kakao_" + res.id;
						var loginURL = "http://localhost:8080/project01/sign/kakaoSignUpPro.jsp?id="+encodeURI(userID);
						window.location.replace(loginURL);
					},
					fail: function(error) {
						alert(JSON.stringify(error));
					}
				});
			},
			fail: function(err) {
				alert(JSON.stringify(err));
			}
		});
	  //]]>
	</script>
	
	<!-- 네이버 -->
	<div id="naverIdLogin"></div>
	
	<script type="text/javascript">
		var naverLogin = new naver.LoginWithNaverId(
			{
				clientId: "MOf0l_qoj5M7p4rLoe4B",
				callbackUrl: "http://localhost:8080/project01/sign/naverSignUp.jsp",
				isPopup: false, /* 팝업을 통한 연동처리 여부 */
				loginButton: {color: "green", type: 3, height: 48} /* 로그인 버튼의 타입을 지정 */
			}
		);
		
		/* 설정정보를 초기화하고 연동을 준비 */
		naverLogin.init();
	</script>
	
	
	
	<!-- 구글 -->
	<div class="g-signin2" data-onsuccess="onSignIn"></div>
    <script>
      function onSignIn(googleUser) {
        // Useful data for your client-side scripts:
        var profile = googleUser.getBasicProfile();
        console.log("ID: " + profile.getId()); // Don't send this directly to your server!
        var googleId = "google_" + profile.getId();
        var googleEmail = profile.getEmail();
        
        /*
        var loginURL = "http://localhost:8080/project01/sign/googleSignUpPro.jsp?id="+encodeURI(googleId)+"&email="+encodeURI(googleEmail);
		window.location.replace(loginURL);
		*/
        

        // The ID token you need to pass to your backend:
        var id_token = googleUser.getAuthResponse().id_token;
        console.log("ID Token: " + id_token);
      
      }
    </script>
</body>
</html>