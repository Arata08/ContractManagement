package com.contract.service;

import com.contract.entity.Contract;
import com.contract.mapper.ContractMapper;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import utils.MyBatisUtil;

import java.util.Collections;
import java.util.Date;
import java.util.List;

public class ContractService {
    private SqlSessionFactory sqlSessionFactory = MyBatisUtil.getSqlSessionFactory();

    public boolean createContract(Contract contract) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            mapper.insertContract(contract);
            session.commit();
            return true;
        }
    }

    public List<Contract> getContracts(String status, String type, Date startDate, Date endDate,
                                      Double minAmount, Double maxAmount,int contractId, int page, int pageSize) {
        System.out.println("startDate: " + startDate + "endDate:" + endDate);
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            int offset = (page - 1) * pageSize;
            return mapper.selectContracts(status, type, startDate, endDate, 
                                        minAmount, maxAmount,contractId, offset, pageSize);
        }
    }

    public int countContracts(String status, String type, Date startDate, Date endDate,
                            Double minAmount, Double maxAmount, int contractId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            return mapper.countContracts(status, type, startDate, endDate, contractId, minAmount, maxAmount);
        }
    }

    public boolean updateContract(Contract contract) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            mapper.updateContract(contract);
            session.commit();
            return true;
        }
    }

    public boolean updateContractStatus(String contractId, String status) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            System.out.println("contractId: " + contractId + ", status: " + status);
            mapper.updateContractStatus(contractId, status);
            session.commit();
            return true;
        }
    }

    public boolean deleteContract(String contractId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            mapper.deleteContract(contractId);
            session.commit();
            return true;
        }
    }

    public List<Contract> getContracts(String status, int page, int pageSize) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            int offset = (page - 1) * pageSize;
            return mapper.selectContractsByStatus(status, offset, pageSize);
        }

    }

    public List<Contract> getContracts(String status, String type, Date startDate, Date endDate, Double minAmount, Double maxAmount, int page, int pageSize) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            int offset = (page - 1) * pageSize;
            return mapper.selectContracts1(status, type, startDate, endDate, minAmount, maxAmount, offset, pageSize);
        }
    }

    public int countContracts(String status, String type, Date startDate, Date endDate,
                              Double minAmount, Double maxAmount) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            return mapper.countContracts1(status, type, startDate, endDate, minAmount, maxAmount);
        }
    }

    public Contract getContractById(Integer contractId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            return mapper.selectContractById(contractId);
        }
    }

    public List<Contract> selectById(int contractId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            ContractMapper mapper = session.getMapper(ContractMapper.class);
            return Collections.singletonList(mapper.selectContractById(contractId));
        }
    }
}