using ComplianceCenter.BLL.DTO;
using ComplianceCenter.DAL;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;

namespace ComplianceCenter.BLL.Managers
{
    // =============================================
    // EmployeeManager
    // ניהול עובדים והסמכות
    // =============================================

    public class EmployeeManager
    {
        private readonly ComplianceCenterEntities _context;

        public EmployeeManager()
        {
            _context = new ComplianceCenterEntities();
        }

        public EmployeeManager(ComplianceCenterEntities context)
        {
            _context = context;
        }

        // קבלת כל העובדים הפעילים
        public List<Employee> GetAllActiveEmployees()
        {
            return _context.Employees
                .Include(e => e.Department)
                .Where(e => e.IsActive)
                .OrderBy(e => e.LastName)
                .ThenBy(e => e.FirstName)
                .ToList();
        }

        // קבלת עובדים לפי מחלקה
        public List<Employee> GetEmployeesByDepartment(int departmentId)
        {
            return _context.Employees
                .Include(e => e.Department)
                .Include(e => e.EmployeeCertifications.Select(c => c.CertificationType))
                .Where(e => e.DepartmentID == departmentId && e.IsActive)
                .OrderBy(e => e.LastName)
                .ToList();
        }

        // קבלת עובד לפי ID
        public Employee GetEmployeeById(int employeeId)
        {
            return _context.Employees
                .Include(e => e.Department)
                .Include(e => e.EmployeeCertifications.Select(c => c.CertificationType))
                .FirstOrDefault(e => e.EmployeeID == employeeId);
        }

        // קבלת עובד לפי מספר עובד
        public Employee GetEmployeeByNumber(string employeeNumber)
        {
            return _context.Employees
                .Include(e => e.Department)
                .FirstOrDefault(e => e.EmployeeNumber == employeeNumber);
        }

        // קבלת הסמכות של עובד
        public List<EmployeeCertification> GetEmployeeCertifications(int employeeId)
        {
            return _context.EmployeeCertifications
                .Include(ec => ec.CertificationType)
                .Where(ec => ec.EmployeeID == employeeId)
                .OrderByDescending(ec => ec.ExpiryDate)
                .ToList();
        }

        // קבלת הסמכות פעילות
        public List<EmployeeCertification> GetActiveEmployeeCertifications(int employeeId)
        {
            return _context.EmployeeCertifications
                .Include(ec => ec.CertificationType)
                .Where(ec => ec.EmployeeID == employeeId
                    && ec.Status == "Active"
                    && ec.ExpiryDate > DateTime.Now)
                .OrderBy(ec => ec.ExpiryDate)
                .ToList();
        }

        // בדיקה האם לעובד יש הסמכה ספציפית
        public bool HasValidCertification(int employeeId, int certificationTypeId)
        {
            return _context.EmployeeCertifications.Any(ec =>
                ec.EmployeeID == employeeId &&
                ec.CertificationTypeID == certificationTypeId &&
                ec.Status == "Active" &&
                ec.ExpiryDate > DateTime.Now);
        }

        // קבלת הסמכות שפג תוקפן
        public List<EmployeeCertification> GetExpiredCertifications(int? departmentId = null, int days = 30)
        {
            var query = _context.EmployeeCertifications
                .Include(ec => ec.Employee)
                .Include(ec => ec.CertificationType)
                .Where(ec => ec.Status == "Active" && ec.ExpiryDate < DateTime.Now);

            if (departmentId.HasValue)
            {
                query = query.Where(ec => ec.Employee.DepartmentID == departmentId.Value);
            }

            return query.OrderBy(ec => ec.ExpiryDate).ToList();
        }

