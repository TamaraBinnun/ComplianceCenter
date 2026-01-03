

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using ComplianceCenter.DAL;
using ComplianceCenter.Models;

namespace ComplianceCenter.Pages
{
    public partial class Replacements : System.Web.UI.Page
    {
        private ComplianceCenterEntities db = new ComplianceCenterEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDepartments();
                LoadShifts();
                SetDefaultDate();
            }
        }

       
        private void LoadDepartments()
        {
            try
            {
                var departments = db.Departments
                    .Where(d => d.IsActive)
                    .OrderBy(d => d.DepartmentName)
                    .Select(d => new
                    {
                        d.DepartmentID,
                        d.DepartmentName
                    })
                    .ToList();

                ddlDepartment.DataSource = departments;
                ddlDepartment.DataTextField = "DepartmentName";
                ddlDepartment.DataValueField = "DepartmentID";
                ddlDepartment.DataBind();

                ddlDepartment.Items.Insert(0, new ListItem("-- בחר מחלקה --", "0"));

                if (departments.Any())
                {
                    ddlDepartment.SelectedIndex = 1;
                    LoadCertifications();
                }
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בטעינת מחלקות: {ex.Message}");
            }
        }

        protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCertifications();
        }

        private void LoadCertifications()
        {
            try
            {
                int deptId = Convert.ToInt32(ddlDepartment.SelectedValue);

                if (deptId == 0)
                {
                    ddlCertification.Items.Clear();
                    ddlCertification.Items.Add(new ListItem("-- בחר מחלקה תחילה --", "0"));
                    return;
                }

                var certifications = (from dr in db.DepartmentRequirements
                                      join ct in db.CertificationTypes
                                          on dr.CertificationTypeID equals ct.CertificationTypeID
                                      where dr.DepartmentID == deptId && dr.IsActive
                                      orderby ct.CriticalityLevel descending, ct.CertificationName
                                      select new
                                      {
                                          ct.CertificationTypeID,
                                          DisplayName = ct.CertificationName + " (" + ct.CriticalityLevel + ")"
                                      }).ToList();

                ddlCertification.DataSource = certifications;
                ddlCertification.DataTextField = "DisplayName";
                ddlCertification.DataValueField = "CertificationTypeID";
                ddlCertification.DataBind();

                ddlCertification.Items.Insert(0, new ListItem("-- בחר הסמכה --", "0"));
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בטעינת הסמכות: {ex.Message}");
            }
        }

        private void LoadShifts()
        {
            try
            {
                var shifts = db.Shifts
                    .Where(s => s.IsActive)
                    .OrderBy(s => s.StartTime)
                    .Select(s => new
                    {
                        s.ShiftID,
                        DisplayName = s.ShiftName + " (" +
                            s.StartTime.ToString().Substring(0, 5) + " - " +
                            s.EndTime.ToString().Substring(0, 5) + ")"
                    })
                    .ToList();

                ddlShift.DataSource = shifts;
                ddlShift.DataTextField = "DisplayName";
                ddlShift.DataValueField = "ShiftID";
                ddlShift.DataBind();

                ddlShift.Items.Insert(0, new ListItem("-- כל המשמרות --", "0"));
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בטעינת משמרות: {ex.Message}");
            }
        }

        private void SetDefaultDate()
        {
            txtShiftDate.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            SearchReplacements();
        }

        private void SearchReplacements()
        {
            try
            {
                if (ddlDepartment.SelectedValue == "0")
                {
                    ShowError("יש לבחור מחלקה");
                    return;
                }

                if (ddlCertification.SelectedValue == "0")
                {
                    ShowError("יש לבחור הסמכה נדרשת");
                    return;
                }

                DateTime shiftDate;
                if (!DateTime.TryParse(txtShiftDate.Text, out shiftDate))
                {
                    ShowError("תאריך לא תקין");
                    return;
                }

                int deptId = Convert.ToInt32(ddlDepartment.SelectedValue);
                int certId = Convert.ToInt32(ddlCertification.SelectedValue);
                int? shiftId = ddlShift.SelectedValue != "0" ?
                    (int?)Convert.ToInt32(ddlShift.SelectedValue) : null;

                // קריאה לפרוצדורה הסופית - עם כל השדות החדשים!
                var results = db.Database.SqlQuery<ReplacementSuggestionResult>(
                    @"EXEC sp_GetReplacementSuggestions 
                        @DepartmentID, 
                        @RequiredCertificationTypeID, 
                        @Date, 
                        @ShiftID, 
                        @MaxResults",
                    new System.Data.SqlClient.SqlParameter("@DepartmentID", deptId),
                    new System.Data.SqlClient.SqlParameter("@RequiredCertificationTypeID", certId),
                    new System.Data.SqlClient.SqlParameter("@Date", shiftDate),
                    new System.Data.SqlClient.SqlParameter("@ShiftID", (object)shiftId ?? DBNull.Value),
                    new System.Data.SqlClient.SqlParameter("@MaxResults", 9)
                ).ToList();

                if (results.Any())
                {
                    rptReplacements.DataSource = results;
                    rptReplacements.DataBind();
                    pnlNoResults.Visible = false;
                    resultsContainer.Visible = true;

                    var availableCount = results.Count(r => r.IsAvailable == 1);
                    ShowSuccess($"נמצאו {results.Count} מחליפים מומלצים ({availableCount} זמינים)");
                }
                else
                {
                    pnlNoResults.Visible = true;
                    resultsContainer.Visible = false;
                    rptReplacements.DataSource = null;
                    rptReplacements.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בחיפוש מחליפים: {ex.Message}");
            }
        }

        protected void rptReplacements_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                int employeeId = Convert.ToInt32(e.CommandArgument);

                switch (e.CommandName)
                {
                    case "Accept":
                        AcceptReplacement(employeeId);
                        break;
                    case "ViewDetails":
                        ViewEmployeeDetails(employeeId);
                        break;
                    case "Reject":
                        RejectReplacement(employeeId);
                        break;
                }
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בביצוע פעולה: {ex.Message}");
            }
        }

        private void AcceptReplacement(int employeeId)
        {
            try
            {
                DateTime shiftDate = DateTime.Parse(txtShiftDate.Text);
                int deptId = Convert.ToInt32(ddlDepartment.SelectedValue);
                int shiftId = Convert.ToInt32(ddlShift.SelectedValue);

                if (shiftId == 0)
                {
                    ShowError("יש לבחור משמרת ספציפית לשיבוץ");
                    return;
                }

                var assignment = new ShiftAssignment
                {
                    EmployeeID = employeeId,
                    ShiftID = shiftId,
                    DepartmentID = deptId,
                    AssignmentDate = shiftDate,
                    IsPresent = null,
                    Notes = "שובץ ע\"י מערכת AI - המלצה אוטומטית",
                    CreatedDate = DateTime.Now
                };

                db.ShiftAssignments.Add(assignment);
                db.SaveChanges();

                LogAction("AI_ACCEPT", "ShiftAssignments", assignment.AssignmentID,
                    $"אושרה החלפה - עובד {employeeId}");

                ShowSuccess("העובד שובץ בהצלחה למשמרת");
                SearchReplacements();
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בשיבוץ עובד: {ex.Message}");
            }
        }

        private void ViewEmployeeDetails(int employeeId)
        {
            Response.Redirect($"EmployeeDetails.aspx?id={employeeId}");
        }

        private void RejectReplacement(int employeeId)
        {
            try
            {
                LogAction("AI_REJECT", "ReplacementSuggestions", employeeId,
                    "המלצה נדחתה על ידי המשתמש");

                ShowSuccess("ההצעה נדחתה");
                SearchReplacements();
            }
            catch (Exception ex)
            {
                ShowError($"שגיאה בדחיית הצעה: {ex.Message}");
            }
        }

        protected string GetInitials(string fullName)
        {
            if (string.IsNullOrEmpty(fullName)) return "??";

            var parts = fullName.Split(' ');
            if (parts.Length >= 2)
                return $"{parts[0][0]}{parts[1][0]}".ToUpper();
            return fullName.Substring(0, Math.Min(2, fullName.Length)).ToUpper();
        }

        protected string GetPercentage(object score, int maxScore)
        {
            if (score == null) return "0";
            double scoreVal = Convert.ToDouble(score);
            return ((scoreVal / maxScore) * 100).ToString("F0");
        }

        private void ShowError(string message)
        {
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-danger";
            lblMessage.Text = message;
        }

        private void ShowSuccess(string message)
        {
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-success";
            lblMessage.Text = message;
        }

        private void LogAction(string action, string tableName, int recordId, string details)
        {
            try
            {
                var log = new AuditLog
                {
                    UserID = GetCurrentUserId(),
                    UserName = GetCurrentUserName(),
                    Action = action,
                    TableName = tableName,
                    RecordID = recordId,
                    NewValue = details,
                    IPAddress = Request.UserHostAddress,
                    UserAgent = Request.UserAgent,
                    CreatedDate = DateTime.Now
                };

                db.AuditLogs.Add(log);
                db.SaveChanges();
            }
            catch { }
        }

        private int GetCurrentUserId()
        {
            return Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 1;
        }

        private string GetCurrentUserName()
        {
            return Session["UserName"]?.ToString() ?? "System";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        //protected override void Dispose(bool disposing)
        //{
        //    if (disposing)
        //    {
        //        db?.Dispose();
        //    }
        //    base.Dispose(disposing);
        //}
    }

}