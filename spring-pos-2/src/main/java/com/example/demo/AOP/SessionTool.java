package com.example.demo.AOP;

import com.example.demo.AOP.LoginCheck.UserType;

import jakarta.servlet.http.HttpSession;

public class SessionTool {
    /*
     * ���� ���ǿ� ����� ���̵� ������ �ش� Ÿ���� Ű�� �����Ѵ�
     */
    private SessionTool() {
    }
	public static void setLoginId(HttpSession session, String userPosition, String id) {
		session.setAttribute(userPosition, id);
	}
	public static String getLoginId(HttpSession session, UserType[] userTypes) {
	    for (UserType userType : userTypes) {
	        String loginId = (String) session.getAttribute(userType.toString());
	        if (loginId != null) {
	            return loginId;
	        }
	    }
	    return null;
	}

 
}