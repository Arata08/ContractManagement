<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>用户管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .modal-backdrop {
            display: none !important;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
    <h2>用户管理</h2>
    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal" data-bs-backdrop="false">
        新增用户
    </button>
</div>

<!-- 新增用户模态框 -->
<div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true" style="margin-top: 50px">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addUserModalLabel">新增用户</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="user" method="post">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="newUsername" class="form-label">用户名</label>
                        <input type="text" class="form-control" id="newUsername" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">密码</label>
                        <input type="password" class="form-control" id="newPassword" name="password" required>
                    </div>
                    <div class="mb-3">
                        <label for="userRole" class="form-label">角色</label>
                        <select class="form-select" id="userRole" name="role" required>
                            <option value="manager">manager</option>
                            <option value="staff" selected>staff</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                    <button type="submit" class="btn btn-primary">创建用户</button>
                </div>
            </form>
        </div>
    </div>
</div>
    <form action="user" method="get" class="mb-3">
        <div class="row">
            <div class="col-md-3">
                <input type="text" name="username" class="form-control" placeholder="输入用户名搜索">
            </div>
            <div class="col-md-2">
                <input type="hidden" name="action" value="find">
                <button type="submit" class="btn btn-primary">搜索</button>
            </div>
        </div>
    </form>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>用户ID</th>
                <th>用户名</th>
                <th>角色</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${not empty allUsers}">
                <c:forEach items="${allUsers}" var="user">
                <tr>
                    <td>${user.userId}</td>
                    <td>${user.username}</td>
                    <td>${user.role}</td>
                    <td>
                        <form action="user" method="post" class="d-inline">
                            <input type="hidden" name="action" value="updateRole">
                            <input type="hidden" name="userId" value="${user.userId}">
                            <select name="role" class="form-select d-inline w-auto">
                                <option value="manager" ${user.role == 'manager' ? 'selected' : ''}>manager</option>
                                <option value="staff" ${user.role == 'staff' ? 'selected' : ''}>staff</option>
                            </select>
                            <button type="submit" class="btn btn-sm btn-success">更新角色</button>
                        </form>
                        <a href="user?action=delete&userId=${user.userId}" class="btn btn-sm btn-danger" onclick="return confirm('确定要删除该用户吗？')">删除</a>
                        <a href="#" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#changePasswordModal${user.userId}">修改密码</a>

                        <div class="modal fade" id="changePasswordModal${user.userId}" tabindex="-1" aria-labelledby="changePasswordModalLabel${user.userId}" aria-hidden="true" style="margin-top: 50px">
                          <div class="modal-dialog">
                            <div class="modal-content">
                              <div class="modal-header">
                                <h5 class="modal-title" id="changePasswordModalLabel${user.userId}">修改用户 ${user.username} 密码</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                              </div>
                              <form action="user" method="post">
                                <input type="hidden" name="action" value="changePassword">
                                <input type="hidden" name="userId" value="${user.userId}">
                                <div class="modal-body">
                                  <div class="mb-3">
                                    <label for="newPassword" class="form-label">新密码</label>
                                    <input type="text" class="form-control" id="newPassword" name="newPassword" required>
                                  </div>
                                </div>
                                <div class="modal-footer">
                                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                                  <button type="submit" class="btn btn-primary">保存更改</button>
                                </div>
                              </form>
                            </div>
                          </div>
                        </div>
                    </td>
                </tr>
                </c:forEach>
            </c:if>
        </tbody>
    </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // 自动打开新增模态框
        if (window.location.hash === '#addUserModal') {
            $('#addUserModal').modal('show');
        }
    });
</script>
</body>
</html>