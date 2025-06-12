package com.contract.mapper;

import com.contract.entity.Approval;
import java.util.List;

public interface ApprovalHistoryMapper {
    int insertApproval(Approval approval);

    List<Approval> getApprovalsByContractId(int contractId);

    int updateApprovalStatus(Approval approval);

    List<Approval> getAllHistoryApprovals();
}