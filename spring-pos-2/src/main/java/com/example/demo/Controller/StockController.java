package com.example.demo.Controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.AOP.LoginCheck;
import com.example.demo.AOP.LoginCheck.UserType;
import com.example.demo.DTO.CategoryDTO;
import com.example.demo.DTO.ProductDTO;
import com.example.demo.DTO.ReceivingDTO;
import com.example.demo.Manager.CategoryManger;
import com.example.demo.Manager.ProductManager;
import com.example.demo.Manager.ReceivingManager;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class StockController {

	@Autowired
	private ProductManager productManager;
	@Autowired
	private CategoryManger categoryManger;
	@Autowired
	private ReceivingManager receivingManager;

	/*
	 * 재고,입고 홈페이지 이동 - 재고 조회, 입고 중만 보기, 입고 내역 보기(입고 중, 입고 완료) 페이지 이동 
	 */
	@GetMapping(value = {"/pos/stock","/pos/stock/receiving","/pos/stock/receivingLog"})
	@LoginCheck(type = {UserType.admin,UserType.manager,UserType.staff})
	public String goHome(HttpServletRequest request,Model model, @RequestParam(defaultValue = "1") int page,
			@RequestParam Map<String, String> params) {
		String requestedPath = request.getRequestURI(); //현재 주소를 페이지 이동을 달리함
		int pageSize = 10;
		String returnString = "";
		String sortCriteria = params.getOrDefault("sortCriteria", "productCode");
		String sortOrder = params.getOrDefault("sortOrder", "desc");
		String searchCriteria = params.getOrDefault("searchCriteria", "");
		String searchKeyword = params.getOrDefault("searchKeyword", "");
		String status = params.getOrDefault("status", "");
		
		List<?> list = null;
		if (requestedPath.equals("/pos/stock")) { //재고 조회 홈페이지
		    list = productManager.getProductList(sortCriteria, sortOrder, searchCriteria, searchKeyword,status);
		    returnString = "stock/stockHome";
		} else if (requestedPath.equals("/pos/stock/receiving")) { //현재 진행 중인 입고만 보여주는 페이지
			sortCriteria = params.getOrDefault("sortCriteria", "receivingDate");
		    list = receivingManager.getReceivings(sortCriteria, sortOrder, searchCriteria, searchKeyword,"ongoing");
		    returnString = "stock/receiving/receivingHome"; 
		}else if (requestedPath.equals("/pos/stock/receivingLog")) { //입고 중이거나 입고 완료된 입고 내역을 보여주는 페이지
			sortCriteria = params.getOrDefault("sortCriteria", "receivingDate");
		    list = receivingManager.getReceivings(sortCriteria, sortOrder, searchCriteria, searchKeyword,status);
		    model.addAttribute("now",LocalDate.now().format( DateTimeFormatter.ofPattern("yyyy-MM-dd")) );
		    returnString = "stock/receiving/receivingLog";
		}

		int totalItems = list.size();
		int totalPages = (int) Math.ceil((double) totalItems / pageSize);
		int offset = (page - 1) * pageSize;
		int endIndex = Math.min(offset + pageSize, totalItems);
		List<?> subList = list.subList(offset, endIndex);

		model.addAttribute("list", subList);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("mode", "stock");	
		model.addAttribute("currentPage", page);
		model.addAttribute("sortCriteria", sortCriteria);
		model.addAttribute("sortOrder", sortOrder);
		model.addAttribute("searchCriteria", searchCriteria);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("status", status);
		
		return returnString;
	}

	/*
	 * 카테고리 추가 페이지 이동
	 */
	@GetMapping("/pos/stock/categoryAdd")
	@LoginCheck(type = {UserType.admin})
	public String goAddCategory() {
		return "stock/categoryAdd";
	}

	/*
	 * 카테고리 추가 작업 실행
	 */
	@PostMapping("/pos/stock/categoryAdd")
	public String gdoAddCategory(Model model, @RequestParam Map<String, String> params) {
		String categoryCode = params.get("categoryCode");
		String categoryName = params.get("categoryName");
		String message = "";
		CategoryDTO categoryDTO = categoryManger.getCategoryByCode(categoryCode);
		if (categoryDTO != null) {
			message = "이미 존재하는 코드입니다 ! \\n[ 카테고리 이름 : " + categoryDTO.getCategoryName() + " ] \\\n [ 카테고리 코드 : "
					+ categoryCode + " ]";
		} else {
			message = categoryManger.addCategory(new CategoryDTO(categoryCode, categoryName));
		}
		model.addAttribute("message", message);
		return "stock/categoryAdd";
	}
	
	/*
	 * 제품 추가 페이지 이동
	 */
	@GetMapping("/pos/stock/productAdd")
	@LoginCheck(type = {UserType.admin})
	public String doAddProduct(Model model) {
		List<CategoryDTO> list = categoryManger.getAllCategories();
		model.addAttribute("categoryList", list);
		return "stock/productAdd";
	}

	/*
	 * 제품 추가 작업 실행
	 */
	@PostMapping("/pos/stock/productAdd")
	public String doAddProduct(Model model, @RequestParam Map<String, String> params) {
		String categoryCode = params.get("categoryCode");
		String productName = params.get("productName");
		int productPrice = Integer.parseInt(params.get("productPrice"));
		ProductDTO productDTO = new ProductDTO(categoryManger.getCategoryByCode(categoryCode), productName, productPrice);
		String message = productManager.insertProduct(productDTO);
		model.addAttribute("message", message);
		return "stock/productAdd";
	}

	/*
	 * 제품 수정 페이지 이동
	 */
	@GetMapping("/pos/stock/productEdit")
	@LoginCheck(type = {UserType.admin})
	public String goEditProduct(Model model, @RequestParam(value = "productNo") int productNo) {
		List<CategoryDTO> list = categoryManger.getAllCategories();
		ProductDTO product = productManager.getProductByNo(productNo);
		model.addAttribute("categoryList", list);
		model.addAttribute("product", product);
		return "stock/productEdit";
	}

	/*
	 * 제품 수정 작업 실행
	 */
	@PostMapping("/pos/stock/productEdit")
	public String doEditProduct(Model model, @RequestParam Map<String, String> params) {
		int productNo = Integer.parseInt(params.get("productNo"));
		String mode = params.get("mode"); //mode 값에 따라 제품을 수정하거나 삭제
		System.out.println(mode);
		String message = "";
		if (mode != null && mode.equals("delete")) {
			message = productManager.deleteProduct(productNo);
			
		} else {
			String categoryCode = params.get("categoryCode");
			String productCode = params.get("productCode");
			String productName = params.get("productName");
			int productPrice = Integer.parseInt(params.get("productPrice"));
			int productStrock = Integer.parseInt(params.get("productStrock"));

			ProductDTO productDTO = new ProductDTO(categoryManger.getCategoryByCode(categoryCode), productName,
					productPrice);
			productDTO.setProductNo(productNo);
			productDTO.setProductCode(productCode);
			productDTO.setProductStock(productStrock);
			message = productManager.updateProduct(productDTO);
		}

		model.addAttribute("message", message);
		return "stock/productEdit";
	}

	/*
	 * 입고 신청 페이지 이동
	 */
	@GetMapping("/pos/stock/productReceiving")
	@LoginCheck(type = {UserType.admin,UserType.manager})
	public String goReceivingProduct(Model model, @RequestParam(value = "productNo") int productNo) {
		List<CategoryDTO> list = categoryManger.getAllCategories();
		ProductDTO product = productManager.getProductByNo(productNo);
		model.addAttribute("categoryList", list);
		model.addAttribute("product", product);
		return "stock/productReceiving";
	}

	/*
	 * 입고 신청 작업 실행
	 */
	@PostMapping("/pos/stock/productReceiving")
	public String doReceivingProduct(Model model, @RequestParam Map<String, String> params) {
		int productNo = Integer.parseInt(params.get("productNo"));
		ProductDTO product = productManager.getProductByNo(productNo);
		int receivingQuantity = Integer.parseInt(params.get("receivingQuantity"));
		String receivingDate = params.get("receivingDate");
		Date currentDate = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String receivingStartDate = dateFormat.format(currentDate);
		
		String message = receivingManager.insertReceiving(new ReceivingDTO(product, receivingQuantity, receivingDate,receivingStartDate));
		
		//productManager.updateRecentReceivingDate(productNo, receivingManager.getRecentReceiving(productNo));

		model.addAttribute("product", product);
		model.addAttribute("receivingQuantity", receivingQuantity);
		model.addAttribute("receivingDate", receivingDate);
		model.addAttribute("message", message);
		return "stock/productReceiving";
	}
	
	/*
	 * 입고 수정 작업 페이지 이동
	 */
	@GetMapping("/pos/stock/receiving/receivingEdit")
	@LoginCheck(type = {UserType.admin,UserType.manager})
	public String goEditReceiving(Model model, @RequestParam(value = "receivingNo") int receivingNo) {
		ReceivingDTO receiving = receivingManager.getReceivingByNo(receivingNo);
		model.addAttribute("receiving", receiving);
		return "stock/receiving/receivingEdit";
	}
	
	/*
	 * 입고 수정 작업 실행
	 */
	@PostMapping("/pos/stock/receiving/receivingEdit")
	public String doEditReceiving(Model model, @RequestParam Map<String, String> params) {
		int receivingNo = Integer.parseInt(params.get("receivingNo"));
		String mode = params.get("mode"); //mode값에 따라 입고 신청을 수정하거나 삭제
		String message = "";
		if (mode != null && mode.equals("delete")) {
			message = receivingManager.deleteReceiving(receivingNo);
		} else {
			int receivingQuantity = Integer.parseInt(params.get("receivingQuantity"));
			String receivingDate = params.get("receivingDate");
			message = receivingManager.updateReceiving(receivingNo,receivingQuantity,receivingDate);

		}

		model.addAttribute("message", message);
		return "stock/receiving/receivingEdit";
	}
	
	/*
	 * 입고 완료 페이지 이동
	 */
	@GetMapping("/pos/stock/receiving/success")
	@LoginCheck(type = {UserType.admin,UserType.manager,UserType.staff})
	public String goSuccessReceiving(Model model,@RequestParam(value = "receivingNo") int receivingNo) {
		ReceivingDTO receiving = receivingManager.getReceivingByNo(receivingNo);
		model.addAttribute("receiving", receiving);
		return "stock/receiving/receivingSuccess";
	}
	
	/*
	 * 입고 완료 작업 실행
	 */
	@PostMapping("/pos/stock/receiving/success")
	public String doSuccessReceiving(Model model, @RequestParam Map<String, String> params) {
		int receivingNo = Integer.parseInt(params.get("receivingNo"));
		ReceivingDTO receivingDTO = receivingManager.getReceivingByNo(receivingNo);
		DateTimeFormatter tFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		DateTimeFormatter dFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		
		receivingManager.updateReceiving(receivingNo, LocalDateTime.now().format(tFormatter));
		productManager.updateReceiving(receivingDTO.getProductDTO().getProductNo(),  LocalDateTime.now().format(dFormatter), receivingDTO.getReceivingQuantity());
		

		model.addAttribute("message", "입고가 완료됐습니다. 재고를 확인해 보세요 !");
		return "stock/receiving/receivingSuccess";
	}
}
