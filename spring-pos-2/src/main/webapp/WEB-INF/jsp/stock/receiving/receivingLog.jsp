
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>


<jsp:include page="../../main/header.jsp" />
<style>
body {
	color: #404E67;
	background: #fff;
	font-family: 'Open Sans', sans-serif;
}

.table-wrapper {
	width: 100%;
	margin: 30px auto;
	background: #fff;
	padding: 20px;
	box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
}

.table-title {
	padding-bottom: 10px;
	margin: 0 0 10px;
}

.table-title h2 {
	margin: 6px 0 0;
	font-size: 22px;
}

.table-title .add-new {
	float: right;
	height: 30px;
	font-weight: bold;
	font-size: 12px;
	text-shadow: none;
	min-width: 100px;
	border-radius: 50px;
	line-height: 13px;
}

.table-title .add-new i {
	margin-right: 4px;
}

table.table {
	table-layout: fixed;
	text-align:center;
}

table.table tr th, table.table tr td {
	border-color: #e9e9e9;
}

table.table th i {
	font-size: 13px;
	margin: 0 5px;
	cursor: pointer;
}

table.table th:last-child {
	width: 100px;
}

table.table td a {
	cursor: pointer;
	display: inline-block;
	margin: 0 5px;
	min-width: 24px;
}

table.table td a.receiving {
	color: #27C46B;
}



table.table td i {
	font-size: 19px;
}

table.table td a.add i {
	font-size: 24px;
	margin-right: -1px;
	position: relative;
	top: 3px;
}

table.table .form-control {
	height: 32px;
	line-height: 32px;
	box-shadow: none;
	border-radius: 2px;
}

table.table .form-control.error {
	border-color: #f50000;
}

table.table td .add {
	display: none;
}
table.table td .btn {
	width:70px;
	height:30px;
	font-size:9px;
}

.pagination {
	float: right;
	margin: 0 0 5px;
}

.pagination li a {
	border: none;
	font-size: 13px;
	min-width: 30px;
	min-height: 30px;
	color: #999;
	margin: 0 2px;
	line-height: 30px;
	border-radius: 2px !important;
	text-align: center;
	padding: 0 6px;
}

.pagination li a:hover {
	color: #666;
}

.pagination li.active a, .pagination li.active a.page-link {
	background: #03A9F4;
}

.pagination li.active a:hover {
	background: #0397d6;
}

.pagination li.disabled i {
	color: #ccc;
}

.pagination li i {
	font-size: 16px;
	padding-top: 6px
}
.table-wrapper,.form-inline.justify-content-end,.row {
	text-align: center; 
}
#title{
	text-align: left; 
}

</style>

