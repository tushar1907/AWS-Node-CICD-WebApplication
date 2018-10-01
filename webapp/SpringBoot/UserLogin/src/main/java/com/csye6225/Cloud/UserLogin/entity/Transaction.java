package com.csye6225.Cloud.UserLogin.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import java.util.UUID;

import javax.persistence.Column;

@Entity
@Table(name="transaction")
public class Transaction {
	
	@Id
	@GeneratedValue(generator="UUID")
	@GenericGenerator(name = "UUID",strategy = "org.hibernate.id.UUIDGenerator")
	@Column(name = "id", updatable = false, nullable = false)
	private UUID id;
	
	@Column(name="description")
	private String description;
	
	@Column(name="merchant")
	private String merchant;
	
	@Column(name="amount")
	private String amount;
	
	@Column(name="date")
	private String date;
	
	@Column(name="category")
	private String category;
	
	

	public Transaction(String description, String merchant, String amount, String date, String category) {
		super();
		this.description = description;
		this.merchant = merchant;
		this.amount = amount;
		this.date = date;
		this.category = category;
	}
	
	

	public Transaction() {
		
	}



	public UUID getId() {
		return id;
	}

	public void setId(UUID id) {
		this.id = id;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getMerchant() {
		return merchant;
	}

	public void setMerchant(String merchant) {
		this.merchant = merchant;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}
	
	
	
}
