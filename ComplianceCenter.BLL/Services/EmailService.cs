using ComplianceCenter.BLL.DTO;
using ComplianceCenter.DAL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;

namespace ComplianceCenter.BLL.Services
{
    // =============================================
    // EmailService
    // שליחת מיילים (SendGrid)
    // =============================================

    public class EmailService
    {
        private readonly string _fromEmail;
        private readonly string _fromName;
        private readonly string _apiKey;

        public EmailService()
        {
            _fromEmail = ConfigurationManager.AppSettings["FromEmail"];
            _fromName = ConfigurationManager.AppSettings["FromName"];
            _apiKey = ConfigurationManager.AppSettings["SendGridApiKey"];
        }

        // שליחת מייל כללי
        public bool SendEmail(string toEmail, string subject, string body, bool isHtml = true)
        {
            try
            {
                using (var client = new SmtpClient("smtp.sendgrid.net", 587))
                {
                    client.Credentials = new NetworkCredential("apikey", _apiKey);
                    client.EnableSsl = true;

                    var message = new MailMessage
                    {
                        From = new MailAddress(_fromEmail, _fromName),
                        Subject = subject,
                        Body = body,
                        IsBodyHtml = isHtml
                    };

                    message.To.Add(toEmail);

                    client.Send(message);
                    return true;
                }
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine($"Email send failed: {ex.Message}");
                return false;
            }
        }

        // שליחת התראת כשירות
        public bool SendReadinessAlert(string toEmail, DepartmentReadinessResult readiness, List<DepartmentGap> gaps)
        {
            var subject = $"התראת כשירות - {readiness.DepartmentName}";

            var body = $@"
                <html dir='rtl'>
                <body style='font-family: Arial, sans-serif;'>
                    <h2>התראת כשירות - {readiness.DepartmentName}</h2>
                    <p>תאריך: {readiness.CalculationDate:dd/MM/yyyy}</p>
                    
                    <div style='background-color: {GetScoreColor(readiness?.ReadinessScore ?? 0)}; padding: 15px; margin: 10px 0; border-radius: 5px;'>
                        <h3>ציון כשירות: {readiness.ReadinessScore:F2}%</h3>
                        <p>סטטוס: {readiness.Status}</p>
                    </div>
                    
                    <h3>פערים:</h3>
                    <ul>
                        <li>קריטיים: {readiness.CriticalGaps}</li>
                        <li>גבוהים: {readiness.HighGaps}</li>
                        <li>בינוניים: {readiness.MediumGaps}</li>
                        <li>נמוכים: {readiness.LowGaps}</li>
                    </ul>
                    
                    {GetGapsHtml(gaps)}
                    
                    <p style='margin-top: 20px; color: #666;'>
                        מייל זה נשלח אוטומטית ממערכת בקרת הכשירות.
                    </p>
                </body>
                </html>";

            return SendEmail(toEmail, subject, body, true);
        }

        // שליחת התראת פקיעת הסמכה
        public bool SendCertificationExpiryAlert(string toEmail, EmployeeCertification certification)
        {
            var subject = $"התראה: הסמכת {certification.CertificationType.CertificationName} עומדת לפוג";

            var body = $@"
                <html dir='rtl'>
                <body style='font-family: Arial, sans-serif;'>
                    <h2>התראת פקיעת הסמכה</h2>
                    
                    <p><strong>עובד:</strong> {certification.Employee.FullName}</p>
                    <p><strong>הסמכה:</strong> {certification.CertificationType.CertificationName}</p>
                    <p><strong>תאריך פקיעה:</strong> {certification.ExpiryDate:dd/MM/yyyy}</p>
                    <p><strong>נותרו:</strong> {certification.DaysUntilExpiry} ימים</p>
                    
                    <div style='background-color: #fff3cd; padding: 15px; margin: 15px 0; border-right: 5px solid #ffc107;'>
                        <strong>פעולה נדרשת:</strong><br/>
                        יש לתאם ריענון הדרכה בהקדם האפשרי.
                    </div>
                    
                    <p style='margin-top: 20px; color: #666;'>
                        מייל זה נשלח אוטומטית ממערכת בקרת הכשירות.
                    </p>
                </body>
                </html>";

            return SendEmail(toEmail, subject, body, true);
        }

