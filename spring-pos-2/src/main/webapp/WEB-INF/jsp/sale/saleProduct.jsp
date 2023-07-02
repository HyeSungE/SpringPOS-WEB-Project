<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>sale product</title>

<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>

<style>


#productSectoin body {
	color: #566787;
	background: #fff;
	font-family: 'Roboto', sans-serif;
	
}

#productSectoin .table-responsive {
	margin: 30px 0;
}

#productSectoin .table-wrapper {
	width: 850px;
	background: #fff;
	margin: 0 auto;
	padding: 20px 30px 5px;
	box-shadow: 0 0 1px 0 rgba(0, 0, 0, .25);
}

#productSectoin .table-title {
	min-width: 100%;
	border-bottom: 1px solid #e9e9e9;
	padding-bottom: 15px;
	margin-bottom: 5px;
	background: #FFFFF;
	margin: -20px -31px 10px;
	padding: 15px 30px;
	color: #fff;
}

#productSectoin .table-title h2 {
	margin: 2px 0 0;
	font-size: 24px;
}

#productSectoin table.table {
	max-width: 80%;
}

#productSectoin table.table tr th, table.table tr td {
	border-color: #e9e9e9;
	padding: 12px 15px;
	vertical-align: middle;
	text-align: center;
}

#productSectoin table.table-striped tbody tr:nth-of-type(odd) {
	background-color: #fcfcfc;
}

#productSectoin table.table-striped.table-hover tbody tr:hover {
	background: #f5f5f5;
}

#productSectoin table.table td a {
	color: #2196f3;
}
</style>
</head>
<body >
	<div class="modal fade" id="quantityModal" tabindex="-1" role="dialog"
		aria-labelledby="quantityModalLabel" aria-hidden="true" >
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="quantityModalLabel">수량 입력</h5>
				</div>
				<div class="modal-body">
					<input type="number" id="quantityInput" class="form-control"
						placeholder="수량을 입력하세요">
				</div>
				<div class="modal-footer">

					<button type="button" class="btn btn-primary" onclick="addCart()">추가</button>
				</div>
			</div>
		</div>
	</div>

	<div id="productSection">
		<div class="clearfix" style="display: flex; justify-content: center;">
			<ul class="pagination">
				<c:if test="${currentPage > 1}">
					<li class="page-item"><a href="#"
						onclick="goToPage(${categoryNo},${currentPage - 1})"
						class="page-link">이전</a></li>
				</c:if>

				<c:forEach begin="1" end="${totalPages}" var="pageNumber">
					<c:choose>
						<c:when test="${pageNumber eq currentPage}">
							<li class="page-item active"><a href="#" class="page-link">${pageNumber}</a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item"><a href="#"
								onclick="goToPage(${categoryNo},${pageNumber})"
								class="page-link">${pageNumber}</a></li>
						</c:otherwise>
					</c:choose>
				</c:forEach>

				<c:if test="${currentPage < totalPages}">
					<li class="page-item"><a href="#"
						onclick="goToPage(${categoryNo},${currentPage + 1})"
						class="page-link">다음</a></li>
				</c:if>
			</ul>
		</div>
		<div class="container-xl" >
			<div>
				<div class="table-wrapper">
					<div class="table-title">
						<div class="row">
							<div class="col-sm-6">
								<h2 style="color: #3e64ff">
									<b>상품</b>
								</h2>
							</div>
							<div class="col-sm-6 text-right">
								<button onclick="goCategories()" class="btn btn-secondary">돌아가기</button>
							</div>
						</div>
					</div>
					<table class="table table-striped table-hover" >
						<thead>
							<tr style="text-align: center">
								<th>상품코드</th>
								<th>상품명</th>
								<th>상태</th>
								<th>수량</th>
								<th>가격</th>
								<th></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="product" items="${productList}">
								<tr
									data-status="${product.productStock == 0 ? 'expired' : 'active'}">
									<td>${product.productCode}</td>
									<td>${product.productName}</td>
									<td><c:if test="${product.productStock==0}">
											<label class="btn btn-danger">품절</label>
										</c:if> <c:if test="${product.productStock!=0}">
											<label class="btn btn-success">판매</label>
										</c:if></td>
									<td>${product.productStock}</td>
									<td>${product.productPrice}</td>
									<td><c:if test="${product.productStock != 0}">
											<button class="btn btn-primary"
												onclick="getQuantity('${product.productCode}', '${product.productName}', ${product.productStock}, ${product.productPrice})">추가</button>
										</c:if></td>
								</tr>
							</c:forEach>

						</tbody>
					</table>
				</div>

			</div>
		</div>
	</div>

