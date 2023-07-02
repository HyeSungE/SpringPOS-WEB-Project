
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<jsp:include page="../main/header.jsp" />
<style>
body {
	color: #404E67;
	background: #FFF;
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
}

table.table tr th, table.table tr td {
	border-color: #e9e9e9;
}

table.table th {
	width: 25%;
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

table.table td a.edit {
	color: #FFC107;
}

table.table td a.delete {
	color: #E34724;
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

.table-wrapper, .form-inline.justify-content-end, .row {
	text-align: center;
}

#title {
	text-align: left;
}
table.table td a.userEdit {
	color: #27C46B;
}



</style>

<div class="container-lg">
	<div class="table-responsive">
		<div class="table-wrapper">
			<div class="table-title">
				<div class="form-inline justify-content-end"
					style="margin-bottom: 40px">
					
					<button type="button" class="btn btn-success ml-3" 
						onclick="performSearchBanned('true')"
						style="margin-right: 30px">활성화 보기</button>
						<button type="button" class="btn btn-danger ml-3"
						onclick="performSearchBanned('false')"
						style="margin-right: 30px">비활성화 보기</button>
					<button type="button" class="btn btn-primary ml-3" id="reset"
						onclick="location.href = '/pos/userEditHome'"
						style="margin-right: 30px">전체</button>
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
							<option value="userName">이름</option>
							<option value="userId">아이디</option>
							<option value="userPosition">직급</option>
							<option value="userBanned">상태</option>
							<option value="userCreationDate">가입일</option>
						</select>

						<button type="button" class="btn btn-primary ml-3" id="sortBtn"
							onclick="performSort()" style="margin-right: 30px">정렬</button>
					</div>
					<div class="form-group ml-3">
						<select class="form-control" id="searchCriteria" name='searchCriteria'
							style="margin-right: 10px">
							<option value="noneSelectCriteria">검색 기준 선택</option>
							<option value="userName">이름</option>
							<option value="userId">아이디</option>
							<option value="userPw">비밀번호</option>
							<option value="userPosition">직급</option>
							<option value="userBanned">상태</option>
							<option value="userCreationDate">가입일</option>
						</select>
						
							<input type="text" name="searchKeyword" class="form-control"
								id="searchKeyword" placeholder="검색어를 입력하세요">
						

					</div>
					<button type="button" class="btn btn-primary ml-3" id="searchBtn"
						onclick="performSearch()">검색</button>
					
				</div>

				<div class="row">
					<div class="col-sm-8">
						<h2 id="title">
							<b>사용자 관리</b>
						</h2>
					</div>
				</div>
			</div>

			<c:choose>
				<c:when test="${empty list}">
					<p>사용자가 없습니다.</p>
				</c:when>
				<c:otherwise>
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>이름</th>
								<th>아이디</th>
								<th>비밀번호</th>
								<th>직급</th>
								<th>상태</th>
								<th>가입일</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${list}" var="user">
								<tr>
									<td>${user.userName}</td>
									<td>${user.userId}</td>
									<td>${user.userPw}</td>
									<td>${user.userPosition == 'staff' ? '직원' : (user.userPosition == 'manager' ? '매니저' : '')}</td>
									<td><c:if test="${user.userBanned==false}">
											<label class="btn btn-danger">비활성화</label>
										</c:if> <c:if test="${user.userBanned==true}">
											<label class="btn btn-success">활성화</label>
										</c:if></td>
									<td>${user.userCreationDate}</td>
									<td><a class="userEdit" title="관리" href="#" onclick="openPopup('userEdit?userNo=${user.userNo}', '사용자 관리',700, 750)">
										<i><span class="fa fa-cog"></span></i></a></td>
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

<jsp:include page="../main/footer.jsp" />

<script>
$(document).ready(function() {
	  var datePickerVisible = false; // 변수 추가
	  var datePickerInitialized = false; // 데이트피커 초기화 여부를 나타내는 변수 추가

	  $("select[name='searchCriteria']").change(function() {
	    var selectedCriteria = $(this).val();
	 
	    if (selectedCriteria === "userCreationDate") {
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

	
	function goToPage(page) {
		var sortCriteria = "${sortCriteria}";
		var sortOrder = "${sortOrder}";
		var searchCriteria = "${searchCriteria}";
		var searchKeyword = "${searchKeyword}";
		var banned = "${banned}";
		
		var url = "?sortCriteria=" + sortCriteria + "&sortOrder=" + sortOrder
				+ "&searchCriteria=" + searchCriteria + "&searchKeyword="
				+ searchKeyword + "&banned=" + banned +"&page=" + page;

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
					+ "&searchCriteria=${searchCriteria}&searchKeyword=${searchKeyword}&banned=${banned}&page=1";
			
		}
	}

	function performSearch() {
		var searchCriteria = document.getElementById("searchCriteria").value;
		var searchKeyword = document.getElementById("searchKeyword").value;
		if (searchCriteria != "noneSelectCriteria" && searchKeyword != "") {
			window.location.href = "?sortCriteria=${sortCriteria}"
					+ "&sortOrder=${sortOrder}"  
					+ "&searchCriteria="+ searchCriteria + "&searchKeyword=" + searchKeyword
					+ "&banned=${banned}&page=1";
		} else if (searchCriteria == "noneSelectCriteria") {
			alert("검색 기준을 선택해야 합니다.");
		} else if (searchKeyword == "") {
			alert("검색어를 입력해야 합니다.");
		}
	}
	
	
	function performSearchBanned(banned) {
		window.location.href = "?banned="+banned + "&page=1";
	}
	
	function openPopup(url, title, width, height) {

    	var left = (window.innerWidth - width) / 2;
	    var top = (window.innerHeight - height) / 2;
	    window.open(url, title, 'width=' + width + ', height=' + height + ', top=' + top + ', left=' + left);
    
    
}
</script>


<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>


<script>



</script>




