package com.example.demo.Controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.AOP.LoginCheck;
import com.example.demo.AOP.LoginCheck.UserType;
import com.example.demo.DTO.CategoryDTO;
import com.example.demo.DTO.ProductDTO;
import com.example.demo.DTO.SaleDTO;
import com.example.demo.Manager.CategoryManger;
import com.example.demo.Manager.ProductManager;
import com.example.demo.Manager.SaleManager;

@Controller
public class SaleController {

	@Autowired
	private ProductManager productManager;
	@Autowired
	private CategoryManger categoryManger;
	@Autowired
	private SaleManager saleManager;

	/*
	 * 사용자에게 제품을 판매하는 페이지 이동
	 */
	@GetMapping("/pos/sale")
	@LoginCheck(type = {UserType.admin,UserType.manager,UserType.staff})
	public String goSale(Model model) {
		List<CategoryDTO> categoryList = categoryManger.getAllCategories();
		model.addAttribute("categoryList", categoryList);
		model.addAttribute("categoryListSize", categoryList.size());
		model.addAttribute("mode", "sale");
		return "sale/saleHome";
	}
	/*
	 * 판매 내역을 볼 수 있는 페이지 이동
	 */
	@GetMapping("/pos/sale/saleView")
	@LoginCheck(type = {UserType.admin,UserType.manager,UserType.staff})
	public String goSaleView(Model model,@RequestParam int saleNo) {
		SaleDTO saleDTO = saleManager.getSaleByNo(saleNo);
		model.addAttribute("sale",saleDTO);
		return "sale/saleView";
	}
	/*
	 * 해당 판매 내역을 상세히 볼 수 있는 판매 내역 상세보기 페이지 이동
	 */
	@GetMapping("/pos/sale/saleLog")
	@LoginCheck(type = {UserType.admin,UserType.manager,UserType.staff})
	public String goSaleLog(Model model, @RequestParam(defaultValue = "1") int page,@RequestParam Map<String, String> params) {	
		int pageSize = 10;
		String sortCriteria = params.getOrDefault("sortCriteria", "saleDate");
		String sortOrder = params.getOrDefault("sortOrder", "desc");
		String searchCriteria = params.getOrDefault("searchCriteria", "");
		String searchKeyword = params.getOrDefault("searchKeyword", "");
		List<SaleDTO> list = saleManager.getSaleLog(sortCriteria, sortOrder, searchCriteria, searchKeyword);
		int totalItems = list.size();
		int totalPages = (int) Math.ceil((double) totalItems / pageSize);
		int offset = (page - 1) * pageSize;
		int endIndex = Math.min(offset + pageSize, totalItems);
		List<SaleDTO> subList = list.subList(offset, endIndex);

		model.addAttribute("list", subList);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("mode", "sale");	
		model.addAttribute("currentPage", page);
		model.addAttribute("sortCriteria", sortCriteria);
		model.addAttribute("sortOrder", sortOrder);
		model.addAttribute("searchCriteria", searchCriteria);
		model.addAttribute("searchKeyword", searchKeyword);

		return "sale/saleLog";
	}
	
	
	/*
	 * 현재 존재하는 카테고리를 보여주는 페이지 이동
	 */
	@GetMapping("pos/sale/categories")
	@LoginCheck(type = {UserType.admin,UserType.manager,UserType.staff})
	public String goCategory(Model model) {
		List<CategoryDTO> categoryList = categoryManger.getAllCategories();
		model.addAttribute("categoryList", categoryList);
		model.addAttribute("categoryListSize", categoryList.size());

		return "sale/saleCategory";
	}

	
	/*
	 * 현재 존재하는 카테고리를 가져와 html을 리턴한다 (ajax)
	 */
	@RequestMapping(value = "/pos/sale/category", method = RequestMethod.GET)
	@ResponseBody
	public String getCategory(@RequestParam int startIndex, @RequestParam int endIndex) {

		List<CategoryDTO> categoryList = categoryManger.getAllCategories();
		if (endIndex > categoryList.size())
			endIndex = categoryList.size() - 1;
		else if (endIndex < 0)
			endIndex = 11;
		if (startIndex < 0)
			startIndex = 0;
		String html = "<table class='categories'>";
		for (int i = startIndex; i <= endIndex; i++) {
			if (i % 4 == 0) {
				html += "<tr>";
			}

			html += "<td><button class='category-button' onclick=getProducts(" + categoryList.get(i).getCategoryNo()
					+ ")>" + categoryList.get(i).getCategoryName() + "</button></td>";

			if (i % 4 == 3) {
				html += "</tr>";
			}
		}
		html += "</table>";

		return html;
	}

	/*
	 * 해당 카테고리의 제품을 보여주는 페이지를 이동
	 */
	@RequestMapping(value = "/pos/sale/category/products", method = RequestMethod.GET)
	public String getProducts(@RequestParam int categoryNo, @RequestParam(defaultValue = "1") int page, Model model) {
		int pageSize = 8;
		List<ProductDTO> productList = productManager.getProductListByCategory(categoryNo);
		int totalItems = productList.size();
		int totalPages = (int) Math.ceil((double) totalItems / pageSize);
		int offset = (page - 1) * pageSize;
		int endIndex = Math.min(offset + pageSize, totalItems);
		List<ProductDTO> subList = productList.subList(offset, endIndex);
		model.addAttribute("categoryNo", categoryNo);
		model.addAttribute("productList", subList);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", page);
		return "sale/saleProduct";
	}

	
	/*
	 * 제품을 선택하면 추가되는 계산 페이지 이동 
	 */
	@GetMapping("pos/sale/cart")
	@LoginCheck(type = {UserType.admin,UserType.manager,UserType.staff})
	public String goCart() {
		return "sale/saleCart";
	}
	
	/*
	 * 계산 완료 시, 계산 완료 작업을 실행하는 작업 실행 (판매내역 삽입, 재고량 감소)
	 */
	@PostMapping("/pos/sale")
	@ResponseBody
	public String insertSale(@RequestBody SaleDTO data) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		String now = LocalDateTime.now().format(formatter);
		data.setSaleDate(now);
		saleManager.insertSale(data);

		return "success";
	}

	
	/*
	 * 완료된 계산을 취소 (판매내역에 취소 날짜 업데이트, 재고량 복구)
	 */
	@PostMapping("/pos/sale/saleCancel")
	public String gdoAddCategory(Model model,  @RequestParam int saleNo) {
		model.addAttribute("message", saleManager.cancelSale(saleNo));
		return "sale/saleView";
	}

}
