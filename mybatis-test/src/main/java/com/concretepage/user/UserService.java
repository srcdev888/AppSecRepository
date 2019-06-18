package com.concretepage.user;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.concretepage.SqlSessionFactoryManager;

public class UserService {

	public User getUserById(Integer userId) {
		SqlSession sqlSession = SqlSessionFactoryManager.getSqlSessionFactory().openSession();
		try {
			UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
			return userMapper.getUserById(userId);
		} finally {
			sqlSession.close();
		}
	}

	public void insertUser(User user) {
		SqlSession sqlSession = SqlSessionFactoryManager.getSqlSessionFactory().openSession();
		try {
			UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
			userMapper.insertUser(user);
			sqlSession.commit();
		} finally {
			sqlSession.close();
		}
	}

	public List<User> getAllUsers() {
		SqlSession sqlSession = SqlSessionFactoryManager.getSqlSessionFactory().openSession();
		try {
			UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
			return userMapper.getAllUsers();
		} finally {
			sqlSession.close();
		}
	}
	
	public List<User> getUserByFirstName(String firstname) {
		SqlSession sqlSession = SqlSessionFactoryManager.getSqlSessionFactory().openSession();
		try {
			UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
			return userMapper.getUserByFirstname(firstname);
		} finally {
			sqlSession.close();
		}
	}

	public void updateUser(User user) {
		SqlSession sqlSession = SqlSessionFactoryManager.getSqlSessionFactory().openSession();
		try {
			UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
			userMapper.updateUser(user);
			sqlSession.commit();
		} finally {
			sqlSession.close();
		}

	}

	public void deleteUser(Integer userId) {
		SqlSession sqlSession = SqlSessionFactoryManager.getSqlSessionFactory().openSession();
		try {
			UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
			userMapper.deleteUser(userId);
			sqlSession.commit();
		} finally {
			sqlSession.close();
		}

	}

	
}
