
using ComplianceCenter.BLL.Managers;
using ComplianceCenter.Controls;
using ComplianceCenter.DAL;
using ComplianceCenter.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ComplianceCenter.Pages
{
    public partial class EmployeeProfile : System.Web.UI.Page
    {
        private EmployeeManager _employeeManager;
        private CertificationManager _certificationManager;
        private ShiftManager _shiftManager;

        private int EmployeeID
        {
            get
            {
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int id))
                    return id;
                return 0;
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            // הגדרת EmployeeID
            SmartCertUpload.EmployeeID = EmployeeID;

            // רישום לאירוע שמירה
            // ודא שהמנוי נעשה בכל בקשה, לפני שלב ה-postback events
            SmartCertUpload.CertificationSaved += SmartCertUpload_CertificationSaved;
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
            if (EmployeeID == 0)
            {
                Response.Redirect("Dashboard.aspx");
                return;
            }

            // אתחול Managers
            _employeeManager = new EmployeeManager();
            _certificationManager = new CertificationManager();
            _shiftManager = new ShiftManager();

            if (!IsPostBack)
            {
                LoadEmployeeProfile();
                LoadDropDowns();


            }
        }

        private void SmartCertUpload_CertificationSaved(object sender, EventArgs e)
        {
            // רענון דף או רשימת הסמכות
            LoadCertifications();
        }

        // =============================================
        // טעינת פרופיל עובד מלא
        // =============================================
        private void LoadEmployeeProfile()
        {
            try
            {
                var employee = _employeeManager.GetEmployeeById(EmployeeID);
                if (employee == null)
                {
                    ShowError("עובד לא נמצא");
                    Response.Redirect("Dashboard.aspx");
                    return;
                }

                // מידע בסיסי
                LoadBasicInfo(employee);

                // סטטיסטיקות
                LoadStatistics(employee);

                // הסמכות
                LoadCertifications();

                // ציר זמן
                LoadTimeline();


                // היסטוריה
                LoadHistory();
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בטעינת פרופיל: {ex.Message}");
            }
        }

        // =============================================
        // טעינת מידע בסיסי
        // =============================================
        private void LoadBasicInfo(Employee employee)
        {
            // שם
            lblEmployeeName.Text = employee.FullName;
            lblEmployeeNumber.Text = employee.EmployeeNumber;
            lblDepartment.Text = employee.Department.DepartmentName;
            lblPosition.Text = employee.PositionTitle ?? "לא צוין";

            // ותק
            var seniority = _employeeManager.GetEmployeeSeniority(employee.EmployeeID);
            lblSeniority.Text = FormatSeniority(seniority);

            // תמונה
            if (!string.IsNullOrEmpty(employee.PhotoFileName) && File.Exists(Server.MapPath($"~/Uploads/avatars/{employee.PhotoFileName}")))
            {
                imgEmployeePhoto.ImageUrl = $"~/Uploads/avatars/{employee.PhotoFileName}";
            }
            else
            {
                imgEmployeePhoto.ImageUrl = "~/Uploads/avatars/default-avatar.png";
            }

            // בדיקה אם העובד נוכח   

            var isOnShift = _shiftManager.IsEmployeeOnShift(EmployeeID);

            var colorClass = isOnShift ? "text-success" : "text-danger"; // Bootstrap classes

       
            iconUser.Attributes["class"] = $"fas fa-user {colorClass}";
        }


        private string FormatSeniority(TimeSpan seniority)
        {
            var years = (int)seniority.TotalDays / 365;
            var months = ((int)seniority.TotalDays % 365) / 30;

            if (years > 0)
                return $"{years} שנים, {months} חודשים";
            if (months > 0)
                return $"{months} חודשים";
            return $"{(int)seniority.TotalDays} ימים";
        }

        // =============================================
        // טעינת סטטיסטיקות
        // =============================================
        private void LoadStatistics(Employee employee)
        {
            var allCerts = _employeeManager.GetEmployeeCertifications(EmployeeID);
            var activeCerts = allCerts.Where(c => c.Status == "Active" && c.ExpiryDate > DateTime.Now).ToList();
            var expiredCerts = allCerts.Where(c => c.Status == "Active" && c.ExpiryDate <= DateTime.Now).ToList();
            var expiringSoon = allCerts.Where(c => c.Status == "Active" &&
                                                  c.ExpiryDate > DateTime.Now &&
                                                  c.ExpiryDate <= DateTime.Now.AddDays(30)).ToList();

            // דרישות המחלקה
            var requirements = _certificationManager.GetDepartmentRequirements(employee.DepartmentID);
            var missingCount = 0;

            foreach (var req in requirements)
            {
                if (!activeCerts.Any(c => c.CertificationTypeID == req.CertificationTypeID))
                {
                    missingCount++;
                }
            }

            // עדכון Labels
            lblActiveCerts.Text = activeCerts.Count.ToString();
            lblExpiredCerts.Text = expiredCerts.Count.ToString();
            lblExpiringSoon.Text = expiringSoon.Count.ToString();
            lblMissingCerts.Text = missingCount.ToString();

            // סטטוס כללי
            if (expiredCerts.Any() || missingCount > 0)
            {
                lblComplianceStatus.Text = "<span class='badge bg-danger fs-5'><i class='fas fa-circle-xmark'></i> לא כשיר</span>";
            }
            else if (expiringSoon.Any())
            {
                lblComplianceStatus.Text = "<span class='badge bg-warning fs-5'><i class='fas fa-triangle-exclamation'></i> דרוש ריענון</span>";
            }
            else
            {
                lblComplianceStatus.Text = "<span class='badge bg-success fs-5'><i class='fas fa-circle-check'></i> כשיר</span>";
            }

            lblCertCount.Text = $"<small class='text-muted'>{activeCerts.Count} מתוך {requirements.Count} הסמכות נדרשות</small>";
        }

        // =============================================
        // טעינת הסמכות
        // =============================================
        private void LoadCertifications()
        {
            var certifications = _employeeManager.GetEmployeeCertifications(EmployeeID);

            var certData = certifications.Select(c => new
            {
                c.EmployeeCertificationID,
                c.CertificationType.CertificationName,
                c.CertificationType.CriticalityLevel,
                c.CertificateNumber,
                c.IssueDate,
                c.ExpiryDate,
                c.Status,
                c.FileType,
                c.CertificateFileName,
                c.ModifiedDate,
                c.CreatedDate
            }).OrderBy(c => c.ExpiryDate).ToList();

            gvCertifications.DataSource = certData;
            gvCertifications.DataBind();
        }

        // =============================================
        // טעינת ציר זמן
        // =============================================
        private void LoadTimeline()
        {
            var certifications = _employeeManager.GetEmployeeCertifications(EmployeeID)
                .OrderByDescending(c => c.IssueDate)
                .Select(c => new
                {
                    c.CertificationType.CertificationName,
                    c.IssueDate,
                    c.ExpiryDate
                })
                .ToList();

            rptTimeline.DataSource = certifications;
            rptTimeline.DataBind();
        }

       
        
        // =============================================
        // טעינת היסטוריה
        // =============================================
        private void LoadHistory()
        {
            using (var context = new ComplianceCenterEntities())
            {
                var history = context.AuditLogs
                    .Where(al => al.TableName == "EmployeeCertifications"
                        || al.TableName == "Employees")
                    .OrderByDescending(al => al.CreatedDate)
                    .Take(20)
                    .Select(al => new
                    {
                        al.CreatedDate,
                        al.Action,
                        al.UserName,
                        Details = al.NewValue ?? al.OldValue
                    })
                    .ToList();

                gvHistory.DataSource = history;
                gvHistory.DataBind();
            }
        }

        // =============================================
        // טעינת DropDowns
        // =============================================
        private void LoadDropDowns()
        {
            // סוגי הסמכות
            var certTypes = _certificationManager.GetAllCertificationTypes();
            ddlCertificationType.DataSource = certTypes;
            ddlCertificationType.DataTextField = "CertificationName";
            ddlCertificationType.DataValueField = "CertificationTypeID";
            ddlCertificationType.DataBind();
            ddlCertificationType.Items.Insert(0, new ListItem("-- בחר סוג הסמכה --", "0"));

           
        }

        // =============================================
        // Event Handlers - GridView Commands
        // =============================================

        protected void gvCertifications_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var arg = Convert.ToString(e.CommandArgument);

            if (e.CommandName == "Preview")
            {
                // פתח את הקובץ המצורף
                PreviewFile(arg);//certificateFileName
            }
            else if (e.CommandName == "Renew")
            {
                // פתח מודל לריענון
                RenewCertification(Convert.ToInt32(arg));//certId
            }
        }

        
        // =============================================
        // שמירת הסמכה חדשה
        // =============================================
        protected void btnSaveCertification_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddlCertificationType.SelectedValue == "0")
                {
                    ShowError("יש לבחור סוג הסמכה");
                    return;
                }

                var certification = new EmployeeCertification
                {
                    EmployeeCertificationID = Convert.ToInt32(hfEmployeeCertificationID.Value),
                    EmployeeID = EmployeeID,
                    CertificationTypeID = Convert.ToInt32(ddlCertificationType.SelectedValue),
                    CertificateNumber = txtCertificateNumber.Text,
                    IssueDate = Convert.ToDateTime(txtIssueDate.Text),
                    ExpiryDate = Convert.ToDateTime(txtExpiryDate.Text),
                    Status = "Active",
                    Notes = txtNotes.Text,
                    CreatedDate = DateTime.Now
                };

                _employeeManager.SaveCertification(certification);

                // Audit Log
                LogAction("INSERT", "EmployeeCertifications", certification.EmployeeCertificationID,
                    $"הוספת הסמכה: {ddlCertificationType.SelectedItem.Text}");

                // רענון
                LoadCertifications();
                LoadStatistics(_employeeManager.GetEmployeeById(EmployeeID));

                ShowSuccess("ההסמכה נשמרה בהצלחה");

                // ניקוי טופס
                ClearCertificationForm();
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בשמירת הסמכה: {ex.Message}");
            }
        }

        

        private void RenewCertification(int certId)
        {
            // פתיחת מודל ריענון
            var cert = _employeeManager.GetEmployeeCertifications(EmployeeID)
                .FirstOrDefault(c => c.EmployeeCertificationID == certId);

            if (cert != null)
            {
                // טעינת נתונים לטופס
                hfEmployeeCertificationID.Value = cert.EmployeeCertificationID.ToString();
                ddlCertificationType.SelectedValue = cert.CertificationTypeID.ToString();
                txtCertificateNumber.Text = cert.CertificateNumber;
                txtIssueDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                // חישוב תאריך פקיעה חדש
                var validityMonths = cert.CertificationType.ValidityPeriodMonths;
                txtExpiryDate.Text = DateTime.Now.AddMonths(validityMonths).ToString("yyyy-MM-dd");

                // פתיחת המודל
                ScriptManager.RegisterStartupScript(this, GetType(), "showModal",
                    "$('#updateCertModal').modal('show');", true);
            }
        }

       
        // =============================================
        // תצוגה מקדימה של קובץ (עדכון מלא)
        // =============================================
        private void PreviewFile(string certificateFileName)
        {
            try
            {
                // בדיקת תקינות שם קובץ
                if (string.IsNullOrEmpty(certificateFileName))
                {
                    ShowError("שם קובץ לא תקין");
                    return;
                }

                // בדיקה אם הקובץ קיים
                var physicalPath = Server.MapPath($"~/Uploads/Certificates/{certificateFileName}");
                if (!File.Exists(physicalPath))
                {
                    ShowError("הקובץ לא קיים במערכת");
                    return;
                }

                // הכנת URL לתצוגה מקדימה
                var fileUrl = ResolveUrl($"~/Uploads/Certificates/{certificateFileName}");
                var fileName = certificateFileName;
                var fileType = Path.GetExtension(fileName).ToLower();

                // שמירה ב-Hidden Fields
                hdnPreviewFileUrl.Value = fileUrl;
                hdnPreviewFileName.Value = fileName;
                hdnPreviewFileType.Value = fileType;

              
                 // בריחה ידנית של backslashes ו‑single quotes
                var jsFileUrl = fileUrl?.Replace("\\", "\\\\").Replace("'", "\\'") ?? "";
                var jsFileName = (fileName ?? "").Replace("'", "\\'");
                var jsFileType = (fileType ?? "").Replace("'", "\\'");

                // קריאה ל-JavaScript לפתיחת ה-Modal
                var script = $@"
                    openFilePreview(
                        '{jsFileUrl}',
                        '{jsFileName}',
                        '{jsFileType}'
                    );
                ";
                 

                ScriptManager.RegisterStartupScript(this, GetType(), "OpenPreview", script, true);
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בתצוגה מקדימה: {ex.Message}");
                LogError(ex);
            }
        }

       


        // =============================================
        // רישום שגיאות (אם עדיין לא קיים)
        // =============================================
        private void LogError(Exception ex)
        {
            try
            {
                var logFolder = Server.MapPath("~/Logs/");
                if (!Directory.Exists(logFolder))
                    Directory.CreateDirectory(logFolder);

                var logFile = Path.Combine(logFolder, $"errors_{DateTime.Now:yyyyMMdd}.txt");
                var errorText = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {ex.GetType().Name}: {ex.Message}\n{ex.StackTrace}\n\n";

                File.AppendAllText(logFile, errorText);
            }
            catch { }
        }

        // =============================================
        // Helper Methods
        // =============================================

        protected string GetCertStatusIcon(object expiryDateObj, object statusObj)
        {
            if (expiryDateObj == null || statusObj == null) return "";

            var expiryDate = Convert.ToDateTime(expiryDateObj);
            var status = statusObj.ToString();

            if (status != "Active") return "<i class='fas fa-ban text-secondary fa-lg'></i>";

            if (expiryDate < DateTime.Now)
                return "<i class='fas fa-circle-xmark text-danger fa-lg' title='פג תוקף'></i>";

            if (expiryDate <= DateTime.Now.AddDays(7))
                return "<i class='fas fa-triangle-exclamation text-danger fa-lg' title='פוקע בקרוב!'></i>";

            if (expiryDate <= DateTime.Now.AddDays(30))
                return "<i class='fas fa-clock text-warning fa-lg' title='פוקע בחודש הקרוב'></i>";

            return "<i class='fas fa-circle-check text-success fa-lg' title='תקף'></i>";
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
                    return string.Empty;
            }
        }

        protected string GetDaysRemaining(DateTime expiryDate)
        {
            var days = (expiryDate - DateTime.Now).Days;

            if (days < 0) return $"פג לפני {Math.Abs(days)} ימים";
            if (days == 0) return "פוקע היום!";
            return $"{days} ימים";
        }

        protected string GetDaysRemainingClass(DateTime expiryDate)
        {
            var days = (expiryDate - DateTime.Now).Days;

            if (days < 0) return "badge bg-danger";
            if (days <= 7) return "badge bg-danger";
            if (days <= 30) return "badge bg-warning";
            return "badge bg-success";
        }

        protected string GetPercentRemaining(DateTime issueDate, DateTime expiryDate)
        {
            var totalDays = (expiryDate - issueDate).TotalDays;
            if (totalDays <= 0) return "0";

            var daysRemaining = (expiryDate - DateTime.Now).TotalDays;
            var percent = (daysRemaining / totalDays) * 100;

            return Math.Max(0, Math.Min(100, percent)).ToString("F0");
        }

        protected string GetProgressBarClass(DateTime issueDate, DateTime expiryDate)
        {
            var percent = double.Parse(GetPercentRemaining(issueDate, expiryDate));

            if (percent <= 10) return "bg-danger";
            if (percent <= 30) return "bg-warning";
            return "bg-success";
        }

        protected string GetTimelineMarkerClass(DateTime expiryDate)
        {
            if (expiryDate < DateTime.Now) return "timeline-marker-expired";
            if (expiryDate <= DateTime.Now.AddDays(30)) return "timeline-marker-warning";
            return "timeline-marker-active";
        }

        protected string GetTimelineStatus(DateTime expiryDate)
        {
            if (expiryDate < DateTime.Now)
                return "<span class='badge bg-danger'>פג תוקף</span>";
            if (expiryDate <= DateTime.Now.AddDays(30))
                return "<span class='badge bg-warning'>פוקע בקרוב</span>";
            return "<span class='badge bg-success'>תקף</span>";
        }

        protected string GetFileIcon(string fileType)
        {
            switch (fileType)
            {
                case "pdf":
                    return "fas fa-file-pdf";
                case "jpg":
                case "jpeg":
                case "png":
                    return "fas fa-file-image";
                default:
                    return "fas fa-file";
            }
        }

        protected string FormatFileSize(int bytes)
        {
            if (bytes < 1024) return $"{bytes} B";
            if (bytes < 1024 * 1024) return $"{bytes / 1024:F2} KB";
            return $"{bytes / (1024 * 1024):F2} MB";
        }

        // =============================================
        // Logging & Messages
        // =============================================

        private void LogAction(string action, string tableName, int recordId, string details)
        {
            using (var context = new ComplianceCenterEntities())
            {
                var log = new AuditLog
                {
                    UserID = Session["UserID"] != null ? (int?)Convert.ToInt32(Session["UserID"]) : null,
                    UserName = Session["UserName"]?.ToString(),
                    Action = action,
                    TableName = tableName,
                    RecordID = recordId,
                    NewValue = details,
                    IPAddress = Request.UserHostAddress,
                    CreatedDate = DateTime.Now
                };

                context.AuditLogs.Add(log);
                context.SaveChanges();
            }
        }

        private void ClearCertificationForm()
        {
            ddlCertificationType.SelectedIndex = 0;
            txtCertificateNumber.Text = "";
            txtIssueDate.Text = "";
            txtExpiryDate.Text = "";
            txtNotes.Text = "";

            ScriptManager.RegisterStartupScript(this, GetType(), "ResetControl",
               "resetSmartUpload();", true);
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showError",
                $"alert('שגיאה: {message}');", true);
        }

        private void ShowSuccess(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showSuccess",
                $"alert('{message}');", true);
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            if (Request.UrlReferrer != null)
                Response.Redirect(Request.UrlReferrer.ToString());
            else
                Response.Redirect("Dashboard.aspx");
        }

        // =============================================
        // Cleanup
        // =============================================
        protected override void OnUnload(EventArgs e)
        {
            _employeeManager?.Dispose();
            _certificationManager?.Dispose();
            base.OnUnload(e);
        }
    }
}