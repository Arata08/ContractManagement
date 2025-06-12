package com.contract.servlet;

import com.contract.entity.User;
import com.contract.service.UserService;
import com.contract.service.UserService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/user")
public class UserServlet extends HttpServlet {
    private UserService userService = new UserService();

    // 假设 UserService 有 changePassword 方法
    // 如果没有，需要在 UserService 中添加该方法

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            Integer userId = Integer.parseInt(request.getParameter("userId"));
            userService.deleteUser(userId);
        } else if ("find".equals(action)) {
            String username = request.getParameter("username");
            if (username == null || username.trim().isEmpty()){
                List<User> allUsers = userService.getAllUsers();
                request.setAttribute("allUsers", allUsers);
                request.getRequestDispatcher("userManage.jsp").forward(request, response);
                return;
            }
            User user = userService.findUserByUsername(username);
            // 修改：将单个用户对象包装成ArrayList
            List<User> users = new ArrayList<>();
            if (user != null) {
                users.add(user);
            }
            request.setAttribute("allUsers", users);
            request.getRequestDispatcher("userManage.jsp").forward(request, response);
            return;
        }
        List<User> allUsers = userService.getAllUsers();
        request.setAttribute("allUsers", allUsers);
        request.getRequestDispatcher("userManage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if ("updateRole".equals(action)) {
            User user = new User();
            user.setUserId(Integer.parseInt(request.getParameter("userId")));
            user.setRole(request.getParameter("role"));
            userService.updateUserRole(user);
        } else if ("create".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            try {
                userService.createUser(username, password, role);
                request.setAttribute("message", "用户创建成功");
            } catch (Exception e) {
                request.setAttribute("error", "创建用户失败: " + e.getMessage());
            }
        } else if ("changePassword".equals(action)) {
            try {
                HttpSession session = request.getSession(false);
                // 修改：直接获取Integer类型而不是强制转换String
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId == null) {
                    throw new IllegalArgumentException("用户ID不能为空");
                }
                String newPassword = request.getParameter("newPassword");
                userService.changePassword(userId, newPassword);
            } catch (NumberFormatException e) {
                System.out.println("无效的用户ID格式"+ e);
                request.getSession().setAttribute("error", "无效的用户ID格式");
            } catch (IllegalArgumentException e) {
                System.out.println("无效的用户ID格式"+ e);
                request.getSession().setAttribute("error", e.getMessage());
            }
        }
        List<User> allUsers = userService.getAllUsers();
        request.setAttribute("allUsers", allUsers);
        request.getRequestDispatcher("userManage.jsp").forward(request, response);
    }
}