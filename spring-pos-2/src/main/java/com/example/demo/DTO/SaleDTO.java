package com.example.demo.DTO;

import java.util.List;

public class SaleDTO {
	private int saleNo;
	private String saleDate;
	private List<SaleProduct> saleProducts;
	private int saleTotalPrice;
	private int saleReceived;
	private int saleChanged;
	private String saleCanceled;
	
	public SaleDTO(int saleNo, String saleDate, List<SaleProduct> saleProducts, int saleTotalPrice, int saleReceived,
			int saleChanged,String saleCanceled) {
		super();
		this.saleNo = saleNo;
		this.saleDate = saleDate;
		this.saleProducts = saleProducts;
		this.saleTotalPrice = saleTotalPrice;
		this.saleReceived = saleReceived;
		this.saleChanged = saleChanged;
		this.saleCanceled = saleCanceled;
	}
	public int getSaleNo() {
		return saleNo;
	}
	public void setSaleNo(int saleNo) {
		this.saleNo = saleNo;
	}
	public String getSaleDate() {
		return saleDate;
	}
	public void setSaleDate(String saleDate) {
		this.saleDate = saleDate;
	}
	public List<SaleProduct> getSaleProducts() {
		return saleProducts;
	}
	public void setSaleProducts(List<SaleProduct> saleProducts) {
		this.saleProducts = saleProducts;
	}
	public int getSaleTotalPrice() {
		return saleTotalPrice;
	}
	public void setSaleTotalPrice(int saleTotalPrice) {
		this.saleTotalPrice = saleTotalPrice;
	}
	public int getSaleReceived() {
		return saleReceived;
	}
	public void setSaleReceived(int saleReceived) {
		this.saleReceived = saleReceived;
	}
	public int getSaleChanged() {
		return saleChanged;
	}
	public void setSaleChanged(int saleChanged) {
		this.saleChanged = saleChanged;
	}
	public String getSaleCanceled() {
		return saleCanceled;
	}
	public void setSaleCanceled(String saleCanceled) {
		this.saleCanceled = saleCanceled;
	}
	

}
