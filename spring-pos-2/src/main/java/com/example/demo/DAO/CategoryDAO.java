package com.example.demo.DAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import com.example.demo.DTO.CategoryDTO;

public class CategoryDAO {
    private JdbcTemplate jdbcTemplate;

    public CategoryDAO(DataSource dataSource) {
        this.jdbcTemplate =new JdbcTemplate(dataSource);
    }

    public List<CategoryDTO> getAllCategories() {
        String query = "SELECT * FROM category_table";
        return jdbcTemplate.query(query, new CategoryRowMapper());
    }

    public CategoryDTO getCategoryByNo(int categoryNo) {
        String query = "SELECT * FROM category_table WHERE categoryNo = ?";
        return jdbcTemplate.queryForObject(query, CategoryDTO.class,categoryNo);
    }
    public CategoryDTO getCategoryByCode(String categoryCode) {
        String query = "SELECT * FROM category_table WHERE categoryCode = ?";
        try {
            return jdbcTemplate.queryForObject(query, new CategoryRowMapper(), categoryCode);
        } catch (EmptyResultDataAccessException e) {
            return null; // 카테고리가 존재하지 않는 경우 null 반환
        }
    }

    public void addCategory(CategoryDTO category) {
        String query = "INSERT INTO category_table (categoryCode, categoryName) VALUES (?, ?)";
        jdbcTemplate.update(query, category.getCategoryCode(), category.getCategoryName());
    }

    public void updateCategory(CategoryDTO category) {
        String query = "UPDATE category_table SET categoryCode = ?, categoryName = ? WHERE categoryNo = ?";
        jdbcTemplate.update(query, category.getCategoryCode(), category.getCategoryName(), category.getCategoryNo());
    }

    public void deleteCategory(int categoryNo) {
        String query = "DELETE FROM category_table WHERE categoryNo = ?";
        jdbcTemplate.update(query, categoryNo);
    }
    public class CategoryRowMapper implements RowMapper<CategoryDTO> {

        @Override
        public CategoryDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
            int categoryNo = rs.getInt("categoryNo");
            String categoryCode = rs.getString("categoryCode");
            String categoryName = rs.getString("categoryName");
            return new CategoryDTO(categoryNo, categoryCode, categoryName);
        }
    }
}
