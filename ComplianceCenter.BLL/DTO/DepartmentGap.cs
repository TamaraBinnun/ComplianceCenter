
namespace ComplianceCenter.BLL.DTO
{
    public class DepartmentGap
    {
        public string CertificationName { get; set; }
        public string CriticalityLevel { get; set; }
        public int MinimumRequired { get; set; }
        public int ActualCompliant { get; set; }
        public int Gap { get; set; }
    }

}
