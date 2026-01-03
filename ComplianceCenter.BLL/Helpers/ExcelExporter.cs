using ComplianceCenter.DAL;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Collections.Generic;
using System.Linq;
using System.Drawing;


namespace ComplianceCenter.BLL.Helpers
{
    // =============================================
    // ExcelExporter
    // יצוא נתונים לאקסל (EPPlus)
    // =============================================

    public class ExcelExporter
    {
        public ExcelExporter()
        {
            // Set EPPlus License Context
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
        }

        // יצוא דוח כשירות מחלקתי
        public byte[] ExportDepartmentReadiness(List<DepartmentReadinessResult> departments)
        {
            using (var package = new ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("כשירות מחלקות");

                // כותרות
                worksheet.Cells[1, 1].Value = "מחלקה";
                worksheet.Cells[1, 2].Value = "ציון כשירות";
                worksheet.Cells[1, 3].Value = "סטטוס";
                worksheet.Cells[1, 4].Value = "נוכחים";
                worksheet.Cells[1, 5].Value = "כשירים";
                worksheet.Cells[1, 6].Value = "פערים קריטיים";
                worksheet.Cells[1, 7].Value = "פערים גבוהים";
                worksheet.Cells[1, 8].Value = "פערים בינוניים";
                worksheet.Cells[1, 9].Value = "פערים נמוכים";

                // עיצוב כותרות
                using (var range = worksheet.Cells[1, 1, 1, 9])
                {
                    range.Style.Font.Bold = true;
                    range.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    range.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));
                    range.Style.Font.Color.SetColor(Color.White);
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                }

                // נתונים
                int row = 2;
                foreach (var dept in departments)
                {
                    worksheet.Cells[row, 1].Value = dept.DepartmentName;
                    worksheet.Cells[row, 2].Value = dept.ReadinessScore;
                    worksheet.Cells[row, 2].Style.Numberformat.Format = "0.00";
                    worksheet.Cells[row, 3].Value = dept.Status;
                    worksheet.Cells[row, 4].Value = dept.TotalPresent;
                    worksheet.Cells[row, 5].Value = dept.TotalPresent - (dept.CriticalGaps + dept.HighGaps + dept.MediumGaps + dept.LowGaps);
                    worksheet.Cells[row, 6].Value = dept.CriticalGaps;
                    worksheet.Cells[row, 7].Value = dept.HighGaps;
                    worksheet.Cells[row, 8].Value = dept.MediumGaps;
                    worksheet.Cells[row, 9].Value = dept.LowGaps;

                    // צביעת שורה לפי ציון
                    var scoreColor = GetScoreColor(dept?.ReadinessScore ?? 0);
                    using (var range = worksheet.Cells[row, 1, row, 9])
                    {
                        range.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        range.Style.Fill.BackgroundColor.SetColor(scoreColor);
                    }

                    row++;
                }

                // התאמת רוחב עמודות
                worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();

                // RTL
                worksheet.View.RightToLeft = true;

