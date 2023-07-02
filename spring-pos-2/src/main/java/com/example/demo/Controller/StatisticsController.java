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
	 * ��� Ȩ������ �̵� 
	 */
	@GetMapping("/pos/statistics")
	@LoginCheck(type = {UserType.admin,UserType.manager,UserType.staff})
	public String goStatistics(Model model) {
		LocalDate today = LocalDate.now();
		DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String todayString = today.format(dayFormatter);
		model.addAttribute("today",todayString.substring(5)); //���� ��¥
		
		//���� ����
		List<SaleDTO> todayList = saleManager.getTodaySaleLog(todayString);
		//���� ����
		String yesterdayString = LocalDate.now().minusDays(1).format(dayFormatter);
		List<SaleDTO> yesterdayList = saleManager.getTodaySaleLog(yesterdayString);

		//���� ���� ���
		String todayInfo[] = getDayLog(todayString); //���� ���� ��Ͽ� ���� ������ ���� �迭
		model.addAttribute("todayList",todayList); //���� ���� ���
	    model.addAttribute("todayIncome",todayInfo[0]); //���� ����
	    model.addAttribute("todayBestProName", productManager.getNameByProductCode(todayInfo[1])); //���� �ִ� �Ǹ� ��ǰ
	    model.addAttribute("todayBestProdQuantity", todayInfo[2]); //�ִ� �Ǹ� ��ǰ ����
	    model.addAttribute("todayHourList",todayInfo[3]); //���� ���� ����� �ð��뺰�� ���
	    
	    //���� ���� ���
	    String yesterdayInfo[] = getDayLog(yesterdayString); //���� ���� ��Ͽ� ���� ������ ���� �迭
		model.addAttribute("yesterdayList",yesterdayList); //���� ���� ���
	    model.addAttribute("yesterdayIncome",yesterdayInfo[0]); //���� ����
	    model.addAttribute("yesterdayBestProName", productManager.getNameByProductCode(yesterdayInfo[1])); //���� �ִ� �Ǹ� ��ǰ
	    model.addAttribute("yesterdayBestProdQuantity", yesterdayInfo[2]); //�ִ� �Ǹ� ��ǰ ����
	    
	    //���ð� ������ ���� ����
	    model.addAttribute("dayDiffPercent", getDiff( Integer.parseInt(yesterdayInfo[0]), Integer.parseInt(todayInfo[0])));
	    
	    //�ֺ� ����
	    //�̹� �� ����
	    String sundayString = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY)).format(dayFormatter); //�Ͽ��� ��¥
	    List<Integer> weekIncomeList = getWeekSalesLogList(sundayString, todayString);//�Ͽ��� ���� ���� ��¥������ ���� ���
	    model.addAttribute("weekIncomeList", new Gson().toJson(weekIncomeList));
	    //���� �� ����
	    String previousSundayString = today.minusWeeks(1).with(TemporalAdjusters.previous(DayOfWeek.SUNDAY)).format(dayFormatter); // ���� �� �Ͽ��� ��¥
	    String previousSaturdayString = today.with(TemporalAdjusters.previous(DayOfWeek.SATURDAY)).format(dayFormatter); //���� �� ����� ��¥
	    List<Integer> lastWeekIncomeList = getWeekSalesLogList(previousSundayString, previousSaturdayString);
	  
	    model.addAttribute("weekTotalPrice",getSum(weekIncomeList));
	    model.addAttribute("lastWeekTotalPrice",getSum(lastWeekIncomeList));
	    model.addAttribute("weekDiffPercent",getDiff(getSum(lastWeekIncomeList), getSum(weekIncomeList))); //�̹� �� ����� ���� �� ������ ����

    
	    //���� ����
	    LocalDate firstDayOfYear = today.with(TemporalAdjusters.firstDayOfYear()); //������ ù��° ��¥
	    String firstDayOfYearString = firstDayOfYear.format(dayFormatter);
	    String[] monthInfo = getMonthSalesLogList(firstDayOfYearString, todayString,today.getMonthValue()-1); //���� ���� ���� �������� ���� ���
	    List<Integer> monthIncomeList = new Gson().fromJson(monthInfo[1], new TypeToken<List<Integer>>(){}.getType());
	    
	    model.addAttribute("monthIncomeList", monthInfo[1]); //���� ����
	    model.addAttribute("thisMonthIncome", monthIncomeList.get(today.getMonthValue()-1)); //�̹� �� ���� 
	    model.addAttribute("lastMonthIncome", monthIncomeList.get(today.getMonthValue()-2)); //���� �� ����
	    model.addAttribute("monthDiffPercent",getDiff( monthIncomeList.get(today.getMonthValue()-2),monthIncomeList.get(today.getMonthValue()-1)) ); // �̹� �� ����� ���� �� ������ ����    
	    model.addAttribute("monthPop", monthInfo[0]); //�̹� �� �պ�� �ð���
	    model.addAttribute("catePopLabel", monthInfo[2]); //�̹� �� �α� ī�װ� ����Ʈ(5)
	    model.addAttribute("catePopValue", monthInfo[3]); //�̹� �� �α� ī�װ� �Ǹ� ���� 
	    
		return "statistics/statisticsHome";
	}

	/*
	 * ���� �Ϸ� ���� ����� �������� �۾�
	 */
	private String[] getDayLog(String day) {
		String[] returnString = new String[4];
		List<SaleDTO> dayList = saleManager.getTodaySaleLog(day);
		Map<String, Integer> bestSellingMap = new HashMap<>();
		int[] hourlyIncome = new int[24]; // �ð��뺰 ������� ������ �迭
		int dayIncome = 0;
		for (SaleDTO sale : dayList) {
			dayIncome += sale.getSaleTotalPrice();
			for (SaleProduct saleProduct : sale.getSaleProducts()) {
				String productCode = saleProduct.getProductCode();
				int quantity = saleProduct.getQuantity();
				bestSellingMap.put(productCode, bestSellingMap.getOrDefault(productCode, 0) + quantity); // �ش� ī�װ��� ��ǰ�� �Ǹż����� ����ؼ� �ִ� �Ǹ� ��ǰ ����
				LocalDateTime saleDate = LocalDateTime.parse(sale.getSaleDate(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
				int hourOfDay = saleDate.getHour();
				int income = sale.getSaleTotalPrice();
				hourlyIncome[hourOfDay] += income; // �ش� �ð����� ����� ����
				
			}
		}
		//�α� ��ǰ�� �������� �۾�
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
	 * �������� ���� ����� �������� �۾�
	 */
	private List<Integer> getWeekSalesLogList(String start,String end) {
		DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		List<SaleDTO> weekList = saleManager.getDaysSaleLog(start, end);

		int[] weekIncome = new int[7]; // ���Ϻ� ������� ������ �迭
		for (SaleDTO sale : weekList) {
			LocalDateTime saleDate = LocalDateTime.parse(sale.getSaleDate(), timeFormatter);
			int dayOfWeek = saleDate.getDayOfWeek().getValue();
			int income = sale.getSaleTotalPrice();
			weekIncome[(dayOfWeek +7) % 7] += income; // �ش� ������ ����� ����
		}
		return Arrays.stream(weekIncome).boxed().collect(Collectors.toList());
	}
	
	/*
	 * �Ѵ��� ���� ����� �������� �۾�
	 */
	private String[] getMonthSalesLogList(String start, String end, int todayMonth) {
		String returnString[] = new String[4];
		DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		List<SaleDTO> monthList = saleManager.getDaysSaleLog(start, end);

		int[] monthIncome = new int[12]; // ���� ������� ������ �迭
		int[] hourlyPop = new int[24]; // �ð��뺰 ������� ������ �迭
		Map<String, Double> catePopMap = new HashMap<>();
		for (SaleDTO sale : monthList) {
			LocalDateTime saleDate = LocalDateTime.parse(sale.getSaleDate(), timeFormatter);
			int saleMonth = saleDate.getMonthValue();
			int income = sale.getSaleTotalPrice();
			monthIncome[saleMonth - 1] += income; // �ش� ���� ����� ����
			if(saleDate.getMonthValue()-1 == todayMonth) {
				int hourOfDay = saleDate.getHour();
				hourlyPop[hourOfDay] += 1; // �ش� �ð����� ����� ����
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
	 * ������ ���� ���ϴ� �۾�
	 */
	private int getSum(List<Integer> list) {
	    int sum = 0;
	    for (Integer num : list) {
	        sum += num;
	    }
	    return sum;
	}
		/*
		 * �ۼ�Ʈ ���̸� ���ϴ� �۾�
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
	            return (int) (-(Math.round(percentage*100.0)/100.0) * 100); // ������ ǥ���Ͽ� ���� �ۼ�Ʈ�� ��Ÿ��
	        } else {
	            return 0; // �� ���� ���� ��� 0�� ��ȯ
	        }
	    }
	}


	

}