<div class="container-lg">
	<div class="table-responsive">
		<div class="table-wrapper">
			<div class="table-title">
				<!-- 검색 및 정렬 부분 -->

				<div class="form-inline justify-content-end"
					style="margin-bottom: 40px">

					<button type="button" class="btn btn-warning ml-3"
						onclick="performSearchStatus('ongoing')" style="margin-right: 30px">입고중
						보기</button>
					<button type="button" class="btn btn-success ml-3"
						onclick="performSearchStatus('success')" style="margin-right: 30px">입고완료
						보기</button>
					<button type="button" class="btn btn-primary ml-3" id="reset"
						onclick="location.href = '/pos/stock/receivingLog'" style="margin-right: 30px">전체</button>
					<div class="form-group">
						<div class="checkbox ml-2">
							<label> <input type="checkbox" id="sortOrderAsc"
								value="asc" onchange="updateSortOrder(this)" checked>오름차순
							</label>
						</div>
						<div class="checkbox ml-2">
							<label> <input type="checkbox" id="sortOrderDesc"
								value="desc" onchange="updateSortOrder(this)">내림차순
							</label>
						</div>
					</div>
					<div class="form-group ml-3">
						<select class="form-control" id="sortCriteria">
							<option value="noneSelectCriteria">정렬 기준 선택</option>
							<option value="productCode">상품코드</option>
							<option value="productName">상품명</option>
							<option value="receivingQuantity">입고수량</option>
							<option value="receivingStartDate">입고신청일</option>
							<option value="receivingDate">입고일</option>
							<option value="receivingSuccessDate">입고도착일</option>
						</select>

						<button type="button" class="btn btn-primary ml-3" id="sortBtn"
							onclick="performSort()" style="margin-right: 30px">정렬</button>
					</div>
					<div class="form-group ml-3">
						<select class="form-control" id="searchCriteria" name='searchCriteria'
							style="margin-right: 10px">
							<option value="noneSelectCriteria">검색 기준 선택</option>
							<option value="productCode">상품코드</option>
							<option value="productName">상품명</option>
							<option value="receivingStartDate">입고신청일</option>
							<option value="receivingDate">입고일</option>
							<option value="receivingSuccessDate">입고도착일</option>
						</select> <input type="text" class="form-control" id="searchKeyword" name= "searchKeyword"
							placeholder="검색어를 입력해 주세요">
					</div>
					<button type="button" class="btn btn-primary ml-3" id="searchBtn"
						onclick="performSearch()">검색</button>
					
					
				</div>

				<div class="row">
					<div class="col-sm-8">
						<h2 id="title">
							<b>상품 입고 내역</b>
						</h2>
					</div>
					<c:if test="${currentUser.userPosition eq 'admin'}">
						<div class="col-sm-4">
							<button type="button" class="btn btn-info add-new"
								onclick=" openPopup('stock/productAdd', '제품 추가', 600, 450)">
								<i class="fa fa-plus"></i> 제품 추가
							</button>
							<button type="button" class="btn btn-info add-new"
								onclick="openPopup('stock/categoryAdd', '카테고리 추가',550, 400)"
								style="margin-right: 30px">
								<i class="fa fa-plus"></i> 카테고리 추가
							</button>
						</div>
					</c:if>
				</div>
			</div>

			<c:choose>
				<c:when test="${empty list}">
					<p>입고 내역이 없습니다.</p>
				</c:when>
				<c:otherwise>
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>카테고리</th>
								<th>상품코드</th>
								<th>상품명</th>
								<th>입고수량</th>
								<th>입고신청일</th>
								<th>입고일</th>
								<th>입고도착일</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${list}" var="receiving">
								<tr>
									<td>${receiving.productDTO.categoryDTO.categoryName}</td>
									<td>${receiving.productDTO.productCode}</td>
									<td>${receiving.productDTO.productName}</td>
									<td>${receiving.receivingQuantity}</td>
									<td>${receiving.receivingStartDate}</td>
									<td>${receiving.receivingDate}</td>
									<td><c:if test="${receiving.receivingSuccessDate == NULL}">
											-
										</c:if> <c:if test="${receiving.receivingDate != NULL}">
											${receiving.receivingSuccessDate}
										</c:if></td>
									<td><c:if test="${receiving.receivingSuccessDate == NULL}">
											<label class="btn btn-warning">입고중</label>
										</c:if> <c:if test="${receiving.receivingSuccessDate != NULL}">
											<label class="btn btn-success">입고완료</label>
										</c:if></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="clearfix">
						<ul class="pagination">
							<c:if test="${currentPage > 1}">

								<li class="page-item"><a href="#"
									onclick="goToPage(${currentPage - 1})" class="page-link">Previous</a></li>

							</c:if>

							<c:forEach begin="1" end="${totalPages}" var="pageNumber">
								<c:choose>
									<c:when test="${pageNumber eq currentPage}">
										<li class="page-item active"><a href="#"
											class="page-link">${pageNumber}</a></li>
									</c:when>
									<c:otherwise>
										<li class="page-item"><a href="#"
											onclick="goToPage(${pageNumber})" class="page-link">${pageNumber}</a></li>
									</c:otherwise>
								</c:choose>
							</c:forEach>

							<c:if test="${currentPage < totalPages}">
								<li class="page-item"><a href="#"
									onclick="goToPage(${currentPage + 1})" class="page-link">Next</a></li>
							</c:if>
						</ul>
					</div>
				</c:otherwise>
			</c:choose>




		</div>
	</div>
</div>

<jsp:include page="../../main/footer.jsp" />