        // קבלת הסמכות שעומדות לפוג
        public List<EmployeeCertification> GetExpiringSoonCertifications(int? departmentId = null, int daysAhead = 30)
        {
            var startDate = DateTime.Now;
            var endDate = DateTime.Now.AddDays(daysAhead);

            var query = _context.EmployeeCertifications
                .Include(ec => ec.Employee)
                .Include(ec => ec.CertificationType)
                .Where(ec => ec.Status == "Active"
                    && ec.ExpiryDate > startDate
                    && ec.ExpiryDate <= endDate);

            if (departmentId.HasValue)
            {
                query = query.Where(ec => ec.Employee.DepartmentID == departmentId.Value);
            }

            return query.OrderBy(ec => ec.ExpiryDate).ToList();
        }
       
        /// <summary>
        /// Gets employee seniority (time since hire date)
        /// </summary>
        public TimeSpan GetEmployeeSeniority(int EmployeeId)
        {
            var employee = _context.Employees
                .FirstOrDefault(e => e.EmployeeID == EmployeeId);

            if (employee == null)
                return TimeSpan.Zero;

            return DateTime.Today - employee.HireDate;
        }


        // שמירת עובד
        public int SaveEmployee(Employee employee)
        {
            if (employee.EmployeeID == 0)
            {
                employee.CreatedDate = DateTime.Now;
                _context.Employees.Add(employee);
            }
            else
            {
                var existing = _context.Employees.Find(employee.EmployeeID);
                if (existing != null)
                {
                    existing.EmployeeNumber = employee.EmployeeNumber;
                    existing.FirstName = employee.FirstName;
                    existing.LastName = employee.LastName;
                    existing.Email = employee.Email;
                    existing.PhoneNumber = employee.PhoneNumber;
                    existing.DepartmentID = employee.DepartmentID;
                    existing.PositionTitle = employee.PositionTitle;
                    existing.HireDate = employee.HireDate;
                    existing.TerminationDate = employee.TerminationDate;
                    existing.IsActive = employee.IsActive;
                    existing.PhotoFileName = employee.PhotoFileName;
                    existing.ModifiedDate = DateTime.Now;
                }
            }

            _context.SaveChanges();
            return employee.EmployeeID;
        }

        // שמירת הסמכה
        public int SaveCertification(EmployeeCertification certification)
        {
            if (certification.EmployeeCertificationID == 0)
            {
                certification.CreatedDate = DateTime.Now;
                _context.EmployeeCertifications.Add(certification);
            }
            else
            {
                var existing = _context.EmployeeCertifications.Find(certification.EmployeeCertificationID);
                if (existing != null)
                {
                    existing.CertificationTypeID = certification.CertificationTypeID;
                    existing.CertificateNumber = certification.CertificateNumber;
                    existing.IssueDate = certification.IssueDate;
                    existing.ExpiryDate = certification.ExpiryDate;
                    existing.Status = certification.Status;
                    existing.CertificateFileName = certification.CertificateFileName;
                    existing.Notes = certification.Notes;
                    existing.ModifiedDate = DateTime.Now;
                }
            }

            _context.SaveChanges();
            return certification.EmployeeCertificationID;
        }

        // מחיקת הסמכה
        public void DeleteCertification(int certificationId)
        {
            var cert = _context.EmployeeCertifications.Find(certificationId);
            if (cert != null)
            {
                cert.Status = "Cancelled";
                cert.ModifiedDate = DateTime.Now;
                _context.SaveChanges();
            }
        }

        // חיפוש עובדים
        public List<Employee> SearchEmployees(string searchTerm)
        {
            var term = searchTerm.ToLower();
            return _context.Employees
                .Include(e => e.Department)
                .Where(e => e.IsActive && (
                    e.FirstName.ToLower().Contains(term) ||
                    e.LastName.ToLower().Contains(term) ||
                    e.EmployeeNumber.ToLower().Contains(term) ||
                    e.Email.ToLower().Contains(term)))
                .OrderBy(e => e.LastName)
                .Take(50)
                .ToList();
        }

        public void Dispose()
        {
            _context?.Dispose();
        }
    }
}
