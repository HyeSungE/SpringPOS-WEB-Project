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
		return "제품을 성공적으로 추가했습니다  \\n[ 제품 이름 : " + productDTO.getProductName() + " ] \\\n [ 제품 가격 : " + productDTO.getProductPrice() + " ]";
	}

	public ProductDTO getProductByNo(int productNo) {
		return productDAO.getProductByProductNo(productNo);
	}

	public String deleteProduct(int productNo) {
		productDAO.deleteProduct(productNo);
		return "제품을 성공적으로 삭제했습니다.";
	}

	public String updateProduct(ProductDTO productDTO) {
		productDAO.updateProduct(productDTO);
		return "제품을 성공적으로 수정했습니다.";
	}

	public void updateReceiving(int productNo, String receivingSuccessDate, int receivingQuantity) {
		productDAO.updateReceiving(productNo, receivingSuccessDate,receivingQuantity);
	}

}
