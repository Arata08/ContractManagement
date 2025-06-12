package com.contract.servlet;

import com.contract.entity.Approval;
import com.contract.service.ApprovalHistoryService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/approval")
public class ApprovalHistoryServlet extends HttpServlet {
    private ApprovalHistoryService approvalService = new ApprovalHistoryService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        int contractId = Integer.parseInt(request.getParameter("contractId"));
        String status = request.getParameter("status");

        Approval approval = new Approval();
        approval.setContractId(contractId);
        approval.setApprover(session.getAttribute("username").toString());
        if (status.equals("执行中")){
            approval.setStatus("同意");
        }else{
            approval.setStatus("驳回");
        }
        approval.setApprovalDate(new Date());

        approvalService.insertApproval(approval);
        response.sendRedirect("contractManage.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        List<Approval> approvals;

        // 检查是否包含 contractId 参数
        if (request.getParameter("contractId") != null && !request.getParameter("contractId").isEmpty()) {
            int contractId = Integer.parseInt(request.getParameter("contractId"));
            approvals = approvalService.getApprovalsByContractId(contractId);
        } else {
            approvals = approvalService.getAllHistoryApprovals();
        }

        request.setAttribute("approvals", approvals);
        request.getRequestDispatcher("approvalHistory.jsp").forward(request, response);
    }
}