package com.example.demo.DTO;

public class ProductDTO {
	private int productNo;
	private CategoryDTO categoryDTO;
	private String productCode;
	private String productName;
	private int productPrice;
	private int productStock;
	private String productCreationDate;
	private String productRecentReceivingDate;
	
	public ProductDTO() {
		
	}

	
	
	public ProductDTO(int productNo, CategoryDTO categoryDTO, String productCode, String productName, int productPrice,
			int productStock, String productCreationDate,String productRecentReceivingDate) {
		super();
		this.productNo = productNo;
		this.categoryDTO = categoryDTO;
		this.productCode = productCode;
		this.productName = productName;
		this.productPrice = productPrice;
		this.productStock = productStock;
		this.productCreationDate = productCreationDate;
		this.productRecentReceivingDate = productRecentReceivingDate;
		
	}



	public ProductDTO(CategoryDTO categoryDTO, String productName, int productPrice) {
		this.categoryDTO = categoryDTO;
		this.productName = productName;
		this.productPrice = productPrice;
	}



	public int getProductNo() {
		return productNo;
	}

	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}

	public CategoryDTO getCategoryDTO() {
		return categoryDTO;
	}

	public void setCategoryDTO(CategoryDTO categoryDTO) {
		this.categoryDTO = categoryDTO;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public int getProductPrice() {
		return productPrice;
	}

	public void setProductPrice(int productPrice) {
		this.productPrice = productPrice;
	}

	public int getProductStock() {
		return productStock;
	}

	public void setProductStock(int productStock) {
		this.productStock = productStock;
	}

	public String getProductCreationDate() {
		return productCreationDate;
	}

	public void setProductCreationDate(String productCreationDate) {
		this.productCreationDate = productCreationDate;
	}



	public String getProductRecentReceivingDate() {
		return productRecentReceivingDate;
	}



	public void setProductRecentReceivingDate(String productRecentReceivingDate) {
		this.productRecentReceivingDate = productRecentReceivingDate;
	}



}
