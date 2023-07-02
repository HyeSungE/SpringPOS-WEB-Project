package com.example.demo.Manager;

import java.util.List;

import com.example.demo.DAO.ReceivingDAO;
import com.example.demo.DTO.ReceivingDTO;

public class ReceivingManager {

	private ReceivingDAO receivingDAO;

	public ReceivingManager(ReceivingDAO receivingDAO) {
		this.receivingDAO = receivingDAO;
	}

	public List<ReceivingDTO> getReceivings(String sortCriteria, String sortOrder, String searchCriteria,
			String searchKeyword,String status) {
		return receivingDAO.getReceivings(sortCriteria, sortOrder, searchCriteria, searchKeyword,status);
	}
	
	public ReceivingDTO getReceivingByNo(int receivingNo) {
		return receivingDAO.getReceivingByReceivingNo(receivingNo);
		
	}
	public String getRecentReceiving(int receivingNo) {
		return receivingDAO.getRecentReceiving(receivingNo);
		
	}
	public String insertReceiving(ReceivingDTO receivingDTO){
		receivingDAO.insertReceiving(receivingDTO);
		return "�԰� ��û�� �Ϸ��߽��ϴ�.";
	}
	public String deleteReceiving(int receivingNo){
		receivingDAO.deleteReceiving(receivingNo);
		return "�԰� ��û�� ���������� ����߽��ϴ�.";
	}
	public String updateReceiving(int receivingNo,int receivingQuantity,String receivingDate){
		receivingDAO.updateReceiving(receivingNo,receivingQuantity,receivingDate);
		return "�԰� ��û�� ���������� �����߽��ϴ�.";
	}

	public void updateReceiving(int receivingNo, String now) {
		receivingDAO.updateReceiving(receivingNo,now);
	}

	
}
