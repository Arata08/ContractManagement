<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>合同管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/index.css" rel="stylesheet">
</head>
<body>
<%@ include file="navbar.jsp" %>

<!-- 主内容区域 -->
<div class="container mt-4 fade-in">
    <div class="row">
        <div class="col-md-12">
            <div class="card slide-up">
                <div class="card-header">
                    <h5 class="card-title">
                        <i class="fas fa-tachometer-alt me-2"></i>系统功能
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row g-4">
                        <!-- 合同管理 -->
                        <div class="col-md-4 mb-3">
                            <div class="card feature-card h-100">
                                <div class="card-body">
                                    <i class="fas fa-file-contract feature-icon"></i>
                                    <h5 class="card-title">合同管理</h5>
                                    <p class="card-text">创建、查询、修改合同信息，全面管理合同生命周期</p>
                                    <a href="contractManage.jsp" class="btn btn-primary">
                                        <i class="fas fa-arrow-right me-2"></i>进入
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- 用户管理 -->
                        <c:if test="${role == 'admin'}">
                            <div class="col-md-4 mb-3">
                                <div class="card feature-card h-100">
                                    <div class="card-body">
                                        <i class="fas fa-users-cog feature-icon"></i>
                                        <h5 class="card-title">用户管理</h5>
                                        <p class="card-text">管理系统用户和权限，确保系统安全运行</p>
                                        <a href="user?action=allUser" class="btn btn-primary">
                                            <i class="fas fa-arrow-right me-2"></i>进入
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- 合同审批 -->
                        <div class="col-md-4 mb-3">
                            <div class="card feature-card h-100">
                                <div class="card-body">
                                    <i class="fas fa-clipboard-check feature-icon"></i>
                                    <h5 class="card-title">合同审批</h5>
                                    <p class="card-text">处理合同审批请求，确保合同合规性</p>
                                    <a href="contract?action=approval" class="btn btn-primary">
                                        <i class="fas fa-arrow-right me-2"></i>进入
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- 审批记录 -->
                        <c:if test="${role ne 'staff'}">
                            <div class="col-md-4 mb-3">
                                <div class="card feature-card h-100">
                                    <div class="card-body">
                                        <i class="fas fa-history feature-icon"></i>
                                        <h5 class="card-title">审批记录</h5>
                                        <p class="card-text">查看合同审批记录，追踪审批流程</p>
                                        <a href="approval" class="btn btn-primary">
                                            <i class="fas fa-arrow-right me-2"></i>进入
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- 模板管理 -->
                        <div class="col-md-4 mb-3">
                            <div class="card feature-card h-100">
                                <div class="card-body">
                                    <i class="fas fa-file-download feature-icon"></i>
                                    <c:choose>
                                        <c:when test="${role == 'staff'}">
                                            <h5 class="card-title">模板下载</h5>
                                            <p class="card-text">下载合同模板，提高合同创建效率</p>
                                        </c:when>
                                        <c:otherwise>
                                            <h5 class="card-title">模板管理</h5>
                                            <p class="card-text">管理合同模板，提高合同创建效率</p>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="file" class="btn btn-primary">
                                        <i class="fas fa-arrow-right me-2"></i>进入
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 添加页面加载动画
    document.addEventListener('DOMContentLoaded', function() {
        // 为卡片添加延迟动画
        const cards = document.querySelectorAll('.feature-card');
        cards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
            card.classList.add('slide-up');
        });

        // 导航栏滚动效果
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.style.background = 'rgba(255, 255, 255, 0.98)';
                navbar.style.boxShadow = '0 5px 25px rgba(0, 0, 0, 0.15)';
            } else {
                navbar.style.background = 'rgba(255, 255, 255, 0.95)';
                navbar.style.boxShadow = '0 5px 20px rgba(0, 0, 0, 0.1)';
            }
        });
    });
</script>
</body>
</html>