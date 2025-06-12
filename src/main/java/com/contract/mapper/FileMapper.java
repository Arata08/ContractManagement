package com.contract.mapper;

import com.contract.entity.EnterpriseFile;
import java.util.List;

public interface FileMapper {
    void insertFile(EnterpriseFile file);
    List<EnterpriseFile> selectAllFiles();
    EnterpriseFile selectFileById(Long fileId);
    void deleteFile(Long fileId);
}