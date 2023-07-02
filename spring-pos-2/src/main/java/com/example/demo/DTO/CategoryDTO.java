package com.example.demo.DTO;

public class CategoryDTO {
    private int categoryNo;
    private String categoryCode;
    private String categoryName;

    public CategoryDTO() {
    }

	public CategoryDTO(int categoryNo, String categoryCode, String categoryName) {
		super();
		this.categoryNo = categoryNo;
		this.categoryCode = categoryCode;
		this.categoryName = categoryName;
	}

	public CategoryDTO(String categoryCode, String categoryName) {
		this.categoryCode = categoryCode;
		this.categoryName = categoryName;
	}

	public int getCategoryNo() {
		return categoryNo;
	}

	public void setCategoryNo(int categoryNo) {
		this.categoryNo = categoryNo;
	}

	public String getCategoryCode() {
		return categoryCode;
	}

	public void setCategoryCode(String categoryCode) {
		this.categoryCode = categoryCode;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

   
}
