<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>审批中的合同</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="navbar.jsp" %>
    <div class="container mt-4">
        <h2>审批中的合同</h2>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>合同ID</th>
                    <th>合同名称</th>
                    <th>类型</th>
                    <th>金额</th>
                    <th>开始日期</th>
                    <th>结束日期</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${contracts}" var="contract">
                    <tr>
                        <td>${contract.contractId}</td>
                        <td>${contract.contractName}</td>
                        <td>${contract.type}</td>
                        <td>${contract.amount}</td>
                        <td><fmt:formatDate value="${contract.startDate}" pattern="yyyy-MM-dd"/></td>
                        <td><fmt:formatDate value="${contract.endDate}" pattern="yyyy-MM-dd"/></td>
                        <td>
                            <form action="contract" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="contractId" value="${contract.contractId}">
                                <input type="hidden" name="status" value="执行中">
                                <c:if test="${role ne 'staff'}">
                                <button type="submit" class="btn btn-sm btn-success">审批</button>
                                </c:if>
                            </form>
                            <form action="contract" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="contractId" value="${contract.contractId}">
                                <input type="hidden" name="status" value="草稿">
                                <c:if test="${role ne 'staff'}">
                                <button type="submit" class="btn btn-sm btn-danger">驳回</button>
                                </c:if>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>