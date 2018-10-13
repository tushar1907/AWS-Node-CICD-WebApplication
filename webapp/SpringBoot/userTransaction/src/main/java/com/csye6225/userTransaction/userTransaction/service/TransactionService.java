package com.csye6225.userTransaction.userTransaction.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.csye6225.userTransaction.userTransaction.repository.TransactionRepository;

@Service
public class TransactionService {
	
	
	
	@Autowired
	private TransactionRepository repo;
	public void deleteTransaction(String id) {
		repo.deleteById(id);
	}

}
