package com.example.demo.Manager;

import java.util.List;

import com.example.demo.DAO.CategoryDAO;
import com.example.demo.DAO.ProductDAO;
import com.example.demo.DTO.CategoryDTO;

public class CategoryManger {
	
	private CategoryDAO categoryDAO;
	private ProductDAO productDAO;
	

	public CategoryManger(CategoryDAO categoryDAO,ProductDAO productDAO) {
		this.categoryDAO = categoryDAO;
		this.productDAO = productDAO;
	}

	public CategoryDTO getCategoryByCode(String categoryCode) {
		return categoryDAO.getCategoryByCode(categoryCode);
		
	}
	
	public List<CategoryDTO> getAllCategories(){
		return categoryDAO.getAllCategories();
	}
	public String addCategory(CategoryDTO categoryDTO) {
		categoryDAO.addCategory(categoryDTO);
		return "ī�װ��� ���������� �߰��߽��ϴ�  \\n[ ī�װ� �̸� : " + categoryDTO.getCategoryName() + " ] \\\n [ ī�װ� �ڵ� : " + categoryDTO.getCategoryCode()
				+ " ]";
		
	}
	
	
	
}
