using System;

namespace ComplianceCenter.BLL.DTO
{
    public class RecurringPattern
    {
        public string AlertType { get; set; }
        public int? CertificationTypeID { get; set; }
        public int OccurrenceCount { get; set; }
        public DateTime LastOccurrence { get; set; }
        public double AverageResolutionHours { get; set; }
    }
}
