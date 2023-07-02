package com.example.demo.Manager;

import java.util.List;

import com.example.demo.DAO.UserDAO;
import com.example.demo.DTO.UserDTO;

public class UserManager {

	private UserDAO userDAO;
	
	public UserManager(UserDAO userDAO) {
		this.userDAO = userDAO;		
	}
	
	public List<UserDTO> getUsers(String sortCriteria, String sortOrder, String searchCriteria, String searchKeyword,String banned) {
		if(banned.equals("")) {
			return userDAO.getUsers(sortCriteria,sortOrder,searchCriteria,searchKeyword,null);
		}else {
			return userDAO.getUsers(sortCriteria,sortOrder,searchCriteria,searchKeyword,Boolean.parseBoolean(banned));
		}
		
		
	}
	public UserDTO getUserByIdPw(String id,String pw) {
		return userDAO.getUserByIdPw(id, pw);
	}
	
	public UserDTO getUserId(String id) {
		return userDAO.getUserId(id);
	}
	
	public void insertUser(UserDTO userDTO) {
		userDAO.insertUser(userDTO);
	}

	public UserDTO getUserByNo(int userNo) {
		return userDAO.getUserByNo(userNo);
	}

	public void updateUser(UserDTO userDTO) {
		userDAO.updateUser(userDTO);
	}

	public void deleteUser(int userNo) {
		userDAO.deleteUser(userNo);
		
	}

	public String findId(String userName, String userUniqueNumber) {
		String idString = userDAO.findId(userName,userUniqueNumber);
		if(idString == null) idString = "�����ϴ� ���̵� ����";
		else idString = "������ ��ġ�ϴ� ���̵�� " + idString + " �Դϴ�.";
		return idString;
	}
	
	public String findPw(String userName, String userId ,String userUniqueNumber) {
		String pwString = userDAO.findPw(userName,userId,userUniqueNumber);
		if(pwString == null) pwString = "�����ϴ� ��й�ȣ ����"; 
		else pwString = "������ ��ġ�ϴ� ��й�ȣ�� " + pwString + " �Դϴ�.";
		return pwString;
	}
}
