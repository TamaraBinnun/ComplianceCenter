using ComplianceCenter.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using ComplianceCenter.BLL.DTO;

namespace ComplianceCenter.BLL.Managers
{// =============================================
    // DepartmentManager
    // ניהול מחלקות וכשירות
    // =============================================

    public class DepartmentManager
    {
        private readonly ComplianceCenterEntities _context;

        public DepartmentManager()
        {
            _context = new ComplianceCenterEntities();
        }

        public DepartmentManager(ComplianceCenterEntities context)
        {
            _context = context;
        }

        // קבלת כל המחלקות הפעילות
        public List<Department> GetAllActiveDepartments()
        {
            return _context.Departments
                .Where(d => d.IsActive)
                .OrderBy(d => d.DepartmentName)
                .ToList();
        }

        // קבלת מחלקה לפי ID
        public Department GetDepartmentById(int departmentId)
        {
            return _context.Departments
                //.Include(d => d.ManagerEmployeeID)
                .Include(d => d.Employees)
                .Include(d => d.DepartmentRequirements.Select(r => r.CertificationType))
                .FirstOrDefault(d => d.DepartmentID == departmentId);
        }

        // חישוב ציון כשירות מחלקה (קריאה ל-SP)
        public DepartmentReadinessResult GetDepartmentReadiness(int departmentId, DateTime? date = null, int? shiftId = null)
        {
            var results = _context.sp_CalculateDepartmentReadiness(departmentId, date, shiftId);
            return results.FirstOrDefault();
        }

        // קבלת כל הציונים של כל המחלקות
        public List<DepartmentReadinessResult> GetAllDepartmentsReadiness(DateTime? date = null)
        {
            var departments = GetAllActiveDepartments();
            var readinessList = new List<DepartmentReadinessResult>();

            foreach (var dept in departments)
            {
                var readiness = GetDepartmentReadiness(dept.DepartmentID, date);
                if (readiness != null)
                {
                    readinessList.Add(readiness);
                }
            }

            return readinessList.OrderBy(r => r.ReadinessScore).ToList();
        }

        // קבלת פערים של מחלקה
        public List<DepartmentGap> GetDepartmentGaps(int departmentId, DateTime? date = null)
        {
            if (!date.HasValue) date = DateTime.Today;

            var query = @"
                SELECT 
                    ct.CertificationName,
                    ct.CriticalityLevel,
                    dr.MinimumRequired,
                    COUNT(DISTINCT CASE 
                        WHEN ec.Status = 'Active' 
                        AND ec.ExpiryDate > @date 
                        AND sa.IsPresent = 1 
                        THEN ec.EmployeeID 
                    END) AS ActualCompliant,
                    dr.MinimumRequired - COUNT(DISTINCT CASE 
                        WHEN ec.Status = 'Active' 
                        AND ec.ExpiryDate > @date 
                        AND sa.IsPresent = 1 
                        THEN ec.EmployeeID 
                    END) AS Gap
                FROM DepartmentRequirements dr
                INNER JOIN CertificationTypes ct ON dr.CertificationTypeID = ct.CertificationTypeID
                LEFT JOIN EmployeeCertifications ec ON ct.CertificationTypeID = ec.CertificationTypeID
                LEFT JOIN Employees e ON ec.EmployeeID = e.EmployeeID
                LEFT JOIN ShiftAssignments sa ON e.EmployeeID = sa.EmployeeID 
                    AND sa.AssignmentDate = @date
                    AND sa.DepartmentID = @departmentId
                WHERE dr.DepartmentID = @departmentId
                    AND dr.IsActive = 1
                GROUP BY ct.CertificationName, ct.CriticalityLevel, dr.MinimumRequired
                HAVING dr.MinimumRequired > COUNT(DISTINCT CASE 
                    WHEN ec.Status = 'Active' 
                    AND ec.ExpiryDate > @date 
                    AND sa.IsPresent = 1 
                    THEN ec.EmployeeID 
                END)
                ORDER BY 
                    CASE ct.CriticalityLevel
                        WHEN 'Critical' THEN 1
                        WHEN 'High' THEN 2
                        WHEN 'Medium' THEN 3
                        WHEN 'Low' THEN 4
                    END";

            return _context.Database.SqlQuery<DepartmentGap>(query,
                new System.Data.SqlClient.SqlParameter("@departmentId", departmentId),
                new System.Data.SqlClient.SqlParameter("@date", date)).ToList();
        }

        // שמירת היסטוריית כשירות
        public void SaveReadinessHistory(DepartmentReadinessResult readiness)
        {
            if (readiness == null) return;

            var history = new ReadinessHistory
            {
                DepartmentID = readiness.DepartmentID ?? 0,
                CalculationDate = readiness.CalculationDate ?? DateTime.Now,
                ShiftID = null,
                ReadinessScore = readiness.ReadinessScore ?? 0,
                TotalRequired = readiness.TotalAssigned ?? 0,
                TotalPresent = readiness.TotalPresent ?? 0,
                TotalCompliant = readiness.TotalPresent - (readiness.CriticalGaps + readiness.HighGaps + readiness.MediumGaps + readiness.LowGaps) ?? 0,
                CriticalGaps = readiness.CriticalGaps ?? 0,
                HighGaps = readiness.HighGaps ?? 0,
                MediumGaps = readiness.MediumGaps ?? 0,
                LowGaps = readiness.LowGaps ?? 0,
                CreatedDate = DateTime.Now
            };

            _context.ReadinessHistories.Add(history);
            _context.SaveChanges();
        }

        // קבלת היסטוריה של מחלקה
        public List<ReadinessHistory> GetDepartmentHistory(int departmentId, int days = 30)
        {
            var startDate = DateTime.Today.AddDays(-days);
            return _context.ReadinessHistories
                .Where(rh => rh.DepartmentID == departmentId && rh.CalculationDate >= startDate)
                .OrderByDescending(rh => rh.CalculationDate)
                .ToList();
        }

        // יצירה/עדכון מחלקה
        public int SaveDepartment(Department department)
        {
            if (department.DepartmentID == 0)
            {
                _context.Departments.Add(department);
            }
            else
            {
                var existing = _context.Departments.Find(department.DepartmentID);
                if (existing != null)
                {
                    existing.DepartmentName = department.DepartmentName;
                    existing.DepartmentCode = department.DepartmentCode;
                    existing.Description = department.Description;
                    existing.ManagerEmployeeID = department.ManagerEmployeeID;
                    existing.MinimumStaffCount = department.MinimumStaffCount;
                    existing.IsActive = department.IsActive;
                    existing.ModifiedDate = DateTime.Now;
                }
            }

            _context.SaveChanges();
            return department.DepartmentID;
        }

        // מחיקה רכה
        public void DeleteDepartment(int departmentId)
        {
            var department = _context.Departments.Find(departmentId);
            if (department != null)
            {
                department.IsActive = false;
                department.ModifiedDate = DateTime.Now;
                _context.SaveChanges();
            }
        }

        public void Dispose()
        {
            _context?.Dispose();
        }
    }
}
