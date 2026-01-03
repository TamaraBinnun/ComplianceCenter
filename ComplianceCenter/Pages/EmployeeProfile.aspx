<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeProfile.aspx.cs" Inherits="ComplianceCenter.Pages.EmployeeProfile" %>

<%@ Register Src="~/Controls/SmartCertUpload.ascx" TagPrefix="uc1" TagName="SmartCertUpload" %>




<!DOCTYPE html>
<html lang="he" dir="rtl">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>פרופיל עובד - מרכז בקרה לכשירות משמרת</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.rtl.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="../Styles/FilePreview.css" rel="stylesheet" />

</head>
<body>
    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
            <div class="container-fluid">
                <a class="navbar-brand" href="Dashboard.aspx">
                    <i class="fas fa-shield-alt me-2"></i>
                    מרכז בקרה לכשירות משמרת
                </a>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <asp:LinkButton ID="btnBack" runat="server" CssClass="nav-link" OnClick="btnBack_Click">
                            <i class="fas fa-arrow-right"></i> חזרה
                        </asp:LinkButton>
                    </li>
                </ul>
            </div>
        </nav>

        <div class="container-fluid mt-4">
            <asp:UpdatePanel ID="UpdatePanelMain" runat="server">
                <ContentTemplate>

                    <!-- Employee Header Card -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-md-2 text-center">
                                            <div class="employee-avatar mb-3">
                                                <asp:Image ID="imgEmployeePhoto" runat="server" 
                                                    CssClass="rounded-circle" 
                                                    Width="120" Height="120"
                                                    AlternateText="תמונת עובד" />
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <h2 class="mb-2">
                                                <i id="iconUser" runat="server" class="fas fa-user"></i>

                                                <asp:Label ID="lblEmployeeName" runat="server"></asp:Label>
                                            </h2>
                                            <div class="employee-details">
                                                <p class="mb-1">
                                                    <strong>מספר עובד:</strong>
                                                    <asp:Label ID="lblEmployeeNumber" runat="server"></asp:Label>
                                                </p>
                                                <p class="mb-1">
                                                    <strong>מחלקה:</strong>
                                                    <asp:Label ID="lblDepartment" runat="server"></asp:Label>
                                                </p>
                                                <p class="mb-1">
                                                    <strong>תפקיד:</strong>
                                                    <asp:Label ID="lblPosition" runat="server"></asp:Label>
                                                </p>
                                                <p class="mb-0">
                                                    <strong>ותק:</strong>
                                                    <asp:Label ID="lblSeniority" runat="server"></asp:Label>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <div class="employee-status-card">
                                                <h5 class="mb-3">סטטוס כשירות</h5>
                                                <asp:Label ID="lblComplianceStatus" runat="server" CssClass="status-badge-large"></asp:Label>
                                                <div class="mt-3">
                                                    <asp:Label ID="lblCertCount" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Stats Row -->
                    <div class="row mb-4">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body text-center">
                                    <i class="fas fa-certificate fa-2x text-success mb-2"></i>
                                    <h3 class="mb-0">
                                        <asp:Label ID="lblActiveCerts" runat="server"></asp:Label>
                                    </h3>
                                    <p class="text-muted mb-0 small">הסמכות פעילות</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body text-center">
                                    <i class="fas fa-clock-rotate-left fa-2x text-danger mb-2"></i>
                                    <h3 class="mb-0">
                                        <asp:Label ID="lblExpiredCerts" runat="server"></asp:Label>
                                    </h3>
                                    <p class="text-muted mb-0 small">הסמכות שפג תוקפן</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body text-center">
                                    <i class="fas fa-hourglass-half fa-2x text-warning mb-2"></i>
                                    <h3 class="mb-0">
                                        <asp:Label ID="lblExpiringSoon" runat="server"></asp:Label>
                                    </h3>
                                    <p class="text-muted mb-0 small">פוקעות בחודש הקרוב</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body text-center">
                                    <i class="fas fa-triangle-exclamation fa-2x text-info mb-2"></i>
                                    <h3 class="mb-0">
                                        <asp:Label ID="lblMissingCerts" runat="server"></asp:Label>
                                    </h3>
                                    <p class="text-muted mb-0 small">הסמכות חסרות</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Main Content Tabs -->
                    <div class="row">
                        <div class="col-12">
                            <ul class="nav nav-tabs" role="tablist">
                                <li class="nav-item">
                                    <button type="button" class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabCertifications">
                                        <i class="fas fa-certificate"></i> הסמכות והדרכות
                                    </button>
                                </li>
                                <li class="nav-item">
                                    <button type="button" class="nav-link" data-bs-toggle="tab" data-bs-target="#tabTimeline">
                                        <i class="fas fa-timeline"></i> ציר זמן
                                    </button>
                                </li>
                                <li class="nav-item">
                                    <button type="button" class="nav-link" data-bs-toggle="tab" data-bs-target="#tabHistory">
                                        <i class="fas fa-history"></i> היסטוריה
                                    </button>
                                </li>
                            </ul>

                            <div class="tab-content border border-top-0 p-4 bg-white shadow-sm">
                                
                                <!-- Tab 1: Certifications -->
                                <div class="tab-pane fade show active" id="tabCertifications">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5 class="mb-0">הסמכות והדרכות</h5>
                                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCertModal">
                                            <i class="fas fa-plus"></i> הוסף הסמכה
                                        </button>
                                    </div>

                                    <asp:GridView ID="gvCertifications" runat="server" CssClass="table table-hover" 
                                        AutoGenerateColumns="false" GridLines="None" OnRowCommand="gvCertifications_RowCommand">
                                        <Columns>
                                            <asp:TemplateField HeaderText="סטטוס">
                                                <ItemTemplate>
                                                    <%# GetCertStatusIcon(Eval("ExpiryDate"), Eval("Status")) %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="CertificationName" HeaderText="שם ההסמכה" />
                                            <asp:TemplateField HeaderText="קריטיות">
                                                <ItemTemplate>
                                                    <%# GetCriticalityBadge((string)Eval("CriticalityLevel")) %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="CertificateNumber" HeaderText="מספר תעודה" />
                                            <asp:TemplateField HeaderText="תאריך הנפקה">
                                                <ItemTemplate>
                                                    <%# ((DateTime)Eval("IssueDate")).ToString("dd/MM/yyyy") %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="תוקף עד">
                                                <ItemTemplate>
                                                    <%# ((DateTime)Eval("ExpiryDate")).ToString("dd/MM/yyyy") %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="ימים נותרים">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblDaysRemaining" runat="server" 
                                                        Text='<%# GetDaysRemaining((DateTime)Eval("ExpiryDate")) %>'
                                                        CssClass='<%# GetDaysRemainingClass((DateTime)Eval("ExpiryDate")) %>'>
                                                    </asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="% נותר">
                                                <ItemTemplate>
                                                    <div class="progress" style="height: 20px;">
                                                        <div class="progress-bar <%# GetProgressBarClass((DateTime)Eval("IssueDate"), (DateTime)Eval("ExpiryDate")) %>" 
                                                             style="width: <%# GetPercentRemaining((DateTime)Eval("IssueDate"), (DateTime)Eval("ExpiryDate")) %>%">
                                                            <%# GetPercentRemaining((DateTime)Eval("IssueDate"), (DateTime)Eval("ExpiryDate")) %>%
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                          
                                          <asp:TemplateField HeaderText="תאריך העלאה">
                                              <ItemTemplate>
                                                  <%# ((DateTime)Eval("CreatedDate")).ToString("dd/MM/yyyy HH:mm") %>
                                              </ItemTemplate>
                                          </asp:TemplateField>
                                            <asp:TemplateField HeaderText="תאריך עדכון אחרון">
                                                <ItemTemplate>
                                                    <%# ((DateTime)Eval("CreatedDate")).ToString("dd/MM/yyyy HH:mm") %>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="פעולות">
                                                <ItemTemplate>

                                                    <asp:LinkButton ID="btnPreview" runat="server"
                                                        CssClass="btn btn-sm btn-outline-primary me-1"
                                                        CommandName="Preview"
                                                        CommandArgument='<%# Eval("CertificateFileName") %>'
                                                        Enabled='<%# !String.IsNullOrEmpty(Eval("CertificateFileName") as string) %>'>
   
                                                        <i class='<%# 
                                                        String.IsNullOrEmpty(Eval("CertificateFileName") as string) 
                                                            ? "fas fa-file fa-2x text-muted disabled-icon" 
                                                            : GetFileIcon((string)Eval("FileType")) + " fa-2x" 
                                                    %>' aria-hidden="true"></i>

                                                    </asp:LinkButton>

                                                   
                                                    <asp:LinkButton ID="btnRenew" runat="server" CssClass="btn btn-sm btn-outline-success"
                                                        CommandName="Renew" CommandArgument='<%# Eval("EmployeeCertificationID") %>'>
                                                        <i class="fas fa-edit fa-2x"></i>

                                                    </asp:LinkButton>
                                                    
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <div class="text-center py-4">
                                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                <p class="text-muted">אין הסמכות רשומות לעובד זה</p>
                                            </div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>

                                <!-- Tab 2: Timeline -->
                                <div class="tab-pane fade" id="tabTimeline">
                                    <h5 class="mb-4">ציר זמן של הסמכות</h5>
                                    <asp:Repeater ID="rptTimeline" runat="server">
                                        <ItemTemplate>
                                            <div class="timeline-item">
                                                <div class="timeline-marker <%# GetTimelineMarkerClass((DateTime)Eval("ExpiryDate")) %>">
                                                    <i class="fas fa-certificate"></i>
                                                </div>
                                                <div class="timeline-content">
                                                    <div class="timeline-date">
                                                        <%# ((DateTime)Eval("IssueDate")).ToString("dd/MM/yyyy") %>
                                                    </div>
                                                    <h6 class="mb-1"><%# Eval("CertificationName") %></h6>
                                                    <p class="mb-1 text-muted small">
                                                        <strong>תוקף עד:</strong> <%# ((DateTime)Eval("ExpiryDate")).ToString("dd/MM/yyyy") %>
                                                    </p>
                                                    <p class="mb-0">
                                                        <%# GetTimelineStatus((DateTime)Eval("ExpiryDate")) %>
                                                    </p>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>

                              

                                <!-- Tab 4: History -->
                                <div class="tab-pane fade" id="tabHistory">
                                    <h5 class="mb-4">היסטוריית שינויים</h5>
                                    <asp:GridView ID="gvHistory" runat="server" CssClass="table table-sm table-striped" 
                                        AutoGenerateColumns="false" GridLines="None">
                                        <Columns>
                                            <asp:TemplateField HeaderText="תאריך ושעה">
                                                <ItemTemplate>
                                                    <%# ((DateTime)Eval("CreatedDate")).ToString("dd/MM/yyyy HH:mm") %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="Action" HeaderText="פעולה" />
                                            <asp:BoundField DataField="UserName" HeaderText="משתמש" />
                                            <asp:BoundField DataField="Details" HeaderText="פרטים" />
                                        </Columns>
                                    </asp:GridView>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- Add Certification Modal -->
                    <div class="modal fade" id="addCertModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">הוסף הסמכה חדשה</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">

                                    <uc1:SmartCertUpload runat="server" ID="SmartCertUpload" />


                                    
                                </div>
                               
                            </div>
                        </div>
                    </div>

                    <!-- Update Certification Modal -->
                    <div class="modal fade" id="updateCertModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">עדכן הסמכה</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <asp:HiddenField ID="hfEmployeeCertificationID" runat="server" />
                                    <div class="mb-3">
                                        <label class="form-label">סוג הסמכה</label>
                                        <asp:DropDownList ID="ddlCertificationType" runat="server" CssClass="form-select" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">מספר תעודה</label>
                                        <asp:TextBox ID="txtCertificateNumber" runat="server" CssClass="form-control" />
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">תאריך הנפקה</label>
                                            <asp:TextBox ID="txtIssueDate" runat="server" CssClass="form-control" TextMode="Date" />
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">תאריך פקיעה</label>
                                            <asp:TextBox ID="txtExpiryDate" runat="server" CssClass="form-control" TextMode="Date" />
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">הערות</label>
                                        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                                    </div>

                                </div>
                                 <div class="modal-footer">
                                     <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ביטול</button>
                                     <asp:Button ID="btnSaveCertification" runat="server" CssClass="btn btn-primary" 
                                         Text="שמור הסמכה" OnClick="btnSaveCertification_Click" />
                                 </div>
                            </div>
                        </div>
                    </div>

                   
                   
                    <div class="modal fade" id="filePreviewModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-xl modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header bg-primary text-white">
                                    <h5 class="modal-title">
                                        <i class="fas fa-eye me-2"></i>
                                        <span id="previewFileName">תצוגה מקדימה</span>
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body p-0" style="min-height: 500px; background: #f8f9fa;">
                                    <!-- Spinner עד שהתמונה נטענת -->
                                    <div id="previewLoader" class="text-center py-5">
                                        <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
                                            <span class="visually-hidden">טוען...</span>
                                        </div>
                                        <p class="mt-3 text-muted">טוען קובץ...</p>
                                    </div>

                                    <!-- תצוגת תמונה -->
                                    <div id="imagePreviewContainer" class="d-none p-4 text-center">
                                        <img id="previewImage" src="" alt="Preview" 
                                             class="img-fluid rounded shadow-lg" 
                                             style="max-height: 70vh; cursor: zoom-in;"
                                             onclick="toggleImageZoom(this)" />
                                        <div class="mt-3">
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="rotatePreviewImage(-90)">
                                                <i class="fas fa-rotate-left"></i> סובב שמאלה
                                            </button>
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="rotatePreviewImage(90)">
                                                <i class="fas fa-rotate-right"></i> סובב ימינה
                                            </button>
                                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="downloadPreviewFile()">
                                                <i class="fas fa-download"></i> הורד
                                            </button>
                                        </div>
                                    </div>

                                    <!-- תצוגת PDF -->
                                    <div id="pdfPreviewContainer" class="d-none">
                                        <iframe id="previewPDF" src="" 
                                                style="width: 100%; height: 70vh; border: none;">
                                        </iframe>
                                        <div class="p-3 text-center bg-white border-top">
                                            <button type="button" class="btn btn-primary" onclick="downloadPreviewFile()">
                                                <i class="fas fa-download"></i> הורד PDF
                                            </button>
                                        </div>
                                    </div>

                                    <!-- הודעת שגיאה -->
                                    <div id="previewError" class="d-none text-center py-5">
                                        <i class="fas fa-exclamation-triangle fa-3x text-warning mb-3"></i>
                                        <h5>לא ניתן להציג את הקובץ</h5>
                                        <p class="text-muted">הקובץ אינו נתמך לתצוגה מקדימה</p>
                                        <button class="btn btn-primary" onclick="downloadPreviewFile()">
                                            <i class="fas fa-download"></i> הורד קובץ
                                        </button>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                        <i class="fas fa-times"></i> סגור
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Hidden field לשמירת נתוני הקובץ -->
                    <asp:HiddenField ID="hdnPreviewFileUrl" runat="server" />
                    <asp:HiddenField ID="hdnPreviewFileName" runat="server" />
                    <asp:HiddenField ID="hdnPreviewFileType" runat="server" />


                </ContentTemplate>
               
            </asp:UpdatePanel>
        </div>

    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script src="../Scripts/Center/FilePreview.js"></script>
    
</body>
</html>
