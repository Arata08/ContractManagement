package com.contract.servlet;

import com.contract.entity.User;
import com.contract.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserService userService = new UserService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        System.out.println(username);
        System.out.println(password);

        User user = userService.login(username, password);
        if (user != null) {
            HttpSession session = request.getSession();
            // 设置用户角色信息到session（每次登录成功都会执行）
            session.setAttribute("role", user.getRole());
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", username);
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}