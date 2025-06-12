package com.contract.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 登录检查过滤器：
 * 该过滤器用于拦截所有请求，判断用户是否已登录。
 * 如果用户未登录且请求的资源不在白名单中，则重定向到登录页面。
 * 白名单中的资源（如静态资源、登录相关页面等）无需登录即可访问。
 */
@WebFilter("/*")
public class LoginCheckFilter implements Filter {

    /**
     * 白名单路径数组
     * <p>
     * 定义了无需登录即可访问的路径，包括登录页面、静态资源等。
     */
    private static final String[] EXCLUDED_PATHS = {
        "/login.jsp",
        "/login",
        "/logout",
        "/css", "/js", "/images"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // 将请求和响应转换为HTTP类型
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        /*
          获取请求路径并去掉上下文路径：
          httpRequest.getContextPath()：获取应用的上下文路径，例如 /ContractManagement。
          httpRequest.getRequestURI()：获取完整的请求URI，例如 /ContractManagement/login.jsp。
          fullPath.substring(contextPath.length())：从完整路径中去掉上下文路径，得到相对路径，例如 /login.jsp。
          */
        String contextPath = httpRequest.getContextPath();
        String fullPath = httpRequest.getRequestURI();
        String path = fullPath.substring(contextPath.length());

        // 检查请求路径是否在白名单中
        boolean isExcluded = false;
        for (String p : EXCLUDED_PATHS) {
            // startsWith：测试该字符串是否从指定的前缀开始
            if (path.startsWith(p)) {
                isExcluded = true;
                break;
            }
        }

        // 如果路径在白名单中，直接放行
        if (isExcluded) {
            chain.doFilter(request, response);
            return;
        }

        // 检查用户是否已登录
        HttpSession session = httpRequest.getSession(false);
        Object user = session != null ? session.getAttribute("userId") : null;

        // 如果用户未登录，重定向到登录页面
        if (user == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
        } else {
            // 用户已登录，继续处理请求
            chain.doFilter(request, response);
        }
    }
}