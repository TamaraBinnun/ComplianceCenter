using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using ComplianceCenter.BLL.Managers;
using ComplianceCenter.DAL;

namespace ComplianceCenter.Controls
{
    public partial class SmartCertUpload : System.Web.UI.UserControl
    {
        private CertificationManager _certificationManager;
        private EmployeeManager _employeeManager;

        #region Properties

        /// <summary>
        /// מזהה העובד (חייב להיות מוגדר)
        /// </summary>
        public int EmployeeID
        {
            get
            {
                if (ViewState["EmployeeID"] != null)
                    return (int)ViewState["EmployeeID"];
                return 0;
            }
            set
            {
                ViewState["EmployeeID"] = value;
            }
        }

        #endregion

        #region Events

        /// <summary>
        /// אירוע שמופעל כאשר הסמכה נשמרת בהצלחה
        /// </summary>
        public event EventHandler CertificationSaved;

        /// <summary>
        /// אירוע שמופעל כאשר ניתוח ה-AI נכשל
        /// </summary>
        public event EventHandler AnalysisFailed;

        #endregion

        #region Page Lifecycle

        protected void Page_Load(object sender, EventArgs e)
        {
             _employeeManager = new EmployeeManager();
            _certificationManager = new CertificationManager();

            if (!IsPostBack)
            {
                LoadCertificationTypes();
                InitializeControl();
            }

            // רישום סקריפט להעברת EmployeeID ל-JavaScript
            RegisterClientScripts();
        }

        /// <summary>
        /// טעינת סוגי הסמכות ל-DropDown
        /// </summary>
        private void LoadCertificationTypes()
        {
            var certTypes = _certificationManager.GetAllCertificationTypes();

            ddlCertificationType.DataSource = certTypes;
            ddlCertificationType.DataTextField = "CertificationName";
            ddlCertificationType.DataValueField = "CertificationTypeID";
            ddlCertificationType.DataBind();
            ddlCertificationType.Items.Insert(0, new ListItem("-- בחר סוג הסמכה --", "0"));
        }

        /// <summary>
        /// אתחול הקונטרול
        /// </summary>
        private void InitializeControl()
        {
            pnlMessage.Visible = false;
            hdnAIAnalysisComplete.Value = "false";
        }

        /// <summary>
        /// רישום סקריפטים לצד הלקוח
        /// </summary>
        private void RegisterClientScripts()
        {
            // העברת EmployeeID ל-JavaScript
            var script = $@"
                <script type='text/javascript'>
                    var employeeId = {EmployeeID};
                    
                    // הוספת hidden field עבור JavaScript
                    if (!document.getElementById('hdnEmployeeId')) {{
                        var input = document.createElement('input');
                        input.type = 'hidden';
                        input.id = 'hdnEmployeeId';
                        input.value = {EmployeeID};
                        document.body.appendChild(input);
                    }}
                </script>
            ";

            Page.ClientScript.RegisterStartupScript(this.GetType(), "EmployeeIdScript", script, false);
        }

        #endregion

        #region Event Handlers

        /// <summary>
        /// שמירת הסמכה לאחר ניתוח AI ואישור משתמש
        /// </summary>
        protected void btnSaveCertification_Click(object sender, EventArgs e)
        {
            try
            {
                // ולידציות
                if (!ValidateCertificationData())
                    return;

                if (EmployeeID == 0)
                {
                    ShowError("מזהה עובד לא תקין");
                    return;
                }

                // שמירת הקובץ הקבוע
                string permanentFileName = SavePermanentFile();

                
                var certification = new EmployeeCertification
                {
                    EmployeeID = EmployeeID,
                    CertificationTypeID = Convert.ToInt32(ddlCertificationType.SelectedValue),
                    CertificateNumber = txtCertificateNumber.Text.Trim(),
                    IssueDate = Convert.ToDateTime(txtIssueDate.Text),
                    ExpiryDate = Convert.ToDateTime(txtExpiryDate.Text),
                    Status = "Active",
                    CertificateFileName = permanentFileName,
                    Notes = txtNotes.Text.Trim(),
                    CreatedDate = DateTime.Now
                };

                _employeeManager.SaveCertification(certification);

                // רישום Audit Log
                LogAction("INSERT_WITH_AI", "EmployeeCertifications", certification.EmployeeCertificationID,
                    $"הסמכה נוספה : {ddlCertificationType.SelectedItem.Text}");

                ShowSuccess("ההסמכה נשמרה בהצלחה! 🎉");

                // הפעלת אירוע
                CertificationSaved?.Invoke(this, EventArgs.Empty);


                // איפוס
                ResetControl();
                
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בשמירת הסמכה: {ex.Message}");
                LogError(ex);
            }
        }

        #endregion

        #region Validation

