	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ page language="java" contentType="text/html; charset=utf-8"
		pageEncoding="utf-8"%>
	
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
		rel="stylesheet">
	<style>
	.cartSection table {
		text-align: center;
	}
	
	#cartTable {
		height: 45vh; 
		max-height: 45vh;
		overflow-y: auto;
	}
	
	#receiptTable {
		height: 28vh;
		max-height: 28vh;
		overflow-y: auto;
		overflow-x: hidden;
	}
	
	th:first-child {
		text-align: center;
	}
	
	th:last-child {
		text-align: right;
	}
	
	.calculate-button {
		display: block;
		width: 100%;
		height: 100%;
		padding: 0;
	}
	
	</style>
	<div class="modal fade" id="calculateModal" tabindex="-1" role="dialog" aria-labelledby="calculateModalLabel" aria-hidden="true">
	  <div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="calculateModalLabel">확인</h5>
	      </div>
	      <div class="modal-body">
	      <h5> <b>계산을 완료하시겠습니까 ?</b></h5>
	      </div>
	      <div class="modal-footer">
	      <button type="button" class="btn btn-secondary" id="closeModal">닫기</button>
	        <button type="button" class="btn btn-primary" id="complete">완료</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<div class="cartSection">
	
		
		<div class="container-xl">
			<div class="row">
				<div class="col-md-12">
					<div class="col-sm-6">
						<h2 style="color: #3e64ff">
							<b>상품목록</b>
						</h2>
					</div>
					<div id="cartTable" class="table-responsive">
						<div class="table-wrapper">
							<div class="table-title">
								<div class="row"></div>
							</div>
							<table class="table table-striped table-hover">
								<thead>
									<tr>
										<th>상품코드</th>
										<th>상품명</th>
										<th>가격</th>
										<th>수량</th>
										<th>총가격</th>
										<th></th>
									</tr>
								</thead>
								<tbody>
									
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<div id="receiptTable">
						<div class="table-wrapper">
							<table class="table table-striped table-hover ">
								<tbody>
									<tr>
										<th><h5>총합 :</h5></th>
										<th><h5>
												<span id="totalAmount">0</span>원
											</h5></th>
									</tr>
									<tr>
										<th><h5>
												받은 돈 :
												</h5></th>
										<th><h5>
												<input type="number" id="receivedAmount" value="0"
													style="text-align: right;">원
											</h5></th>
									</tr>
									<tr>
										<th><h5>
												거스름돈 :
												</h5></th>
										<th><h5>
												<span id="changeAmount">0</span>원
											</h5></th>
									</tr>
								</tbody>
							</table>
							<div class="col-md-12">
								<button class="btn btn-primary calculate-button btn-block"
						style="height: 50px;" data-toggle="modal" data-target="#calculateModal">계산하기</button>
							</div>
						</div>
					</div>
				</div>
	
			</div>
	
			
	
	
	
		</div>
	
		
	</div>
<script>
		$(document).ready(function() {
			$("#receivedAmount").on("input", function() {
				calculateChangeAmount();
			});
			
			$(".calculate-button").on("click", function() {
			    var totalAmount = parseInt($("#totalAmount").text());
			    var receivedAmount = parseInt($("#receivedAmount").val());

			    if (totalAmount === 0) {
			      alert("상품이 없습니다.");
			    } else if (receivedAmount < totalAmount) {
			      alert("받은 돈이 부족합니다.");
			    } else {
			      $('#calculateModal').modal('show');
			    }
			  });
			
			$("#closeModal").click(function() {
			    $("#calculateModal").modal("hide");
			  });
			$("#complete").click(function() {
				var saleProducts = [];
				$("#cartTable table tbody tr").each(function() {
				var productCode = $(this).find("td:nth-child(1)").text(); 
				var productName = $(this).find("td:nth-child(2)").text(); 
				var price = parseInt($(this).find("td:nth-child(3)").text());
				var quantity = parseInt($(this).find("td:nth-child(4)").find(".quantityInput").val());
				var saleProduct = {
								   productCode: productCode,
								   productName: productName,
						           price: price,
						           quantity: quantity
				};
				saleProducts.push(saleProduct);
				});
						        
				var totalAmount = parseInt($("#totalAmount").text());
				var receivedAmount = parseInt($("#receivedAmount").val());
				var changeAmount = parseInt($("#changeAmount").text());
				var data = {
						    saleProducts: saleProducts,
						    saleTotalPrice: totalAmount,
						    saleReceived: receivedAmount,
						   	saleChanged: changeAmount
						    };
				 $.ajax({
						url: "/pos/sale",
						type: "POST",
						data: JSON.stringify(data),
					    contentType: "application/json",
						success: function(response) {
						  			window.location.href = "sale"; 
						            },
						error: function(xhr, status, error) {
						            window.location.href = "error";
						            }
						});    				
				});
			function calculateChangeAmount() {
			    var totalAmount = parseInt($("#totalAmount").text());
			    var receivedAmount = parseInt($("#receivedAmount").val());
			    var changeAmount = receivedAmount - totalAmount;
			    $("#changeAmount").text(changeAmount);
			}

		});						   			   		
</script>
	
	
	