                return package.GetAsByteArray();
            }
        }

        // יצוא רשימת עובדים עם הסמכות
        public byte[] ExportEmployeeCertifications(List<Employee> employees)
        {
            using (var package = new ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("עובדים והסמכות");

                // כותרות
                worksheet.Cells[1, 1].Value = "מספר עובד";
                worksheet.Cells[1, 2].Value = "שם פרטי";
                worksheet.Cells[1, 3].Value = "שם משפחה";
                worksheet.Cells[1, 4].Value = "מחלקה";
                worksheet.Cells[1, 5].Value = "הסמכה";
                worksheet.Cells[1, 6].Value = "תוקף עד";
                worksheet.Cells[1, 7].Value = "סטטוס";
                worksheet.Cells[1, 8].Value = "ימים עד פקיעה";

                // עיצוב כותרות
                using (var range = worksheet.Cells[1, 1, 1, 8])
                {
                    range.Style.Font.Bold = true;
                    range.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    range.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));
                    range.Style.Font.Color.SetColor(Color.White);
                }

                // נתונים
                int row = 2;
                foreach (var emp in employees)
                {
                    foreach (var cert in emp.EmployeeCertifications.Where(c => c.Status == "Active"))
                    {
                        worksheet.Cells[row, 1].Value = emp.EmployeeNumber;
                        worksheet.Cells[row, 2].Value = emp.FirstName;
                        worksheet.Cells[row, 3].Value = emp.LastName;
                        worksheet.Cells[row, 4].Value = emp.Department.DepartmentName;
                        worksheet.Cells[row, 5].Value = cert.CertificationType.CertificationName;
                        worksheet.Cells[row, 6].Value = cert.ExpiryDate;
                        worksheet.Cells[row, 6].Style.Numberformat.Format = "dd/mm/yyyy";
                        worksheet.Cells[row, 7].Value = cert.IsExpired ? "פג תוקף" : "תקף";
                        worksheet.Cells[row, 8].Value = cert.DaysUntilExpiry;

                        // צביעה לפי סטטוס
                        if (cert.IsExpired)
                        {
                            worksheet.Cells[row, 7].Style.Fill.PatternType = ExcelFillStyle.Solid;
                            worksheet.Cells[row, 7].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(255, 199, 206));
                        }
                        else if (cert.DaysUntilExpiry <= 30)
                        {
                            worksheet.Cells[row, 7].Style.Fill.PatternType = ExcelFillStyle.Solid;
                            worksheet.Cells[row, 7].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(255, 235, 156));
                        }

                        row++;
                    }
                }

                worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();
                worksheet.View.RightToLeft = true;

                return package.GetAsByteArray();
            }
        }

        // יצוא חיזוי פערים
        public byte[] ExportFutureGaps(List<FutureGapResult> gaps)
        {
            using (var package = new ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("חיזוי פערים");

                // כותרות
                worksheet.Cells[1, 1].Value = "מחלקה";
                worksheet.Cells[1, 2].Value = "הסמכה";
                worksheet.Cells[1, 3].Value = "קריטיות";
                worksheet.Cells[1, 4].Value = "נדרש";
                worksheet.Cells[1, 5].Value = "כשירים כרגע";
                worksheet.Cells[1, 6].Value = "יפוג תוקף";
                worksheet.Cells[1, 7].Value = "צפי כשירים";
                worksheet.Cells[1, 8].Value = "פער צפוי";
                worksheet.Cells[1, 9].Value = "ימים עד פקיעה";
                worksheet.Cells[1, 10].Value = "דחיפות";
                worksheet.Cells[1, 11].Value = "פעולה מומלצת";
                worksheet.Cells[1, 12].Value = "עלות משוערת";

                using (var range = worksheet.Cells[1, 1, 1, 12])
                {
                    range.Style.Font.Bold = true;
                    range.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    range.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));
                    range.Style.Font.Color.SetColor(Color.White);
                }

                int row = 2;
                foreach (var gap in gaps)
                {
                    worksheet.Cells[row, 1].Value = gap.DepartmentName;
                    worksheet.Cells[row, 2].Value = gap.CertificationName;
                    worksheet.Cells[row, 3].Value = gap.CriticalityLevel;
                    worksheet.Cells[row, 4].Value = gap.Required;
                    worksheet.Cells[row, 5].Value = gap.CurrentCompliant;
                    worksheet.Cells[row, 6].Value = gap.ExpiringCount;
                    worksheet.Cells[row, 7].Value = gap.ProjectedCompliant;
                    worksheet.Cells[row, 8].Value = gap.ProjectedGap;
                    worksheet.Cells[row, 9].Value = gap.MinDaysUntil;
                    worksheet.Cells[row, 10].Value = gap.Urgency;
                    worksheet.Cells[row, 11].Value = gap.RecommendedAction;
                    worksheet.Cells[row, 12].Value = gap.EstimatedCost;
                    worksheet.Cells[row, 12].Style.Numberformat.Format = "₪#,##0";

                    row++;
                }

                worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();
                worksheet.View.RightToLeft = true;

                return package.GetAsByteArray();
            }
        }

        private Color GetScoreColor(decimal score)
        {
            if (score < 50) return Color.FromArgb(255, 199, 206); // אדום
            if (score < 75) return Color.FromArgb(255, 235, 156); // צהוב
            if (score < 90) return Color.FromArgb(198, 239, 206); // ירוק בהיר
            return Color.FromArgb(155, 194, 230); // כחול
        }
    }

}
