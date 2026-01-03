using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ComplianceCenter.BLL.Helpers
{


    // =============================================
    // DateHelper
    // פונקציות עזר לתאריכים
    // =============================================

    public class DateHelper
    {
        // המרת תאריך לעברית
        public static string ToHebrewDate(DateTime date)
        {
            var hebrewMonths = new[]
            {
                "ינואר", "פברואר", "מרץ", "אפריל", "מאי", "יוני",
                "יולי", "אוגוסט", "ספטמבר", "אוקטובר", "נובמבר", "דצמבר"
            };

            return $"{date.Day} {hebrewMonths[date.Month - 1]} {date.Year}";
        }

        // חישוב תאריך עבודה הבא
        public static DateTime GetNextWorkday(DateTime date)
        {
            do
            {
                date = date.AddDays(1);
            }
            while (date.DayOfWeek == DayOfWeek.Friday || date.DayOfWeek == DayOfWeek.Saturday);

            return date;
        }

        // האם תאריך בעתיד
        public static bool IsInFuture(DateTime date)
        {
            return date.Date > DateTime.Today;
        }

        // האם תאריך בעבר
        public static bool IsInPast(DateTime date)
        {
            return date.Date < DateTime.Today;
        }

        // פורמט זמן יחסי ("לפני 3 ימים")
        public static string GetRelativeTime(DateTime date)
        {
            var span = DateTime.Now - date;

            if (span.TotalMinutes < 1) return "עכשיו";
            if (span.TotalMinutes < 60) return $"לפני {(int)span.TotalMinutes} דקות";
            if (span.TotalHours < 24) return $"לפני {(int)span.TotalHours} שעות";
            if (span.TotalDays < 7) return $"לפני {(int)span.TotalDays} ימים";
            if (span.TotalDays < 30) return $"לפני {(int)(span.TotalDays / 7)} שבועות";
            if (span.TotalDays < 365) return $"לפני {(int)(span.TotalDays / 30)} חודשים";
            return $"לפני {(int)(span.TotalDays / 365)} שנים";
        }

        // טווח תאריכים
        public static List<DateTime> GetDateRange(DateTime start, DateTime end)
        {
            var dates = new List<DateTime>();
            for (var date = start; date <= end; date = date.AddDays(1))
            {
                dates.Add(date);
            }
            return dates;
        }

        // תאריך תחילת חודש
        public static DateTime GetStartOfMonth(DateTime date)
        {
            return new DateTime(date.Year, date.Month, 1);
        }

        // תאריך סוף חודש
        public static DateTime GetEndOfMonth(DateTime date)
        {
            return new DateTime(date.Year, date.Month, DateTime.DaysInMonth(date.Year, date.Month));
        }

        // מספר ימי עבודה בין תאריכים
        public static int GetWorkdaysBetween(DateTime start, DateTime end)
        {
            int workdays = 0;
            for (var date = start; date <= end; date = date.AddDays(1))
            {
                if (date.DayOfWeek != DayOfWeek.Friday && date.DayOfWeek != DayOfWeek.Saturday)
                {
                    workdays++;
                }
            }
            return workdays;
        }
    }
}
