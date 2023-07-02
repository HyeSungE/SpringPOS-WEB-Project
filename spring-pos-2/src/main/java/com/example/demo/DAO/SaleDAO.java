package com.example.demo.DAO;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import com.example.demo.DTO.SaleDTO;
import com.example.demo.DTO.SaleProduct;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class SaleDAO {

	private JdbcTemplate jdbcTemplate;

	public SaleDAO(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	public String insertSale(SaleDTO saleDTO) {
	    String saleProductsString = new Gson().toJson(saleDTO.getSaleProducts());
	    String sql = "INSERT INTO sale_table (saleDate, saleProducts, saleTotalPrice, saleReceived, saleChanged) VALUES (?, ?, ?, ?, ?)";
	    jdbcTemplate.update(
	            sql,
	            saleDTO.getSaleDate(),
	            saleProductsString,
	            saleDTO.getSaleTotalPrice(),
	            saleDTO.getSaleReceived(),
	            saleDTO.getSaleChanged()
	    );

	    for (SaleProduct saleProduct : saleDTO.getSaleProducts()) {
	        String productCode = saleProduct.getProductCode();
	        int quantitySold = saleProduct.getQuantity();
	        jdbcTemplate.update("UPDATE product_table SET productStock = productStock - ? WHERE productCode = ?",quantitySold,productCode);
	    }
	    
	    return "Success";
	}

	public List<SaleDTO> getSaleLog(String sortCriteria, String sortOrder, String searchCriteria, String searchKeyword) {
		String query = "SELECT * FROM sale_table";
		String orderQuery = " ORDER BY " +  sortCriteria + " " + sortOrder;

		if (searchCriteria != null && !searchCriteria.isEmpty() && searchKeyword != null && !searchKeyword.isEmpty()) {
			String searchQuery = " WHERE " + searchCriteria + " LIKE '%" + searchKeyword + "%'";
			query += searchQuery + orderQuery;
		} else {
			query += orderQuery;
		}
		return jdbcTemplate.query(query, new SaleRowMapper());
	}
	
	public List<SaleDTO> getTodaySaleLog(String today) {
	    String query = "SELECT * FROM sale_table WHERE DATE(saleDate) = ? AND saleCanceled IS NULL";
	    return jdbcTemplate.query(query, new SaleRowMapper(), today);
	}

	public List<SaleDTO> getDaysSaleLog(String startDay, String endDay) {
	    String sql = "SELECT * FROM sale_table WHERE DATE(saleDate) BETWEEN DATE(?) AND DATE(?) AND saleCanceled IS NULL";
	    return jdbcTemplate.query(sql, new SaleRowMapper(), startDay, endDay);
	}
	public SaleDTO getSaleByNo(int saleNo) {
	    String sql = "SELECT * FROM sale_table WHERE saleNo = ?";
	    return jdbcTemplate.queryForObject(sql, new SaleRowMapper(), saleNo);
	}
	public String cancelSale(int saleNo) {
	    String sql = "UPDATE sale_table SET saleCanceled = CURRENT_TIMESTAMP WHERE saleNo = ? AND saleCanceled IS NULL";
	    int row = jdbcTemplate.update(sql, saleNo);
	    if(row  == 0 ) {
	    	return "이미 취소된 거래입니다 !";
	    }else {
	    	 SaleDTO saleDTO = getSaleByNo(saleNo);
	  	    for (SaleProduct saleProduct : saleDTO.getSaleProducts()) {
	  	        String productCode = saleProduct.getProductCode();
	  	        int quantitySold = saleProduct.getQuantity();
	  	        jdbcTemplate.update("UPDATE product_table SET productStock = productStock + ? WHERE productCode = ?",quantitySold,productCode);
	  	    }
	  	  return "거래가 취소되었습니다.";
	    }

	   
	}


	
	 
	 
	
	public class SaleRowMapper implements RowMapper<SaleDTO> {
		public SaleDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
			String saleProductsString = rs.getString("saleProducts");
			List<SaleProduct> saleProducts = new Gson().fromJson(saleProductsString, new TypeToken<List<SaleProduct>>() {}.getType());
			SaleDTO sale = new SaleDTO(
					rs.getInt("saleNo"),
					rs.getString("saleDate"),
					saleProducts, 
					rs.getInt("saleTotalPrice"),
					rs.getInt("saleReceived"),
					rs.getInt("saleChanged"),
					rs.getString("saleCanceled"));
			return sale;
		}
	}

}