        /// <summary>
        /// ולידציה של נתוני הסמכה לפני שמירה
        /// </summary>
        private bool ValidateCertificationData()
        {
            if (ddlCertificationType.SelectedValue == "0")
            {
                ShowError("יש לבחור סוג הסמכה");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtCertificateNumber.Text))
            {
                ShowError("יש למלא מספר תעודה");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtIssueDate.Text))
            {
                ShowError("יש למלא תאריך הנפקה");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtExpiryDate.Text))
            {
                ShowError("יש למלא תאריך פקיעה");
                return false;
            }

            // בדיקה שתאריך פקיעה אחרי תאריך הנפקה
            DateTime issueDate, expiryDate;
            if (DateTime.TryParse(txtIssueDate.Text, out issueDate) &&
                DateTime.TryParse(txtExpiryDate.Text, out expiryDate))
            {
                if (expiryDate <= issueDate)
                {
                    ShowError("תאריך פקיעה חייב להיות אחרי תאריך הנפקה");
                    return false;
                }
            }
            else
            {
                ShowError("תאריכים לא תקינים");
                return false;
            }

            return true;
        }

        #endregion

        #region File Management

        /// <summary>
        /// שמירת הקובץ באחסון קבוע
        /// </summary>
        private string SavePermanentFile()
        {
            try
            {
                var tempFileName = hdnUploadedFileName.Value;
                if (string.IsNullOrEmpty(tempFileName))
                    return null;

                var tempFolder = Server.MapPath("~/Uploads/Temp/");
                var permanentFolder = Server.MapPath("~/Uploads/Certificates/");

                if (!Directory.Exists(permanentFolder))
                    Directory.CreateDirectory(permanentFolder);

                var tempPath = Path.Combine(tempFolder, tempFileName);
                var extension = Path.GetExtension(tempFileName);
                var permanentFileName = $"{EmployeeID}_{DateTime.Now:yyyyMMddHHmmss}_{Guid.NewGuid():N}{extension}";
                var permanentPath = Path.Combine(permanentFolder, permanentFileName);

                if (File.Exists(tempPath))
                {
                    File.Move(tempPath, permanentPath);
                    return permanentFileName;
                }

                return null;
            }
            catch (Exception ex)
            {
                LogError(ex);
                return null;
            }
        }

        #endregion

        #region UI Methods

        /// <summary>
        /// איפוס הקונטרול למצב התחלתי
        /// </summary>
        public void ResetControl()
        {
            ddlCertificationType.SelectedIndex = 0;
            txtCertificateNumber.Text = "";
            txtIssueDate.Text = "";
            txtExpiryDate.Text = "";
            txtNotes.Text = "";
            txtAIDetectedType.Text = "";
            txtAIDetectedNumber.Text = "";
            txtAIDetectedIssue.Text = "";
            txtAIDetectedExpiry.Text = "";
            txtAIRawText.Text = "";
            hdnUploadedFileName.Value = "";
            hdnAIAnalysisComplete.Value = "false";
            pnlMessage.Visible = false;

            ScriptManager.RegisterStartupScript(this, GetType(), "ResetControl",
                "resetSmartUpload();", true);
        }

        /// <summary>
        /// הצגת הודעת שגיאה
        /// </summary>
        private void ShowError(string message)
        {
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert-smart alert-danger";
            lblMessage.Text = $"<i class='fas fa-exclamation-circle'></i> {message}";

            var script = $@"
                alert('שגיאה: {message.Replace("'", "\\'")}');
        
                ";
            ScriptManager.RegisterStartupScript(this, GetType(), "showError", script, true);
        }

        
        /// <summary>
        /// הצגת הודעת הצלחה
        /// </summary>
        private void ShowSuccess(string message)
        {
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert-smart alert-success";
            lblMessage.Text = $"<i class='fas fa-check-circle'></i> {message}";

            var script = $@"
                alert('ההסמכה נשמרה בהצלחה! 🎉');
                ";
            ScriptManager.RegisterStartupScript(this, GetType(), "closeModalSuccess", script, true);
        }

        #endregion

        #region Logging

        /// <summary>
        /// רישום פעולה ב-Audit Log
        /// </summary>
        private void LogAction(string action, string tableName, int recordId, string details)
        {
            try
            {
                using (var context = new ComplianceCenterEntities())
                {
                    var log = new AuditLog
                    {
                        UserID = Session["UserID"] != null ? (int?)Convert.ToInt32(Session["UserID"]) : null,
                        UserName = Session["UserName"]?.ToString() ?? "System",
                        Action = action,
                        TableName = tableName,
                        RecordID = recordId,
                        NewValue = details,
                        IPAddress = Page.Request.UserHostAddress,
                        UserAgent = Page.Request.UserAgent,
                        CreatedDate = DateTime.Now
                    };

                    context.AuditLogs.Add(log);
                    context.SaveChanges();
                }
            }
            catch { }
        }

        /// <summary>
        /// רישום שגיאות לקובץ
        /// </summary>
        private void LogError(Exception ex)
        {
            try
            {
                var logFolder = Server.MapPath("~/Logs/");
                if (!Directory.Exists(logFolder))
                    Directory.CreateDirectory(logFolder);

                var logFile = Path.Combine(logFolder, $"smart_cert_upload_{DateTime.Now:yyyyMMdd}.txt");
                var errorText = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {ex.GetType().Name}: {ex.Message}\n{ex.StackTrace}\n\n";

                File.AppendAllText(logFile, errorText);
            }
            catch { }
        }

        #endregion

        #region Cleanup

        protected override void OnUnload(EventArgs e)
        {
            _certificationManager?.Dispose();
            base.OnUnload(e);
        }

        #endregion
    }
}