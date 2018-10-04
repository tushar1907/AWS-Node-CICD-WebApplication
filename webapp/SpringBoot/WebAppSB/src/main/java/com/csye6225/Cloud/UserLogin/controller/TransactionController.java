package com.csye6225.Cloud.UserLogin.controller;

import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.csye6225.Cloud.UserLogin.dao.UserDao;
import com.csye6225.Cloud.UserLogin.entity.Transaction;
import com.csye6225.Cloud.UserLogin.service.TransactionService;

@RestController
public class TransactionController {
	
	@Autowired
	private TransactionService transactionService;
	
	@Autowired
	private UserDao userDao;
	
	@GetMapping("user/{id}/transaction")
	public Set<Transaction> getAllTransacrtion(@PathVariable int id, HttpServletRequest request, HttpServletResponse response){
		
		//return user.getTransactions();
		return userDao.findById(id).get().getTransactions();
	}
	
	@PostMapping("user/{id}/transaction")
	public void addTransaction(@PathVariable int id, @RequestBody Transaction transaction) {
		//user.addTransactions(transaction);
		
		userDao.findById(id).get().addTransactions(transaction);
		transactionService.addTransaction(userDao.findById(id).get());
	//	System.out.println(transaction.getId().toString());
	}
	
//	@GetMapping("user/{id}/transaction/{transactionId}")
//	public Transaction getTransaction(@PathVariable UUID transactionId, @PathVariable int id) {
//		
//		System.out.println(userDao.findById(id).get().getTransactions().stream().filter(t -> t.getId() == (transactionId)).toString());
//		return null;
//		
//	}
	
	@PutMapping("user/{userId}/transaction/{transactionId}")
	public void updateTransaction(@PathVariable int userId , @PathVariable String transactionId, @RequestBody Transaction tranasction) {
		
		transactionService.updateTransaction(userId,transactionId ,tranasction);
		
	}
	
	@DeleteMapping("user/{userId}/transaction/{id}")
	public void deleteTransaction(@PathVariable String id) {
		
		transactionService.deleteTransaction(id);
		
	}
	
	

}