        // שליחת דוח יומי
        public bool SendDailyReport(string toEmail, List<DepartmentReadinessResult> allDepartments)
        {
            var subject = $"דוח כשירות יומי - {DateTime.Today:dd/MM/yyyy}";

            var avgScore = allDepartments.Average(d => (double)d.ReadinessScore);
            var criticalDepts = allDepartments.Count(d => d.Status == "Critical");

            var body = $@"
                <html dir='rtl'>
                <body style='font-family: Arial, sans-serif;'>
                    <h2>דוח כשירות יומי</h2>
                    <p>תאריך: {DateTime.Today:dd/MM/yyyy}</p>
                    
                    <div style='background-color: #f8f9fa; padding: 15px; margin: 15px 0; border-radius: 5px;'>
                        <h3>סיכום כללי</h3>
                        <p><strong>ציון ממוצע:</strong> {avgScore:F2}%</p>
                        <p><strong>מחלקות במצב קריטי:</strong> {criticalDepts}</p>
                    </div>
                    
                    <h3>פירוט לפי מחלקות:</h3>
                    <table style='width: 100%; border-collapse: collapse;'>
                        <tr style='background-color: #343a40; color: white;'>
                            <th style='padding: 10px; text-align: right;'>מחלקה</th>
                            <th style='padding: 10px; text-align: center;'>ציון</th>
                            <th style='padding: 10px; text-align: center;'>סטטוס</th>
                            <th style='padding: 10px; text-align: center;'>פערים קריטיים</th>
                        </tr>
                        {GetDepartmentsTableRows(allDepartments)}
                    </table>
                    
                    <p style='margin-top: 20px; color: #666;'>
                        מייל זה נשלח אוטומטית ממערכת בקרת הכשירות.
                    </p>
                </body>
                </html>";

            return SendEmail(toEmail, subject, body, true);
        }

        // פונקציות עזר
        private string GetScoreColor(decimal score)
        {
            if (score < 50) return "#f8d7da"; // אדום בהיר
            if (score < 75) return "#fff3cd"; // צהוב בהיר
            if (score < 90) return "#d1ecf1"; // כחול בהיר
            return "#d4edda"; // ירוק בהיר
        }

        private string GetGapsHtml(List<DepartmentGap> gaps)
        {
            if (gaps == null || !gaps.Any()) return "";

            var html = "<h3>פערים מפורטים:</h3><ul>";
            foreach (var gap in gaps.Take(5))
            {
                html += $"<li><strong>{gap.CertificationName}</strong> ({gap.CriticalityLevel}): חסרים {gap.Gap} עובדים מוסמכים</li>";
            }
            html += "</ul>";

            return html;
        }

        private string GetDepartmentsTableRows(List<DepartmentReadinessResult> departments)
        {
            var html = "";
            foreach (var dept in departments.OrderBy(d => d.ReadinessScore))
            {
                var rowColor = dept.ReadinessScore < 75 ? "#fff3cd" : "white";
                html += $@"
                    <tr style='background-color: {rowColor};'>
                        <td style='padding: 10px; border: 1px solid #dee2e6;'>{dept.DepartmentName}</td>
                        <td style='padding: 10px; border: 1px solid #dee2e6; text-align: center;'>{dept.ReadinessScore:F2}%</td>
                        <td style='padding: 10px; border: 1px solid #dee2e6; text-align: center;'>{dept.Status}</td>
                        <td style='padding: 10px; border: 1px solid #dee2e6; text-align: center;'>{dept.CriticalGaps}</td>
                    </tr>";
            }
            return html;
        }
    }

}
