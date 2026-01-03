<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="ComplianceCenter.Pages.Dashboard" %>

<!DOCTYPE html>
<html lang="he" dir="rtl">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>מרכז בקרה לכשירות משמרת - Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.rtl.min.css" rel="stylesheet" />
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.3.0/dist/chart.umd.min.js"></script>
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

        <!-- Main Container -->
        <div class="container-fluid mt-4">
            <asp:UpdatePanel ID="UpdatePanelMain" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    
                    <!-- Header Section -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h2 class="mb-0">
                                        <i class="fas fa-tachometer-alt text-primary"></i>
                                        מצב כשירות כללי
                                    </h2>
                                    <p class="text-muted mb-0">
                                        <i class="far fa-calendar-alt"></i>
                                        <asp:Label ID="lblCurrentDate" runat="server"></asp:Label>
                                        |
                                        <i class="far fa-clock"></i>
                                        <asp:Label ID="lblCurrentTime" runat="server"></asp:Label>
                                    </p>
                                </div>
                                <div>
                                    <button id="btnRefresh" runat="server" class="btn btn-primary" onserverclick="btnRefresh_Click">
                                        <i class="fas fa-sync-alt"></i> רענן נתונים
                                    </button>

                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- KPI Cards -->
                    <div class="row mb-4">
                        <!-- Overall Readiness Score -->
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-2">ציון כשירות כללי</h6>
                                            <h2 class="mb-0">
                                                <asp:Label ID="lblOverallScore" runat="server" CssClass="fw-bold"></asp:Label>
                                                <span class="fs-5">%</span>
                                            </h2>
                                            <small>
                                                <asp:Label ID="lblScoreTrend" runat="server"></asp:Label>
                                            </small>
                                        </div>
                                        <div class="icon-circle bg-primary bg-opacity-10">
                                            <i class="fas fa-gauge-high fa-2x text-primary"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Active Alerts -->
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-2">התראות פעילות</h6>
                                            <h2 class="mb-0">
                                                <asp:Label ID="lblActiveAlerts" runat="server" CssClass="fw-bold text-danger"></asp:Label>
                                            </h2>
                                            <small>
                                                <asp:Label ID="lblCriticalAlerts" runat="server"></asp:Label>
                                            </small>
                                        </div>
                                        <div class="icon-circle bg-danger bg-opacity-10">
                                            <i class="fas fa-triangle-exclamation fa-2x text-danger"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Critical Gaps -->
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-2">פערים קריטיים</h6>
                                            <h2 class="mb-0">
                                                <asp:Label ID="lblCriticalGaps" runat="server" CssClass="fw-bold text-warning"></asp:Label>
                                            </h2>
                                            <small class="text-muted">בכל המפעל</small>
                                        </div>
                                        <div class="icon-circle bg-warning bg-opacity-10">
                                            <i class="fas fa-exclamation-circle fa-2x text-warning"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Expiring Soon -->
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-2">הסמכות פוקעות</h6>
                                            <h2 class="mb-0">
                                                <asp:Label ID="lblExpiringSoon" runat="server" CssClass="fw-bold text-info"></asp:Label>
                                            </h2>
                                            <small class="text-muted">ב-30 הימים הקרובים</small>
                                        </div>
                                        <div class="icon-circle bg-info bg-opacity-10">
                                            <i class="fas fa-calendar-xmark fa-2x text-info"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Heat Map Section -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-fire text-danger"></i>
                                        מרכז בקרה - כשירות מחלקות
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <asp:Repeater ID="rptDepartments" runat="server">
                                        <HeaderTemplate>
                                            <div class="row g-3">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <div class="col-xl-3 col-lg-4 col-md-6">
                                                <div class="department-card <%# GetStatusClass((decimal)Eval("ReadinessScore")) %>" 
                                                     onclick="location.href='DepartmentDetails.aspx?id=<%# Eval("DepartmentID") %>'">
                                                    <div class="department-header">
                                                        <h6 class="mb-0"><%# Eval("DepartmentName") %></h6>
                                                        <div class="status-badge">
                                                            <%# GetStatusIcon((string)Eval("Status")) %>
                                                        </div>
                                                    </div>
                                                    <div class="department-score">
                                                        <div class="score-circle">
                                                            <span class="score-value"><%# string.Format("{0:F1}", Eval("ReadinessScore")) %></span>
                                                            <span class="score-unit">%</span>
                                                        </div>
                                                    </div>
                                                    <div class="department-details">
                                                        <div class="detail-row">
                                                            <span class="detail-label">
                                                                <i class="fas fa-users"></i> נוכחים:
                                                            </span>
                                                            <span class="detail-value"><%# Eval("TotalPresent") %></span>
                                                        </div>
                                                        <div class="detail-row">
                                                            <span class="detail-label">
                                                                <i class="fas fa-circle-check"></i> כשירים:
                                                            </span>
                                                            <span class="detail-value">
                                                                <%# (int)Eval("TotalPresent") - (int)Eval("CriticalGaps") - (int)Eval("HighGaps") - (int)Eval("MediumGaps") - (int)Eval("LowGaps") %>
                                                            </span>
                                                        </div>
                                                        <%# (int)Eval("CriticalGaps") > 0 ? 
                                                            "<div class='alert alert-danger py-1 px-2 mt-2 mb-0'>" +
                                                            "<small><i class='fas fa-exclamation-triangle'></i> " + 
                                                            Eval("CriticalGaps") + " פערים קריטיים</small></div>" : "" %>
                                                    </div>
                                                    <div class="department-footer">
                                                        <small class="text-muted">לחץ לפרטים מלאים</small>
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </div>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Row -->
                    <div class="row mb-4">
                        <!-- Readiness Trend Chart -->
                        <div class="col-lg-8 mb-4">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-chart-line text-primary"></i>
                                        מגמת כשירות - 30 ימים אחרונים
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="trendChart" height="80"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Distribution Chart -->
                        <div class="col-lg-4 mb-4">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-header bg-white">
                                    <h5 class="mb-0">
                                        <i class="fas fa-chart-pie text-success"></i>
                                        התפלגות סטטוס
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="distributionChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Alerts -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">
                                        <i class="fas fa-bell text-warning"></i>
                                        התראות אחרונות
                                    </h5>
                                    <a href="AlertsManagement.aspx" class="btn btn-sm btn-outline-primary">
                                        צפה בכל ההתראות
                                    </a>
                                </div>
                                <div class="card-body p-0">
                                    <asp:GridView ID="gvAlerts" runat="server" CssClass="table table-hover mb-0" 
                                        AutoGenerateColumns="false" GridLines="None" ShowHeader="true">
                                        <Columns>
                                            <asp:TemplateField HeaderText="חומרה">
                                                <ItemTemplate>
                                                    <span class="badge bg-<%# GetSeverityBadgeClass((string)Eval("Severity")) %>">
                                                        <%# Eval("Severity") %>
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="DepartmentName" HeaderText="מחלקה" />
                                            <asp:BoundField DataField="Title" HeaderText="כותרת" />
                                            <asp:TemplateField HeaderText="תאריך">
                                                <ItemTemplate>
                                                    <%# ((DateTime)Eval("CreatedDate")).ToString("dd/MM/yyyy HH:mm") %>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="פעולות">
                                                <ItemTemplate>
                                                    <a href="AlertsManagement.aspx?id=<%# Eval("AlertID") %>" 
                                                       class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-eye"></i> צפה
                                                    </a>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <div class="text-center py-4 text-muted">
                                                <i class="fas fa-check-circle fa-3x mb-3"></i>
                                                <p>אין התראות פעילות</p>
                                            </div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Hidden fields for chart data -->
                    <asp:HiddenField ID="hfTrendData" runat="server" />
                    <asp:HiddenField ID="hfDistributionData" runat="server" />

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

    </form>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script src="Scripts/dashboard.js"></script>
    
    <!-- Chart Initialization -->
    <script>
        // Initialize charts when page loads
        document.addEventListener('DOMContentLoaded', function() {
            initializeTrendChart();
            initializeDistributionChart();
        });

        function initializeTrendChart() {
            var trendData = document.getElementById('<%= hfTrendData.ClientID %>').value;
            if (!trendData) return;

            var data = JSON.parse(trendData);
            
            var ctx = document.getElementById('trendChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: 'ציון כשירות ממוצע',
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
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100
                        }
                    }
                }
            });
        }

        function initializeDistributionChart() {
            var distData = document.getElementById('<%= hfDistributionData.ClientID %>').value;
            if (!distData) return;

            var data = JSON.parse(distData);
            
            var ctx = document.getElementById('distributionChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: data.labels,
                    datasets: [{
                        data: data.values,
                        backgroundColor: [
                            'rgb(25, 135, 84)',   // ירוק
                            'rgb(255, 193, 7)',   // צהוב
                            'rgb(220, 53, 69)'    // אדום
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }
    </script>
</body>
</html>
