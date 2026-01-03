

using ComplianceCenter.BLL.Managers;
using ComplianceCenter.BLL.Services;
using ComplianceCenter.DAL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ComplianceCenter.Pages
{
    public partial class DepartmentDetails : System.Web.UI.Page
    {
        private DepartmentManager _departmentManager;
        private EmployeeManager _employeeManager;
        private CertificationManager _certificationManager;
        private RecommendationEngine _aiEngine;

        private int DepartmentID
        {
            get
            {
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int id))
                    return id;
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // בדיקת אימות
            //if (Session["UserID"] == null)
            //{
            //    Response.Redirect("Login.aspx");
            //    return;
            //}

            // בדיקת פרמטר
            if (DepartmentID == 0)
            {
                Response.Redirect("Dashboard.aspx");
                return;
            }

            // אתחול Managers
            _departmentManager = new DepartmentManager();
            _employeeManager = new EmployeeManager();
            _certificationManager = new CertificationManager();
            _aiEngine = new RecommendationEngine();

            if (!IsPostBack)
            {
                LoadDepartmentDetails();
            }
        }

        // =============================================
        // טעינת כל פרטי המחלקה
        // =============================================
        private void LoadDepartmentDetails()
        {
            try
            {
                // 1. טעינת מידע בסיסי
                LoadDepartmentInfo();

                // 2. טעינת כשירות נוכחית
                LoadReadinessScore();

                // 3. טעינת עובדים במשמרת
                LoadEmployees();

                // 4. טעינת פערים
                LoadGaps();

                // 5. טעינת דרישות
                LoadRequirements();

                // 6. טעינת היסטוריה
                LoadHistory();
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בטעינת נתונים: {ex.Message}");
            }
        }

        // =============================================
        // טעינת מידע בסיסי על המחלקה
        // =============================================
        private void LoadDepartmentInfo()
        {
            var department = _departmentManager.GetDepartmentById(DepartmentID);
            if (department != null)
            {
                lblDepartmentName.Text = department.DepartmentName;
                lblDate.Text = DateTime.Today.ToString("dddd, dd MMMM yyyy", new System.Globalization.CultureInfo("he-IL"));
            }
        }

        // =============================================
        // טעינת ציון כשירות
        // =============================================
        private void LoadReadinessScore()
        {
            var readiness = _departmentManager.GetDepartmentReadiness(DepartmentID);
            if (readiness != null)
            {
                // ציון כללי
                lblReadinessScore.Text = readiness?.ReadinessScore?.ToString("F1");

                // KPIs
                lblTotalAssigned.Text = readiness.TotalAssigned.ToString();
                lblTotalPresent.Text = readiness.TotalPresent.ToString();
                lblTotalCompliant.Text = (readiness.TotalPresent - readiness.CriticalGaps -
                                         readiness.HighGaps - readiness.MediumGaps - readiness.LowGaps).ToString();
                lblCriticalGaps.Text = readiness.CriticalGaps.ToString();

                // סטטוס
                lblStatus.Text = GetStatusBadge(readiness.Status);

                // אם יש פערים קריטיים - הצג התראה
                if (readiness.CriticalGaps > 0)
                {
                    pnlCriticalGaps.Visible = true;
                    LoadCriticalGaps();
                }
            }
        }

        // =============================================
        // טעינת פערים קריטיים
        // =============================================
        private void LoadCriticalGaps()
        {
            var allGaps = _departmentManager.GetDepartmentGaps(DepartmentID);
            var criticalGaps = allGaps.Where(g => g.CriticalityLevel == "Critical").ToList();

            rptCriticalGaps.DataSource = criticalGaps;
            rptCriticalGaps.DataBind();
        }

        // =============================================
        // טעינת עובדים במשמרת
        // =============================================
        private void LoadEmployees(string searchTerm = null)
        {
            var employees = _employeeManager.GetEmployeesByDepartment(DepartmentID);

            // סינון לפי חיפוש
            if (!string.IsNullOrEmpty(searchTerm))
            {
                searchTerm = searchTerm.ToLower();
                employees = employees.Where(e =>
                    e.FirstName.ToLower().Contains(searchTerm) ||
                    e.LastName.ToLower().Contains(searchTerm) ||
                    e.EmployeeNumber.ToLower().Contains(searchTerm)
                ).ToList();
            }

            // קבלת שיבוצים להיום
            var shiftManager = new ShiftManager();
            var assignments = shiftManager.GetShiftAssignments(DepartmentID, DateTime.Today);

            // מיזוג נתונים
            var employeeData = employees.Select(e => new
            {
                e.EmployeeID,
                e.EmployeeNumber,
                e.FirstName,
                e.LastName,
                e.PositionTitle,
                IsPresent = assignments.Any(a => a.EmployeeID == e.EmployeeID && a.IsPresent == true),
                IsCompliant = IsEmployeeCompliant(e.EmployeeID)
            }).ToList();

            gvEmployees.DataSource = employeeData;
            gvEmployees.DataBind();
        }

        // =============================================
        // בדיקה האם עובד כשיר
        // =============================================
        private bool IsEmployeeCompliant(int employeeId)
        {
            var requirements = _certificationManager.GetDepartmentRequirements(DepartmentID);

            foreach (var req in requirements)
            {
                if (!_employeeManager.HasValidCertification(employeeId, req.CertificationTypeID))
                {
                    return false;
                }
            }

            return true;
        }

        // =============================================
        // קבלת הסמכות חסרות לעובד
        // =============================================
        protected string GetMissingCertifications(object employeeIdObj)
        {
            if (employeeIdObj == null) return string.Empty;

            int employeeId = Convert.ToInt32(employeeIdObj);
            var requirements = _certificationManager.GetDepartmentRequirements(DepartmentID);
            var missing = new List<string>();

            foreach (var req in requirements)
            {
                if (!_employeeManager.HasValidCertification(employeeId, req.CertificationTypeID))
                {
                    missing.Add(req.CertificationType.CertificationName);
                }
            }

            if (missing.Any())
            {
                return string.Join(", ", missing);
            }

            return "<span class='text-success'>✓ הכל תקין</span>";
        }

        // =============================================
        // טעינת פערים
        // =============================================
        private void LoadGaps()
        {
            var gaps = _departmentManager.GetDepartmentGaps(DepartmentID);

            // הוספת CertificationTypeID לכל פער (מחיפוש בבסיס)
            using (var context = new ComplianceCenterEntities())
            {
                var gapsWithTypeId = gaps.Select(g =>
                {
                    var certType = context.CertificationTypes
                        .FirstOrDefault(ct => ct.CertificationName == g.CertificationName);

                    return new
                    {
                        g.CertificationName,
                        g.CriticalityLevel,
                        g.MinimumRequired,
                        g.ActualCompliant,
                        g.Gap,
                        CertificationTypeID = certType?.CertificationTypeID ?? 0
                    };
                }).ToList();

                gvGaps.DataSource = gapsWithTypeId;
                gvGaps.DataBind();
            }
        }

        // =============================================
        // טעינת דרישות
        // =============================================
        private void LoadRequirements()
        {
            var requirements = _certificationManager.GetDepartmentRequirements(DepartmentID);

            var reqData = requirements.Select(r => new
            {
                r.CertificationType.CertificationName,
                r.CertificationType.CriticalityLevel,
                r.MinimumRequired,
                r.Priority,
                r.Notes
            }).ToList();

            gvRequirements.DataSource = reqData;
            gvRequirements.DataBind();
        }

        // =============================================
        // טעינת היסטוריה
        // =============================================
        private void LoadHistory()
        {
            var history = _departmentManager.GetDepartmentHistory(DepartmentID, 30);

            var chartData = new
            {
                labels = history.Select(h => h.CalculationDate.ToString("dd/MM")).Reverse().ToArray(),
                values = history.Select(h => (double)h.ReadinessScore).Reverse().ToArray()
            };

            hfHistoryData.Value = JsonConvert.SerializeObject(chartData);
        }

        // =============================================
        // Event Handlers
        // =============================================

        protected void btnSearchEmployee_Click(object sender, EventArgs e)
        {
            LoadEmployees(txtSearchEmployee.Text);
        }

        protected void btnGetRecommendations_Click(object sender, EventArgs e)
        {
            // קבלת המלצות AI לכל הפערים הקריטיים
            var gaps = _departmentManager.GetDepartmentGaps(DepartmentID);
            var criticalGaps = gaps.Where(g => g.CriticalityLevel == "Critical").ToList();

            if (criticalGaps.Any())
            {
                // לצורך הדוגמה - ניקח את הפער הראשון
                var firstGap = criticalGaps.First();

                using (var context = new ComplianceCenterEntities())
                {
                    var certType = context.CertificationTypes
                        .FirstOrDefault(ct => ct.CertificationName == firstGap.CertificationName);

                    if (certType != null)
                    {
                        var suggestions = _aiEngine.SuggestReplacements(DepartmentID, certType.CertificationTypeID,null,null);

                        rptRecommendations.DataSource = suggestions.Take(5);
                        rptRecommendations.DataBind();

                        pnlRecommendations.Visible = true;
                    }
                }
            }
        }

        protected void btnSuggestReplacement_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            int certificationTypeId = Convert.ToInt32(btn.CommandArgument);

            var suggestions = _aiEngine.SuggestReplacements(DepartmentID, certificationTypeId,null,null);

            rptRecommendations.DataSource = suggestions.Take(5);
            rptRecommendations.DataBind();

            pnlRecommendations.Visible = true;
        }

        protected void btnCloseRecommendations_Click(object sender, EventArgs e)
        {
            pnlRecommendations.Visible = false;
        }

        // =============================================
        // Helper Methods
        // =============================================

        protected string GetEmployeeStatusIcon(object isCompliantObj)
        {
            if (isCompliantObj == null) return "";

            bool isCompliant = Convert.ToBoolean(isCompliantObj);

            if (isCompliant)
            {
                return "<i class='fas fa-circle-check text-success fa-lg'></i>";
            }
            else
            {
                return "<i class='fas fa-circle-xmark text-danger fa-lg'></i>";
            }
        }

        protected string GetCriticalityBadge(string level)
        {
            switch (level)
            {
                case "Critical":
                    return "<span class='badge bg-danger'>קריטי</span>";
                case "High":
                    return "<span class='badge bg-warning'>גבוה</span>";
                case "Medium":
                    return "<span class='badge bg-info'>בינוני</span>";
                case "Low":
                    return "<span class='badge bg-secondary'>נמוך</span>";
                default:
                    return "<span class='badge bg-secondary'>לא ידוע</span>";
            }
        }

        protected string GetStatusBadge(string status)
        {
            switch (status)
            {
                case "Critical":
                    return "<span class='badge bg-danger fs-6'><i class='fas fa-circle-xmark'></i> קריטי</span>";
                case "Warning":
                    return "<span class='badge bg-warning fs-6'><i class='fas fa-triangle-exclamation'></i> אזהרה</span>";
                case "Attention":
                    return "<span class='badge bg-info fs-6'><i class='fas fa-circle-exclamation'></i> תשומת לב</span>";
                case "OK":
                    return "<span class='badge bg-success fs-6'><i class='fas fa-circle-check'></i> תקין</span>";
                default:
                    return "<span class='badge bg-secondary fs-6'>לא ידוע</span>";
            }
        }

        protected string GetScoreClass()
        {
            var readiness = _departmentManager.GetDepartmentReadiness(DepartmentID);
            if (readiness == null) return "score-default";

            if (readiness.ReadinessScore >= 90) return "score-excellent";
            if (readiness.ReadinessScore >= 75) return "score-good";
            if (readiness.ReadinessScore >= 50) return "score-warning";
            return "score-critical";
        }

        private void ShowError(string message)
        {
            System.Diagnostics.Debug.WriteLine($"Error: {message}");
            // כאן אפשר להוסיף Toast או Alert למשתמש
        }

        // =============================================
        // Cleanup
        // =============================================
        protected override void OnUnload(EventArgs e)
        {
            _departmentManager?.Dispose();
            _employeeManager?.Dispose();
            _certificationManager?.Dispose();
            _aiEngine?.Dispose();
            base.OnUnload(e);
        }
    }
}