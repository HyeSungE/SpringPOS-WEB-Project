package com.example.demo.Manager;

import java.util.List;

import com.example.demo.DAO.ProductDAO;
import com.example.demo.DTO.ProductDTO;

public class ProductManager {

	private ProductDAO productDAO;
	
	public ProductManager(ProductDAO productDAO) {
		this.productDAO = productDAO;		
	}

	public List<ProductDTO> getProductList(String sortCriteria, String sortOrder, String searchCriteria,
			String searchKeyword,String status) {
		return productDAO.getProducts(sortCriteria, sortOrder, searchCriteria, searchKeyword,status);
	}
	
	public List<ProductDTO> getProductListByCategory(int categoryNo) {
		return productDAO.getProductListByCategory(categoryNo);
	}


	public String getNameByProductCode(String productCode) {
		return productDAO.getNameByProductCode(productCode);
	}
	
	public String insertProduct(ProductDTO productDTO) {
		productDAO.insertProduct(productDTO);
		return "��ǰ�� ���������� �߰��߽��ϴ�  \\n[ ��ǰ �̸� : " + productDTO.getProductName() + " ] \\\n [ ��ǰ ���� : " + productDTO.getProductPrice() + " ]";
	}

	public ProductDTO getProductByNo(int productNo) {
		return productDAO.getProductByProductNo(productNo);
	}

	public String deleteProduct(int productNo) {
		productDAO.deleteProduct(productNo);
		return "��ǰ�� ���������� �����߽��ϴ�.";
	}

	public String updateProduct(ProductDTO productDTO) {
		productDAO.updateProduct(productDTO);
		return "��ǰ�� ���������� �����߽��ϴ�.";
	}

	public void updateReceiving(int productNo, String receivingSuccessDate, int receivingQuantity) {
		productDAO.updateReceiving(productNo, receivingSuccessDate,receivingQuantity);
	}

}
