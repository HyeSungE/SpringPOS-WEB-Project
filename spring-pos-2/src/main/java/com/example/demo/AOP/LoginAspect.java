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
	 * ������̼��� Ÿ�Կ� ���� �α��� üũ�� �����ϴ� AOP
	 *  - �α����� ���� ���� ���·� �ּҷ� ���� ���� ��, �α��� �������� �̵��Ѵ�.
	 *  - �α����� �� ����ڴ� �ڽ��� ���޿� ���� ������ �� �ִ� �������� �ٸ���. 
	 *  - ���� �� ������ ���ٽ� �˸�â�� ���� ������ �̵��� ���´�.
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
