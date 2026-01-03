<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DepartmentDetails.aspx.cs" Inherits="ComplianceCenter.Pages.DepartmentDetails" %>

<!DOCTYPE html>
<html lang="he" dir="rtl">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>פרטי מחלקה - מרכז בקרה לכשירות משמרת</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.rtl.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
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
                        <a class="nav-link" href="Dashboard.aspx">
                            <i class="fas fa-arrow-right"></i> חזרה למרכז בקרה
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <div class="container-fluid mt-4">
            <asp:UpdatePanel ID="UpdatePanelMain" runat="server">
                <ContentTemplate>

                    <!-- Header -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-md-8">
                                            <h2 class="mb-2">
                                                <i class="fas fa-building text-primary"></i>
                                                <asp:Label ID="lblDepartmentName" runat="server"></asp:Label>
                                            </h2>
                                            <p class="text-muted mb-0">
                                                <i class="far fa-calendar-alt"></i>
                                                <asp:Label ID="lblDate" runat="server"></asp:Label>
                                            </p>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <div class="readiness-score-large">
                                                <div class="score-circle-large <%# GetScoreClass() %>">
                                                    <asp:Label ID="lblReadinessScore" runat="server" CssClass="score-value-large"></asp:Label>
                                                    <span class="score-unit-large">%</span>
                                                    <div class="score-label-large">ציון כשירות</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- KPI Cards -->
                    <div class="row mb-4">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <h6 class="text-muted mb-2">עובדים במשמרת</h6>
                                    <h3 class="mb-0">
                                        <asp:Label ID="lblTotalPresent" runat="server"></asp:Label>
                                        <small class="text-muted fs-6">/ <asp:Label ID="lblTotalAssigned" runat="server"></asp:Label></small>
                                    </h3>
                                    <small class="text-muted">נוכחים / משובצים</small>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <h6 class="text-muted mb-2">עובדים כשירים</h6>
                                    <h3 class="mb-0 text-success">
                                        <asp:Label ID="lblTotalCompliant" runat="server"></asp:Label>
                                    </h3>
                                    <small class="text-muted">עם כל ההסמכות</small>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <h6 class="text-muted mb-2">פערים קריטיים</h6>
                                    <h3 class="mb-0 text-danger">
                                        <asp:Label ID="lblCriticalGaps" runat="server"></asp:Label>
                                    </h3>
                                    <small class="text-muted">דורש טיפול מיידי</small>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <h6 class="text-muted mb-2">סטטוס כללי</h6>
                                    <h3 class="mb-0">
                                        <asp:Label ID="lblStatus" runat="server"></asp:Label>
                                    </h3>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Critical Gaps Alert -->
                    <asp:Panel ID="pnlCriticalGaps" runat="server" Visible="false" CssClass="row mb-4">
                        <div class="col-12">
                            <div class="alert alert-danger border-0 shadow-sm">
                                <h5 class="alert-heading">
                                    <i class="fas fa-triangle-exclamation"></i>
                                    פערים קריטיים זוהו!
                                </h5>
                                <p class="mb-3">המחלקה חסרה הסמכות קריטיות. יש לטפל מיידית:</p>
                                <asp:Repeater ID="rptCriticalGaps" runat="server">
                                    <HeaderTemplate>
                                        <ul class="mb-0">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <li>
                                            <strong><%# Eval("CertificationName") %></strong>:
                                            נדרשים <%# Eval("MinimumRequired") %> עובדים, 
                                            קיימים רק <%# Eval("ActualCompliant") %> 
                                            (חסרים <%# Eval("Gap") %>)
                                        </li>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </ul>
                                    </FooterTemplate>
                                </asp:Repeater>
                                <hr />
                                <div class="mb-0">
                                    <asp:Button ID="btnGetRecommendations" runat="server" CssClass="btn btn-light" 
                                        Text="קבל המלצות AI" OnClick="btnGetRecommendations_Click" />
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- Tabs -->
                    <div class="row">
                        <div class="col-12">
                            <ul class="nav nav-tabs" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabEmployees" type="button">
                                        <i class="fas fa-users"></i> עובדים במשמרת
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabGaps" type="button">
                                        <i class="fas fa-exclamation-circle"></i> פערי כשירות
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabRequirements" type="button">
                                        <i class="fas fa-list-check"></i> דרישות כשירות
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabHistory" type="button">
                                        <i class="fas fa-chart-line"></i> היסטוריה
                                    </button>
                                </li>
                            </ul>

                            <div class="tab-content border border-top-0 p-4 bg-white shadow-sm">
                                
                                <!-- Tab 1: Employees -->
                                <div class="tab-pane fade show active" id="tabEmployees" role="tabpanel">
                                    <div class="mb-3">
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                                            <asp:TextBox ID="txtSearchEmployee" runat="server" CssClass="form-control" 
                                                placeholder="חפש עובד לפי שם או מספר..." />
                                            <asp:Button ID="btnSearchEmployee" runat="server" CssClass="btn btn-primary" 
                                                Text="חפש" OnClick="btnSearchEmployee_Click" />
                                        </div>
                                    </div>

                                    <asp:GridView ID="gvEmployees" runat="server" CssClass="table table-hover" 
                                        AutoGenerateColumns="false" GridLines="None">
                                        <Columns>
                                            <asp:TemplateField HeaderText="סטטוס">
                                                <ItemTemplate>
                                                    <%# GetEmployeeStatusIcon(Eval("IsCompliant")) %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="EmployeeNumber" HeaderText="מספר עובד" />
                                            <asp:TemplateField HeaderText="שם מלא">
                                                <ItemTemplate>
                                                    <%# Eval("FirstName") %> <%# Eval("LastName") %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="PositionTitle" HeaderText="תפקיד" />
                                            <asp:TemplateField HeaderText="נוכחות">
                                                <ItemTemplate>
                                                    <%# (bool)Eval("IsPresent") ? 
                                                        "<span class='badge bg-success'>נוכח</span>" : 
                                                        "<span class='badge bg-secondary'>נעדר</span>" %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="הסמכות חסרות">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblMissingCerts" runat="server" 
                                                        Text='<%# GetMissingCertifications(Eval("EmployeeID")) %>'
                                                        CssClass="text-danger small"></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="פעולות">
                                                <ItemTemplate>
                                                    <a href='EmployeeProfile.aspx?id=<%# Eval("EmployeeID") %>' 
                                                       class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-eye"></i> פרופיל
                                                    </a>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>

                                <!-- Tab 2: Gaps -->
                                <div class="tab-pane fade" id="tabGaps" role="tabpanel">
                                    <asp:GridView ID="gvGaps" runat="server" CssClass="table table-hover" 
                                        AutoGenerateColumns="false" GridLines="None">
                                        <Columns>
                                            <asp:TemplateField HeaderText="חומרה">
                                                <ItemTemplate>
                                                    <%# GetCriticalityBadge((string)Eval("CriticalityLevel")) %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="CertificationName" HeaderText="הסמכה" />
                                            <asp:BoundField DataField="MinimumRequired" HeaderText="נדרש" />
                                            <asp:BoundField DataField="ActualCompliant" HeaderText="קיים" />
                                            <asp:TemplateField HeaderText="פער">
                                                <ItemTemplate>
                                                    <span class="badge bg-danger">
                                                        <%# Eval("Gap") %> חסרים
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="פעולות">
                                                <ItemTemplate>
                                                    <asp:Button ID="btnSuggestReplacement" runat="server" 
                                                        CssClass="btn btn-sm btn-outline-primary"
                                                        Text="הצע מחליף" 
                                                        CommandArgument='<%# Eval("CertificationTypeID") %>'
                                                        OnClick="btnSuggestReplacement_Click" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <div class="text-center py-4 text-success">
                                                <i class="fas fa-check-circle fa-3x mb-3"></i>
                                                <p>אין פערי כשירות! כל ההסמכות הנדרשות קיימות.</p>
                                            </div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>

                                <!-- Tab 3: Requirements -->
                                <div class="tab-pane fade" id="tabRequirements" role="tabpanel">
                                    <asp:GridView ID="gvRequirements" runat="server" CssClass="table table-striped" 
                                        AutoGenerateColumns="false" GridLines="None">
                                        <Columns>
                                            <asp:BoundField DataField="CertificationName" HeaderText="הסמכה" />
                                            <asp:TemplateField HeaderText="קריטיות">
                                                <ItemTemplate>
                                                    <%# GetCriticalityBadge((string)Eval("CriticalityLevel")) %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="MinimumRequired" HeaderText="מינימום נדרש" />
                                            <asp:BoundField DataField="Priority" HeaderText="עדיפות" />
                                            <asp:BoundField DataField="Notes" HeaderText="הערות" />
                                        </Columns>
                                    </asp:GridView>
                                </div>

                                <!-- Tab 4: History -->
                                <div class="tab-pane fade" id="tabHistory" role="tabpanel">
                                    <canvas id="historyChart" height="80"></canvas>
                                    <asp:HiddenField ID="hfHistoryData" runat="server" />
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- AI Recommendations Modal -->
                    <asp:Panel ID="pnlRecommendations" runat="server" Visible="false" CssClass="modal-overlay">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">
                                        <i class="fas fa-robot text-primary"></i>
                                        המלצות AI
                                    </h5>
                                    <asp:Button ID="btnCloseRecommendations" runat="server" CssClass="btn-close" 
                                        OnClick="btnCloseRecommendations_Click" />
                                </div>
                                <div class="modal-body">
                                    <asp:Repeater ID="rptRecommendations" runat="server">
                                        <ItemTemplate>
                                            <div class="card mb-3">
                                                <div class="card-body">
                                                    <h6><%# Eval("FullName") %></h6>
                                                    <p class="mb-2">
                                                        <strong>מחלקה נוכחית:</strong> <%# Eval("CurrentDepartment") %><br />
                                                        <strong>ציון התאמה:</strong> 
                                                        <span class="badge bg-success"><%# Eval("MatchScore") %>%</span>
                                                    </p>
                                                    <p class="text-muted small mb-0">
                                                        <%# Eval("Recommendation") %>
                                                    </p>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.3.0/dist/chart.umd.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            initializeHistoryChart();
        });

        function initializeHistoryChart() {
            var historyData = document.getElementById('<%= hfHistoryData.ClientID %>').value;
            if (!historyData) return;

            var data = JSON.parse(historyData);
            
            var ctx = document.getElementById('historyChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: 'ציון כשירות',
                        data: data.values,
                        borderColor: 'rgb(13, 110, 253)',
                        backgroundColor: 'rgba(13, 110, 253, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100
                        }
                    }
                }
            });
        }
    </script>
</body>
</html>