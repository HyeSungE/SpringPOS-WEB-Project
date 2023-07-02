<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.7.0.min.js"></script>
<link href="/css/bootstrap.css" rel="stylesheet">
<script src="/js/bootstrap.min.js"></script>
<meta charset="EUC-KR">
<title>POS WEB REGISTER</title>

<style>
body {
	color: #fff;
	font-family: 'Roboto', sans-serif;
}

html, body {
	height: 100%;
	display: flex;
	align-items: center;
	justify-content: center;
}

.form-control {
	height: 40px;
	box-shadow: none;
	color: #969fa4;
}

.form-control:focus {
	border-color: #5cb85c;
}

.form-control, .btn {
	border-radius: 3px;
}

.signup-form {
	width: 450px;
	margin: 0 auto;
	padding: 30px 0;
	font-size: 15px;
}

.signup-form h2 {
	color: #636363;
	margin: 0 0 15px;
	position: relative;
	text-align: center;
	font-size: 22.5px;
}

.signup-form h2:before, .signup-form h2:after {
	content: "";
	height: 2px;
	width: 30%;
	background: #d4d4d4;
	position: absolute;
	top: 50%;
	z-index: 2;
}

.signup-form h2:before {
	left: 0;
}

.signup-form h2:after {
	right: 0;
}

.signup-form .hint-text {
	color: #999;
	margin-bottom: 30px;
	text-align: center;
}

.signup-form form {
	color: #999;
	border-radius: 3px;
	margin-bottom: 15px;
	background: #f2f3f7;
	box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
	padding: 30px;
}

.signup-form .form-group {
	margin-bottom: 20px;
	text-align: center;
}

.signup-form input[type="checkbox"] {
	margin-top: 3px;
}

.signup-form .btn {
	font-size: 16px;
	font-weight: bold;
	min-width: 140px;
	outline: none !important;
}

.signup-form .row div:first-child {
	padding-right: 10px;
}

.signup-form .row div:last-child {
	padding-left: 10px;
}

.signup-form a {
	color: #fff;
	text-decoration: underline;
}

.signup-form a:hover {
	text-decoration: none;
}

.signup-form form a {
	color: #5cb85c;
	text-decoration: none;
}

.signup-form form a:hover {
	text-decoration: underline;
}

.signup-form .btn {
	font-size: 16px;
	font-weight: bold;
	width: 60%;
	outline: none !important;
	background-color: #3598dc;
	border-color: #3598dc;
	display: inline-block;
}
</style>

</head>
<body>

	<div class="signup-form">
		<form action="/pos/register" method="post"
			onsubmit="return checkForm()">
			<h2>POS 회원가입</h2>
			<p class="hint-text">POS를 이용하기 위해서 회원가입을 진행해 주세요.</p>
			<div class="row form-group">
				<input type="text" class="form-control" name="register_name"
					placeholder="이름 입력" required="required">
			</div>
			<div class="row form-group">
				<input type="email" class="form-control" name="register_id"
					id="register_id" placeholder="이메일 입력" required="required"
					onfocus="disableRegisterButton()" style="width: 65%;">
				<button type="button" class="btn btn-primary" style="width: 30%;"
					onclick="checkDuplicate()">중복 확인</button>
				<span id="dup_success_message" style="color: green;"></span>
				<!-- Added span element -->
			</div>

			<div class="row form-group">
				<input type="password" class="form-control" name="register_password"
					placeholder="비밀번호 입력" required="required">
			</div>
			<div class="row form-group">
				<input type="password" class="form-control"
					name="register_confirm_password" placeholder="비밀번호 확인"
					required="required">
			</div>
			<div class="row form-group">
				<input type="text" class="form-control" name="register_manager_code" placeholder="#매니저 : 매니저 코드를 입력">
			</div>

			<div class="form-group">
				<button type="submit" class="btn btn-success btn-lg btn-block"
					id="register_btn" disabled>회원가입</button>
			</div>
		</form>

		<div class="text-center">
			<span style="color: black;">이미 계정이 있으십니까 ?</span> <a href="/pos"
				style="color: black;">로그인</a>
		</div>
	</div>
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<script>
		function disableRegisterButton() {
			$('#register_btn').prop('disabled', true);
		}

		function checkDuplicate() {
			var id = $('#register_id').val();
			if (id === '') {
				alert('이메일을 입력해주세요.');
				return;
			}
			$.ajax({
				url : '/pos/checkDuplicateEmail',
				type : 'GET',
				data : {
					id : id
				},
				success : function(response) {
					if (response === 'duplicate') {
						alert('중복된 아이디입니다.');
						$('#register_btn').prop('disabled', true);
						$('#dup_success_message').text(''); // Clear the message
					} else {
						alert('사용 가능한 아이디입니다.');
						$('#register_btn').prop('disabled', false);
						$('#dup_success_message').text('사용 가능한 아이디입니다'); // Set the message
					}
				},
				error : function() {
					alert('오류가 발생했습니다.');
				}
			});
		}

		function checkForm() {
			var password = $('input[name="register_password"]').val();
			var confirmPassword = $('input[name="register_confirm_password"]')
					.val();

			if (password !== confirmPassword) {
				alert('비밀번호가 같지 않습니다.');
				return false;
			}

			return true;
		}
	</script>

</body>
</html>