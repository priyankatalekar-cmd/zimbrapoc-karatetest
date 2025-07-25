package utils;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.*;
import java.util.Date;

public class StoreEmailList {

    private static final String FILE_PATH = "target/useremails.xlsx";

    public static void writeEmail(String emailId) {
        File file = new File(FILE_PATH);
        Workbook workbook;
        Sheet sheet;

        try {
            if (file.exists()) {
                FileInputStream fis = new FileInputStream(file);
                workbook = new XSSFWorkbook(fis);
                sheet = workbook.getSheetAt(0);
            } else {
                workbook = new XSSFWorkbook();
                sheet = workbook.createSheet("Emails");
                Row header = sheet.createRow(0);
                header.createCell(0).setCellValue("Email ID");
                header.createCell(1).setCellValue("Created At");
            }

            int lastRow = sheet.getLastRowNum() + 1;
            Row row = sheet.createRow(lastRow);
            row.createCell(0).setCellValue(emailId);
            row.createCell(1).setCellValue(new Date().toString());

            FileOutputStream fos = new FileOutputStream(FILE_PATH);
            workbook.write(fos);
            fos.close();
            workbook.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to write to Excel: " + e.getMessage());
        }
    }
}