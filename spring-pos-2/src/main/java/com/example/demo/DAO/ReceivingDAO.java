package com.example.demo.DAO;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import com.example.demo.DTO.ProductDTO;
import com.example.demo.DTO.ReceivingDTO;

public class ReceivingDAO {
	private JdbcTemplate jdbcTemplate;
	private ProductDAO productDAO;
	private CategoryDAO categoryDAO;

	public ReceivingDAO(DataSource dataSource, ProductDAO productDAO, CategoryDAO categoryDAO) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
		this.productDAO = productDAO;
		this.categoryDAO = categoryDAO;
	}

	public void insertReceiving(ReceivingDTO receivingDTO) {
		String sql = "INSERT INTO receiving_table (productNo, receivingQuantity, receivingDate, receivingStartDate) VALUES (?, ?, ?, ?)";
		jdbcTemplate.update(sql, receivingDTO.getProductDTO().getProductNo(), receivingDTO.getReceivingQuantity(),
				receivingDTO.getReceivingDate(), receivingDTO.getReceivingStartDate());
	}
	public void deleteReceiving(int receivingNo) {
	    String sql = "DELETE FROM receiving_table WHERE receivingNo = ?";
	    jdbcTemplate.update(sql, receivingNo);
	}

	public void updateReceiving(int receivingNo, int receivingQuantity, String receivingDate) {
	    String sql = "UPDATE receiving_table SET receivingQuantity = ?, receivingDate = ? WHERE receivingNo = ?";
	    jdbcTemplate.update(sql, receivingQuantity, receivingDate, receivingNo);
	}
	public void updateReceiving(int receivingNo, String now) {
		 String sql = "UPDATE receiving_table SET receivingSuccessDate = ? WHERE receivingNo = ?";
		    jdbcTemplate.update(sql, now, receivingNo);
	}

	public String getRecentReceiving(int productNo) {
		String sql = "SELECT MAX(receivingSuccessDate) FROM receiving_table WHERE productNo = ?";
		return jdbcTemplate.queryForObject(sql, String.class, productNo);
	}

	public List<ReceivingDTO> getReceivings(String sortCriteria, String sortOrder, String searchCriteria, String searchKeyword,String status) {
		String sortTableName ="r";
		String searchTableName ="r";
		if(sortCriteria.contains("product")) sortTableName="p";
		if(searchCriteria.contains("product")) searchTableName="p";
			
		String query = "SELECT r.*, p.* FROM receiving_table r LEFT JOIN product_table p ON r.productNo = p.productNo";
		if(status!=null && status.equals("ongoing")) query += " WHERE r.receivingSuccessDate IS NULL";
		else if(status!=null && status.equals("success")) query += " WHERE r.receivingSuccessDate IS NOT NULL";
		
		String orderQuery = " ORDER BY "+ sortTableName +"." + sortCriteria + " " + sortOrder;
		if (searchCriteria != null && !searchCriteria.isEmpty() && searchKeyword != null && !searchKeyword.isEmpty()) {
			if(status!=null && !status.equals("")) query += " AND "; 
			else query += " WHERE "; 
			String searchQuery = searchTableName + "." + searchCriteria + " LIKE '%" + searchKeyword + "%'";
			query += searchQuery + orderQuery;
		} else {
			query += orderQuery;
		}
		return jdbcTemplate.query(query, new ReceivingRowMapper());
	}

	

	public ReceivingDTO getReceivingByReceivingNo(int receivingNo) {
	    String query = "SELECT r.*, p.* FROM receiving_table r LEFT JOIN product_table p ON r.productNo = p.productNo WHERE r.receivingNo = ?";
	    return jdbcTemplate.queryForObject(query, new ReceivingRowMapper(), receivingNo);
	}

	public class ReceivingRowMapper implements RowMapper<ReceivingDTO> {

		public ReceivingDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
			int productNo = rs.getInt("productNO");
			ProductDTO productDTO = productDAO.getProductByProductNo(productNo);
			

			ProductDTO product = new ProductDTO(rs.getInt("productNo"), productDTO.getCategoryDTO(), rs.getString("productCode"),
					rs.getString("productName"), rs.getInt("productPrice"), rs.getInt("productStock"),
					rs.getString("productCreationDate"), rs.getString("productRecentReceivingDate"));

			ReceivingDTO receiving = new ReceivingDTO(rs.getInt("receivingNo"), product, rs.getInt("receivingQuantity"),
					rs.getString("receivingDate"), rs.getString("receivingStartDate"),rs.getString("receivingSuccessDate"));
			return receiving;
		}
	}

	

}
