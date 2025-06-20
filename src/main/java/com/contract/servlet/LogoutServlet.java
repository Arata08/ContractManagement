package com.contract.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取会话并使其失效
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // 清除所有 session 数据
        }

        // 重定向到登录页或首页
        response.sendRedirect("login.jsp");
    }
}
