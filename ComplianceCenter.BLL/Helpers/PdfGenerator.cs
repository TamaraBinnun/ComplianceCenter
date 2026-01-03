using ComplianceCenter.DAL;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace ComplianceCenter.BLL.Helpers
{
    // =============================================
    // PdfGenerator
    // יצירת PDF (iTextSharp)
    // =============================================

    public class PdfGenerator
    {
        // יצירת דוח כשירות PDF
        public byte[] GenerateReadinessReport(List<DepartmentReadinessResult> departments, DateTime reportDate)
        {
            using (var ms = new MemoryStream())
            {
                var document = new Document(PageSize.A4, 25, 25, 30, 30);
                var writer = PdfWriter.GetInstance(document, ms);

                document.Open();

                // Font עברי
                var baseFont = BaseFont.CreateFont("C:\\Windows\\Fonts\\arial.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                var titleFont = new iTextSharp.text.Font(baseFont, 18, iTextSharp.text.Font.BOLD);
                var headerFont = new iTextSharp.text.Font(baseFont, 14, iTextSharp.text.Font.BOLD);
                var normalFont = new iTextSharp.text.Font(baseFont, 12);

                // כותרת
                var title = new Paragraph("דוח כשירות מחלקות", titleFont);
                title.Alignment = Element.ALIGN_CENTER;
                document.Add(title);

                document.Add(new Paragraph($"תאריך: {reportDate:dd/MM/yyyy}", normalFont));
                document.Add(new Paragraph(" ")); // רווח

                // סיכום
                var avgScore = departments.Average(d => (double)d.ReadinessScore);
                var criticalCount = departments.Count(d => d.Status == "Critical");

                var summary = new Paragraph($"ציון ממוצע: {avgScore:F2}% | מחלקות במצב קריטי: {criticalCount}", headerFont);
                document.Add(summary);
                document.Add(new Paragraph(" "));

                // טבלה
                var table = new PdfPTable(6);
                table.WidthPercentage = 100;
                table.RunDirection = PdfWriter.RUN_DIRECTION_RTL;

                // כותרות טבלה
                AddTableHeader(table, "מחלקה", headerFont);
                AddTableHeader(table, "ציון", headerFont);
                AddTableHeader(table, "סטטוס", headerFont);
                AddTableHeader(table, "נוכחים", headerFont);
                AddTableHeader(table, "כשירים", headerFont);
                AddTableHeader(table, "פערים קריטיים", headerFont);

                // שורות
                foreach (var dept in departments.OrderBy(d => d.ReadinessScore))
                {
                    AddTableCell(table, dept.DepartmentName, normalFont);
                    AddTableCell(table, $"{dept.ReadinessScore:F2}%", normalFont);
                    AddTableCell(table, dept.Status, normalFont);
                    AddTableCell(table, dept.TotalPresent.ToString(), normalFont);
                    AddTableCell(table, (dept.TotalPresent - dept.CriticalGaps - dept.HighGaps - dept.MediumGaps - dept.LowGaps).ToString(), normalFont);
                    AddTableCell(table, dept.CriticalGaps.ToString(), normalFont);
                }

                document.Add(table);

                // סגירה
                document.Close();
                writer.Close();

                return ms.ToArray();
            }
        }

        private void AddTableHeader(PdfPTable table, string text, iTextSharp.text.Font font)
        {
            var cell = new PdfPCell(new Phrase(text, font));
            cell.BackgroundColor = new BaseColor(79, 129, 189);
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.Padding = 5;
            table.AddCell(cell);
        }

        private void AddTableCell(PdfPTable table, string text, iTextSharp.text.Font font)
        {
            var cell = new PdfPCell(new Phrase(text, font));
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.Padding = 5;
            table.AddCell(cell);
        }
    }
}
