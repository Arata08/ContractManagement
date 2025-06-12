package com.contract.mapper;

import com.contract.entity.Contract;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

public interface ContractMapper {
    void insertContract(Contract contract);
    List<Contract> selectContracts(
            @Param("status") String status,
            @Param("type") String type,
            @Param("startDate") Date startDate,
            @Param("endDate") Date endDate,
            @Param("minAmount") Double minAmount,
            @Param("maxAmount") Double maxAmount,
            @Param("contractId") int contractId,
            @Param("offset") int offset,
            @Param("pageSize") int pageSize);
    int countContracts(
            @Param("status") String status,
            @Param("type") String type,
            @Param("startDate") Date startDate,
            @Param("endDate") Date endDate,
            @Param("contractId") int contractId,
            @Param("minAmount") Double minAmount,
            @Param("maxAmount") Double maxAmount);
    void updateContract(Contract contract);
    void updateContractStatus(@Param("contractId") String contractId, @Param("status") String status);
    void deleteContract(String contractId);

    List<Contract> selectContractsByStatus(
            @Param("status") String status,
            @Param("offset") int offset,
            @Param("pageSize") int pageSize);

    List<Contract> selectContracts1(
            @Param("status") String status,
            @Param("type") String type,
            @Param("startDate") Date startDate,
            @Param("endDate") Date endDate,
            @Param("minAmount") Double minAmount,
            @Param("maxAmount") Double maxAmount,
            @Param("offset") int offset,
            @Param("pageSize") int pageSize);
    int countContracts1(
            @Param("status") String status,
            @Param("type") String type,
            @Param("startDate") Date startDate,
            @Param("endDate") Date endDate,
            @Param("minAmount") Double minAmount,
            @Param("maxAmount") Double maxAmount);

    Contract selectContractById(Integer contractId);

}