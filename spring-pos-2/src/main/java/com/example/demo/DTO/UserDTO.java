package com.example.demo.DTO;

public class UserDTO {
	private int userNo;
	private String userName;
	private String userId;
	private String userPw;
	private String userPosition;
	private boolean userBanned;
	private String userCreationDate;
	private String userUniqueNumber;
	
	public UserDTO() {
		
	}
	public UserDTO(int userNo, String userName, String userId, String userPw, String userPosition, boolean userBanned,
			String userCreationDate,String userUniqueNumber) {
		super();
		this.userNo = userNo;
		this.userName = userName;
		this.userId = userId;
		this.userPw = userPw;
		this.userPosition = userPosition;
		this.userBanned = userBanned;
		this.userCreationDate = userCreationDate;
		this.userUniqueNumber = userUniqueNumber;
	}
	public UserDTO(String userName, String userId, String userPw,boolean userBanned,String userCreationDate) {
		this.userName = userName;
		this.userId = userId;
		this.userPw = userPw;
		this.userBanned = userBanned;
		this.userCreationDate = userCreationDate;
	}
	public UserDTO(String userName, String userId, String userPw, String userPosition, Boolean userBanned) {
		this.userName = userName;
		this.userId = userId;
		this.userPw = userPw;
		this.userPosition = userPosition;
		this.userBanned = userBanned;
	}
	
	
	public int getUserNo() {
		return userNo;
	}
	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public String getUserPosition() {
		return userPosition;
	}
	public void setUserPosition(String userPosition) {
		this.userPosition = userPosition;
	}
	public boolean isUserBanned() {
		return userBanned;
	}
	public void setUserBanned(boolean userBanned) {
		this.userBanned = userBanned;
	}
	public String getUserCreationDate() {
		return userCreationDate;
	}
	public void setUserCreationDate(String userCreationDate) {
		this.userCreationDate = userCreationDate;
	}
	public String getUserUniqueNumber() {
		return userUniqueNumber;
	}
	public void setUserUniqueNumber(String userUniqueNumber) {
		this.userUniqueNumber = userUniqueNumber;
	}
	
	
	
	

}
