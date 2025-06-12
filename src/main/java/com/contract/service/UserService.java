package com.contract.service;

import com.contract.entity.User;
import com.contract.mapper.UserMapper;
import com.contract.entity.User;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import utils.MyBatisUtil;

import java.util.List;

public class UserService {
    public void createUser(String username, String password, String role) throws Exception {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            if (userMapper.findUserByUsername(username) != null) {
                throw new Exception("用户名已存在");
            }
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);
            userMapper.insertUser(user);
            session.commit();
        }
    }

    public void changePassword(int userId, String newPassword) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            userMapper.updatePassword(userId, newPassword);
            session.commit();
        }
    }
    private SqlSessionFactory sqlSessionFactory = MyBatisUtil.getSqlSessionFactory();

    public User login(String username, String password) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            User user = mapper.findByUsername(username);
            if (user != null && user.getPassword().equals(password)) {
                return user;
            }
            return null;
        }
    }

    public boolean register(User user) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            User existingUser = mapper.findByUsername(user.getUsername());
            if (existingUser != null) {
                return false;
            }
            mapper.insertUser(user);
            session.commit();
            return true;
        }
    }

    public boolean updateUser(User user) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            mapper.updateUser(user);
            session.commit();
            return true;
        }
    }

    public boolean deleteUser(Integer userId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            mapper.deleteUser(userId);
            session.commit();
            return true;
        }
    }

    public User findUserByUsername(String username) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.findUserByUsername(username);
        }
    }

    public boolean updateUserRole(User user) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            mapper.updateUserRole(user);
            session.commit();
            return true;
        }
    }

    public List<User> getAllUsers() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            UserMapper mapper = session.getMapper(UserMapper.class);
            return mapper.getAllUsers();
        }
    }
}