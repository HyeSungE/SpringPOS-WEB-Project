
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
<title>POS 제품 수정</title>
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
	<c:set var="productNo" value="${product.productNo}" />
	<div class="signup-form">
		<form action="productEdit?productNo=${product.productNo}"
			method="post" class="form-horizontal">
			<input type="hidden" name="mode" id="mode" value="">
			<div class="row">

				<h2>상품 수정</h2>

			</div>
			<div class="form-group row">
				<label class="col-form-label col-4">카테고리</label>
				<div class="col-8">
					<select class="form-control" name="categoryCode" id="categoryCode"
						required="required">
						<c:forEach var="category" items="${categoryList}">
							<option value="${category.categoryCode}"
								${category.categoryCode == product.categoryDTO.categoryCode ? 'selected' : ''}>${category.categoryName}</option>
						</c:forEach>


					</select>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-form-label col-4">상품코드</label>
				<div class="col-8">
					<input type="text" class="form-control" name="productCode"
						id="productCode" value="${product.productCode}"
						required="required" readonly>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-form-label col-4">상품이름</label>
				<div class="col-8">
					<input type="text" class="form-control" name="productName"
						value="${product.productName}" required="required">
				</div>
			</div>

			<div class="form-group row">
				<label class="col-form-label col-4">상품가격</label>
				<div class="col-8">
					<input type="number" class="form-control" name="productPrice"
						value="${product.productPrice}" min="0" step="1"
						required="required">

				</div>
			</div>

			<div class="form-group row">
				<label class="col-form-label col-4">상품수량</label>
				<div class="col-8">
					<input type="number" class="form-control" name="productStrock"
						value="${product.productStock}" min="0" step="1"
						required="required">
				</div>
			</div>

			<div class="form-group row">
				<label class="col-form-label col-4">상품생성일자</label>
				<div class="col-8">
					<input type="text" class="form-control" name="productCreationDate"
						value="${product.productCreationDate}" min="0" step="1"
						required="required" readonly>
				</div>
			</div>


			<div class="form-group row justify-content-center">
				<div class="col-auto">
					<div class="btn-group" role="group" aria-label="수정 및 삭제">
						<button type="submit" class="btn btn-primary btn-lg">수정하기</button>
						<div class="mx-2"></div>
						<button class="btn btn-primary btn-lg" onclick="confirmDelete()">삭제하기</button>
					</div>
				</div>
			</div>


		</form>

	</div>
	<script>
		function confirmDelete() {
			if (confirm("목록에서 상품을 삭제하시겠습니까?")) {
				 document.getElementById("mode").value = "delete";
			      document.forms[0].submit();
			} else {}
		}
		$(document).ready(function() {
			// 카테고리 선택 시 상품코드에 반영
			$('#categoryCode').change(function() {
				var categoryCode = $(this).val();
				var productNo = "${productNo}";

				var updatedProductCode = categoryCode + '-' + productNo;
				$('#productCode').val(updatedProductCode);
			});
		});
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