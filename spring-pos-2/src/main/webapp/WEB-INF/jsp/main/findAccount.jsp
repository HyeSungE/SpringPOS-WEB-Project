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
<title>POS WEB FIND ACCOUNT</title>


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
	<div class="login-form">
		<form action="/pos/find" method="post">
			<h2 class="text-center">
				<c:if test="${mode eq 'id'}">
    				이메일 찾기
				</c:if>
				<c:if test="${mode eq 'password'}">
    				비밀번호 찾기
				</c:if>

			</h2>
			<div class="form-group has-error">
				<input type="text" class="form-control" name="userName"
					placeholder="이름 입력" required="required">
			</div>
			<c:if test="${mode eq 'password'}">
    				<div class="form-group">
				<input type="text" class="form-control" name="userId"
					placeholder="아이디 입력" required="required">
			</div>
				</c:if>
			<div class="form-group">
				<input type="text" class="form-control" name="userUniqueNumber"
					placeholder="고유번호 입력" required="required">
			</div>
			<div class="form-group">
				<button type="submit" class="btn btn-primary btn-lg btn-block">찾기</button>
			</div>

		</form>
		
	</div>
	<script>
	var message = "${message}";
	if (message !== '') {
		alert(message);
		window.close();
	}
	</script>
</body>
</html>