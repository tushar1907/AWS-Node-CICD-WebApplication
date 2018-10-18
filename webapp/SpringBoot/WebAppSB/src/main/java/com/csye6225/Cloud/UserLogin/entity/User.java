package com.csye6225.Cloud.UserLogin.entity;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name="user")
public class User {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
//	@Column(name="id")
	private int id;
	
//	@Column(name="email")
	private String email;
	
	//@Column(name="password")
	private String password;
	
	@OneToMany(cascade=CascadeType.ALL, fetch=FetchType.LAZY)
	@JoinColumn(name="user_id")
	private Set<Transaction> transactions;
	
	public User(String email, String password) {
		super();
		this.email = email;
		this.password = password;
	}
	
	public User() {
		
	}
	
	public User(User user) {
		this.email = user.getEmail();
		this.password = user.getPassword();
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}

	public Set<Transaction> getTransactions() {
		return transactions;
	}

	public void setTransactions(Set<Transaction> transactions) {
		this.transactions = transactions;
	}
	
	//add a  method
	
	public void addTransactions(Transaction transaction) {
		
		if(transactions == null) {
			transactions = new HashSet<>();
		}		
		transactions.add(transaction);
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", email=" + email + ", password=" + password + ", transactions=" + transactions
				+ "]";
	}
	
	
	
	

}
