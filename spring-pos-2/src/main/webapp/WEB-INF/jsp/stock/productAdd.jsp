
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
<title>POS 제품 추가</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<style>
body {
	color: #999;
	background:#fff;
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
	<div class="signup-form">
		<form action="productAdd" method="post" class="form-horizontal">
			<div class="row">

				<h2>제품 추가</h2>

			</div>
			<div class="form-group row">
				<label class="col-form-label col-4">카테고리</label>
				<div class="col-8">
					<select class="form-control" name="categoryCode"
						required="required">
						<c:forEach var="category" items="${categoryList}">
							<option value="${category.categoryCode}">${category.categoryName}(${category.categoryCode})</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-form-label col-4">제품이름</label>
				<div class="col-8">
					<input type="text" class="form-control" name="productName"
						required="required">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-form-label col-4">제품가격</label>
				<div class="col-8">
					<input type="number" class="form-control" name="productPrice"
						min="0" step="1" required="required">
						
				</div>
			</div>
			<div class="form-group row">
				<div class="col-8 offset-4">

					<button type="submit" class="btn btn-primary btn-lg">추가하기</button>
				</div>
			</div>

		</form>

	</div>
	<script>
	var message = "${message}";
	if (message !== '') {
		alert(message);
		window.opener.postMessage('popupClosed', '*');
		window.opener.location.reload(); // 부모 페이지 새로고침
		window.close();
	}
	</script>

</body>

</html>