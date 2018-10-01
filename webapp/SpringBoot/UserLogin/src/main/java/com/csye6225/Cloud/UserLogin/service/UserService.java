package com.csye6225.Cloud.UserLogin.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.csye6225.Cloud.UserLogin.dao.UserDao;
import com.csye6225.Cloud.UserLogin.entity.User;

@Service
public class UserService {
	
	@Autowired
	private UserDao userDAO;
	
	public void addUser(User user) {
		userDAO.save(user);
	}

}
