<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!DOCTYPE html>
<html>
<head>
    <title>审批历史</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
    <div class="container mt-4">
        <h2>审批历史</h2>

        <!-- 增加查询表单 -->
        <form action="approval" method="get" class="mb-3">
            <div class="input-group">
                <input type="text" name="contractId" class="form-control" placeholder="请输入合同编号">
                <button type="submit" class="btn btn-primary">查询</button>
            </div>
        </form>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>合同编号</th>
                    <th>审批人</th>
                    <th>审批日期</th>
                    <th>状态</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty approvals}">
                    <p>没有找到审批记录。</p>
                </c:if>
                <c:forEach items="${approvals}" var="approval">
                    <tr>
                        <td>${approval.contractId}</td>
                        <td>${approval.approver}</td>
                        <td><fmt:formatDate value="${approval.approvalDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>${approval.status}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <a href="contractManage.jsp" class="btn btn-primary">返回合同管理</a>
    </div>
</body>
</html>