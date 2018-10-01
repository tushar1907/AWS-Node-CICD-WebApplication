package com.csye6225.Cloud.UserLogin.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.csye6225.Cloud.UserLogin.entity.Transaction;
import com.csye6225.Cloud.UserLogin.service.TransactionService;

@RestController
public class TransactionController {
	
	@Autowired
	private TransactionService transactionService;
	
	@GetMapping("/transaction")
	public List<Transaction> getAllTransacrtion(){
		return null;
	}
	
	@PostMapping("/transaction")
	public void addTransaction(@RequestBody Transaction transaction) {
		transactionService.addTransaction(transaction);
		System.out.println(transaction.getId());
	}
	
	@PutMapping("/transaction/{id}")
	public void addTransaction(@PathVariable UUID id ) {
		//transactionService.addTransaction(transaction);
	}

}
