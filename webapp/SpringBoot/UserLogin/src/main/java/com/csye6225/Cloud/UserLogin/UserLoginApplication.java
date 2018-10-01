package com.csye6225.Cloud.UserLogin;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;

import com.csye6225.Cloud.UserLogin.dao.UserDao;

@SpringBootApplication
@EntityScan("com.csye6225.Cloud.UserLogin.entity")
public class UserLoginApplication {
	
	@Autowired
	UserDao userRepository;
	
	@Autowired
	private DataSource dataSource;

	public static void main(String[] args) {
		SpringApplication.run(UserLoginApplication.class, args);
	}
}
