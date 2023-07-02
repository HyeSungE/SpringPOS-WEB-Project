
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<jsp:include page="../main/header.jsp" />
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<style>
.pos-container {
	display: grid;
	grid-template-columns: 2fr 1.5fr; /* 1/3 : 2/3 비율로 설정 */
	grid-gap: 10px; /* 버튼 간격 설정 */
	height: 80vh;
	max-height: 100vh;
	overflow: auto; /* 내용이 넘칠 경우 스크롤 생성 */
	overflow-x : hidden;
	
}

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
	transition: color 0.3s ease;
}

.titleSection .material-icons:hover {
	color: #41cba9;
	outline: none !important;
}
.cartSection table{
 text-align : center;
}
</style>


<div class="pos-container">
	<div id="categorySection">

	</div>

	<div id="cartSection" >
		
	</div>


</div>



<jsp:include page="../main/footer.jsp" />


<script>
$(document).ready(function() {
	$('#categorySection').load('sale/categories');
	$('#cartSection').load('sale/cart');
});

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

</script>
