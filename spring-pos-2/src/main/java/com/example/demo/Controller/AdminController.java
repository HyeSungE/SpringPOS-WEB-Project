package com.example.demo.Controller;

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
import com.example.demo.DTO.UserDTO;
import com.example.demo.Manager.UserManager;

@Controller

public class AdminController {
	@Autowired
	private UserManager userManager;

	/*
	 * 사용자 관리 홈페이지 이동
	 */
	@GetMapping("/pos/userEditHome")
	@LoginCheck(type = UserType.admin)
	public String goUserManager(Model model, @RequestParam(defaultValue = "1") int page,
			@RequestParam Map<String, String> params) {
		
		int pageSize = 10;
		String sortCriteria = params.getOrDefault("sortCriteria", "userCreationDate");
		String sortOrder = params.getOrDefault("sortOrder", "desc");
		String searchCriteria = params.getOrDefault("searchCriteria", "");
		String searchKeyword = params.getOrDefault("searchKeyword", "");
		String banned = params.getOrDefault("banned", "");
		List<UserDTO> list = userManager.getUsers(sortCriteria, sortOrder, searchCriteria, searchKeyword,banned);
		
		int totalItems = list.size();
		int totalPages = (int) Math.ceil((double) totalItems / pageSize);
		int offset = (page - 1) * pageSize;
		int endIndex = Math.min(offset + pageSize, totalItems);
		List<UserDTO> subList = list.subList(offset, endIndex);

		model.addAttribute("list", subList);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("mode", "admin");	
		model.addAttribute("currentPage", page);
		model.addAttribute("sortCriteria", sortCriteria);
		model.addAttribute("sortOrder", sortOrder);
		model.addAttribute("searchCriteria", searchCriteria);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("banned", banned);
		
		return "admin/userEditHome";
	}
	/*
	 * 사용자 관리 작업을 하는 페이지 이동
	 */
	@GetMapping("/pos/userEdit")
	@LoginCheck(type = UserType.admin)
	public String goUserEdit(Model model, @RequestParam int userNo) {
		model.addAttribute("user", userManager.getUserByNo(userNo));
	
		return "admin/userEdit";
	}
	/*
	 * mode값에 따라 사용자를 수정하거나 삭제한다
	 */
	@PostMapping("/pos/userEdit")
	public String doUserEdit(Model model, @RequestParam Map<String, String> params) {
		String modeString = params.get("mode");
		UserDTO userDTO = new UserDTO(
				params.get("userName"),
				params.get("userId"),
				params.get("userPw"),
				params.get("userPosition"),
				Boolean.parseBoolean(params.get("userBanned"))				
		);
		System.out.println(modeString);
		userDTO.setUserNo(Integer.parseInt(params.get("userNo")));
		if(modeString.equals("edit")){
			userManager.updateUser(userDTO);
			model.addAttribute("message", "사용자를 수정했습니다 !");
		}else if(modeString.equals("delete")) {
			userManager.deleteUser(userDTO.getUserNo());
			model.addAttribute("message", "사용자를 삭제했습니다 !");
		}
		
		return "admin/userEdit";
	}
	
	

}
