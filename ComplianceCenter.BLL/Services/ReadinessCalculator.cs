using ComplianceCenter.BLL.DTO;
using ComplianceCenter.DAL;
using System;
using System.Collections.Generic;
using System.Linq;

namespace ComplianceCenter.BLL.Services
{
    // =============================================
    // ReadinessCalculator
    // חישובי כשירות וסיכון
    // =============================================

    public class ReadinessCalculator
    {
        private readonly ComplianceCenterEntities _context;

        public ReadinessCalculator()
        {
            _context = new ComplianceCenterEntities();
        }

        public ReadinessCalculator(ComplianceCenterEntities context)
        {
            _context = context;
        }

        // חישוב ציון משוקלל לפי רמת קריטיות
        public decimal CalculateWeightedScore(List<DepartmentGap> gaps, int totalRequired, int totalCompliant)
        {
            if (totalRequired == 0) return 100;

            decimal totalWeight = 0;
            decimal weightedSum = 0;

            foreach (var gap in gaps)
            {
                var weight = GetCriticalityWeight(gap.CriticalityLevel);
                totalWeight += weight;

                var complianceRate = gap.ActualCompliant / (decimal)gap.MinimumRequired;
                weightedSum += complianceRate * weight;
            }

            if (totalWeight == 0) return 100;

            return Math.Round((weightedSum / totalWeight) * 100, 2);
        }

        // משקל לפי קריטיות
        private decimal GetCriticalityWeight(string criticalityLevel)
        {
            switch (criticalityLevel.Trim())
            {
                case "Critical":
                    return 4.0m;
                case "High":
                    return 3.0m;
                case "Medium":
                    return 2.0m;
                case "Low":
                    return 1.0m;
                default:
                    return 1.0m;
            }
        }

        // חישוב Risk Score (0-100, ככל שגבוה יותר = מסוכן יותר)
        public decimal CalculateRiskScore(DepartmentReadinessResult readiness, int activeAlerts, int upcomingExpirations)
        {
            var score = 0m;

            // 40% - ציון כשירות נוכחי (הפוך)
            score += (100 - (readiness?.ReadinessScore ?? 0)) * 0.4m;

            // 30% - פערים קריטיים
            score += ((readiness?.CriticalGaps ?? 0) * 10) * 0.3m;

            // 20% - התראות פעילות
            score += (activeAlerts * 5) * 0.2m;

            // 10% - הסמכות שיפקעו בקרוב
            score += (upcomingExpirations * 3) * 0.1m;

            return Math.Min(100, Math.Round(score, 2));
        }

        // חיזוי מגמה
        public string PredictTrend(List<ReadinessHistory> history)
        {
            if (history == null || history.Count < 7) return "Unknown";

            var recent = history.OrderByDescending(h => h.CalculationDate).Take(7).ToList();
            var firstHalf = recent.Skip(4).Average(h => (double)h.ReadinessScore);
            var secondHalf = recent.Take(3).Average(h => (double)h.ReadinessScore);

            var diff = secondHalf - firstHalf;

            if (diff > 5) return "Improving";
            if (diff < -5) return "Declining";
            return "Stable";
        }

        // חישוב אחוז שינוי
        public decimal CalculateChangePercentage(decimal current, decimal previous)
        {
            if (previous == 0) return 0;
            return Math.Round(((current - previous) / previous) * 100, 2);
        }

        public void Dispose()
        {
            _context?.Dispose();
        }
    }
}
