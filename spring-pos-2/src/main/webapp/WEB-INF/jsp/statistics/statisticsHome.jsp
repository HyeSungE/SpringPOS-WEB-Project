<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<title>POS STATISTICS</title>
<jsp:include page="../main/header.jsp" />
<link
	href="https://fonts.googleapis.com/icon?family=Material+Icons+Round"
	rel="stylesheet">
<link href="/css/statistics.css" rel="stylesheet">
</head>
<main
	class="main-content position-relative max-height-vh-100 h-100 border-radius-lg ">

	<div class="container-fluid py-0">
		<div class="row">

			<div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
				<div class="card">
					<div class="card-header p-3 pt-2">
						<div
							class="icon icon-lg icon-shape bg-gradient-danger shadow-danger text-center border-radius-xl mt-n4 position-absolute">
							<i class="material-icons opacity-10">thumb_up</i>
						</div>
						<div class="text-end pt-1">
							<p class="text-sm mb-0 text-capitalize">오늘 최다 판매</p>
							<h4 class="mb-0">
								<c:if test="${empty todayBestProName}">판매 제품 없음</c:if>
								<c:if test="${not empty todayBestProName}">${todayBestProName}</c:if>
							</h4>

						</div>
					</div>
					<hr class="dark horizontal my-0">
					<div class="card-footer p-3">
						<p class="mb-0">
							<span class="text-success text-sm font-weight-bolder">+${todayBestProdQuantity}개
								판매</span>
						</p>
						<p class="text-sm mb-0 text-capitalize">어제 최다 판매 제품 :
							${yesterdayBestProName} ${yesterdayBestProdQuantity}개</p>
					</div>
				</div>
			</div>

			<div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
				<div class="card">
					<div class="card-header p-3 pt-2">
						<div
							class="icon icon-lg icon-shape bg-gradient-success shadow-success text-center border-radius-xl mt-n4 position-absolute">
							<i class="material-icons opacity-10">attach_money</i>
						</div>
						<div class="text-end pt-1">
							<p class="text-sm mb-0 text-capitalize">오늘 매출액(${today})</p>
							<h4 class="mb-0">${todayIncome}원</h4>
						</div>
					</div>
					<hr class="dark horizontal my-0">
					<div class="card-footer p-3">
						<p class="mb-0">
							<span class="text-success text-sm font-weight-bolder">어제
								대비 : ${dayDiffPercent}%</span>
						</p>
						<p class="text-sm mb-0 text-capitalize">어제 매출 :
							${yesterdayIncome}원</p>
					</div>
				</div>
			</div>

			<div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
				<div class="card">
					<div class="card-header p-3 pt-2">
						<div
							class="icon icon-lg icon-shape bg-gradient-primary shadow-primary text-center border-radius-xl mt-n4 position-absolute">
							<i class="material-icons opacity-10">attach_money</i>
						</div>
						<div class="text-end pt-1">
							<p class="text-sm mb-0 text-capitalize">일주일 매출(~ ${today})</p>
							<h4 class="mb-0">${weekTotalPrice}원</h4>
						</div>
					</div>
					<hr class="dark horizontal my-0">
					<div class="card-footer p-3">
						<p class="mb-0">
							<span class="text-success text-sm font-weight-bolder">저번 주
								대비 ${weekDiffPercent}%</span>
						</p>
						<p class="text-sm mb-0 text-capitalize">저번 주 매출 :
							${lastWeekTotalPrice}원</p>
					</div>
				</div>
			</div>

			<div class="col-xl-3 col-sm-6 mb-xl-0 mb-4">
				<div class="card">
					<div class="card-header p-3 pt-2">
						<div
							class="icon icon-lg icon-shape bg-gradient-info shadow-info text-center border-radius-xl mt-n4 position-absolute">
							<i class="material-icons opacity-10">attach_money</i>
						</div>
						<div class="text-end pt-1">
							<p class="text-sm mb-0 text-capitalize">한달 매출(~ ${today})</p>
							<h4 class="mb-0">${thisMonthIncome}원</h4>
						</div>
					</div>
					<hr class="dark horizontal my-0">
					<div class="card-footer p-3">
						<p class="mb-0">
							<span class="text-success text-sm font-weight-bolder">저번 달
								대비 ${monthDiffPercent}%</span>
						</p>
						<p class="text-sm mb-0 text-capitalize">저번 달 매출 :
							${lastMonthIncome}원</p>
					</div>
				</div>
			</div>

		</div>



		<div class="row mt-4">

			<div class="col-lg-4 col-md-6 mt-4 mb-4">
				<div class="card z-index-2 ">
					<div
						class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent">
						<div
							class="bg-gradient-success shadow-success border-radius-lg py-3 pe-1">
							<div class="chart">
								<canvas id="today-chart-line" class="chart-canvas" height="170"></canvas>
							</div>
						</div>
					</div>
					<div class="card-body">
						<hr class="dark horizontal">
						<h6 class="mb-0 ">시간별 매출</h6>
					</div>
				</div>
			</div>

			<div class="col-lg-4 col-md-6 mt-4 mb-4">
				<div class="card z-index-2  ">
					<div
						class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent">
						<div
							class="bg-gradient-primary shadow-primary border-radius-lg py-3 pe-1">
							<div class="chart">
								<canvas id="week-chart-line" class="chart-canvas" height="170"></canvas>
							</div>
						</div>
					</div>
					<div class="card-body">
						<hr class="dark horizontal">
						<h6 class="mb-0 ">요일별 매출</h6>
					</div>
				</div>
			</div>

			<div class="col-lg-4 col-md-6 mt-4 mb-4">
				<div class="card z-index-2 ">
					<div
						class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent">
						<div
							class="bg-gradient-info shadow-info border-radius-lg py-3 pe-1">
							<div class="chart">
								<canvas id="month-chart-line" class="chart-canvas" height="170"></canvas>
							</div>
						</div>
					</div>
					<div class="card-body">
						<hr class="dark horizontal">
						<h6 class="mb-0 ">월별 매출</h6>
					</div>
				</div>
			</div>
		</div>
		<div class="row mb-4" style="margin-top: 60px;">

			<div class="col-lg-8 col-md-6 mb-md-0 mb-4" style="height: 100px;">
				<div class="card z-index-2 ">
					<div
						class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent">
						<div
							class="bg-gradient-dark shadow-dark border-radius-lg py-3 pe-1">
							<div class="chart">
								<canvas id="pop-time-chart-bars" class="chart-canvas"
									height="250"></canvas>
							</div>
						</div>
					</div>
					<div class="card-body">
						<hr class="dark horizontal">
						<h6 class="mb-0 ">붐비는 시간대</h6>
					</div>
				</div>
			</div>

			<div class="col-lg-4 col-md-6 mb-md-0 mb-4">
				<div class="card z-index-2 ">
					<div
						class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent">
						<div
							class="bg-gradient-warning shadow-warning border-radius-lg py-3 pe-1">
							<div class="chart">
								<canvas id="pop-cate-pie-chart" class="chart-canvas"
									height="250"></canvas>
							</div>
						</div>
					</div>
					<div class="card-body">
						<hr class="dark horizontal">
						<h6 class="mb-0 ">인기 카테고리</h6>
					</div>
				</div>
			</div>

		</div>



	</div>

