package com.contract.service;

import com.contract.mapper.FileMapper;
import com.contract.entity.EnterpriseFile;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import utils.MyBatisUtil;

import java.util.List;

public class FileService {
    private final SqlSessionFactory sqlSessionFactory = MyBatisUtil.getSqlSessionFactory();

    public void uploadFile(EnterpriseFile file) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            FileMapper mapper = session.getMapper(FileMapper.class);
            mapper.insertFile(file);
            session.commit();
        }
    }

    public List<EnterpriseFile> getAllFiles() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            FileMapper mapper = session.getMapper(FileMapper.class);
            return mapper.selectAllFiles();
        }
    }

    public EnterpriseFile getFileById(Long fileId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            FileMapper mapper = session.getMapper(FileMapper.class);
            return mapper.selectFileById(fileId);
        }
    }

    public void deleteFile(Long fileId) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            FileMapper mapper = session.getMapper(FileMapper.class);
            mapper.deleteFile(fileId);
            session.commit();
        }
    }
}