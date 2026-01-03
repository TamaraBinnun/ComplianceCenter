
// =============================================
// Entity Framework Models - Part 1
// Core Business Entities
// Location: App_Code/Models/
// =============================================

using ComplianceCenter.DAL.Enums;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ComplianceCenter.DAL
{
    

    // =============================================
    // Model 2: Employee
    // =============================================

    
    public partial class Employee
    {
       
        public string FullName => $"{FirstName} {LastName}";

        
        public int YearsOfService => DateTime.Now.Year - HireDate.Year;

       
    }

    // =============================================
    // Model 3: CertificationType
    // =============================================

 
    public partial class CertificationType
    {
        public CriticalityLevel CriticalityEnum
        {
            get
            {
                switch (CriticalityLevel)
                {
                    case "Critical":
                        return Enums.CriticalityLevel.Critical;
                    case "High":
                        return Enums.CriticalityLevel.High;
                    case "Medium":
                        return Enums.CriticalityLevel.Medium;
                    case "Low":
                        return Enums.CriticalityLevel.Low;
                    default:
                        return Enums.CriticalityLevel.Medium;
                }
            }
        }

       
    }

    // =============================================
    // Model 4: EmployeeCertification
    // =============================================

  
    public partial class EmployeeCertification
    {
        public string FileType
        {
            get
            {
                var i = CertificateFileName?.LastIndexOf('.');
                if (i.HasValue && i + 1 < CertificateFileName?.Length)
                {
                    return CertificateFileName?.Substring(i.Value + 1);
                }
                return null;
            }
        }
       
        public int DaysUntilExpiry => (ExpiryDate - DateTime.Now).Days;

        
        public bool IsExpired => ExpiryDate < DateTime.Now;

        public bool IsActive => !(ExpiryDate < DateTime.Now);


        public bool IsExpiringSoon => DaysUntilExpiry <= 30 && DaysUntilExpiry > 0;

        
        public string StatusIcon
        {
            get
            {
                if (IsExpired) return "🔴";
                if (DaysUntilExpiry <= 7) return "🔴";
                if (DaysUntilExpiry <= 30) return "🟡";
                if (DaysUntilExpiry <= 90) return "🟢";
                return "✅";
            }
        }

        
        public decimal PercentRemaining
        {
            get
            {
                var totalDays = (ExpiryDate - IssueDate).Days;
                if (totalDays == 0) return 0;
                var daysRemaining = (ExpiryDate - DateTime.Now).Days;
                return Math.Max(0, Math.Min(100, (decimal)daysRemaining / totalDays * 100));
            }
        }
    }

    
    // =============================================
    // Model 6: Shift
    // =============================================

  
    public partial class Shift
    {
        
        public TimeSpan Duration => EndTime > StartTime
            ? EndTime - StartTime
            : TimeSpan.FromHours(24) - StartTime + EndTime;

        
    }

    // =============================================
    // Model 7: ShiftAssignment
    // =============================================

   
    public partial class ShiftAssignment
    {
       
        public TimeSpan? WorkDuration
        {
            get
            {
                if (CheckInTime.HasValue && CheckOutTime.HasValue)
                    return CheckOutTime.Value - CheckInTime.Value;
                return null;
            }
        }

        
        public string AttendanceStatus
        {
            get
            {
                if (!IsPresent.HasValue) return "Unknown";
                return IsPresent.Value ? "Present" : "Absent";
            }
        }
    }

    // =============================================
    // Model 8: ReadinessAlert
    // =============================================

    public partial class ReadinessAlert
    {
        
        public bool IsActive => Status == "Active";

        
        public TimeSpan? TimeToResolve
        {
            get
            {
                if (ResolvedDate.HasValue)
                    return ResolvedDate.Value - CreatedDate;
                return null;
            }
        }

        
        public int AgeInHours => (int)(DateTime.Now - CreatedDate).TotalHours;

       
    }

    

    
        
    // =============================================
    // Model 11: User
    // =============================================

    public partial class User
    {
        
        public bool IsLocked => LockedUntil.HasValue && LockedUntil.Value > DateTime.Now;

        
        public UserRole RoleEnum
        {
            get
            {
                return Enum.TryParse<UserRole>(Role, out var result) ? result : UserRole.Viewer;
            }
        }

       
    }

    // =============================================
    // Model 12: ReadinessHistory
    // =============================================

    public partial class ReadinessHistory
    {
       
        public string Status
        {
            get
            {
                if (CriticalGaps > 0) return "Critical";
                if (HighGaps > 0) return "Warning";
                if (ReadinessScore >= 90) return "Excellent";
                if (ReadinessScore >= 75) return "Good";
                return "Attention";
            }
        }

        
        public decimal ComplianceRate => TotalPresent > 0 ? (decimal)TotalCompliant / TotalPresent * 100 : 0;
    }

    // =============================================
    // Model 13: ScheduledTask
    // =============================================

    public partial class ScheduledTask
    {
        public bool IsDue => NextRunDate.HasValue && NextRunDate.Value <= DateTime.Now;

        
        public bool WasSuccessful => LastRunStatus == "Success";
    }

    // =============================================
    // Model 14: ReplacementSuggestion
    // =============================================

    public partial class ReplacementSuggestion
    {
        
        public bool IsPending => Status == "Pending";

        
        public string ConfidenceLevel
        {
            get
            {
                if (ConfidenceScore >= 80) return "High";
                if (ConfidenceScore >= 60) return "Medium";
                return "Low";
            }
        }
    }

    // =============================================
    // Model 15: ComplianceReport
    // =============================================

  
    public partial class ComplianceReport
    {
        
        public string FileSizeFormatted
        {
            get
            {
                if (!FileSize.HasValue) return "N/A";
                if (FileSize < 1024) return $"{FileSize} B";
                if (FileSize < 1024 * 1024) return $"{FileSize / 1024:F2} KB";
                return $"{FileSize / (1024 * 1024):F2} MB";
            }
        }
    }
}