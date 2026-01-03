using ComplianceCenter.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using ComplianceCenter.BLL.DTO;

namespace ComplianceCenter.BLL.Managers
{

    // =============================================
    // CertificationManager
    // ניהול סוגי הסמכות ודרישות
    // =============================================

    public class CertificationManager
    {
        private readonly ComplianceCenterEntities _context;

        public CertificationManager()
        {
            _context = new ComplianceCenterEntities();
        }

        public CertificationManager(ComplianceCenterEntities context)
        {
            _context = context;
        }

        // קבלת כל סוגי ההסמכות
        public List<CertificationType> GetAllCertificationTypes()
        {
            return _context.CertificationTypes
                .OrderBy(ct => ct.CertificationName)
                .ToList();
        }

        // קבלת סוג הסמכה לפי ID
        public CertificationType GetCertificationTypeById(int certificationTypeId)
        {
            return _context.CertificationTypes.Find(certificationTypeId);
        }

        // קבלת דרישות של מחלקה
        public List<DepartmentRequirement> GetDepartmentRequirements(int departmentId)
        {
            return _context.DepartmentRequirements
                .Include(dr => dr.CertificationType)
                .Where(dr => dr.DepartmentID == departmentId && dr.IsActive)
                .OrderByDescending(dr => dr.Priority)
                .ThenBy(dr => dr.CertificationType.CertificationName)
                .ToList();
        }

        // שמירת דרישה
        public int SaveDepartmentRequirement(DepartmentRequirement requirement)
        {
            if (requirement.RequirementID == 0)
            {
                requirement.CreatedDate = DateTime.Now;
                _context.DepartmentRequirements.Add(requirement);
            }
            else
            {
                var existing = _context.DepartmentRequirements.Find(requirement.RequirementID);
                if (existing != null)
                {
                    existing.CertificationTypeID = requirement.CertificationTypeID;
                    existing.MinimumRequired = requirement.MinimumRequired;
                    existing.Priority = requirement.Priority;
                    existing.IsActive = requirement.IsActive;
                    existing.Notes = requirement.Notes;
                    existing.ModifiedDate = DateTime.Now;
                }
            }

            _context.SaveChanges();
            return requirement.RequirementID;
        }

        // מחיקת דרישה
        public void DeleteDepartmentRequirement(int requirementId)
        {
            var req = _context.DepartmentRequirements.Find(requirementId);
            if (req != null)
            {
                req.IsActive = false;
                req.ModifiedDate = DateTime.Now;
                _context.SaveChanges();
            }
        }

        // קבלת הסמכות קריטיות
        public List<CertificationType> GetCriticalCertifications()
        {
            return _context.CertificationTypes
                .Where(ct => ct.CriticalityLevel == "Critical")
                .OrderBy(ct => ct.CertificationName)
                .ToList();
        }

        // סטטיסטיקה של הסמכות
        public CertificationStatistics GetCertificationStatistics(int certificationTypeId)
        {
            var totalActive = _context.EmployeeCertifications
                .Count(ec => ec.CertificationTypeID == certificationTypeId
                    && ec.Status == "Active"
                    && ec.ExpiryDate > DateTime.Now);

            var expiringSoon = _context.EmployeeCertifications
                .Count(ec => ec.CertificationTypeID == certificationTypeId
                    && ec.Status == "Active"
                    && ec.ExpiryDate > DateTime.Now
                    && ec.ExpiryDate <= DateTime.Now.AddDays(30));

            var expired = _context.EmployeeCertifications
                .Count(ec => ec.CertificationTypeID == certificationTypeId
                    && ec.Status == "Active"
                    && ec.ExpiryDate <= DateTime.Now);

            return new CertificationStatistics
            {
                TotalActive = totalActive,
                ExpiringSoon = expiringSoon,
                Expired = expired
            };
        }

        public void Dispose()
        {
            _context?.Dispose();
        }
    }

}
