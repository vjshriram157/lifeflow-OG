package com.bloodbank.servlets;

import com.bloodbank.util.FirebaseConfig;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

public class ExportReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // 1. Set cache-busting headers to ensure real-time data
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
        response.setDateHeader("Expires", 0); // Proxies.

        // Set content type for Excel .xlsx
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=System_Report.xlsx");

        // Use SXSSFWorkbook for memory efficiency
        try (SXSSFWorkbook workbook = new SXSSFWorkbook(100); 
             OutputStream out = response.getOutputStream()) {
            
            Sheet sheet = workbook.createSheet("System Users Report");
            
            // 2. CREATE STYLES
            
            // Header Style: Bold, Centered, Blue Background, White Text, Borders
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(headerFont);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setFillForegroundColor(IndexedColors.BLUE_GREY.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            // Data Style: Borders
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);
            
            // Timestamp Style: Italic, Right aligned
            CellStyle metaStyle = workbook.createCellStyle();
            Font metaFont = workbook.createFont();
            metaFont.setItalic(true);
            metaStyle.setFont(metaFont);
            metaStyle.setAlignment(HorizontalAlignment.RIGHT);

            // 3. CREATE TIMESTAMP ROW
            String timestamp = "Report Generated At: " + java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            Row tsRow = sheet.createRow(0);
            Cell tsCell = tsRow.createCell(0);
            tsCell.setCellValue(timestamp);
            tsCell.setCellStyle(metaStyle);
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 7));

            // 4. CREATE HEADER ROW
            String[] headers = {"ID", "Full Name", "Role", "Email", "Phone", "Blood Group", "Status", "City"};
            Row headerRow = sheet.createRow(1);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // 5. FETCH AND WRITE DATA
            Firestore db = FirebaseConfig.getFirestore();
            if (db == null) throw new IllegalStateException("Database not available");

            // Fresh fetch from Firestore - no caching
            QuerySnapshot usersSnapshot = db.collection("users").get().get();
            List<QueryDocumentSnapshot> usersList = usersSnapshot.getDocuments();

            int rowIdx = 2; // Data starts at row 2
            for (QueryDocumentSnapshot userDoc : usersList) {
                String role = userDoc.getString("role");
                
                // Only include the requested roles for real-time reporting (Donors, Banks, and Admins)
                if ("DONOR".equalsIgnoreCase(role) || "BANK".equalsIgnoreCase(role) || "ADMIN".equalsIgnoreCase(role)) {
                    Row row = sheet.createRow(rowIdx++);
                    
                    row.createCell(0).setCellValue(val(userDoc.getId()));
                    row.createCell(1).setCellValue(val(userDoc.getString("full_name")));
                    row.createCell(2).setCellValue(val(role));
                    row.createCell(3).setCellValue(val(userDoc.getString("email")));
                    row.createCell(4).setCellValue(val(userDoc.getString("phone")));
                    row.createCell(5).setCellValue(val(userDoc.getString("blood_group")));
                    row.createCell(6).setCellValue(val(userDoc.getString("status")));
                    row.createCell(7).setCellValue(val(userDoc.getString("city")));

                    // Apply borders
                    for (int i = 0; i < headers.length; i++) {
                        row.getCell(i).setCellStyle(dataStyle);
                    }
                }
            }

            // 6. FINAL POLISH
            
            // Add Auto-filter
            if (rowIdx > 2) {
                sheet.setAutoFilter(new CellRangeAddress(1, rowIdx - 1, 0, headers.length - 1));
            }

            // Auto-size columns
            ((org.apache.poi.xssf.streaming.SXSSFSheet)sheet).trackAllColumnsForAutoSizing();
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating Excel report");
            }
        }
    }

    private String val(String data) {
        if (data == null || "null".equalsIgnoreCase(data)) return "";
        return data;
    }
}