</body>
<script>
function goToPage(categoryNo, page) {
    $('#categorySection').load('sale/category/products?categoryNo=' + categoryNo + '&page=' + page);
}
function goCategories() {
	$('#categorySection').load('sale/categories');
}
var selectedProductNo;
var selectedProductName;
var selectedProductStock;
var selectedProductPrice;

function getQuantity(productCode, productName, productStock,productPrice) {
    selectedProductCode = productCode;
    selectedProductName = productName;
    selectedProductStock = productStock;
    selectedProductPrice = productPrice;
    $('#quantityModal').modal('show');
}

function addCart() {
    var quantity = parseInt($('#quantityInput').val());
    if (isNaN(quantity) || quantity <= 0 || quantity > selectedProductStock) {
    	alert('유효하지 않은 수량입니다. 다시 입력해주세요.');
        return;
    }

    addProduct(selectedProductCode,selectedProductName,quantity,selectedProductPrice);

    $('#quantityModal').modal('hide');
    $('#quantityInput').val('');
}

function addProduct(productCode, productName,quantity,productPrice) {
	 var chkProduct = $('.cartSection table tbody tr').filter(function() {
	        return $(this).find('td:first-child').text() === productCode;
		});
	 if (chkProduct.length > 0) {
	        var chkQuantity = parseInt(chkProduct.find('.quantityInput').val());
	        var newQuantity = chkQuantity + quantity;
	        if (newQuantity > selectedProductStock) {
	            alert('수량이 재고를 초과합니다!');
	            return;
	        }
	        chkProduct.find('.quantityInput').val(newQuantity);
	        updateTotalPrice(chkProduct.find('.quantityInput'));
	    }else{
	    	 var totalPrice = productPrice * quantity;
	    	    var newRow = '<tr>' +
	    	        '<td>' + productCode + '</td>' +
	    	        '<td>' + productName + '</td>' +
	    	        '<td>' + productPrice + '</td>' +
	    	        '<td><input type="number" class="quantityInput" value="' + quantity + '" min="1"></td>' +
	    	        '<td class="totalPrice">' + totalPrice + '</td>' +
	    	        '<td><button onclick="removeProduct(this)" class="btn btn-danger">X</button></td>' +
	    	        '</tr>';
	    	    $('#cartTable table tbody').append(newRow);
	    	    $('#cartTable table tbody .quantityInput').on('input', function() {
	    	        var input = $(this);
	    	        var originalValue = input.data('original-value');
	    	        var quantity = parseInt(input.val());
					if(isNaN(quantity)){
						
						 updateTotalPrice(input);
					}else if (quantity === 0) {
						  if (confirm('해당 상품을 삭제하시겠습니까?')) {
							  // 수량이 0인 경우에 해당 상품 행 삭제
						        var row = input.closest('tr');
						        row.remove();
						        updateTotalPrice(input);
						  }
				    } 
					else  if ( quantity < 0 || quantity > selectedProductStock) {
	    	            input.val(originalValue);
	    	            alert('유효하지 않은 수량입니다. 다시 입력해주세요.');
	    	        } else {
	    	            input.data('original-value', quantity);
	    	            updateTotalPrice(input);
	    	        }
	    	    });	
	    	    updateTotalPrice($('.quantityInput:last'));
	    }
}
function removeProduct(button) {
    var row = $(button).closest('tr');
    var price = parseInt(row.find('td:nth-child(3)').text());
    var quantity = parseInt(row.find('.quantityInput').val());
    
    if (!isNaN(quantity)) {
        var subtotal = price * quantity;
        var totalAmount = parseInt($('#totalAmount').text());
        var newTotalAmount = totalAmount - subtotal;
        $('#totalAmount').text(newTotalAmount);
    }
    
    row.remove();
}

function updateTotalPrice(input) {
    var totalAmount = 0;
    $('#cartTable table tbody tr').each(function() {
        var price = parseInt($(this).find('td:nth-child(3)').text());
        var quantity = parseInt($(this).find('.quantityInput').val());
        if(isNaN(quantity)) quantity = 0;
        var totalPrice = price * quantity;
     
        $(this).find('.totalPrice').text(totalPrice);
        totalAmount += totalPrice;
    });
    $('#totalAmount').text(totalAmount);
}



</script>
<script src="/js/jquery-3.7.0.min.js"></script>
<script src="/js/bootstrap.min.js"></script>

</html>
