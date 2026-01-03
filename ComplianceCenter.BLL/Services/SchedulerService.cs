using ComplianceCenter.BLL.Managers;
using ComplianceCenter.DAL;
using System;
using System.Linq;

namespace ComplianceCenter.BLL.Services
{


    // =============================================
    // SchedulerService
    // משימות מתוזמנות (Quartz.NET)
    // =============================================

    public class SchedulerService
    {
        private readonly ComplianceCenterEntities _context;
        private readonly EmailService _emailService;

        public SchedulerService()
        {
            _context = new ComplianceCenterEntities();
            _emailService = new EmailService();
        }

        // בדיקת כשירות יומית (רץ בלילה)
        //public void RunDailyReadinessCheck()
        //{
        //    try
        //    {
        //        var departmentManager = new DepartmentManager(_context);
        //        var departments = departmentManager.GetAllActiveDepartments();

        //        foreach (var dept in departments)
        //        {
        //            var readiness = departmentManager.GetDepartmentReadiness(dept.DepartmentID);
        //            if (readiness != null)
        //            {
        //                // שמירה להיסטוריה
        //                departmentManager.SaveReadinessHistory(readiness);

        //                // אם קריטי - שליחת התראה
        //                if (readiness.Status == "Critical" || readiness.ReadinessScore < 70)
        //                {
        //                    CreateCriticalAlert(readiness);
        //                }
        //            }
        //        }

        //        UpdateTaskStatus("ReadinessCheck", "Success", "Checked all departments");
        //    }
        //    catch (Exception ex)
        //    {
        //        UpdateTaskStatus("ReadinessCheck", "Failed", ex.Message);
        //    }
        //}

        // התראות על פקיעת הסמכות
        public void RunExpiryNotifications()
        {
            try
            {
                var employeeManager = new EmployeeManager(_context);

                // הסמכות שפוקעות בעוד 7 ימים
                var expiringSoon = employeeManager.GetExpiringSoonCertifications(null, 7);

                foreach (var cert in expiringSoon)
                {
                    // שליחת מייל לעובד ולמנהל
                    if (!string.IsNullOrEmpty(cert.Employee.Email))
                    {
                        _emailService.SendCertificationExpiryAlert(cert.Employee.Email, cert);
                    }

                    // שליחת מייל למנהל המחלקה
                    var manager = cert.Employee.Department.Employee;//Manager
                    if (manager != null && !string.IsNullOrEmpty(manager.Email))
                    {
                        _emailService.SendCertificationExpiryAlert(manager.Email, cert);
                    }
                }

                UpdateTaskStatus("ExpiryNotification", "Success", $"Sent {expiringSoon.Count} notifications");
            }
            catch (Exception ex)
            {
                UpdateTaskStatus("ExpiryNotification", "Failed", ex.Message);
            }
        }

        // דוח יומי למנהלים
        public void RunDailyReport()
        {
            try
            {
                var departmentManager = new DepartmentManager(_context);
                var allDepartments = departmentManager.GetAllDepartmentsReadiness();

                // שליחת מייל לכל המנהלים
                var managers = _context.Users
                    .Where(u => u.Role == "SafetyManager" || u.Role == "Admin")
                    .Where(u => u.IsActive)
                    .ToList();

                foreach (var manager in managers)
                {
                    _emailService.SendDailyReport(manager.Email, allDepartments);
                }

                UpdateTaskStatus("DailyReport", "Success", $"Sent reports to {managers.Count} managers");
            }
            catch (Exception ex)
            {
                UpdateTaskStatus("DailyReport", "Failed", ex.Message);
            }
        }

        // עדכון סטטוס משימה
        private void UpdateTaskStatus(string taskType, string status, string message)
        {
            var task = _context.ScheduledTasks
                .FirstOrDefault(t => t.TaskType == taskType);

            if (task != null)
            {
                task.LastRunDate = DateTime.Now;
                task.LastRunStatus = status;
                task.LastRunMessage = message;
                task.NextRunDate = CalculateNextRun(task);
                _context.SaveChanges();
            }
        }

        // חישוב זמן הרצה הבא
        private DateTime CalculateNextRun(ScheduledTask task)
        {
            // פשטות: הרצה הבאה ב-24 שעות
            return DateTime.Now.AddHours(24);
        }

        // יצירת התראה קריטית
        //private void CreateCriticalAlert(DepartmentReadinessResult readiness)
        //{
        //    var alertManager = new AlertManager(_context);

        //    var alert = new ReadinessAlert
        //    {
        //        DepartmentID = readiness?.DepartmentID ?? 0,
        //        AlertType = "LowReadinessScore",
        //        Severity = readiness.ReadinessScore < 50 ? "Critical" : "High",
        //        Title = $"ציון כשירות נמוך - {readiness.DepartmentName}",
        //        Description = $"ציון הכשירות ירד ל-{readiness.ReadinessScore:F2}%. קיימים {readiness.CriticalGaps} פערים קריטיים.",
        //        Status = "Active",
        //        CreatedDate = DateTime.Now
        //    };

        //    alertManager.CreateAlert(alert);
        //}

        public void Dispose()
        {
            _context?.Dispose();
        }
    }
}
