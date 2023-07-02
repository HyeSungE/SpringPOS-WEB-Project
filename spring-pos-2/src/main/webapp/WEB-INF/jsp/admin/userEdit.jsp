
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Roboto:400,700">
<title>POS 사용자 관리</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
	

<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
<style>
body {
	color: #999;
	background: #fff;
	font-family: 'Roboto', sans-serif;
}

.form-control {
	border-color: #eee;
	min-height: 41px;
	box-shadow: none !important;
}

.form-control:focus {
	border-color: #5cd3b4;
}

.form-control, .btn {
	border-radius: 3px;
}

.signup-form {
	width: 500px;
	margin: 0 auto;
	padding: 30px 0;
	text-align : center;
}

.signup-form h2 {
	color: #333;
	margin: 0 0 30px 0;
	display: inline-block;
	padding: 0 30px 10px 0;
	border-bottom: 3px solid #3e64ff;
}

.signup-form form {
	color: #999;
	border-radius: 3px;
	margin-bottom: 15px;
	background: #fff;
	box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
	padding: 30px;
}

.signup-form .form-group row {
	margin-bottom: 20px;
}

.signup-form label {
	font-weight: normal;
	font-size: 14px;
	line-height: 2;
}

.signup-form input[type="checkbox"] {
	position: relative;
	top: 1px;
}

.signup-form .btn {
	font-size: 16px;
	font-weight: bold;
	background: #3e64ff;
	border: none;
	margin-top: 20px;
	min-width: 140px;
}

.signup-form .btn:hover, .signup-form .btn:focus {
	background: #41cba9;
	outline: none !important;
}

</style>
</head>
<body>
	<c:set var="message" value="${message}" />
	<c:set var="userNo" value="${user.userNo}" />
	<div class="signup-form">
		<form action="userEdit?userNo=${user.userNo}"
			method="post" class="form-horizontal">
			<input type="hidden" name="userNo" id="userNo" value="${user.userNo}"/>
			<input type="hidden" name="mode" id="mode" value=""/>
			<div class="row"><h2>사용자 수정</h2></div>
			
		
			<div class="form-group row">
				<label class="col-form-label col-4">이름</label>
				<div class="col-8">
					<input type="text" class="form-control" name="userName"
						value="${user.userName}" required="required">
				</div>
			</div>
			
			<div class="form-group row">
				<label class="col-form-label col-4">아이디</label>
				<div class="col-8">
					<input type="text" class="form-control" name="userId"
						value="${user.userId}" required="required">
				</div>
			</div>
			
			<div class="form-group row">
				<label class="col-form-label col-4">비밀번호</label>
				<div class="col-8">
					<input type="text" class="form-control" name="userPw"
						value="${user.userPw}" required="required">
				</div>
			</div>
			
			<div class="form-group row">
				<label class="col-form-label col-4">직급</label>
				<div class="col-8">
					<select class="form-control" name="userPosition" id="userPosition" required="required">
							<option value="staff" ${user.userPosition == 'staff' ? 'selected' : ''}>직원</option>
							<option value="manager" ${user.userPosition == 'manager' ? 'selected' : ''}>매니저</option>
					</select>
				</div>
			</div>
			
			<div class="form-group row">
				<label class="col-form-label col-4">상태</label>
				<div class="col-8">
					<select class="form-control" name="userBanned" id="userBanned" required="required">
							<option value=true ${user.userBanned==true ? 'selected' : ''}>활성화</option>
							<option value=false ${user.userBanned==false ? 'selected' : ''}>비활성화</option>
					</select>
				</div>
			</div>
			

			
			<div class="form-group row">
				<label class="col-form-label col-4">가입일</label>
				<div class="col-8">
					<input type="text" class="form-control" name="userCreationDate"
						value="${user.userCreationDate}" required="required" readonly>
				</div>
			</div>

		



			<div class="form-group row justify-content-center">
				<div class="col-auto">
					<div>
						<button class="btn btn-primary btn-lg" id="editButton">수정하기</button>
					</div>
				</div>
				
				<div class="col-auto">
					<div>
						<button  class="btn btn-primary btn-lg" id="deleteButton">탈퇴하기</button>
					</div>
				</div>
			</div>


		</form>

	</div>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script>

		var message = "${message}";
		if (message !== '') {
			alert(message);
			window.opener.postMessage('popupClosed', '*');
			window.opener.location.reload(); // 부모 페이지 새로고침
			window.close();
		}
		
		$(document).ready(function() {
		    // 수정하기 버튼 클릭 시
		    $('#editButton').click(function() {
		        $('#mode').val('edit'); // mode 값을 'edit'로 설정
		        $('form').submit(); 
		    });

		    // 탈퇴하기 버튼 클릭 시
		    $('#deleteButton').click(function() {
		        $('#mode').val('delete'); // mode 값을 'delete'로 설정
		        $('form').submit(); 
		    });
		});

	</script>

</body>

</html>