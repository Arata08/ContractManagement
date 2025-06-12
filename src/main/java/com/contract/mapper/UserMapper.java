package com.contract.mapper;

import com.contract.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {
    void updatePassword(@Param("userId") Integer userId, @Param("newPassword") String newPassword);
    User findByUsername(String username);
    void insertUser(User user);
    void updateUser(User user);
    void deleteUser(Integer userId);
    User findUserByUsername(String username);
    void updateUserRole(User user);

    List<User> getAllUsers();
}