<script>
var message = "${message}";
if (message !== '') {
	alert(message);
	window.opener.postMessage('popupClosed', '*');
	window.opener.location.reload(); // 부모 페이지 새로고침
	window.close();
}

	function goToPage(page) {
		var sortCriteria = "${sortCriteria}";
		var sortOrder = "${sortOrder}";
		var searchCriteria = "${searchCriteria}";
		var searchKeyword = "${searchKeyword}";
		var status = "${status}";
		
		var url = "?sortCriteria=" + sortCriteria + "&sortOrder=" + sortOrder
				+ "&searchCriteria=" + searchCriteria + "&searchKeyword="
				+ searchKeyword + "&status=" + status +"&page=" + page;

		window.location.href = url;
	}

	function updateSortOrder(checkbox) {
		var sortOrderAsc = document.getElementById("sortOrderAsc");
		var sortOrderDesc = document.getElementById("sortOrderDesc");

		if (checkbox.id == "sortOrderAsc" && sortOrderAsc.checked) {
			sortOrderDesc.checked = false;
		} else if (checkbox.id == "sortOrderDesc" && sortOrderDesc.checked) {
			sortOrderAsc.checked = false;
		} else {
			checkbox.checked = true;
		}
	}

	function performSort() {
		var sortCriteria = document.getElementById("sortCriteria").value;
		var sortOrderAsc = document.getElementById("sortOrderAsc").checked;
		var sortOrderDesc = document.getElementById("sortOrderDesc").checked;
		if (sortCriteria == "noneSelectCriteria") {
			alert("정렬 기준을 선택해야 합니다.");
		} else {
			var sortOrder = "";
			if (sortOrderAsc === true) {
				sortOrder = "asc";
			} else if (sortOrderDesc === true) {
				sortOrder = "desc";
			}
			
			window.location.href = "?sortCriteria="+ sortCriteria+ "&sortOrder="+ sortOrder
					+ "&searchCriteria=${searchCriteria}&searchKeyword=${searchKeyword}&status=${status}&page=1";
			
		}
	}


	function performSearch() {
		var searchCriteria = document.getElementById("searchCriteria").value;
		var searchKeyword = document.getElementById("searchKeyword").value;
		if (searchCriteria != "noneSelectCriteria" && searchKeyword != "") {
			window.location.href = "?sortCriteria=${sortCriteria}"
					+ "&sortOrder=${sortOrder}"  
					+ "&searchCriteria="+ searchCriteria + "&searchKeyword=" + searchKeyword
					+ "&status=${status}&page=1";
		} else if (searchCriteria == "noneSelectCriteria") {
			alert("검색 기준을 선택해야 합니다.");
		} else if (searchKeyword == "") {
			alert("검색어를 입력해야 합니다.");
		}
	}
	
	
	function performSearchStatus(status) {

			window.location.href = "?status="+status + "&page=1";

	}
	function openPopup(url, title, width, height,receivingDate) {
		var currentDate = new Date().toISOString().split('T')[0];
		 if (receivingDate <= currentDate) {
	   		alert("입고일이 오늘 이전이거나 당일인 내역은 수정할 수 없습니다.");
	     	
	    }else{
	    	var left = (window.innerWidth - width) / 2;
		    var top = (window.innerHeight - height) / 2;
		    window.open(url, title, 'width=' + width + ', height=' + height + ', top=' + top + ', left=' + left);
	    }
	    
	}
	

</script>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">

<script>
$(document).ready(function() {
	  var datePickerVisible = false; // 변수 추가
	  var datePickerInitialized = false; // 데이트피커 초기화 여부를 나타내는 변수 추가

	  $("select[name='searchCriteria']").change(function() {
	    var selectedCriteria = $(this).val();
	 
	    if (selectedCriteria === "receivingStartDate" || selectedCriteria === "receivingDate" || selectedCriteria === "receivingSuccessDate") {
	      $("input[name='searchKeyword']").prop("readonly", true); // 검색창 입력 막기

	      if (!datePickerInitialized) { // 데이트피커 초기화 여부 확인
	        $("input[name='searchKeyword']").datepicker({
	          dateFormat: "yy-mm-dd",
	          onSelect: function(dateText) {
	            $("input[name='searchKeyword']").val(dateText);
	          }
	        });
	        datePickerInitialized = true; // 데이트피커 초기화 완료
	      }

	      $("input[name='searchKeyword']").datepicker("show");

	      datePickerVisible = true; // 데이트피커가 나타났음을 표시
	    } else {
	      $("input[name='searchKeyword']").prop("readonly", false); // 검색창 입력 가능하게 변경
	      $("input[name='searchKeyword']").datepicker("hide"); // 데이트피커 숨기기
	      datePickerVisible = false; // 데이트피커가 사라짐을 표시
	    }
	  });
	});
</script>
