<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.example.demo.DTO.UserDTO" %>
	
<!doctype html>
<html lang="en">
<head>
<title>POS WEB</title>
<meta charset="EUC-KR">
<link href="/css/main_page.css" rel="stylesheet">
<link href="/css/nav.css" rel="stylesheet">
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link
  rel="stylesheet"
  href="https://fonts.googleapis.com/icon?family=Material+Icons"
/>
<style>
.modal {
	display: none;
	position: fixed;
	z-index: 9999;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
	background-color: #fefefe;
	margin: 25% auto;
	padding: 20px;
	border: 1px solid #888;
	width: 50%;
	max-width: 500px;
}
#user-info-modal .modal-content {
	color: black;
}

</style>
<body>
	<%UserDTO currentUser = (UserDTO) session.getAttribute("currentUser");%>
	<div class="wrapper d-flex align-items-stretch">

		<nav id="sidebar" class="active">
			<h2>
				<a href="/pos/home" class="logo" style="margin-bottom: 100px;">POS</a>
			</h2>
			<ul class="list-unstyled components mb-5">
				<li class="active"><a href="/pos/home"><span
						class="fa fa-home"></span>홈</a></li>
				<li><a href="/pos/stock"><span class="fa fa-cube"></span>재고/입고</a></li>
				<li><a href="/pos/sale"><span class="fa fa-usd"></span>판매</a></li>
				<li><a href="/pos/statistics"><span
						class="fa fa-line-chart"></span>통계</a></li>

				<c:if test="${currentUser.userPosition eq 'admin'}">
					<li><a href="/pos/userEditHome"><span class="fa fa-cog"></span>사용자 관리</a></li>
				</c:if>
			</ul>
		</nav>
		<!-- Page Content  -->
		<div id="content" class="p-4 p-md-5">

			<nav class="navbar navbar-expand-lg navbar-light bg-light">
				<div class="container-fluid">

					<%
					String mode = (String) request.getAttribute("mode");
					if (mode != null && mode.equals("stock")) {
					%>
					<button type="button"  class="btn btn-primary"
						value="stock" onclick="goTo(this.value)">재고 관리</button>
					<span style="margin-right: 10px;"></span>
					<!-- 간격을 주기 위한 빈 요소 -->
					<button type="button"  class="btn btn-primary"
						value="receiving" onclick="goTo(this.value)">입고 관리</button>
					<span style="margin-right: 10px;"></span>
					<button type="button"  class="btn btn-primary"
						value="receivingLog" onclick="goTo(this.value)">입고 내역</button>
					<%
					}else if(mode != null && mode.equals("sale")){
					%>
					<button type="button"  class="btn btn-primary"
						value="sale" onclick="goTo(this.value)">판매</button>
					<span style="margin-right: 10px;"></span>
					<!-- 간격을 주기 위한 빈 요소 -->
					<button type="button"  class="btn btn-primary"
						value="saleLog" onclick="goTo(this.value)">판매내역</button>
					<%
					}
					%>

					<div class="collapse navbar-collapse" id="navbarSupportedContent">

						<ul class="nav navbar-nav ml-auto">
							<li class="nav-item active">
								<span style="color: black; margin-left : 20px;">${currentUser.userName}님환영합니다!!</span>
								<a href="#" onclick="showUserInfo()">&nbsp;내 정보</a> &nbsp;| <a
								href="#" onclick="logout()">&nbsp;로그아웃</a>
							</li>
						</ul>
					</div>
				</div>
				<div id="user-info-modal" class="modal">
					<div class="modal-content">
						<span class="close" onclick="closeUserInfoModal()">&times;</span>
						<!-- 모달 창에 유저 정보를 표시하는 내용 추가 -->
						<h5 style="border-bottom: 1px solid blue;">${currentUser.userName}님의 정보</h5>		
						<p>이름: ${currentUser.userName}</p>
						<p>번호 : ${currentUser.userUniqueNumber}
						<p>직급: ${currentUser.userPosition == 'staff' ? '직원' : (currentUser.userPosition == 'manager' ? '매니저' : '관리자')}</p>
						<p>이메일: ${currentUser.userId}</p>
						<p>입사일: ${currentUser.userCreationDate}</p>
					</div>
				</div>
				<script>
					// 유저 정보 모달 창 열기
					function showUserInfo() {
						var modal = document.getElementById("user-info-modal");
						modal.style.display = "block";
					}

					// 유저 정보 모달 창 닫기
					function closeUserInfoModal() {
						var modal = document.getElementById("user-info-modal");
						modal.style.display = "none";
					}
					function goTo(value) {
						if (value === "stock") {
							window.location.href = "/pos/stock"; 
						} else if (value === "receiving") {
							window.location.href = "/pos/stock/receiving"; 
						}else if (value === "receivingLog") {
							window.location.href = "/pos/stock/receivingLog"; 
						}else if (value === "sale") {
							window.location.href = "/pos/sale"; 
						}else if (value === "saleLog") {
							window.location.href = "/pos/sale/saleLog"; 
						}
					}
					

				</script>
			</nav>