package com.example.demo.AOP;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.example.demo.AOP.LoginCheck.UserType;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
@Aspect
public class LoginAspect {
	/*
	 * 어노테이션의 타입에 따라서 로그인 체크를 실행하는 AOP
	 *  - 로그인을 하지 않은 상태로 주소로 직접 접근 시, 로그인 페이지로 이동한다.
	 *  - 로그인을 한 사용자는 자신의 직급에 따라 접근할 수 있는 페이지가 다르다. 
	 *  - 권한 외 페이지 접근시 알림창을 띄우고 페이지 이동을 막는다.
	 */
	@Around("@annotation(com.example.demo.AOP.LoginCheck) && @annotation(loginCheck)")
	public Object userLoginCheck(ProceedingJoinPoint proceedingJoinPoint, LoginCheck loginCheck) throws Throwable {
		HttpSession session = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest()
				.getSession();

		UserType[] userType = loginCheck.type();
		
		String id = SessionTool.getLoginId(session, userType);

		if (id == null) {
			HttpServletResponse response = ((ServletRequestAttributes) RequestContextHolder
					.currentRequestAttributes()).getResponse();
			if (session.getAttribute("currentUser") != null) {
				response.sendRedirect("/pos/noPermission");
			} else {
				response.sendRedirect("/pos"); 
				
			}
		}

		return proceedingJoinPoint.proceed();
	}
}
