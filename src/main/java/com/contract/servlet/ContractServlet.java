package com.contract.servlet;

import com.contract.entity.Approval;
import com.contract.entity.Contract;
import com.contract.service.ApprovalHistoryService;
import com.contract.service.ContractService;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/contract")
public class ContractServlet extends HttpServlet {
    private final ContractService contractService = new ContractService();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        // 处理普通表单请求
        String action = request.getParameter("action");
        String role = (String) session.getAttribute("role");

        try {
            // 检查是否为文件上传请求
            if (ServletFileUpload.isMultipartContent(request)) {
                handleMultipartRequest(request, session, role, response);
            } else {
                if ("delete".equals(action)) {
                    String contractId = request.getParameter("contractId");
                    // 新增角色校验逻辑
                    if ("staff".equals(role)) {
                        Contract currentContract = contractService.getContractById(Integer.valueOf(contractId));
                        if (currentContract != null && ("执行中".equals(currentContract.getStatus())
                                || "已终止".equals(currentContract.getStatus())|| "审批中".equals(currentContract.getStatus()))) {
                            session.setAttribute("error", "员工角色禁止删除执行中、审批中和已终止状态的合同");
                            this.doGet(request, response);
                            return;
                        }
                    }
                    contractService.deleteContract(contractId);
                    session.setAttribute("message", "合同删除成功");
                } else if ("updateStatus".equals(action)) {
                    String contractId = request.getParameter("contractId");
                    String status = request.getParameter("status");
                    contractService.updateContractStatus(contractId, status);
                    //添加到审批记录表
                    Approval approval = new Approval();
                    approval.setContractId(Integer.parseInt(contractId));
                    approval.setApprover(session.getAttribute("username").toString());
                    if (status.equals("执行中")){
                        approval.setStatus("同意");
                    }else{
                        approval.setStatus("驳回");
                    }
                    approval.setApprovalDate(new Date());
                    ApprovalHistoryService approvalService  = new ApprovalHistoryService();
                    approvalService.insertApproval(approval);
                    session.setAttribute("message", "合同状态更新成功");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "操作失败: " + e.getMessage());
        }
        if ("updateStatus".equals(action)){
            this.handleApprovalPage(request, response);
        }else{
            this.doGet(request, response);
        }

    }

    private void handleMultipartRequest(HttpServletRequest request, HttpSession session, String role, HttpServletResponse response) throws Exception {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = upload.parseRequest(request);

        // 解析表单参数
        Map<String, String> formParams = new HashMap<>();
        String attachmentPath = null;

        for (FileItem item : items) {
            if (item.isFormField()) {
                formParams.put(item.getFieldName(), item.getString("UTF-8"));
            } else if ("attachment".equals(item.getFieldName()) && item.getSize() > 0) {
                String fileName = item.getName();
                if (fileName != null && !fileName.isEmpty()) {
                    // 获取上传目录的绝对路径
                    String uploadDir = getServletContext().getRealPath("/uploads/");

                    File dir = new File(uploadDir);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    String filePath = uploadDir + fileName;
                    System.out.println("文件路径: " + filePath);

                    item.write(new File(filePath));
                    attachmentPath = "/uploads/" + fileName;
                }
            }
        }

        String action = formParams.get("action");

        if ("create".equals(action)) {
            Contract contract = createContractFromParams(formParams);
            if (attachmentPath != null) {
                contract.setAttachmentPath(attachmentPath);
            }
            contractService.createContract(contract);
            session.setAttribute("message", "合同创建成功");
        } else if ("update".equals(action)) {
            Contract contract = createContractFromParams(formParams);
            if (attachmentPath != null) {
                contract.setAttachmentPath(attachmentPath);
            }
            // 新增角色校验逻辑
            if ("staff".equals(role)) {
                Contract currentContract = contractService.getContractById(contract.getContractId());
                if (currentContract != null && ("执行中".equals(currentContract.getStatus())
                        || "已终止".equals(currentContract.getStatus()))) {
                    session.setAttribute("error", "员工角色禁止修改执行中和已终止状态的合同");
                    this.doGet(request, response);
                    return;
                }
            }
            contractService.updateContract(contract);
            session.setAttribute("message", "合同更新成功");
        }
    }

    private Contract createContractFromParams(Map<String, String> params) throws ParseException {
        Contract contract = new Contract();
        contract.setContractId(Integer.parseInt(params.get("contractId")));
        contract.setContractName(params.get("contractName"));
        contract.setType(params.get("type"));
        contract.setAmount(Double.parseDouble(params.get("amount")));
        contract.setStartDate(dateFormat.parse(params.get("startDate")));
        contract.setEndDate(dateFormat.parse(params.get("endDate")));
        contract.setStatus(params.get("status"));
        return contract;
    }

    private Contract createContractFromRequest(HttpServletRequest request) throws ParseException {
        Contract contract = new Contract();
        contract.setContractId(Integer.parseInt(request.getParameter("contractId")));
        contract.setContractName(request.getParameter("contractName"));
        contract.setType(request.getParameter("type"));
        contract.setAmount(Double.parseDouble(request.getParameter("amount")));
        contract.setStartDate(dateFormat.parse(request.getParameter("startDate")));
        contract.setEndDate(dateFormat.parse(request.getParameter("endDate")));
        contract.setStatus(request.getParameter("status"));
        return contract;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("approval".equals(action)) {
            handleApprovalPage(request, response);
            return;
        }

        // 分页查询合同列表
        int page = 1;
        int pageSize = 10;
        String status = request.getParameter("status");
        String type = request.getParameter("type");
        Date startDate = parseDate(request.getParameter("startDate"));
        Date endDate = parseDate(request.getParameter("endDate"));
        Double minAmount = parseDouble(request.getParameter("minAmount"));
        Double maxAmount = parseDouble(request.getParameter("maxAmount"));
        /*合同编号*/
        /*判断不为空再赋值*/
        int contractId;
        List<Contract> contracts;
        int total;
        if (request.getParameter("contractId") != null && !request.getParameter("contractId").trim().isEmpty()) {
            contractId = Integer.parseInt(request.getParameter("contractId"));
            contracts = contractService.selectById(contractId);
            total = 1;
        }else {
            contracts = contractService.getContracts(
                    status, type, startDate, endDate, minAmount, maxAmount, page, pageSize);
            total = contractService.countContracts(
                    status, type, startDate, endDate, minAmount, maxAmount);
        }

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            // 使用默认值
        }
        request.setAttribute("contracts", contracts);
        request.setAttribute("total", total);
        request.setAttribute("page", page);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("contractManage.jsp").forward(request, response);
    }

    private void handleApprovalPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 强制查询状态为"审批中"的合同
        int page = 1;
        int pageSize = 10;

        List<Contract> contracts = contractService.getContracts("审批中", page, pageSize);

        request.setAttribute("contracts", contracts);
        request.getRequestDispatcher("approvalContract.jsp").forward(request, response);
    }

    private Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) {
            return null;
        }
        try {
            return dateFormat.parse(dateStr);
        } catch (ParseException e) {
            return null;
        }
    }

    private Double parseDouble(String value) {
        if (value == null || value.isEmpty()) {
            return null;
        }
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}