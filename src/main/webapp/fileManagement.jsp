<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>企业文件管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="navbar.jsp" %>
    <div class="container mt-4">
        <h2>企业文件管理</h2>
        <c:if test="${role != 'staff'}">
        <form action="file" method="post" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label for="fileType" class="form-label">文件类型</label>
                        <select class="form-select" id="fileType" name="fileType" required>
                            <option value="合同模板">合同模板</option>
                            <option value="企业资质">企业资质</option>
                            <option value="招投标模板">招投标模板</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="file" class="form-label">选择文件</label>
                        <input class="form-control" type="file" id="file" name="file" required>
                    </div>
                    <button type="submit" class="btn btn-primary">上传</button>
                </form>
        </c:if>
        
        <table class="table table-striped mt-4">
            <thead>
                <tr>
                    <th>文件ID</th>
                    <th>文件名称</th>
                    <th>文件类型</th>
                    <th>上传时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${files}" var="file">
                    <tr>
                        <td>${file.fileId}</td>
                        <td>${file.fileName}</td>
                        <td>${file.fileType}</td>
                        <td><fmt:formatDate value="${file.uploadTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>
                            <a href="file?action=download&fileId=${file.fileId}" class="btn btn-sm btn-primary">下载</a>
                            <c:if test="${role != 'staff'}">
                            <a href="file?action=delete&fileId=${file.fileId}" class="btn btn-sm btn-danger">删除</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>