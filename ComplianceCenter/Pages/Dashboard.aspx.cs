
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using Newtonsoft.Json;
using ComplianceCenter.BLL.Managers;
using ComplianceCenter.DAL;

namespace ComplianceCenter.Pages
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private DepartmentManager _departmentManager;
        //private AlertManager _alertManager;
        private EmployeeManager _employeeManager;

        protected void Page_Load(object sender, EventArgs e)
        {
            // בדיקת אימות
            //if (Session["UserID"] == null)
            //{
            //    Response.Redirect("Login.aspx");
            //    return;
            //}

            // אתחול Managers
            _departmentManager = new DepartmentManager();
            //_alertManager = new AlertManager();
            _employeeManager = new EmployeeManager();

            if (!IsPostBack)
            {
                InitializePage();
                LoadDashboardData();
            }

            // עדכון שעה בכל טעינה
            UpdateCurrentTime();
        }

        // =============================================
        // אתחול דף
        // =============================================
        private void InitializePage()
        {
            // הצגת שם משתמש
            if (Session["UserName"] != null)
            {
                lblUserName.Text = $"<i class='fas fa-user'></i> {Session["UserName"]}";
            }

            // תאריך נוכחי
            lblCurrentDate.Text = DateTime.Today.ToString("dd/MM/yyyy");
        }

        // =============================================
        // עדכון שעה נוכחית
        // =============================================
        private void UpdateCurrentTime()
        {
            lblCurrentTime.Text = DateTime.Now.ToString("HH:mm:ss");
        }

        // =============================================
        // טעינת נתוני Dashboard
        // =============================================
        private void LoadDashboardData()
        {
            try
            {
                // 1. טעינת כשירות כל המחלקות
                var allDepartments = _departmentManager.GetAllDepartmentsReadiness();

                // 2. חישוב KPIs
                CalculateKPIs(allDepartments);

                // 3. טעינת מפת חום
                LoadHeatMap(allDepartments);

                // 4. טעינת התראות אחרונות
                LoadRecentAlerts();

                // 5. הכנת נתונים לגרפים
                PrepareChartData(allDepartments);
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בטעינת נתונים: {ex.Message}");
            }
        }

        // =============================================
        // חישוב KPIs (Key Performance Indicators)
        // =============================================
        private void CalculateKPIs(List<DepartmentReadinessResult> departments)
        {
            if (departments == null || !departments.Any())
            {
                lblOverallScore.Text = "0";
                lblActiveAlerts.Text = "0";
                lblCriticalGaps.Text = "0";
                lblExpiringSoon.Text = "0";
                return;
            }

            // 1. ציון כשירות כללי (ממוצע משוקלל)
            var avgScore = departments.Average(d => (double)d.ReadinessScore);
            lblOverallScore.Text = avgScore.ToString("F1");
            lblOverallScore.CssClass = GetScoreColorClass((decimal)avgScore);

            // מגמה (לעומת אתמול)
            var yesterdayScore = GetYesterdayAverageScore();
            var trend = avgScore - yesterdayScore;
            if (trend > 0)
            {
                lblScoreTrend.Text = $"<i class='fas fa-arrow-up text-success'></i> +{trend:F1}% מאתמול";
                lblScoreTrend.CssClass = "text-success";
            }
            else if (trend < 0)
            {
                lblScoreTrend.Text = $"<i class='fas fa-arrow-down text-danger'></i> {trend:F1}% מאתמול";
                lblScoreTrend.CssClass = "text-danger";
            }
            else
            {
                lblScoreTrend.Text = "<i class='fas fa-minus text-muted'></i> ללא שינוי";
                lblScoreTrend.CssClass = "text-muted";
            }

            // 2. התראות פעילות
            //var alertCounts = _alertManager.GetAlertCountsBySeverity();
            //var totalAlerts = alertCounts.Values.Sum();
            //var criticalAlerts = alertCounts.ContainsKey("Critical") ? alertCounts["Critical"] : 0;

            //lblActiveAlerts.Text = totalAlerts.ToString();
            //lblCriticalAlerts.Text = criticalAlerts > 0
            //    ? $"<i class='fas fa-exclamation-triangle'></i> {criticalAlerts} קריטיות"
            //    : "אין התראות קריטיות";

            //// עדכון תג התראות בתפריט
            //if (totalAlerts > 0)
            //{
            //    lblAlertCount.Text = totalAlerts.ToString();
            //    lblAlertCount.Visible = true;
            //}
            //else
            //{
            //    lblAlertCount.Visible = false;
            //}

            // 3. פערים קריטיים
            var totalCriticalGaps = departments.Sum(d => d.CriticalGaps);
            lblCriticalGaps.Text = totalCriticalGaps.ToString();

            // 4. הסמכות שפוקעות בקרוב
            var expiringSoon = _employeeManager.GetExpiringSoonCertifications(null, 30);
            lblExpiringSoon.Text = expiringSoon.Count.ToString();
        }

        // =============================================
        // טעינת מפת חום
        // =============================================
        private void LoadHeatMap(List<DepartmentReadinessResult> departments)
        {
            // מיון לפי ציון (נמוך לגבוה כדי שהקריטיים יופיעו ראשונים)
            var sortedDepartments = departments.OrderBy(d => d.ReadinessScore).ToList();

            rptDepartments.DataSource = sortedDepartments;
            rptDepartments.DataBind();
        }

        // =============================================
        // טעינת התראות אחרונות
        // =============================================
        private void LoadRecentAlerts()
        {
            //var recentAlerts = _alertManager.GetActiveAlerts()
            //    .OrderByDescending(a => a.CreatedDate)
            //    .Take(5)
            //    .Select(a => new
            //    {
            //        a.AlertID,
            //        DepartmentName = a.Department.DepartmentName,
            //        a.Severity,
            //        a.Title,
            //        a.CreatedDate
            //    })
            //    .ToList();

            //gvAlerts.DataSource = recentAlerts;
            //gvAlerts.DataBind();
        }

        // =============================================
        // הכנת נתונים לגרפים
        // =============================================
        private void PrepareChartData(List<DepartmentReadinessResult> departments)
        {
            // 1. גרף מגמות - 30 ימים אחרונים
            var trendData = GetTrendChartData();
            hfTrendData.Value = JsonConvert.SerializeObject(trendData);

            // 2. גרף התפלגות סטטוס
            var distributionData = GetDistributionChartData(departments);
            hfDistributionData.Value = JsonConvert.SerializeObject(distributionData);
        }

        // =============================================
        // נתוני גרף מגמות
        // =============================================
        private object GetTrendChartData()
        {
            var startDate = DateTime.Today.AddDays(-30);
            var endDate = DateTime.Today;

            var history = new List<DailyAverage>();

            using (var context = new ComplianceCenterEntities())
            {
                var allHistory = context.ReadinessHistories
                    .Where(rh => rh.CalculationDate >= startDate && rh.CalculationDate <= endDate)
                    .GroupBy(rh => rh.CalculationDate)
                    .Select(g => new DailyAverage
                    {
                        Date = g.Key,
                        AverageScore = g.Average(x => (double)x.ReadinessScore)
                    })
                    .OrderBy(x => x.Date)
                    .ToList();

                history = allHistory;
            }

            return new
            {
                labels = history.Select(h => h.Date.ToString("dd/MM")).ToArray(),
                values = history.Select(h => Math.Round(h.AverageScore, 1)).ToArray()
            };
        }

        // =============================================
        // נתוני גרף התפלגות
        // =============================================
        private object GetDistributionChartData(List<DepartmentReadinessResult> departments)
        {
            var excellent = departments.Count(d => d.ReadinessScore >= 90);
            var good = departments.Count(d => d.ReadinessScore >= 75 && d.ReadinessScore < 90);
            var needsAttention = departments.Count(d => d.ReadinessScore < 75);

            return new
            {
                labels = new[] { "מצוין (90%+)", "טוב (75-89%)", "דורש תשומת לב (<75%)" },
                values = new[] { excellent, good, needsAttention }
            };
        }

        // =============================================
        // קבלת ציון אתמול
        // =============================================
        private double GetYesterdayAverageScore()
        {
            try
            {
                var yesterday = DateTime.Today.AddDays(-1);

                using (var context = new ComplianceCenterEntities())
                {
                    var yesterdayAvg = context.ReadinessHistories
                        .Where(rh => rh.CalculationDate == yesterday)
                        .Average(rh => (double?)rh.ReadinessScore);

                    return yesterdayAvg ?? 0;
                }
            }
            catch
            {
                return 0;
            }
        }

        // =============================================
        // Event Handlers
        // =============================================

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadDashboardData();
            UpdatePanelMain.Update();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Account/Login.aspx");
        }

        // =============================================
        // Helper Methods - למיפוי ב-Repeater
        // =============================================

        protected string GetStatusClass(decimal score)
        {
            if (score >= 90) return "status-excellent";
            if (score >= 75) return "status-good";
            if (score >= 50) return "status-warning";
            return "status-critical";
        }

        protected string GetStatusIcon(string status)
        {
            switch (status)
            {
                case "Critical":
                    return "<i class='fas fa-circle-xmark text-danger'></i>";
                case "Warning":
                    return "<i class='fas fa-triangle-exclamation text-warning'></i>";
                case "Attention":
                    return "<i class='fas fa-circle-exclamation text-info'></i>";
                case "OK":
                    return "<i class='fas fa-circle-check text-success'></i>";
                default:
                    return "<i class='fas fa-circle-question text-secondary'></i>";
            }
        }

        protected string GetScoreColorClass(decimal score)
        {
            if (score >= 90) return "text-success";
            if (score >= 75) return "text-primary";
            if (score >= 50) return "text-warning";
            return "text-danger";
        }

        protected string GetSeverityBadgeClass(string severity)
        {
            switch (severity)
            {
                case "Critical":
                    return "danger";
                case "High":
                    return "warning";
                case "Medium":
                    return "info";
                case "Low":
                    return "secondary";
                default:
                    return "secondary";
            }
        }

        // =============================================
        // הצגת שגיאה
        // =============================================
        private void ShowError(string message)
        {
            // כאן אפשר להוסיף Toast או Alert
            // לצורך הדוגמה - רק Debug
            System.Diagnostics.Debug.WriteLine($"Error: {message}");
        }

        // =============================================
        // Cleanup
        // =============================================
        protected override void OnUnload(EventArgs e)
        {
            _departmentManager?.Dispose();
            //_alertManager?.Dispose();
            _employeeManager?.Dispose();
            base.OnUnload(e);
        }

        // =============================================
        // DTOs
        // =============================================
        private class DailyAverage
        {
            public DateTime Date { get; set; }
            public double AverageScore { get; set; }
        }
    }

}