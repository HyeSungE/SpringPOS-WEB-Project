package com.example.demo.DTO;

public class ReceivingDTO {
	private int receivingNo;
	private ProductDTO productDTO;
	private int receivingQuantity;
	private String receivingDate;
	private String receivingStartDate;
	private String receivingSuccessDate;
	
	
	public ReceivingDTO(int receivingNo, ProductDTO productDTO, int receivingQuantity, String receivingDate, String receivingStartDate,String receivingSuccessDate) {
		super();
		this.receivingNo = receivingNo;
		this.productDTO = productDTO;
		this.receivingQuantity = receivingQuantity;
		this.receivingDate = receivingDate;
		this.receivingStartDate = receivingStartDate;
		this.receivingSuccessDate = receivingSuccessDate;
	}
	public ReceivingDTO( ProductDTO productDTO,int receivingQuantity, String receivingDate, String receivingStartDate) {
		this.productDTO = productDTO;
		this.receivingQuantity = receivingQuantity;
		this.receivingDate = receivingDate;
		this.receivingStartDate = receivingStartDate;
	}
	public int getReceivingNo() {
		return receivingNo;
	}
	public void setReceivingNo(int receivingNo) {
		this.receivingNo = receivingNo;
	}

	public ProductDTO getProductDTO() {
		return productDTO;
	}
	public void setProductDTO(ProductDTO productDTO) {
		this.productDTO = productDTO;
	}
	public int getReceivingQuantity() {
		return receivingQuantity;
	}
	public void setReceivingQuantity(int receivingQuantity) {
		this.receivingQuantity = receivingQuantity;
	}
	public String getReceivingDate() {
		return receivingDate;
	}
	public void setReceivingDate(String receivingDate) {
		this.receivingDate = receivingDate;
	}
	public String getReceivingStartDate() {
		return receivingStartDate;
	}
	public void getReceivingStartDate(String receivingStartDate) {
		this.receivingStartDate = receivingStartDate;
	}
	public String getReceivingSuccessDate() {
		return receivingSuccessDate;
	}
	public void setReceivingSuccessDate(String receivingSuccessDate) {
		this.receivingSuccessDate = receivingSuccessDate;
	}
	public void setReceivingStartDate(String receivingStartDate) {
		this.receivingStartDate = receivingStartDate;
	}

}
