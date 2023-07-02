<%@page import="java.util.logging.Logger"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.7.0.min.js"></script>
<link href="/css/bootstrap.min.css" rel="stylesheet">
<script src="/js/bootstrap.min.js"></script>
<meta charset="EUC-KR">
<title>POS WEB LOGIN</title>
<script>

<%if ("true".equals(request.getParameter("loginBanned"))) {%>
alert("계정이 비활성화 상태입니다. 매니저나 관리자에게 문의하세요");
<%}%>

<%if ("true".equals(request.getParameter("loginFail"))) {%>
	alert("로그인에 실패했습니다. 다시 시도해주세요.");
<%}%>

<%if("true".equals(request.getParameter("registered"))) {%>
alert("회원가입에 성공했습니다. 로그인을 해주세요!");
<%}%>
</script>

<style>
body {
	color: #fff;
}

.form-control {
	min-height: 41px;
	background: #f2f2f2;
	box-shadow: none !important;
	border: transparent;
}

.form-control:focus {
	background: #e2e2e2;
}

.form-control, .btn {
	border-radius: 2px;
}

.login-form {
	width: 350px;
	margin: 30px auto;
	text-align: center;
}

.login-form h2 {
	margin: 10px 0 25px;
}

.login-form form {
	color: #7a7a7a;
	border-radius: 3px;
	margin-bottom: 15px;
	background: #fff;
	box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
	padding: 30px;
	margin-bottom: 10px;
}

.login-form .btn {
	font-size: 16px;
	font-weight: bold;
	background: #3598dc;
	border: none;
	outline: none !important;
}

.login-form .btn:hover, .login-form .btn:focus {
	background: #2389cd;
}

.login-form a {
	text-decoration: underline;
}

.login-form a:hover {
	text-decoration: none;
}

.login-form form a {
	color: #7a7a7a;
	text-decoration: none;
}

.login-form form a:hover {
	text-decoration: underline;
}

.login-form .btn {
	font-size: 16px;
	font-weight: bold;
	background: #3598dc;
	border: none;
	outline: none !important;
	width: 60%;
}

.login-form form .form-group {
	margin-bottom: 10px;
}

.login-form {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
}
</style>


</head>
<body>
	<c:set var="message" value="${message}"/>
	<div class="login-form">
		<form action="/pos" method="post">
			<h2 class="text-center">POS LOGIN</h2>
			<div class="form-group has-error">
				<input type="text" class="form-control" name="userId"
					placeholder="이메일 입력" required="required">
			</div>
			<div class="form-group">
				<input type="password" class="form-control" name="userPw"
					placeholder="비밀번호 입력" required="required">
			</div>
			<div class="form-group">
				<button type="submit" class="btn btn-primary btn-lg btn-block">로그인</button>
			</div>
			
			<p>
				 <a href="#" onclick="openPopup('id')">이메일 찾기</a> <a href="#" onclick="openPopup('password')">비밀번호 찾기</a>
			</p>
		</form>
		<p class="text-center">
			<span style="color: black;">계정이 없으시면</span> <a href="/pos/register"
				style="color: black;">회원가입</a>
		</p>

	</div>
	
	<!-- 팝업 창 -->

<script>
    function openPopup(mode) {
    	var mode = mode;
        var popupUrl = "/pos/find?mode="+mode; // 팝업 창으로 표시할 URL
        var popupWindow = window.open(popupUrl, "계정찾기", "width=600, height=400");
        popupWindow.focus();
    }

</script>

</body>
</html>