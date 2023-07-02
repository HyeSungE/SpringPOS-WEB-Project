package com.example.demo.Controller;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.AOP.LoginCheck;
import com.example.demo.AOP.LoginCheck.UserType;
import com.example.demo.DTO.SaleDTO;
import com.example.demo.DTO.SaleProduct;
import com.example.demo.Manager.CategoryManger;
import com.example.demo.Manager.ProductManager;
import com.example.demo.Manager.SaleManager;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@Controller
public class StatisticsController {

	@Autowired
	private ProductManager productManager;
	@Autowired
	private CategoryManger categoryManger;
	@Autowired
	private SaleManager saleManager;


	/*
	 * 통계 홈페이지 이동 
	 */
	@GetMapping("/pos/statistics")
	@LoginCheck(type = {UserType.admin,UserType.manager,UserType.staff})
	public String goStatistics(Model model) {
		LocalDate today = LocalDate.now();
		DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String todayString = today.format(dayFormatter);
		model.addAttribute("today",todayString.substring(5)); //오늘 날짜
		
		//오늘 매출
		List<SaleDTO> todayList = saleManager.getTodaySaleLog(todayString);
		//어제 매출
		String yesterdayString = LocalDate.now().minusDays(1).format(dayFormatter);
		List<SaleDTO> yesterdayList = saleManager.getTodaySaleLog(yesterdayString);

		//오늘 매출 통계
		String todayInfo[] = getDayLog(todayString); //오늘 매출 기록에 관한 정보를 담은 배열
		model.addAttribute("todayList",todayList); //오늘 매출 기록
	    model.addAttribute("todayIncome",todayInfo[0]); //오늘 매출
	    model.addAttribute("todayBestProName", productManager.getNameByProductCode(todayInfo[1])); //오늘 최다 판매 제품
	    model.addAttribute("todayBestProdQuantity", todayInfo[2]); //최다 판매 제품 수량
	    model.addAttribute("todayHourList",todayInfo[3]); //오늘 매출 기록을 시간대별로 통계
	    
	    //어제 매출 통계
	    String yesterdayInfo[] = getDayLog(yesterdayString); //어제 매출 기록에 관한 정보를 담은 배열
		model.addAttribute("yesterdayList",yesterdayList); //어제 매출 기록
	    model.addAttribute("yesterdayIncome",yesterdayInfo[0]); //어제 매출
	    model.addAttribute("yesterdayBestProName", productManager.getNameByProductCode(yesterdayInfo[1])); //어제 최다 판매 제품
	    model.addAttribute("yesterdayBestProdQuantity", yesterdayInfo[2]); //최다 판매 제품 수량
	    
	    //오늘과 어제의 매출 차이
	    model.addAttribute("dayDiffPercent", getDiff( Integer.parseInt(yesterdayInfo[0]), Integer.parseInt(todayInfo[0])));
	    
	    //주별 매출
	    //이번 주 매출
	    String sundayString = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY)).format(dayFormatter); //일요일 날짜
	    List<Integer> weekIncomeList = getWeekSalesLogList(sundayString, todayString);//일요일 부터 오늘 날짜까지의 매출 기록
	    model.addAttribute("weekIncomeList", new Gson().toJson(weekIncomeList));
	    //저번 주 매출
	    String previousSundayString = today.minusWeeks(1).with(TemporalAdjusters.previous(DayOfWeek.SUNDAY)).format(dayFormatter); // 저번 주 일요일 날짜
	    String previousSaturdayString = today.with(TemporalAdjusters.previous(DayOfWeek.SATURDAY)).format(dayFormatter); //저번 주 토요일 날짜
	    List<Integer> lastWeekIncomeList = getWeekSalesLogList(previousSundayString, previousSaturdayString);
	  
	    model.addAttribute("weekTotalPrice",getSum(weekIncomeList));
	    model.addAttribute("lastWeekTotalPrice",getSum(lastWeekIncomeList));
	    model.addAttribute("weekDiffPercent",getDiff(getSum(lastWeekIncomeList), getSum(weekIncomeList))); //이번 주 매출과 저번 주 매출의 차이

    
	    //월별 매출
	    LocalDate firstDayOfYear = today.with(TemporalAdjusters.firstDayOfYear()); //올해의 첫번째 날짜
	    String firstDayOfYearString = firstDayOfYear.format(dayFormatter);
	    String[] monthInfo = getMonthSalesLogList(firstDayOfYearString, todayString,today.getMonthValue()-1); //올해 부터 오늘 날까지의 매출 기록
	    List<Integer> monthIncomeList = new Gson().fromJson(monthInfo[1], new TypeToken<List<Integer>>(){}.getType());
	    
	    model.addAttribute("monthIncomeList", monthInfo[1]); //월별 매출
	    model.addAttribute("thisMonthIncome", monthIncomeList.get(today.getMonthValue()-1)); //이번 달 매출 
	    model.addAttribute("lastMonthIncome", monthIncomeList.get(today.getMonthValue()-2)); //저번 달 매출
	    model.addAttribute("monthDiffPercent",getDiff( monthIncomeList.get(today.getMonthValue()-2),monthIncomeList.get(today.getMonthValue()-1)) ); // 이번 달 매출과 저번 달 매출의 차이    
	    model.addAttribute("monthPop", monthInfo[0]); //이번 달 붐비는 시간대
	    model.addAttribute("catePopLabel", monthInfo[2]); //이번 달 인기 카테고리 리스트(5)
	    model.addAttribute("catePopValue", monthInfo[3]); //이번 달 인기 카테고리 판매 비율 
	    
		return "statistics/statisticsHome";
	}

	/*
	 * 오늘 하루 매출 기록을 가져오는 작업
	 */
	private String[] getDayLog(String day) {
		String[] returnString = new String[4];
		List<SaleDTO> dayList = saleManager.getTodaySaleLog(day);
		Map<String, Integer> bestSellingMap = new HashMap<>();
		int[] hourlyIncome = new int[24]; // 시간대별 매출액을 저장할 배열
		int dayIncome = 0;
		for (SaleDTO sale : dayList) {
			dayIncome += sale.getSaleTotalPrice();
			for (SaleProduct saleProduct : sale.getSaleProducts()) {
				String productCode = saleProduct.getProductCode();
				int quantity = saleProduct.getQuantity();
				bestSellingMap.put(productCode, bestSellingMap.getOrDefault(productCode, 0) + quantity); // 해당 카테고리의 제품의 판매수량을 계산해서 최다 판매 제품 선정
				LocalDateTime saleDate = LocalDateTime.parse(sale.getSaleDate(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
				int hourOfDay = saleDate.getHour();
				int income = sale.getSaleTotalPrice();
				hourlyIncome[hourOfDay] += income; // 해당 시간대의 매출액 누적
				
			}
		}
		//인기 제품을 가져오는 작업
		String bestProductCode = "";
		int bestProductQuantity = 0;
		for (Map.Entry<String, Integer> entry : bestSellingMap.entrySet()) {
			if (entry.getValue() > bestProductQuantity) {
				bestProductCode = entry.getKey();
				bestProductQuantity = entry.getValue();
			}
		}
		returnString[0] = String.valueOf(dayIncome);
		returnString[1] = bestProductCode;
		returnString[2] = String.valueOf(bestProductQuantity);
		returnString[3] = new Gson().toJson(Arrays.stream(hourlyIncome).boxed().collect(Collectors.toList()));
		return returnString;
	}
	
	/*
	 * 일주일의 매출 기록을 가져오는 작업
	 */
	private List<Integer> getWeekSalesLogList(String start,String end) {
		DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		List<SaleDTO> weekList = saleManager.getDaysSaleLog(start, end);

		int[] weekIncome = new int[7]; // 요일별 매출액을 저장할 배열
		for (SaleDTO sale : weekList) {
			LocalDateTime saleDate = LocalDateTime.parse(sale.getSaleDate(), timeFormatter);
			int dayOfWeek = saleDate.getDayOfWeek().getValue();
			int income = sale.getSaleTotalPrice();
			weekIncome[(dayOfWeek +7) % 7] += income; // 해당 요일의 매출액 누적
		}
		return Arrays.stream(weekIncome).boxed().collect(Collectors.toList());
	}
	
	/*
	 * 한달의 매출 기록을 가져오는 작업
	 */
	private String[] getMonthSalesLogList(String start, String end, int todayMonth) {
		String returnString[] = new String[4];
		DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		List<SaleDTO> monthList = saleManager.getDaysSaleLog(start, end);

		int[] monthIncome = new int[12]; // 월별 매출액을 저장할 배열
		int[] hourlyPop = new int[24]; // 시간대별 매출액을 저장할 배열
		Map<String, Double> catePopMap = new HashMap<>();
		for (SaleDTO sale : monthList) {
			LocalDateTime saleDate = LocalDateTime.parse(sale.getSaleDate(), timeFormatter);
			int saleMonth = saleDate.getMonthValue();
			int income = sale.getSaleTotalPrice();
			monthIncome[saleMonth - 1] += income; // 해당 월의 매출액 누적
			if(saleDate.getMonthValue()-1 == todayMonth) {
				int hourOfDay = saleDate.getHour();
				hourlyPop[hourOfDay] += 1; // 해당 시간대의 매출액 누적
				for (SaleProduct saleProduct : sale.getSaleProducts()) {
					String cateCode = saleProduct.getProductCode().substring(0,3);
					String cateName = categoryManger.getCategoryByCode(cateCode).getCategoryName();
					catePopMap.put(cateName, catePopMap.getOrDefault(cateName, 0.0) + 1);
				}
			}
		}

		int cateValueSum = 0;
		for(Double v : catePopMap.values()) {
			cateValueSum+=v;
		}
		for(String cateName : catePopMap.keySet()) {
			double percent = (double)catePopMap.get(cateName)/(double)cateValueSum;
			catePopMap.put(cateName, (Math.round(percent*100.0)/100.0)*100);
		}

		returnString[0] = new Gson().toJson(Arrays.stream(hourlyPop).boxed().collect(Collectors.toList()));
		returnString[1] = new Gson().toJson(Arrays.stream(monthIncome).boxed().collect(Collectors.toList()));
		returnString[2] = new Gson().toJson(catePopMap.entrySet().stream().sorted(Collections.reverseOrder(Map.Entry.comparingByValue())).map(Map.Entry::getKey).collect(Collectors.toList()));
		returnString[3] = new Gson().toJson(catePopMap.entrySet().stream().sorted(Collections.reverseOrder(Map.Entry.comparingByValue())).map(Map.Entry::getValue).collect(Collectors.toList()));

		return returnString;
	}

	/*
	 * 매출의 함을 구하는 작업
	 */
	private int getSum(List<Integer> list) {
	    int sum = 0;
	    for (Integer num : list) {
	        sum += num;
	    }
	    return sum;
	}
		/*
		 * 퍼센트 차이를 구하는 작업
		 */
	private int getDiff(int lastValue, int thisValue) {
	    if (lastValue <= 0 || thisValue <= 0) {
	        return 0;
	    } else {
	        if (thisValue > lastValue) {
	            double percentage = ((double) (thisValue - lastValue) / lastValue);
	            return (int) ((Math.round(percentage*100.0)/100.0) * 100);
	        } else if (thisValue < lastValue) {
	            double percentage = ((double) (lastValue - thisValue) / thisValue);
	            return (int) (-(Math.round(percentage*100.0)/100.0) * 100); // 음수로 표현하여 낮은 퍼센트를 나타냄
	        } else {
	            return 0; // 두 수가 같을 경우 0을 반환
	        }
	    }
	}


	

}