</main>

<jsp:include page="../main/footer.jsp" />
<!--   Core JS Files   -->


<script src="/js//chartjs.min.js"></script>
<script>
	var ctx = document.getElementById("today-chart-line").getContext("2d");

	new Chart(ctx, {
		type : "line",
		data : {
			labels : [ "00", "01", "02", "03", "04", "05", "06", "07","08","09","10",
				 "11", "12", "13", "14", "15", "16", "17", "18","19","20",
				 "21","22","23","00"],
			datasets : [ {
				label : "시간대별 매출",
				tension : 0,
				borderWidth : 0,
				pointRadius : 5,
				pointBackgroundColor : "rgba(255, 255, 255, .8)",
				pointBorderColor : "transparent",
				borderColor : "rgba(255, 255, 255, .8)",
				borderColor : "rgba(255, 255, 255, .8)",
				borderWidth : 4,
				backgroundColor : "transparent",
				fill : true,
				data :${todayHourList},
				maxBarThickness : 6

			} ],
		},
		options : {
			responsive : true,
			maintainAspectRatio : false,
			plugins : {
				legend : {
					display : false,
				}
			},
			interaction : {
				intersect : false,
				mode : 'index',
			},
			scales : {
				y : {
					grid : {
						drawBorder : false,
						display : true,
						drawOnChartArea : true,
						drawTicks : false,
						borderDash : [ 5, 5 ],
						color : 'rgba(255, 255, 255, .2)'
					},
					ticks : {
						suggestedMin : 0,
						suggestedMax : 500,
						beginAtZero : true,
						padding : 10,
						font : {
							size : 14,
							weight : 300,
							family : "Roboto",
							style : 'normal',
							lineHeight : 2
						},
						color : "#fff"
					},
				},
				x : {
					grid : {
						drawBorder : false,
						display : true,
						drawOnChartArea : true,
						drawTicks : false,
						borderDash : [ 5, 5 ],
						color : 'rgba(255, 255, 255, .2)'
					},
					ticks : {
						display : true,
						color : '#f8f9fa',
						padding : 10,
						font : {
							size : 14,
							weight : 300,
							family : "Roboto",
							style : 'normal',
							lineHeight : 2
						},
					}
				},
			},
		},
	});

	var ctx2 = document.getElementById("week-chart-line").getContext("2d");
	
	new Chart(ctx2, {
		type : "line",
		data : {
			labels : [ "일","월", "화", "수", "목", "금", "토"],
			datasets : [ {
				label : "요일별 매출",
				tension : 0,
				borderWidth : 0,
				pointRadius : 5,
				pointBackgroundColor : "rgba(255, 255, 255, .8)",
				pointBorderColor : "transparent",
				borderColor : "rgba(255, 255, 255, .8)",
				borderColor : "rgba(255, 255, 255, .8)",
				borderWidth : 4,
				backgroundColor : "transparent",
				fill : true,
				data: ${weekIncomeList},
				maxBarThickness : 6

			} ],
		},
		options : {
			responsive : true,
			maintainAspectRatio : false,
			plugins : {
				legend : {
					display : false,
				}
			},
			interaction : {
				intersect : false,
				mode : 'index',
			},
			scales : {
				y : {
					grid : {
						drawBorder : false,
						display : true,
						drawOnChartArea : true,
						drawTicks : false,
						borderDash : [ 5, 5 ],
						color : 'rgba(255, 255, 255, .2)'
					},
					ticks : {
						display : true,
						color : '#f8f9fa',
						padding : 10,
						font : {
							size : 14,
							weight : 300,
							family : "Roboto",
							style : 'normal',
							lineHeight : 2
						},
					}
				},
				x : {
					grid : {
						drawBorder : false,
						display : false,
						drawOnChartArea : false,
						drawTicks : false,
						borderDash : [ 5, 5 ]
					},
					ticks : {
						display : true,
						color : '#f8f9fa',
						padding : 10,
						font : {
							size : 14,
							weight : 300,
							family : "Roboto",
							style : 'normal',
							lineHeight : 2
						},
					}
				},
			},
		},
	});

	var ctx3 = document.getElementById("month-chart-line").getContext("2d");

	new Chart(ctx3, {
		type : "line",
		data : {
			labels : [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
			datasets : [ {
				label : "월별 매출",
				borderWidth : 0,
				pointRadius : 5,
				pointBackgroundColor : "rgba(255, 255, 255, .8)",
				pointBorderColor : "transparent",
				borderColor : "rgba(255, 255, 255, .8)",
				borderWidth : 4,
				backgroundColor : "transparent",
				fill : true,
				data : ${monthIncomeList},
			} ],
		},
		options : {
			responsive : true,
			maintainAspectRatio : false,
			plugins : {
				legend : {
					display : false,
				}
			},
			interaction : {
				intersect : false,
				mode : 'index',
			},
			scales : {
				y : {
					grid : {
						drawBorder : false,
						display : true,
						drawOnChartArea : true,
						drawTicks : false,
						borderDash : [ 5, 5 ],
						color : 'rgba(255, 255, 255, .2)'
					},
					ticks : {
						display : true,
						padding : 10,
						color : '#f8f9fa',
						font : {
							size : 14,
							weight : 300,
							family : "Roboto",
							style : 'normal',
							lineHeight : 2
						},
					}
				},
				x : {
					grid : {
						drawBorder : false,
						display : false,
						drawOnChartArea : false,
						drawTicks : false,
						borderDash : [ 5, 5 ]
					},
					ticks : {
						display : true,
						color : '#f8f9fa',
						padding : 10,
						font : {
							size : 14,
							weight : 300,
							family : "Roboto",
							style : 'normal',
							lineHeight : 2
						},
					}
				},
			},
		},
	});
	
	var ctx4 = document.getElementById("pop-time-chart-bars").getContext("2d");

	new Chart(ctx4, {
	  type: "bar",
	  data: {
	    labels: [
	      "00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10",
	      "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
	      "21", "22", "23"
	    ],
	    datasets: [{
	      label: "붐비는 시간대",
	      tension: 0,
	      borderWidth: 0,
	      pointRadius: 5,
	      pointBackgroundColor: "rgba(255, 255, 255, .8)",
	      pointBorderColor: "transparent",
	      borderColor: "rgba(255, 255, 255, .8)",
	      borderWidth: 4,
	      backgroundColor: "transparent",
	      fill: true,
	      data: ${monthPop},
	      maxBarThickness: 6
	    }],
	  },
	  options: {
	    responsive: true,
	    maintainAspectRatio: false,
	    plugins: {
	      legend: {
	        display: false,
	      }
	    },
	    interaction: {
	      intersect: false,
	      mode: 'index',
	    },
	    scales: {
	      y: {
	        grid: {
	          drawBorder: false,
	          display: true,
	          drawOnChartArea: true,
	          drawTicks: false,
	          borderDash: [5, 5],
	          color: 'rgba(255, 255, 255, .2)'
	        },
	        ticks: {
	          display: true,
	          padding: 10,
	          color: '#f8f9fa',
	          font: {
	            size: 14,
	            weight: 300,
	            family: "Roboto",
	            style: 'normal',
	            lineHeight: 2
	          },
	        },
	        title: {
	          display: true,
	          text: '방문 횟수',
	          color: '#f8f9fa',
	          font: {
	            size: 16,
	            weight: 'bold',
	            family: "Roboto",
	            style: 'normal'
	          },
	        }
	      },
	      x: {
	        grid: {
	          drawBorder: false,
	          display: false,
	          drawOnChartArea: false,
	          drawTicks: false,
	          borderDash: [5, 5]
	        },
	        ticks: {
	          display: true,
	          color: '#f8f9fa',
	          padding: 10,
	          font: {
	            size: 14,
	            weight: 300,
	            family: "Roboto",
	            style: 'normal',
	            lineHeight: 2
	          },
	        },
	        title: {
	          display: true,
	          text: '시간',
	          color: '#f8f9fa',
	          font: {
	            size: 16,
	            weight: 'bold',
	            family: "Roboto",
	            style: 'normal'
	          },
	        }
	      },
	    },
	  },
	});

	
	
	var ctx5 = document.getElementById("pop-cate-pie-chart").getContext("2d");

	new Chart(ctx5, {
	  type: "pie",
	  data: {
	    labels: ${catePopLabel},
	    datasets: [
	      {
	        label: "인기 카테고리",
	        backgroundColor: ['#ffd950', '#02bc77', '#28c3d7', '#FF6384', '#52f3ff'],
	        data: ${catePopValue}
	      }
	    ]
	  },
	  options: {
	    responsive: true,
	    maintainAspectRatio: false,
	    plugins: {
	      tooltip: {
	        enabled: false // 툴팁 비활성화
	      }
	    },
	    legend: {
	      display: false
	    },
	    elements: {
	      arc: {
	        borderWidth: 4 // 원의 테두리 두께 조절
	      }
	    },
	    animation: {
	      animateRotate: true, // 회전 애니메이션 활성화
	      animateScale: true // 크기 변화 애니메이션 활성화
	    }
	  },
	  plugins: [
	    {
	      id: 'custom-labels',
	      afterDatasetsDraw: function (chart) {
	        var ctx = chart.ctx;
	        chart.data.datasets.forEach(function (dataset, datasetIndex) {
	          var meta = chart.getDatasetMeta(datasetIndex);
	          if (!meta.hidden) {
	            meta.data.forEach(function (element, index) {
	              // 데이터 라벨 위치 계산
	              var position = element.tooltipPosition();
	              ctx.fillStyle = '#000'; // 데이터 라벨 색상 설정
	              ctx.font = '10px Arial'; // 데이터 라벨 글꼴 설정
	              ctx.textAlign = 'center';
	              ctx.textBaseline = 'middle';
	              // 데이터 라벨 표시
	              ctx.fillText(dataset.data[index]+"%", position.x, position.y);
	            });
	          }
	        });
	      }
	    }
	  ]
	});



</script>
<script>
	var win = navigator.platform.indexOf('Win') > -1;
	if (win && document.querySelector('#sidenav-scrollbar')) {
		var options = {
			damping : '0.5'
		}
		Scrollbar.init(document.querySelector('#sidenav-scrollbar'), options);
	}
</script>
<script async defer src="https://buttons.github.io/buttons.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@3"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>

