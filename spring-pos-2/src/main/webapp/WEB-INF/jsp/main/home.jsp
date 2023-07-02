	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ page language="java" contentType="text/html; charset=utf-8"
		pageEncoding="utf-8"%>
	
<jsp:include page="header.jsp" />



<!-- Home Content -->
<div id="content" class="p-4 p-md-5">

	<div class="date-time-card">
		<div class="card">
			<div class="card-body">

				<h2 id="current-date"></h2>
				<h3 id="current-time"></h3>
				<h3 class="card-title">
					<span class="badge badge-success">오늘의 매출액</span> : <span
						class="lead">${todayIncome}원</span>

				</h3>

			</div>
		</div>
	</div>

</div>

<jsp:include page="footer.jsp" />
<script>
	// 현재 날짜와 시간 업데이트 함수
	function updateDateTime() {
		var currentDateElement = document.getElementById("current-date");
		var currentTimeElement = document.getElementById("current-time");

		var currentDate = new Date();
		var options = {
			weekday : 'long',
			year : 'numeric',
			month : 'long',
			day : 'numeric'
		};
		var formattedDate = currentDate.toLocaleDateString(undefined, options);
		currentDateElement.textContent = "오늘은 " + formattedDate + " 입니다.";

		var currentTime = currentDate.toLocaleTimeString();
		currentTimeElement.textContent = "현재 시간 : " + currentTime;
	}

	// 1초마다 날짜와 시간 업데이트
	setInterval(updateDateTime, 1000);

	// 페이지 로드 시에도 날짜와 시간 업데이트
	window.addEventListener("load", updateDateTime);
</script>