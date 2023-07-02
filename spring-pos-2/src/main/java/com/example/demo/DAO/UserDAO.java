package com.example.demo.DAO;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Random;

import javax.sql.DataSource;

import org.springframework.dao.IncorrectResultSizeDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import com.example.demo.DTO.UserDTO;

public class UserDAO {

	private JdbcTemplate jdbcTemplate;

	public UserDAO(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	public List<UserDTO> getUsers(String sortCriteria, String sortOrder, String searchCriteria, String searchKeyword,Boolean banned) {
		String orderQuery = " ORDER BY " +  sortCriteria + " " + sortOrder;
		String searchQuery = searchCriteria + " LIKE '%" + searchKeyword + "%'";
		String bannedQuery = " userBanned="+banned;
		
		String query = "SELECT * FROM user_table WHERE userPosition<> 'admin'";
		if(banned!=null) query += " AND "+bannedQuery;
	
		if (searchCriteria != null && !searchCriteria.isEmpty() && searchKeyword != null && !searchKeyword.isEmpty()) {
			if(banned!=null) query += " AND " + searchQuery + orderQuery;
			else query += " AND " + searchQuery + orderQuery;
		} else {
			query += orderQuery;
		}
		return jdbcTemplate.query(query, new UserRowMapper());
	}
	

	public UserDTO getUserByIdPw(String id, String pw) {
		String sql = "select * from user_table where userId = ? and userPw = ?";
		List<UserDTO> results = jdbcTemplate.query(sql, new UserRowMapper(), id,pw);
		return results.isEmpty() ? null : results.get(0);

	}
	
	public UserDTO getUserId(String id) {
		String sql = "select * from user_table where userId= ?";
		List<UserDTO> results = jdbcTemplate.query(sql, new UserRowMapper(), id);
		return results.isEmpty() ? null : results.get(0);

	}

	public void insertUser(UserDTO user) {
	    String sql = "INSERT INTO user_table (userName, userId, userPw, userPosition, userBanned, userCreationDate, userUniqueNumber) VALUES (?, ?, ?, ?, ?, ?, ?)";
	    //고유 번호 생성 (가입일 + 두 자리 랜덤 숫자 + 초)
	    LocalDateTime now = LocalDateTime.now();
	    Random random = new Random();
	    int randomTwoDigitNumber = random.nextInt(100);
	    int second = now.getSecond();
	    String userUniqueNumber = String.format("%02d%s", randomTwoDigitNumber, second);
	    userUniqueNumber = now.format(DateTimeFormatter.ofPattern("yyyyMMdd")) + userUniqueNumber;
	    
	    
	    jdbcTemplate.update(sql, user.getUserName(), user.getUserId(), user.getUserPw(), user.getUserPosition(),
	            user.isUserBanned(), user.getUserCreationDate(), userUniqueNumber);
	}
	public UserDTO getUserByNo(int userNo) {
		String sql = "select * from user_table where userNo= ?";
		return jdbcTemplate.queryForObject(sql, new UserRowMapper(), userNo);
	}
	
	public void updateUser(UserDTO userDTO) {
	    String sql = "UPDATE user_table SET userName = ?, userId = ?, userPw = ?, userPosition = ?, userBanned = ? WHERE userNo = ?";
	    jdbcTemplate.update(sql, userDTO.getUserName(), userDTO.getUserId(), userDTO.getUserPw(),
	            userDTO.getUserPosition(), userDTO.isUserBanned(), userDTO.getUserNo());
	}
	public void deleteUser(int userNo) {
		 String query = "DELETE FROM user_table WHERE userNo = ?";
	        jdbcTemplate.update(query, userNo);
		
	}
	
	public String findId(String userName, String userUniqueNumber) {
		try {
			String sql = "select userId from user_table where userName = ? AND userUniqueNumber = ?";
			return jdbcTemplate.queryForObject(sql, String.class, userName, userUniqueNumber);
		} catch (IncorrectResultSizeDataAccessException error) { 
			return null;
		}
	}
	
	public String findPw(String userName, String userId, String userUniqueNumber) {
		try {
			String sql = "select userPw from user_table where userName = ? AND userId = ? AND userUniqueNumber = ?";
			return jdbcTemplate.queryForObject(sql, String.class, userName,userId,userUniqueNumber);
		} catch (IncorrectResultSizeDataAccessException error) { 
			return null;
		}
	}

	public class UserRowMapper implements RowMapper<UserDTO> {
		public UserDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
			UserDTO user = new UserDTO(rs.getInt("userNo"),
					rs.getString("userName"),
					rs.getString("userId"), 
					rs.getString("userPw"),
					rs.getString("userPosition"),
					rs.getBoolean("userBanned"),
					rs.getString("userCreationDate"),
					rs.getString("userUniqueNumber"));
			return user;
		}
	}






}
