
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
	width: 1000px;
	margin: 0 auto;
	padding: 30px 0;
	margin: 0 auto;
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

.text-black {
	color: black;
}

.table-sm td, .table-sm th {
	padding: 0.3rem;
	font-size: 12px;
	vertical-align: middle;
	text-align : center;
}

.table-sm tbody tr {
	height: 30px;
}
</style>
</head>
<body>
	<c:set var="message" value="${message}" />
	<c:set var="saleNo" value="${sale.saleNo}" />
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
				<div class="signup-form" style="padding-bottom: 0px;">
					<form action="saleCancel?saleNo=${sale.saleNo}" method="post"
						class="form-horizontal">
						<h2>판매 내역 상세보기</h2>

						<div class="form-group row">
							<div class="col-md-4">
								<label class="col-form-label text-black">판매번호</label>
								<h5 class="form-control border-primary" name="saleNo">${sale.saleNo}</h5>
							</div>

							<div class="col-md-4">
								<label class="col-form-label text-black">판매날짜</label>
								<h5 class="form-control border-primary" name="saleDate">${sale.saleDate}</h5>
							</div>

							<div class="col-md-4">
								<label class="col-form-label text-black">취소날짜</label>
								<h5 class="form-control border-primary rounded-3"
									name="saleCanceled">${sale.saleCanceled != null ? sale.saleCanceled : "-"}</h5>
							</div>
						</div>

						<div class="form-group row">
							<div class="col-md-4">
								<label class="col-form-label text-black">판매금액</label>
								<h5 class="form-control border-primary rounded-3"
									name="saleTotalPrice">${sale.saleTotalPrice}원</h5>
							</div>

							<div class="col-md-4">
								<label class="col-form-label text-black">받은돈</label>
								<h5 class="form-control border-primary rounded-3"
									name="saleReceived">${sale.saleReceived}원</h5>
							</div>

							<div class="col-md-4">
								<label class="col-form-label text-black">거스름돈</label>
								<h5 class="form-control border-primary rounded-3"
									name="saleChanged">${sale.saleChanged}원</h5>
							</div>
						</div>

						<div class="form-group row justify-content-center">
							<div class="col-auto">
								<button type="submit" class="btn btn-primary btn-lg">취소하기</button>
							</div>
						</div>
					</form>
				</div>
			</div>

		</div>
		<div class="row">

			<div class="col-md-6">
				<div class="signup-form">
						<div class="table-responsive" style="height: 300px; overflow-y: auto;">
							<table class="table table-bordered table-sm">
								<thead>
									<tr>
										<th>상품코드</th>
										<th>상품이름</th>
										<th>상품가격</th>
										<th>구매수량</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${sale.saleProducts}" var="saleProduct">
										<tr>
											<td>${saleProduct.productCode}</td>
											<td>${saleProduct.productName}</td>
											<td>${saleProduct.price}</td>
											<td>${saleProduct.quantity}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					
				</div>
			</div>
		</div>

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