<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<html>
<head>
    <title>合同管理系统 - 合同管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="container mt-4">
    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">合同列表</h5>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addContractModal">
                新增合同
            </button>
        </div>
        <div class="card-body">
            <form id="searchForm" action="contract" method="get" class="mb-4">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label for="status" class="form-label">合同状态</label>
                        <select name="status" class="form-select">
                            <option value="">全部</option>
                            <option value="草稿" ${param.status == '草稿' ? 'selected' : ''}>草稿</option>
                            <option value="审批中" ${param.status == '审批中' ? 'selected' : ''}>审批中</option>
                            <option value="执行中" ${param.status == '执行中' ? 'selected' : ''}>执行中</option>
                            <option value="已终止" ${param.status == '已终止' ? 'selected' : ''}>已终止</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="type" class="form-label">合同类型</label>
                        <select name="type" class="form-select">
                            <option value="">全部</option>
                            <option value="采购" ${param.type == '采购' ? 'selected' : ''}>采购</option>
                            <option value="销售" ${param.type == '销售' ? 'selected' : ''}>销售</option>
                            <option value="租赁" ${param.type == '租赁' ? 'selected' : ''}>租赁</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="startDate" class="form-label">开始日期</label>
                        <input type="date" name="startDate" class="form-control" value="${param.startDate}">
                    </div>
                    <div class="col-md-3">
                        <label for="endDate" class="form-label">结束日期</label>
                        <input type="date" name="endDate" class="form-control" value="${param.endDate}">
                    </div>
                    <div class="col-md-3">
                        <label for="minAmount" class="form-label">最小金额</label>
                        <input type="number" id="minAmount" name="minAmount" class="form-control" value="${param.minAmount}">
                    </div>
                    <div class="col-md-3">
                        <label for="maxAmount" class="form-label">最大金额</label>
                        <input type="number" id="maxAmount" name="maxAmount" class="form-control" value="${param.maxAmount}">
                    </div>
                    <div class="col-md-3">
                        <label for="contractId" class="form-label">合同编号</label>
                        <input type="text" name="contractId" class="form-control" value="${param.contractId}">
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary">查询</button>
                        <button type="reset" class="btn btn-secondary ms-2">重置</button>
                    </div>
                </div>
            </form>

            <div class="table-responsive">
                <table class="table table-striped table-hover" id="contractTable">
                    <thead>
                    <tr>
                        <th>合同编号</th>
                        <th>合同名称</th>
                        <th>类型</th>
                        <th>金额</th>
                        <th>开始日期</th>
                        <th>结束日期</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${contracts}" var="contract">
                        <tr>
                            <td>${contract.contractId}</td>
                            <td>${contract.contractName}</td>
                            <td>${contract.type}</td>
                            <td><fmt:formatNumber value="${contract.amount}" type="currency"/></td>
                            <td><fmt:formatDate value="${contract.startDate}" pattern="yyyy-MM-dd"/></td>
                            <td><fmt:formatDate value="${contract.endDate}" pattern="yyyy-MM-dd"/></td>
                            <td>${contract.status}</td>
                            <td>
                                <button class="btn btn-sm btn-outline-primary" 
                                        onclick="viewContract('${contract.contractId}', '${contract.attachmentPath}')">查看</button>
                                <button class="btn btn-sm btn-outline-warning"
                                        onclick='editContract({
                                                "contractId": "${contract.contractId}",
                                                "contractName": "${contract.contractName}",
                                                "type": "${contract.type}",
                                                "amount": "${contract.amount}",
                                                "startDate": "<fmt:formatDate value="${contract.startDate}" pattern="yyyy-MM-dd"/>",
                                                "endDate": "<fmt:formatDate value="${contract.endDate}" pattern="yyyy-MM-dd"/>",
                                                "status": "${contract.status}",
                                                "attachmentPath": "${contract.attachmentPath}"
                                                })'>编辑</button>
                                <button class="btn btn-sm btn-outline-danger" onclick="deleteContract('${contract.contractId}')">删除</button>
                                <a href="approval?contractId=${contract.contractId}" class="btn btn-sm btn-info">查看审批历史</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <c:if test="${page > 1}">
                        <li class="page-item">
                            <a class="page-link" href="contract?page=${page - 1}&status=${param.status}&type=${param.type}&startDate=${param.startDate}&endDate=${param.endDate}&minAmount=${param.minAmount}&maxAmount=${param.maxAmount}">上一页</a>
                        </li>
                    </c:if>

                    <!-- 使用 fmt:parseNumber 确保 end 是一个整数 -->
                    <c:set var=" totalPages" value="${(total + pageSize - 1) / pageSize}" />
                    <fmt:parseNumber var="totalPagesInt" integerOnly="true" value="${totalPages}" />

                    <c:forEach begin="1" end="${totalPagesInt}" var="i">
                        <li class="page-item ${i == page ? 'active' : ''}">
                            <a class="page-link" href="contract?page=${i}&status=${param.status}&type=${param.type}&startDate=${param.startDate}&endDate=${param.endDate}&minAmount=${param.minAmount}&maxAmount=${param.maxAmount}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${page * pageSize < total}">
                        <li class="page-item">
                            <a class="page-link" href="contract?page=${page + 1}&status=${param.status}&type=${param.type}&startDate=${param.startDate}&endDate=${param.endDate}&minAmount=${param.minAmount}&maxAmount=${param.maxAmount}">下一页</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </div>
