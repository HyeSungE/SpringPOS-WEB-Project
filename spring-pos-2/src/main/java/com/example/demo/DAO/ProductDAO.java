package com.example.demo.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import com.example.demo.DTO.CategoryDTO;
import com.example.demo.DTO.ProductDTO;

public class ProductDAO {
	private JdbcTemplate jdbcTemplate;
	private CategoryDAO categoryDAO;

	public ProductDAO(DataSource dataSource, CategoryDAO categoryDAO) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
		this.categoryDAO = categoryDAO;
	}

	public void deleteProduct(int productNo) {
        String query = "DELETE FROM product_table WHERE productNo = ?";
        jdbcTemplate.update(query, productNo);
    }
	
	public ProductDTO getProductByProductNo(int productNo) {
	    String query = "SELECT p.*, c.* FROM product_table p LEFT JOIN category_table c ON p.categoryNo = c.categoryNo WHERE p.productNo = ?";
	    return jdbcTemplate.queryForObject(query, new ProductRowMapper(), productNo);
	}
	public List<ProductDTO> getProductListByCategory(int categoryNo) {
		 String query = "SELECT p.*, c.* FROM product_table p LEFT JOIN category_table c ON p.categoryNo = c.categoryNo WHERE p.categoryNo = ? order by p.productCode asc";
		 return jdbcTemplate.query(query, new ProductRowMapper(), categoryNo);
	}
	public boolean insertProduct(ProductDTO product) {
		String query = "INSERT INTO product_table (categoryNo, productCode, productName, productPrice, productStock, productCreationDate, productRecentReceivingDate) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?)";

		try {
			int categoryNo = product.getCategoryDTO().getCategoryNo();
			String productName = product.getProductName();
			int productPrice = product.getProductPrice();
			int productStock = 0;
			Date productCreationDate = new Date();
			Date productRecentReceivingDate = null;

			KeyHolder keyHolder = new GeneratedKeyHolder();
			jdbcTemplate.update(new PreparedStatementCreator() {
				@Override
				public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
					PreparedStatement pstmt = con.prepareStatement(query, new String[] { "productNo" });
					pstmt.setInt(1, categoryNo);
					pstmt.setString(2, ""); 
					pstmt.setString(3, productName);
					pstmt.setInt(4, productPrice);
					pstmt.setInt(5, productStock);
					pstmt.setDate(6, new java.sql.Date(productCreationDate.getTime()));
					pstmt.setNull(7, java.sql.Types.DATE);
					return pstmt;
				}
			}, keyHolder);

			int productNo = keyHolder.getKey().intValue();
			String productCode = product.getCategoryDTO().getCategoryCode() + "-" +  productNo;

			updateProductCode(productNo, productCode);

			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	

	private void updateProductCode(int productNo, String productCode) {
		String updateQuery = "UPDATE product_table SET productCode = ? WHERE productNo = ?";

		jdbcTemplate.update(updateQuery, productCode, productNo);
	}

	public void updateReceiving(int productNo, String receivingSuccessDate, int receivingQuantity) {
		String updateQuery = "UPDATE product_table SET productRecentReceivingDate = ? , productStock = productStock + ? WHERE productNo = ?";

		jdbcTemplate.update(updateQuery, receivingSuccessDate,receivingQuantity, productNo);
	}
	

	public void updateProduct(ProductDTO productDTO) {
		String updateQuery = "UPDATE product_table SET product_table.categoryNo = ? , productCode = ? , productName = ? , productPrice = ? , productStock = ? WHERE productNo = ?";

		jdbcTemplate.update(updateQuery, productDTO.getCategoryDTO().getCategoryNo(), productDTO.getProductCode(),productDTO.getProductName()
				,productDTO.getProductPrice(),productDTO.getProductStock(),productDTO.getProductNo());
	}

	public int getTotalItemCount() {
		Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM product_table", Integer.class);
		return count;
	}

	public List<ProductDTO> getProducts(String sortCriteria, String sortOrder, String searchCriteria, String searchKeyword,String status) {
		String sortTableName ="p";
		String searchTableName ="p";
		if(sortCriteria.contains("category")) sortTableName="c";
		if(searchCriteria.contains("category")) searchTableName="c";
		
		String query = "SELECT p.* , c.* FROM product_table p LEFT JOIN category_table c ON p.categoryNo = c.categoryNo";
		if(status!=null && status.equals("onStock")) query += " WHERE p.productStock > 0";
		else if(status!=null && status.equals("offStock")) query += " WHERE p.productStock <= 0";
		String orderQuery = " ORDER BY " + sortTableName + "." + sortCriteria + " " + sortOrder;

		if (searchCriteria != null && !searchCriteria.isEmpty() && searchKeyword != null && !searchKeyword.isEmpty()) {
			if(status!=null && !status.equals("")) query += " AND "; 
			else query += " WHERE "; 
			String searchQuery = searchTableName + "." + searchCriteria + " LIKE '%" + searchKeyword + "%'";
			query += searchQuery + orderQuery;
		} else {
			query += orderQuery;
		}
		return jdbcTemplate.query(query, new ProductRowMapper());
	}

	public List<ProductDTO> getStockItems(int page, int pageSize) {
		int offset = (page - 1) * pageSize;
		String query = "SELECT p.* , c.* FROM product_table p LEFT JOIN category_table c ON p.categoryNo = c.categoryNo LIMIT ?, ?";

		return jdbcTemplate.query(query, new ProductRowMapper(), offset, pageSize);
	}

	public String getNameByProductCode(String productCode) {
	    String sql = "SELECT productName FROM product_table WHERE productCode = ?";
	    List<String> names = jdbcTemplate.query(sql, new Object[]{productCode}, (rs, rowNum) -> rs.getString("productName"));

	    if (names.isEmpty()) {
	        return "";
	    } else {
	        return names.get(0);
	    }
	}



	public class ProductRowMapper implements RowMapper<ProductDTO> {

		public ProductDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
			int categoryNo = rs.getInt("categoryNo");
			String categoryCode = rs.getString("categoryCode");
			String categoryName = rs.getString("categoryName");

			CategoryDTO category = new CategoryDTO(categoryNo, categoryCode, categoryName);

			ProductDTO product = new ProductDTO(rs.getInt("productNo"), category, rs.getString("productCode"),
					rs.getString("productName"), rs.getInt("productPrice"), rs.getInt("productStock"),
					rs.getString("productCreationDate"), rs.getString("productRecentReceivingDate"));

			return product;
		}
	}






}
