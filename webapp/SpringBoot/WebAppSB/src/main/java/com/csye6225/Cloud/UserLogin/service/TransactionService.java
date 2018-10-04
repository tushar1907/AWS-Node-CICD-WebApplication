package com.csye6225.Cloud.UserLogin.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.csye6225.Cloud.UserLogin.dao.TransactionDao;
import com.csye6225.Cloud.UserLogin.dao.UserDao;
import com.csye6225.Cloud.UserLogin.entity.Transaction;
import com.csye6225.Cloud.UserLogin.entity.User;

@Service
public class TransactionService {
	
	@Autowired
	private UserDao userDao;
	
	@Autowired
	private TransactionDao transactionDao;
	
	
	public List<Transaction> getAllTransacrtion(){
		return null;
	}
	
	public void addTransaction(User user) {
		userDao.save(user);
	}
	
	public void updateTransaction(int id, String transactionId ,Transaction tranasction ) {
		
		User user = userDao.findById(id).get();
		
		for(Transaction trans :user.getTransactions()) {
			if(trans.getId().equals(transactionId)) {
				System.out.println("###################"+trans);
				System.out.println("###################"+tranasction);
				trans.setDescription(tranasction.getDescription());
				trans.setCategory(tranasction.getCategory());
				trans.setAmount(tranasction.getAmount());
				trans.setDate(tranasction.getDate());
				trans.setMerchant(tranasction.getMerchant());
				transactionDao.save(trans);
				break;
			}
		}
		
		//userDao.findById(id).get().addTransactions(tranasction);
		
		System.out.println("Transaction id in the URL is::::"+transactionId);
		
		
		
	}

	public void deleteTransaction(String id) {
		
//		Optional<Transaction> t = transactionDao.findById(id);
//		transactionDao.delete(t);
		transactionDao.deleteById(id);
//		User user = userDao.findById(userId).get();
//			for(Transaction trans :user.getTransactions()) {
//			if(trans.getId().equals(id)) {
//				
//			}
//		}
		
	}

}
