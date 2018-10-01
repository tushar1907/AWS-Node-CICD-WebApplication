package com.csye6225.Cloud.UserLogin.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.csye6225.Cloud.UserLogin.entity.User;
import com.csye6225.Cloud.UserLogin.service.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class UserController {
	
	@Autowired
	private BCryptPasswordEncoder bcrypt;
	
	@Autowired
	private UserService userService;

	@GetMapping("/time")
	public String getTime() throws JsonProcessingException {
		DateTimeFormatter drf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
		LocalDateTime now = LocalDateTime.now();
		ObjectMapper mapper = new ObjectMapper();
		String jsonInString = mapper.writeValueAsString(drf.format(now));
		
		
		return jsonInString;
	}
	
	@PostMapping("/user/register")
	public void addUser(@RequestBody User user) {
		
		User encoded = new User();
		
		encoded.setEmail(user.getEmail());
		encoded.setPassword(bcrypt.encode(user.getPassword()));
		
		userService.addUser(encoded);
		
	}

}
