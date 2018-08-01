package com.concretepage.user;

import java.util.List;

public interface UserMapper {

	public User getUserById(Integer userId);

	public void insertUser(User user);

 	public List<User> getAllUsers();

	public void updateUser(User user);

	public void deleteUser(Integer userId);

	public List<User> getUserByFirstname(String firstname);
}