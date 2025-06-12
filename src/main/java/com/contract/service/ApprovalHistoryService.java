package com.contract.service;

import com.contract.entity.Approval;
import com.contract.mapper.ApprovalHistoryMapper;
import utils.MyBatisUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class ApprovalHistoryService {
    public int insertApproval(Approval approval) {
        try (SqlSession session = MyBatisUtil.getSqlSessionFactory().openSession()) {
            ApprovalHistoryMapper mapper = session.getMapper(ApprovalHistoryMapper.class);
            int result = mapper.insertApproval(approval);
            session.commit();
            return result;
        }
    }

    public List<Approval> getApprovalsByContractId(int contractId) {
        try (SqlSession session = MyBatisUtil.getSqlSessionFactory().openSession()) {
            ApprovalHistoryMapper mapper = session.getMapper(ApprovalHistoryMapper.class);
            return mapper.getApprovalsByContractId(contractId);
        }
    }

    public int updateApprovalStatus(Approval approval) {
        try (SqlSession session = MyBatisUtil.getSqlSessionFactory().openSession()) {
            ApprovalHistoryMapper mapper = session.getMapper(ApprovalHistoryMapper.class);
            int result = mapper.updateApprovalStatus(approval);
            session.commit();
            return result;
        }
    }

    public List<Approval>  getAllHistoryApprovals() {
        try (SqlSession session = MyBatisUtil.getSqlSessionFactory().openSession()) {
            ApprovalHistoryMapper mapper = session.getMapper(ApprovalHistoryMapper.class);
            return mapper.getAllHistoryApprovals();
        }
    }
}