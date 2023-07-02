package com.example.demo.Controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.AOP.LoginCheck;
import com.example.demo.AOP.LoginCheck.UserType;
import com.example.demo.AOP.SessionTool;
import com.example.demo.DTO.SaleDTO;
import com.example.demo.DTO.UserDTO;
import com.example.demo.Manager.SaleManager;
import com.example.demo.Manager.UserManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class MainController {
	@Autowired
	private UserManager userManager;
	@Autowired
	private SaleManager saleManager;
	
	/*
	 * 로그인 페이지 이동
	 */
	@GetMapping(value = { "/pos", "/pos/logout" })
	public String goLogin(HttpServletRequest req) {
		req.getSession().invalidate();
		return "/main/login";
	}
	
	/*
	 * 로그인 작업
	 */
	@RequestMapping(value = "/pos",method=RequestMethod.POST)
	public String doLogin(HttpServletRequest req,Model model,
			@RequestParam(value = "userId") String id, 
			@RequestParam(value = "userPw") String pw) {
		HttpSession session = req.getSession();
		session.setMaxInactiveInterval(0);
		UserDTO user = userManager.getUserByIdPw(id, pw);
		if(user!=null) {
			if(user.isUserBanned()==true) {
				return "redirect:/pos?loginBanned=true";
			}else {
				
			
				session.setAttribute("currentUser", user);
				SessionTool.setLoginId(session, user.getUserPosition(),id);
			return "redirect:/pos/home";	
			}
			
		}else {
			return "redirect:/pos?loginFail=true";
		}
	}
	
	/*
	 * 회원가입 페이지 이동
	 */
	@GetMapping("/pos/register")
	public String goRegister() {
		return "main/register";
	}
	
	/*
	 * 회원가입 작업 실행
	 */
	@PostMapping("/pos/register")
	public String doRegister(
	        @RequestParam("register_name") String name,
	        @RequestParam("register_id") String id,
	        @RequestParam("register_password") String password,
	        @RequestParam(value = "register_manager_code", required = false) String managerCode) {
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	    String creationDate = dateFormat.format(new Date());
	    
		UserDTO user = new UserDTO(name,id,password,false,creationDate);
		if(managerCode.equals("iammanager")) user.setUserPosition("manager");
		else user.setUserPosition("staff");
		
	    userManager.insertUser(user);
	    return "redirect:/pos?registered=true";
	}

	/*
	 * 홈페이지 이동
	 */
	@GetMapping("/pos/home")
	@LoginCheck(type = {UserType.admin,UserType.manager,UserType.staff})
	public String goHome(Model model) {
		String todayString =  LocalDate.now().format( DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		List<SaleDTO> dayList = saleManager.getTodaySaleLog(todayString);
		int dayIncome = 0;
		for (SaleDTO sale : dayList) {
			dayIncome += sale.getSaleTotalPrice();
		}
		model.addAttribute("todayIncome",dayIncome); 
	    return "main/home";
	}
	
	/*
	 * 중복된 이메일을 체크하는 작업을 실행 (ajax)
	 */
	@GetMapping("/pos/checkDuplicateEmail")
    @ResponseBody
    public String checkDuplicateEmail(@RequestParam("id") String id) {
        UserDTO user = userManager.getUserId(id);
        if (user!=null) {
            return "duplicate";
        } else {
            return "success";
        }
    }
	
	/*
	 * 로그인한 사용자가 권환 외 페이지에 접근 시 이동하는 페이지 이동
	 */
	@GetMapping("/pos/noPermission")
	public String noPermission() {
		return "main/noPermission";
	}
	
	/*
	 * 아이디와 비밀번호를 찾는 페이지 이동
	 */
	@GetMapping("/pos/find")
	public String goFindAccount(Model model, @RequestParam("mode") String mode) {
	    model.addAttribute("mode", mode);
	    return "main/findAccount";
	}
	
	/*
	 * 아이이와 비밀번호를 찾아 리턴 해주는 작업 실행
	 */ 
	@PostMapping("/pos/find")
	public String doFindAccount(Model model, @RequestParam Map<String, String> params) {

		String userName = params.get("userName");
		String userId = params.get("userId");
		String userUniqueNumber = params.get("userUniqueNumber");
		if(userId==null) {
			model.addAttribute("message",userManager.findId(userName,userUniqueNumber));
		}else {
			model.addAttribute("message",userManager.findPw(userName,userId,userUniqueNumber));
		}
	    return "main/findAccount";
	}



}
