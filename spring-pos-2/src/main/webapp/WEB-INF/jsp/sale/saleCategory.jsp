
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<style>

.categories {
	width: 100%;
}

.category-button {
	width: 80%;
	height: 150px;
	background-color: #ccc;
	border: none;
	border-radius: 5px;
	margin-bottom: 20px;
}

.titleSection {
	display: flex;
	align-items: center;
	justify-content: center;
	margin-bottom: 10px;
}

.titleSection .material-icons {
	cursor: pointer;
	font-size: 3rem;
	color: grey;
	transition: color 0.3s ease;
}

.titleSection .material-icons:hover {
	color: #41cba9;
	outline: none !important;
}

</style>



<div id="categorySection">
	<div class="titleSection"
		style="display: flex; align-items: center; justify-content: center;">
		<span class="material-icons" onclick="goCategories('left')">arrow_circle_left</span>
		<h3 class="text-center" style="margin: 0;">카테고리</h3>
		<span class="material-icons" onclick="goCategories('right')">arrow_circle_right</span>
	</div>

	<div class="contentSection" id="categoryContent">
		<table class="categories">
			<c:forEach var="category" items="${categoryList}" varStatus="status">
				<c:if test="${status.index >= 0 && status.index < 12}">
					<c:if test="${status.index % 4 == 0}">
						<tr>
					</c:if>
					<td>
						<button class="category-button"
							onclick="getProducts(${category.categoryNo})">${category.categoryName}</button>
					</td>
					<c:if test="${status.index % 4 == 3}">
						</tr>
					</c:if>
				</c:if>
			</c:forEach>
		</table>
	</div>
</div>
<script>

var startIndex = 0;
var endIndex = 11;
var categoryListSize = ${categoryListSize};


function goCategories(direction) {
	var increment = 12; 

	if (direction === 'left') {
		startIndex -= increment;
		endIndex -= increment;
		
	} else if (direction === 'right') {
		startIndex += increment;
		endIndex += increment;
		
	}

	getCategories(startIndex,endIndex);
}

function getCategories(startIndex,endIndex) {
	
	  // AJAX 요청 보내기
	  $.ajax({
	    url: 'sale/category', // 실제 다음 페이지의 URL로 대체
	    method: 'GET',
	    data: { 
	    	startIndex: startIndex,
	    	endIndex:endIndex}, // 요청 파라미터로 다음 페이지 정보 전달
	    success: function(response) {
	      // 응답 데이터를 사용하여 페이지 업데이트
	      $('#categoryContent').html(response);
	    },
	    error: function() {
	      alert('페이지를 로드하는 동안 오류가 발생했습니다.');
	    }
	  });
	}

function getProducts(categoryNo) {
	$('#categorySection').load('sale/category/products?categoryNo=' + categoryNo);
}