</div>

<!-- 新增合同模态框 -->
<div class="modal fade" id="addContractModal" tabindex="-1" aria-labelledby="addContractModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addContractModalLabel">新增合同</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="contract" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="contractId" class="form-label">合同编号</label>
                        <%-- 随机生成9位数字作为contractId，并格式化为十进制整数 --%>
                        <c:set var="contractId" value="${Math.round(Math.random() * 900000000 + 100000000)}" />
                        <input type="text" class="form-control" id="contractId" name="contractId" value="${contractId}" required readonly>
                    </div>
                    <div class="mb-3">
                        <label for="contractName" class="form-label">合同名称</label>
                        <input type="text" class="form-control" id="contractName" name="contractName" required>
                    </div>
                    <div class="mb-3">
                        <label for="type" class="form-label">合同类型</label>
                        <select class="form-select" id="type" name="type" required>
                            <option value="采购">采购</option>
                            <option value="销售">销售</option>
                            <option value="租赁">租赁</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="amount" class="form-label">金额</label>
                        <input type="number" step="0.01" class="form-control" id="amount" name="amount" required>
                    </div>
                    <div class="mb-3">
                        <label for="startDate" class="form-label">开始日期</label>
                        <input type="date" class="form-control" id="startDate" name="startDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="endDate" class="form-label">结束日期</label>
                        <input type="date" class="form-control" id="endDate" name="endDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="status" class="form-label">合同状态</label>
                        <select class="form-select" id="status" name="status" required>
                            <option value="草稿">草稿</option>
                            <option value="审批中">审批中</option>
                            <c:if test="${role ne 'staff'}">
                            <option value="执行中">执行中</option>
                            <option value="已终止">已终止</option>
                            </c:if>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="attachment" class="form-label">合同附件</label>
                        <input type="file" class="form-control" id="attachment" name="attachment">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 编辑合同模态框 -->
<div class="modal fade" id="editContractModal" tabindex="-1" aria-labelledby="editContractModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editContractModalLabel">编辑合同</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="contract" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <div class="modal-body" id="editContractForm">
                    <div class="mb-3">
                        <label class="form-label">合同编号</label>
                        <input type="text" class="form-control" name="contractId" required readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">合同名称</label>
                        <input type="text" class="form-control" name="contractName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">合同类型</label>
                        <select class="form-select" name="type" required>
                            <option value="采购">采购</option>
                            <option value="销售">销售</option>
                            <option value="租赁">租赁</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">金额</label>
                        <input type="number" step="0.01" class="form-control" name="amount" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">开始日期</label>
                        <input type="date" class="form-control" name="startDate" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">结束日期</label>
                        <input type="date" class="form-control" name="endDate" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">合同状态</label>
                        <select class="form-select" name="status" required>
                            <option value="草稿">草稿</option>
                            <option value="审批中">审批中</option>
                            <c:if test="${role ne 'staff'}">
                            <option value="执行中">执行中</option>
                            <option value="已终止">已终止</option>
                            </c:if>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">当前附件</label>
                        <div id="currentAttachment" class="form-text"></div>
                        <input type="hidden" name="existingAttachment">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">更新附件</label>
                        <input type="file" class="form-control" name="attachment">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
<script>
    $(document).ready(function() {
    // 自动打开新增合同模态框
    if(window.location.hash === '#addContractModal') {
        $('#addContractModal').modal('show');
    }

    $('#contractTable').DataTable({
            paging: false,
            searching: false,
            info: false
        });
    });

    function viewContract(contractId, attachmentPath) {
        if(attachmentPath && attachmentPath.trim().length > 0) {
            // 直接打开附件文件
            window.open(attachmentPath, '_blank');
        } else {
            alert('该合同暂无附件');
        }
    }

    function editContract(contract) {
        const form = $('#editContractForm');
        // 直接使用传入的contract对象数据
        form.find('input[name="contractId"]').val(contract.contractId);
        form.find('input[name="contractName"]').val(contract.contractName);
        form.find('select[name="type"]').val(contract.type);
        form.find('input[name="amount"]').val(contract.amount);
        form.find('input[name="startDate"]').val(contract.startDate);
        form.find('input[name="endDate"]').val(contract.endDate);
        form.find('select[name="status"]').val(contract.status);
        $('#currentAttachment').html(contract.attachmentPath || '无附件');
        $('input[name="existingAttachment"]').val(contract.attachmentPath);
        $('#editContractModal').modal('show');
    }

    function deleteContract(contractId) {
        if (confirm('确定要删除合同 ' + contractId + ' 吗？')) {
            $('<form>').attr({
                method: 'post',
                action: 'contract'
            }).append(
                $('<input>').attr({
                    type: 'hidden',
                    name: 'action',
                    value: 'delete'
                }),
                $('<input>').attr({
                    type: 'hidden',
                    name: 'contractId',
                    value: contractId
                })
            ).appendTo('body').submit();
        }
    }
</script>
</body>
</html>