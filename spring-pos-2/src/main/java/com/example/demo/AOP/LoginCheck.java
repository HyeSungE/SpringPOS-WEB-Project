package com.example.demo.AOP;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD) //��� ������̼��� ������ �� Ÿ���� ���Ѵ�.
public @interface LoginCheck {
	/*
	 * ���� �Ŵ��� �������� �α��� Ÿ�� ����
	 */
    public static enum UserType {
        staff, manager, admin 
    }

    UserType[] type();
}
