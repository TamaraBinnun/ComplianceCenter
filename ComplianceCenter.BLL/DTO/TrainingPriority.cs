

namespace ComplianceCenter.BLL.DTO
{
    public class TrainingPriority
    {
        public int DepartmentID { get; set; }
        public string DepartmentName { get; set; }
        public string CertificationName { get; set; }
        public string CriticalityLevel { get; set; }
        public int ProjectedGap { get; set; }
        public int DaysUntil { get; set; }
        public decimal EstimatedCost { get; set; }
        public decimal PriorityScore { get; set; }
        public string Urgency { get; set; }
    }
}
