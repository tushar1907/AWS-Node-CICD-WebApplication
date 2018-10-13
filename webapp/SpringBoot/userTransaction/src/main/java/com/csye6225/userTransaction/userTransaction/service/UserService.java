package com.csye6225.userTransaction.userTransaction.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.csye6225.userTransaction.userTransaction.entity.User;
import com.csye6225.userTransaction.userTransaction.repository.UserRepository;

@Service
public class UserService {
	
	@Autowired
	private UserRepository userRepo;
	
	public List<User> getAllUsers(){
		return userRepo.findAll();
	}
	
	public void addUser(User user) {
		userRepo.save(user);
	}

}
