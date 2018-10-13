package com.csye6225.userTransaction.userTransaction.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.GenericGenerator;

@Entity
public class Transaction {

//	@Id
//	@GeneratedValue(generator = "uuid")
//	@GenericGenerator(name = "uuid", strategy = "uuid")
	
	@GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid", strategy = "uuid")
    @Column(columnDefinition = "CHAR(32)")
    @Id
	private String id;
	
	@NotNull
	private String description;
	@NotNull
	private String merchant;
	@NotNull
	private String amount;
	@NotNull
	private String date;
	@NotNull
	private String category;
	
	public Transaction() {
		super();
	}

	public Transaction(String description, String merchant, String amount, String date, String category) {
		super();
		this.description = description;
		this.merchant = merchant;
		this.amount = amount;
		this.date = date;
		this.category = category;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
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

	@Override
	public String toString() {
		return "Transaction [id=" + id + ", description=" + description + ", merchant=" + merchant + ", amount="
				+ amount + ", date=" + date + ", type=" + category + "]";
	}

}
