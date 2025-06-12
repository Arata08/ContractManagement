<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
<link href="css/index.css" rel="stylesheet">
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="index.jsp">
            <i class="fas fa-file-contract me-2"></i>合同管理系统
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link ${param.currentPage == 'index' ? 'active' : ''}" href="index.jsp">
                        <i class="fas fa-home me-1"></i>首页
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle ${param.currentPage == 'contract' ? 'active' : ''}" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-file-alt me-1"></i>合同管理
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="contractManage.jsp">
                            <i class="fas fa-list me-2"></i>合同列表
                        </a></li>
                        <c:if test="${role ne 'staff'}">
                            <li><a class="dropdown-item" href="contractManage.jsp#addContractModal">
                                <i class="fas fa-plus me-2"></i>新建合同
                            </a></li>
                        </c:if>
                    </ul>
                </li>
                <c:if test="${role == 'admin'}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle ${param.currentPage == 'user' ? 'active' : ''}" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-users me-1"></i>用户管理
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="user?action=allUser">
                                <i class="fas fa-user-friends me-2"></i>用户列表
                            </a></li>
                            <li><a class="dropdown-item" href="userManage.jsp#addUserModal">
                                <i class="fas fa-user-plus me-2"></i>新增用户
                            </a></li>
                        </ul>
                    </li>
                </c:if>
                <li class="nav-item">
                    <a class="nav-link ${param.currentPage == 'approval' ? 'active' : ''}" href="contract?action=approval">
                        <i class="fas fa-check-circle me-1"></i>合同审批
                    </a>
                </li>
                <c:if test="${role ne 'staff'}">
                    <li class="nav-item">
                        <a class="nav-link ${param.currentPage == 'history' ? 'active' : ''}" href="approval">
                            <i class="fas fa-history me-1"></i>审批记录
                        </a>
                    </li>
                </c:if>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle ${param.currentPage == 'template' ? 'active' : ''}" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-file-download me-1"></i>模板管理
                    </a>
                    <ul class="dropdown-menu">
                        <c:choose>
                            <c:when test="${role == 'staff'}">
                                <li><a class="dropdown-item" href="file">
                                    <i class="fas fa-download me-2"></i>模板下载
                                </a></li>
                            </c:when>
                            <c:otherwise>
                                <li><a class="dropdown-item" href="file">
                                    <i class="fas fa-download me-2"></i>模板管理
                                </a></li>
                                <li><a class="dropdown-item" href="file">
                                    <i class="fas fa-upload me-2"></i>模板上传
                                </a></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </li>
            </ul>
            <span class="navbar-text">
                <i class="fas fa-user me-1"></i>欢迎，${username} |
                <a href="logout" class="text-white">
                    <i class="fas fa-sign-out-alt me-1"></i>退出
                </a>
            </span>
        </div>
    </div>
</nav>