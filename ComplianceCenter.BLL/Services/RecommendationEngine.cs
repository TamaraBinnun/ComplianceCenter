using ComplianceCenter.BLL.DTO;
using ComplianceCenter.DAL;
using System;
using System.Collections.Generic;
using System.Linq;

namespace ComplianceCenter.BLL.Services
{
    // =============================================
    // AIRecommendationEngine
    // מנוע המלצות AI
    // =============================================

    public class RecommendationEngine
    {
        private readonly ComplianceCenterEntities _context;

        public RecommendationEngine()
        {
            _context = new ComplianceCenterEntities();
        }

        public RecommendationEngine(ComplianceCenterEntities context)
        {
            _context = context;
        }

        // המלצות למחליף עובד
        public List<ReplacementSuggestionResult> SuggestReplacements(int departmentId, int certificationTypeId, int? shiftID, DateTime? date = null)
        {
            return _context.sp_GetReplacementSuggestions(departmentId, certificationTypeId, date, shiftID, 10).ToList();
        }

        // המלצות לתיעדוף הדרכות
        public List<TrainingPriority> PrioritizeTrainings(int? departmentId = null)
        {
            var gaps = _context.sp_PredictFutureGaps(departmentId, 30);

            var priorities = gaps.Select(g => new TrainingPriority
            {
                DepartmentID = g.DepartmentID,
                DepartmentName = g.DepartmentName,
                CertificationName = g.CertificationName,
                CriticalityLevel = g.CriticalityLevel,
                ProjectedGap = g?.ProjectedGap ?? 0,
                DaysUntil = g?.MinDaysUntil ?? 0,
                EstimatedCost = g?.EstimatedCost ?? 0,
                PriorityScore = CalculateTrainingPriority(g),
                Urgency = g.Urgency
            }).OrderByDescending(tp => tp.PriorityScore).ToList();

            return priorities;
        }

        // חישוב ציון עדיפות להדרכה
        private decimal CalculateTrainingPriority(FutureGapResult gap)
        {
            var score = 0m;

            // קריטיות (40%)
            switch (gap.CriticalityLevel)
            {
                case "Critical":
                    score += 40;
                    break;
                case "High":
                    score += 30;
                    break;
                case "Medium":
                    score += 20;
                    break;
                case "Low":
                    score += 10;
                    break;
                default:
                    score += 10;
                    break;
            }

            // גודל הפער (30%)
            score += Math.Min(30, (gap?.ProjectedGap ?? 0) * 5);

            // זמן עד הפקיעה (30%)
            if (gap.MinDaysUntil <= 7) score += 30;
            else if (gap.MinDaysUntil <= 14) score += 20;
            else if (gap.MinDaysUntil <= 21) score += 10;
            else score += 5;

            return score;
        }

        // ניתוח דפוסים חוזרים
        public List<RecurringPattern> IdentifyRecurringIssues(int departmentId, int months = 6)
        {
            var startDate = DateTime.Today.AddMonths(-months);

            var alerts = _context.ReadinessAlerts
                .Where(ra => ra.DepartmentID == departmentId
                    && ra.CreatedDate >= startDate)
                .GroupBy(ra => new { ra.AlertType, ra.RelatedCertificationTypeID })
                .Select(g => new RecurringPattern
                {
                    AlertType = g.Key.AlertType,
                    CertificationTypeID = g.Key.RelatedCertificationTypeID,
                    OccurrenceCount = g.Count(),
                    LastOccurrence = g.Max(ra => ra.CreatedDate),
                    AverageResolutionHours = g.Where(ra => ra.ResolvedDate.HasValue)
                        .Average(ra => (double?)((ra.ResolvedDate.Value - ra.CreatedDate).TotalHours)) ?? 0
                })
                .Where(rp => rp.OccurrenceCount >= 3)
                .OrderByDescending(rp => rp.OccurrenceCount)
                .ToList();

            return alerts;
        }

        // המלצות פעולה אוטומטיות
        public string GenerateActionRecommendation(DepartmentReadinessResult readiness, List<DepartmentGap> gaps)
        {
            if (readiness.ReadinessScore < 50)
            {
                return "🔴 מצב קריטי - נדרשת פעולה מיידית! שקול להשבית פעילות עד לפתרון הבעיה.";
            }

            if (readiness.CriticalGaps > 0)
            {
                var criticalGap = gaps.FirstOrDefault(g => g.CriticalityLevel == "Critical");
                if (criticalGap != null)
                {
                    return $"⚠️ חסרה הסמכה קריטית: {criticalGap.CertificationName}. יש למצוא מחליף בדחיפות או לעצור את הפעילות הרלוונטית.";
                }
            }

            if (readiness.ReadinessScore < 75)
            {
                return "🟡 מצב דורש תשומת לב. תכנן הדרכות ושיבוצים מחדש בימים הקרובים.";
            }

            if (readiness.ReadinessScore < 90)
            {
                return "🟢 מצב טוב. המשך במעקב שוטף.";
            }

            return "✅ מצב מצוין! כל ההסמכות הנדרשות קיימות.";
        }

        public void Dispose()
        {
            _context?.Dispose();
        }
    }
}
