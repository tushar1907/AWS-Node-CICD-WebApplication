package com.csye6225.userTransaction.userTransaction;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@SpringBootApplication
@EntityScan("com.csye6225.userTransaction.userTransaction.entity")
public class UserTransactionApplication {

	public static void main(String[] args) {
		SpringApplication.run(UserTransactionApplication.class, args);
	}
}
