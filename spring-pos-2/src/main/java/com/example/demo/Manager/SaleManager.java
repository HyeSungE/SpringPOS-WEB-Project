package com.example.demo.Manager;

import java.util.List;

import com.example.demo.DAO.SaleDAO;
import com.example.demo.DTO.SaleDTO;

public class SaleManager {
	
	private SaleDAO saleDAO;
	public SaleManager(SaleDAO saleDAO) {
		this.saleDAO = saleDAO;
	}
	
	public void insertSale(SaleDTO saleDTO) {
		saleDAO.insertSale(saleDTO);
	}

	public List<SaleDTO> getSaleLog(String sortCriteria, String sortOrder, String searchCriteria, String searchKeyword) {
		return saleDAO.getSaleLog(sortCriteria,sortOrder,searchCriteria,searchKeyword);
	}

	public List<SaleDTO> getTodaySaleLog(String today) {
		return saleDAO.getTodaySaleLog(today);
	}
	public List<SaleDTO> getDaysSaleLog(String startDay, String endDay) {
		return saleDAO.getDaysSaleLog(startDay,endDay);
	}

	public SaleDTO getSaleByNo(int saleNo) {
		return saleDAO.getSaleByNo(saleNo);
	}
	public String cancelSale(int saleNo) {
		return saleDAO.cancelSale(saleNo);
	}

}
