package com.csye6225.Cloud.UserLogin.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.csye6225.Cloud.UserLogin.dao.UserDao;
import com.csye6225.Cloud.UserLogin.entity.CustomUserDetails;
import com.csye6225.Cloud.UserLogin.entity.User;

@Service
public class CustomUserDetailsService implements UserDetailsService {
	
	@Autowired
	private UserDao userDao;

	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		
		Optional<User> optionalUser = userDao.findByEmail(userName);
		
		optionalUser.orElseThrow(() -> new UsernameNotFoundException("Username not found"));
		optionalUser.map(users -> new CustomUserDetails(users)).get();
		
		
		return optionalUser.map(user -> new CustomUserDetails(user)).get();
	}

}
