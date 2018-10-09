package com.csye6225.userTransaction.userTransaction.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.csye6225.userTransaction.userTransaction.Authorization.Authorization;
import com.csye6225.userTransaction.userTransaction.entity.User;
import com.csye6225.userTransaction.userTransaction.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
public class UserController {

	@Autowired
	private UserService userService;

	@Autowired
	private Authorization auth;

	@GetMapping("/time")
	public void showTime(HttpServletRequest request, HttpServletResponse response) throws IOException {

		ObjectMapper mapper = new ObjectMapper();

		String[] values = auth.values(request);
		// String pw_hash = BCrypt.hashpw(values[1], BCrypt.gensalt());
		if (values.length == 0) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().println("Bad Request");

		}

		else {

			// for (User user : userService.getAllUsers()) {
			// if (user.getEmail() == values[0]
			// && BCrypt.checkpw(BCrypt.hashpw(values[1], BCrypt.gensalt(4)),
			// user.getPassword())) {
			// DateTimeFormatter drf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
			// LocalDateTime now = LocalDateTime.now();
			//
			// response.getWriter().println(mapper.writeValueAsString(drf.format(now)));
			// break;
			// }
			// response.getWriter().println(mapper.writeValueAsString("User does not
			// exist"));

			// else {
			// response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			// response.getWriter().println("Bad Request");
			List<User> users = userService.getAllUsers();
			User u = users.stream().filter(t -> t.getEmail().equals(values[0])).findAny().get();
			if (BCrypt.checkpw(values[1], u.getPassword())) {
				DateTimeFormatter drf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
				LocalDateTime now = LocalDateTime.now();
				response.getWriter().println(mapper.writeValueAsString(drf.format(now)));
			}
		}

	}

	@GetMapping("/user/list")
	public List<User> getAllUsers() {
		return userService.getAllUsers();
	}

	@PostMapping("/user/register")
	public void addUser(@Valid @RequestBody User user, BindingResult result, HttpServletResponse response)
			throws IOException {

		ObjectMapper mapper = new ObjectMapper();

		if (result.hasErrors()) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().println(mapper.writeValueAsString("Invalid feild in user!!!"));
		} else {

			if (userService.getAllUsers().isEmpty()) {

				String pw_hash = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
				user.setPassword(pw_hash);
				userService.addUser(user);
				response.setStatus(HttpServletResponse.SC_CREATED);
			} else {

				// for (User temp : userService.getAllUsers()) {
				// if (temp.getEmail().equals(user.getEmail())) {
				// response.getWriter().println(mapper.writeValueAsString("User Already
				// exists."));
				// break;
				// }
				if (userService.getAllUsers().stream().anyMatch(t -> t.getEmail().equals(user.getEmail()))) {
					response.getWriter().println(mapper.writeValueAsString("User Already exists."));
				} else {
					String pw_hash = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(4));
					user.setPassword(pw_hash);
					userService.addUser(user);
					response.setStatus(HttpServletResponse.SC_CREATED);
					// user.setPassword(bcrypt.encode(user.getPassword()));

				}
			}
		}

	}
}
