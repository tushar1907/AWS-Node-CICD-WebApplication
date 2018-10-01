package com.csye6225.Cloud.UserLogin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.csye6225.Cloud.UserLogin.dao.TransactionDao;
import com.csye6225.Cloud.UserLogin.entity.Transaction;

@Service
public class TransactionService {
	
	@Autowired
	private TransactionDao transactionDao;
	
	
	public List<Transaction> getAllTransacrtion(){
		return null;
	}
	
	public void addTransaction(Transaction transaction) {
		transactionDao.save(transaction);
	}

}
