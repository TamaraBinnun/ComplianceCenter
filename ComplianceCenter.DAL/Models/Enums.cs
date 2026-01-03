
namespace ComplianceCenter.DAL.Enums
{
    // =============================================
    // Enums
    // =============================================

    public enum CriticalityLevel
    {
        Low = 1,
        Medium = 2,
        High = 3,
        Critical = 4
    }

    public enum CertificationStatus
    {
        Active,
        Expired,
        Suspended,
        Cancelled
    }

    public enum AlertSeverity
    {
        Info,
        Low,
        Medium,
        High,
        Critical
    }

    public enum AlertStatus
    {
        Active,
        Resolved,
        Dismissed,
        Expired
    }

    public enum UserRole
    {
        Admin,
        SafetyManager,
        ShiftManager,
        HR,
        Doctor,
        Viewer
    }

    public enum NotificationType
    {
        Email,
        SMS,
        Push,
        InApp
    }

    public enum NotificationStatus
    {
        Pending,
        Sent,
        Failed,
        Cancelled
    }

}
