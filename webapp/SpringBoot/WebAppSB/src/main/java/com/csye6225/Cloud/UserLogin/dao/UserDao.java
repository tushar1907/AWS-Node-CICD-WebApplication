package com.csye6225.Cloud.UserLogin.dao;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import com.csye6225.Cloud.UserLogin.entity.User;

public interface UserDao extends CrudRepository<User, Integer> {

	Optional<User> findByEmail(String userName);


}
