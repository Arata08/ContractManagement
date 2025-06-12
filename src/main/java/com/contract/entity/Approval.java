package com.contract.entity;

import java.util.Date;

public class Approval {
    private int approvalId;
    private int contractId;
    private String approver;
    private Date approvalDate;
    private String status;

    // Getters and Setters
    public int getApprovalId() {
        return approvalId;
    }

    public void setApprovalId(int approvalId) {
        this.approvalId = approvalId;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public String getApprover() {
        return approver;
    }

    public void setApprover(String approver) {
        this.approver = approver;
    }

    public Date getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(Date approvalDate) {
        this.approvalDate = approvalDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Approval{" +
                "approvalId=" + approvalId +
                ", contractId=" + contractId +
                ", approver=" + approver +
                ", approvalDate=" + approvalDate +
                ", status='" + status + '\'' +
                '}';
    }
}