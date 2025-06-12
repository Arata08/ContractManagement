package com.contract.servlet;

import com.contract.service.FileService;
import com.contract.entity.EnterpriseFile;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Random;

@WebServlet("/file")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50,
        location = "C:/temp" // 自定义临时目录
)
public class FileServlet extends HttpServlet {
    private FileService fileService = new FileService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String fileType = request.getParameter("fileType");
        Part filePart = request.getPart("file");
        String fileName = filePart.getSubmittedFileName();
        InputStream fileContent = filePart.getInputStream();

        // 保存文件到服务器
        String uploadPath = request.getServletContext().getRealPath("/uploads");
        Path filePath = Path.of(uploadPath, fileName);
        Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);

        // 保存文件信息到数据库
        EnterpriseFile file = new EnterpriseFile();
        file.setFileName(fileName);
        file.setFilePath(filePath.toString());
        file.setFileType(fileType);
        file.setUploadUserId((Integer) request.getSession().getAttribute("userId"));
        file.setFileSize(filePart.getSize());
        file.setFileExtension(fileName.substring(fileName.lastIndexOf(".") + 1));

        fileService.uploadFile(file);

        List<EnterpriseFile> files = fileService.getAllFiles();
        request.setAttribute("files", files);
        request.getRequestDispatcher("fileManagement.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if ("download".equals(action)) {
            Long fileId = Long.parseLong(request.getParameter("fileId"));
            EnterpriseFile file = fileService.getFileById(fileId);
            
            // 修改文件名设置逻辑，对文件名进行 URL 编码
            String fileName = file.getFileName();
            String encodedFileName = java.net.URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");
            Files.copy(Path.of(file.getFilePath()), response.getOutputStream());
        } else if ("delete".equals(action)) {
            Long fileId = Long.parseLong(request.getParameter("fileId"));
            fileService.deleteFile(fileId);
            List<EnterpriseFile> files = fileService.getAllFiles();
            request.setAttribute("files", files);
            request.getRequestDispatcher("fileManagement.jsp").forward(request, response);
        } else {
            List<EnterpriseFile> files = fileService.getAllFiles();
            request.setAttribute("files", files);
            request.getRequestDispatcher("fileManagement.jsp").forward(request, response);
        }
    }
}