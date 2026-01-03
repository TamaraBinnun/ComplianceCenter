<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Replacements.aspx.cs" Inherits="ComplianceCenter.Pages.Replacements" %>

<!DOCTYPE html>
<html lang="he" dir="rtl">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>מרכז בקרה לכשירות משמרת - החלפת עובד</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.rtl.min.css" rel="stylesheet" />
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.3.0/dist/chart.umd.min.js"></script>
    
        <link href="Content/Replacements.css" rel="stylesheet" />

</head>
<body>
    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
        
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="Dashboard.aspx">
                <i class="fas fa-shield-alt me-2"></i>
                מרכז בקרה לכשירות משמרת
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="Dashboard.aspx">
                            <i class="fas fa-home"></i> דף הבית
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="AlertsManagement.aspx">
                            <i class="fas fa-bell"></i> התראות
                            <asp:Label ID="lblAlertCount" runat="server" CssClass="badge bg-danger ms-1"></asp:Label>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="Reports.aspx">
                            <i class="fas fa-chart-bar"></i> דוחות
                        </a>
                    </li>
                    <li class="nav-item">
                        <asp:Label ID="lblUserName" runat="server" CssClass="nav-link"></asp:Label>
                    </li>
                    <li class="nav-item">
                        <asp:LinkButton ID="btnLogout" runat="server" CssClass="nav-link" OnClick="btnLogout_Click">
                            <i class="fas fa-sign-out-alt"></i> יציאה
                        </asp:LinkButton>
                    </li>
                </ul>
            </div>
        </div>
    </nav>


    <div class="container-fluid ai-replacement-container">
        <!-- כותרת -->
        <div class="page-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h4 class="page-title">
                        <i class="fas fa-robot"></i>
                          הצעת מחליפים חכמה
                    </h4>
                    <p class="page-subtitle">מערכת חכמה הממליצה על עובדים מתאימים להחלפה בהתבסס על ניתוח נתונים מתקדם</p>
                </div>
                
            </div>
        </div>

        <!-- פילטרים -->
        <div class="card filter-card mb-4">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">מחלקה</label>
                        <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-select"
                            AutoPostBack="true" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">הסמכה נדרשת</label>
                        <asp:DropDownList ID="ddlCertification" runat="server" CssClass="form-select">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">תאריך משמרת</label>
                        <asp:TextBox ID="txtShiftDate" runat="server" CssClass="form-control" 
                            TextMode="Date" />
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">משמרת</label>
                        <asp:DropDownList ID="ddlShift" runat="server" CssClass="form-select">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">&nbsp;</label>
                        <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary w-100" 
                            Text="🔍 חפש מחליפים" OnClick="btnSearch_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- התראת מצב -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert mb-4">
            <i class="fas fa-info-circle"></i>
            <asp:Label ID="lblMessage" runat="server" />
        </asp:Panel>

        <!-- תוצאות - רשימת מחליפים מומלצים -->
        <div class="row" id="resultsContainer" runat="server">
            <asp:Repeater ID="rptReplacements" runat="server" OnItemCommand="rptReplacements_ItemCommand">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="replacement-card" data-score='<%# Eval("MatchScore") %>'>
                            <div class="card-header-custom">
                                <div class="employee-info">
                                    <div class="employee-avatar">
                                        <%# GetInitials(Eval("FullName").ToString()) %>
                                    </div>
                                    <div class="employee-details">
                                        <h5 class="employee-name"><%# Eval("FullName") %></h5>
                                        <p class="employee-position"><%# Eval("PositionTitle") %></p>
                                    </div>
                                </div>
                                <div class="confidence-badge" data-score='<%# Eval("MatchScore") %>'>
                                    <div class="score-circle">
                                        <span class="score-value"><%# String.Format("{0:F0}", Eval("MatchScore")) %></span>
                                    </div>
                                    <span class="score-label">ציון התאמה</span>
                                </div>
                            </div>
                            
                            <div class="card-body-custom">
                                <div class="Recommendation-section">
                                    <i class="fas fa-lightbulb"></i>
                                    <p class="Recommendation-text"><%# Eval("Recommendation") %></p>
                                </div>
                                
                                <div class="scores-breakdown">
                                    <h6>פירוט ציונים:</h6>
                                    <div class="score-item">
                                        <span class="score-label-small">הסמכה בתוקף</span>
                                        <div class="score-bar">
                                            <div class="score-fill" style='width: <%# GetPercentage(Eval("AvailabilityScore"), 40) %>%'></div>
                                        </div>
                                        <span class="score-num"><%# String.Format("{0:F0}", Eval("AvailabilityScore")) %></span>
                                    </div>
                                    <div class="score-item">
                                        <span class="score-label-small">היסטוריה</span>
                                        <div class="score-bar">
                                            <div class="score-fill" style='width: <%# GetPercentage(Eval("ExperienceScore"), 25) %>%'></div>
                                        </div>
                                        <span class="score-num"><%# String.Format("{0:F0}", Eval("ExperienceScore")) %></span>
                                    </div>
                                    <div class="score-item">
                                        <span class="score-label-small">זמינות</span>
                                        <div class="score-bar">
                                            <div class="score-fill" style='width: <%# GetPercentage(Eval("AvailabilityScore"), 10) %>%'></div>
                                        </div>
                                        <span class="score-num"><%# String.Format("{0:F0}", Eval("AvailabilityScore")) %></span>
                                    </div>
                                    <div class="score-item">
                                        <span class="score-label-small">ניסיון</span>
                                        <div class="score-bar">
                                            <div class="score-fill" style='width: <%# GetPercentage(Eval("ExperienceScore"), 10) %>%'></div>
                                        </div>
                                        <span class="score-num"><%# String.Format("{0:F0}", Eval("ExperienceScore")) %></span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-footer-custom">
                                <asp:LinkButton ID="btnAccept" runat="server" CssClass="btn btn-success btn-sm"
                                    CommandName="Accept" CommandArgument='<%# Eval("EmployeeID") %>'>
                                    <i class="fas fa-check"></i> אשר החלפה
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnViewDetails" runat="server" CssClass="btn btn-outline-primary btn-sm"
                                    CommandName="ViewDetails" CommandArgument='<%# Eval("EmployeeID") %>'>
                                    <i class="fas fa-eye"></i> פרטים
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnReject" runat="server" CssClass="btn btn-outline-danger btn-sm"
                                    CommandName="Reject" CommandArgument='<%# Eval("EmployeeID") %>'>
                                    <i class="fas fa-times"></i> דחה
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- מצב ריק -->
        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="no-results">
            <i class="fas fa-search"></i>
            <h3>לא נמצאו מחליפים מתאימים</h3>
            <p>נסה לשנות את הקריטריונים או לבדוק מחלקות אחרות</p>
        </asp:Panel>
    </div>
    </form>

    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    

    <script src="Scripts/Replacements.js"></script>
</body>
</html>
