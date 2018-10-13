package com.csye6225.userTransaction.userTransaction.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.csye6225.userTransaction.userTransaction.Authorization.Authorization;
import com.csye6225.userTransaction.userTransaction.entity.Transaction;
import com.csye6225.userTransaction.userTransaction.entity.User;
import com.csye6225.userTransaction.userTransaction.repository.TransactionRepository;
import com.csye6225.userTransaction.userTransaction.repository.UserRepository;
import com.csye6225.userTransaction.userTransaction.service.TransactionService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class TransactionController {

	@Autowired
	private UserRepository userRepo;

	@Autowired
	private TransactionRepository transRepo;
	
	@Autowired
	private TransactionService transactionService;

	@Autowired
	private Authorization auth;

	private ObjectMapper mapper = new ObjectMapper();

	@GetMapping("/transaction")
	public List<Transaction> getAllTransaction(HttpServletRequest request, HttpServletResponse response)
			throws JsonProcessingException, IOException {

		// User user = userRepo.findById(id).get();
		String[] values = auth.values(request);
		if (userRepo.findAll().stream().anyMatch(t -> t.getEmail().equals(values[0]))) {
			User user = userRepo.findAll().stream().filter(t -> t.getEmail().equals(values[0])).findFirst().get();
			if (BCrypt.checkpw(values[1], user.getPassword())) {
				return user.getTransactions();
			} else {
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				return null;
			}
		} else

		{
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().println(mapper.writeValueAsString("No such user!!!"));
			return null;
		}

	}

	@PostMapping("/transaction")
	public void addTransaction(@Valid @RequestBody Transaction trans, BindingResult result, HttpServletRequest request,
			HttpServletResponse response) throws IOException {

		// if (userRepo.existsById(id)) {
		// User user = userRepo.findById(id).get();
		if (result.hasErrors()) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().println(mapper.writeValueAsString("Missing feild in transaction!!!"));
		} else {

			String[] values = auth.values(request);
			if (userRepo.findAll().stream().anyMatch(t -> t.getEmail().equals(values[0]))) {
				User user = userRepo.findAll().stream().filter(t -> t.getEmail().equals(values[0])).findFirst().get();
				if (BCrypt.checkpw(values[1], user.getPassword())) {
					user.addTransaction(trans);
					userRepo.save(user);
					response.setStatus(HttpServletResponse.SC_CREATED);
					response.getWriter().println(mapper.writeValueAsString("Transaction Saved"));
				} else {
					response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				}
				// } else {
				// response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				// response.getWriter().println(mapper.writeValueAsString("No such user!!!"));
				// }

			} else {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().println(mapper.writeValueAsString("No such user!!!"));
			}
		}
	}

	@PutMapping("/transaction/{transId}")
	public void updateTransaction(@PathVariable String transId,
			@Valid @RequestBody Transaction trans, BindingResult result, HttpServletRequest request,
			HttpServletResponse response) throws JsonProcessingException, IOException {

		// if (userRepo.existsById(id)) {
		// User user = userRepo.findById(id).get();
		if (result.hasErrors()) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().println(mapper.writeValueAsString("Missing feild in transaction!!!"));
		} else {
			String[] values = auth.values(request);
			if (userRepo.findAll().stream().anyMatch(t -> t.getEmail().equals(values[0]))) {
				User user = userRepo.findAll().stream().filter(t -> t.getEmail().equals(values[0])).findFirst().get();
				if (user.getEmail().equals(values[0]) && BCrypt.checkpw(values[1], user.getPassword())) {
					List<Transaction> transactions = user.getTransactions();
					if (transactions.stream().anyMatch(t -> t.getId().equals(transId))) {
						Transaction t = transRepo.findById(transId).get();
						t.setDescription(trans.getDescription());
						t.setAmount(trans.getAmount());
						t.setDate(trans.getDate());
						t.setMerchant(trans.getMerchant());
						t.setCategory(trans.getCategory());
						transRepo.save(t);
					} else {
						response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
					}
				} else {
					response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				}
			} else {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				response.getWriter().println(mapper.writeValueAsString("No such user!!!"));
			}
		}
	}

	@DeleteMapping("/transaction/{transId}")
	public void deleteTransaction(@PathVariable String transId, HttpServletRequest request,
			HttpServletResponse response) throws JsonProcessingException, IOException {
		// if (userRepo.existsById(id)) {
		// User user = userRepo.findById(id).get();
		String[] values = auth.values(request);
		if (userRepo.findAll().stream().anyMatch(t -> t.getEmail().equals(values[0]))) {
			User user = userRepo.findAll().stream().filter(t -> t.getEmail().equals(values[0])).findFirst().get();

			if (BCrypt.checkpw(values[1], user.getPassword())) {
				List<Transaction> transactions = user.getTransactions();
				if (transactions.stream().anyMatch(t -> t.getId().equals(transId))) {
					System.out.println(transRepo.findById(transId).get());
					//transRepo.deleteById(transId);
//					transRepo.delete(transRepo.findById(transId).get());
					transactions.remove(transactions.stream()
							.filter(t -> t.getId().equals(transId)).findFirst().get());
					userRepo.save(user);
					//transactionService.deleteTransaction(transId);
					transRepo.delete(transRepo.findById(transId).get());
					//transRepo.
					response.getWriter().println(mapper.writeValueAsString("Transaction Deleted!!!"));
				} else {
					response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
					response.getWriter().println(mapper.writeValueAsString("No such transaction!!!"));
				}
			} else {
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			}
		} else {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().println(mapper.writeValueAsString("No such user!!!"));	
		}
	}

}

// User user =userRepo.findAll().stream().filter(t ->
// t.getEmail().equals(values[0])).findFirst().get();
