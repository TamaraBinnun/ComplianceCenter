USE [ComplianceCenter]
GO
/****** Object:  Table [dbo].[AlertNotifications]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlertNotifications](
	[NotificationID] [int] IDENTITY(1,1) NOT NULL,
	[AlertID] [int] NOT NULL,
	[RecipientEmail] [nvarchar](100) NOT NULL,
	[RecipientPhone] [nvarchar](20) NULL,
	[NotificationType] [nvarchar](20) NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[SentDate] [datetime] NULL,
	[ErrorMessage] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NotificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditLogs]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLogs](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[UserName] [nvarchar](100) NULL,
	[Action] [nvarchar](100) NOT NULL,
	[TableName] [nvarchar](100) NULL,
	[RecordID] [int] NULL,
	[OldValue] [nvarchar](max) NULL,
	[NewValue] [nvarchar](max) NULL,
	[IPAddress] [nvarchar](50) NULL,
	[UserAgent] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CertificationTypes]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CertificationTypes](
	[CertificationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[CertificationName] [nvarchar](100) NOT NULL,
	[CertificationCode] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[ValidityPeriodMonths] [int] NOT NULL,
	[CriticalityLevel] [nvarchar](20) NOT NULL,
	[RequiresRenewal] [bit] NOT NULL,
	[RegulatoryBody] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CertificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComplianceReports]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComplianceReports](
	[ReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportName] [nvarchar](200) NOT NULL,
	[ReportType] [nvarchar](50) NOT NULL,
	[GeneratedByUserID] [int] NOT NULL,
	[ReportPeriodStart] [date] NULL,
	[ReportPeriodEnd] [date] NULL,
	[FileName] [nvarchar](255) NULL,
	[FileSize] [int] NULL,
	[FileType] [nvarchar](20) NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DepartmentRequirements]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DepartmentRequirements](
	[RequirementID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[CertificationTypeID] [int] NOT NULL,
	[MinimumRequired] [int] NOT NULL,
	[Priority] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Notes] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RequirementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departments]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [nvarchar](100) NOT NULL,
	[DepartmentCode] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[ManagerEmployeeID] [int] NULL,
	[MinimumStaffCount] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeCertifications]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCertifications](
	[EmployeeCertificationID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[CertificationTypeID] [int] NOT NULL,
	[CertificateNumber] [nvarchar](50) NULL,
	[IssueDate] [date] NOT NULL,
	[ExpiryDate] [date] NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[CertificateFileName] [nvarchar](255) NULL,
	[Notes] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeCertificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeNumber] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[DepartmentID] [int] NOT NULL,
	[PositionTitle] [nvarchar](100) NULL,
	[HireDate] [date] NOT NULL,
	[TerminationDate] [date] NULL,
	[IsActive] [bit] NOT NULL,
	[PhotoFileName] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReadinessAlerts]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReadinessAlerts](
	[AlertID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[AlertType] [nvarchar](50) NOT NULL,
	[Severity] [nvarchar](20) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[RelatedCertificationTypeID] [int] NULL,
	[RelatedEmployeeID] [int] NULL,
	[Status] [nvarchar](20) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ResolvedDate] [datetime] NULL,
	[ResolvedByUserID] [int] NULL,
	[ResolutionNotes] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[AlertID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReadinessHistory]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReadinessHistory](
	[HistoryID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[CalculationDate] [date] NOT NULL,
	[ShiftID] [int] NULL,
	[ReadinessScore] [decimal](5, 2) NOT NULL,
	[TotalRequired] [int] NOT NULL,
	[TotalPresent] [int] NOT NULL,
	[TotalCompliant] [int] NOT NULL,
	[CriticalGaps] [int] NOT NULL,
	[HighGaps] [int] NOT NULL,
	[MediumGaps] [int] NOT NULL,
	[LowGaps] [int] NOT NULL,
	[Notes] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReplacementSuggestions]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReplacementSuggestions](
	[SuggestionID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[RequiredCertificationTypeID] [int] NOT NULL,
	[SuggestedEmployeeID] [int] NOT NULL,
	[ConfidenceScore] [decimal](5, 2) NOT NULL,
	[Reason] [nvarchar](500) NULL,
	[Status] [nvarchar](20) NOT NULL,
	[ReviewedByUserID] [int] NULL,
	[ReviewedDate] [datetime] NULL,
	[ReviewNotes] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SuggestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScheduledTasks]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduledTasks](
	[TaskID] [int] IDENTITY(1,1) NOT NULL,
	[TaskName] [nvarchar](100) NOT NULL,
	[TaskType] [nvarchar](50) NOT NULL,
	[Schedule] [nvarchar](100) NOT NULL,
	[LastRunDate] [datetime] NULL,
	[NextRunDate] [datetime] NULL,
	[LastRunStatus] [nvarchar](20) NULL,
	[LastRunMessage] [nvarchar](500) NULL,
	[IsEnabled] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShiftAssignments]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShiftAssignments](
	[AssignmentID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[ShiftID] [int] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[AssignmentDate] [date] NOT NULL,
	[IsPresent] [bit] NULL,
	[CheckInTime] [datetime] NULL,
	[CheckOutTime] [datetime] NULL,
	[Notes] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AssignmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Shifts]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shifts](
	[ShiftID] [int] IDENTITY(1,1) NOT NULL,
	[ShiftName] [nvarchar](50) NOT NULL,
	[ShiftCode] [nvarchar](10) NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ShiftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[PasswordHash] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Role] [nvarchar](50) NOT NULL,
	[EmployeeID] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[LastLoginDate] [datetime] NULL,
	[FailedLoginAttempts] [int] NOT NULL,
	[LockedUntil] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AuditLogs] ON 
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (1, 2, N'safety_manager', N'UPDATE', N'EmployeeCertifications', 1, NULL, N'Status changed to Active', N'192.168.1.100', NULL, CAST(N'2025-12-26T21:49:47.160' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (2, 3, N'shift_manager_a', N'INSERT', N'ShiftAssignments', 123, NULL, N'New shift assignment created', N'192.168.1.101', NULL, CAST(N'2025-12-28T21:49:47.160' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (3, 2, N'safety_manager', N'INSERT', N'ReadinessAlerts', 1, NULL, N'Critical alert created', N'192.168.1.100', NULL, CAST(N'2025-12-30T21:49:47.160' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (4, 4, N'hr_manager', N'UPDATE', N'Employees', 5, NULL, N'Employee details updated', N'192.168.1.102', NULL, CAST(N'2025-12-31T09:49:47.160' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (5, NULL, NULL, N'UPLOAD', N'CertificateFiles', 0, NULL, N'הועלה קובץ: oved111111111.jpg', N'::1', NULL, CAST(N'2026-01-02T01:00:12.300' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (6, NULL, NULL, N'UPLOAD', N'CertificateFiles', 0, NULL, N'הועלה קובץ: oved111111111.jpg', N'::1', NULL, CAST(N'2026-01-02T01:00:45.477' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (7, NULL, NULL, N'INSERT', N'EmployeeCertifications', 42, NULL, N'הוספת הסמכה: בטיחות כללית', N'::1', NULL, CAST(N'2026-01-02T01:01:33.377' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (8, NULL, NULL, N'UPLOAD', N'CertificateFiles', 0, NULL, N'הועלה קובץ: oved111111111.jpg', N'::1', NULL, CAST(N'2026-01-02T01:01:57.757' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (9, NULL, NULL, N'UPLOAD', N'CertificateFiles', 0, NULL, N'הועלה קובץ: oved111111111.jpg', N'::1', NULL, CAST(N'2026-01-02T01:02:06.917' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (10, NULL, NULL, N'UPLOAD', N'CertificateFiles', 0, NULL, N'הועלה קובץ: oved111111111.jpg', N'::1', NULL, CAST(N'2026-01-02T01:03:27.970' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (11, NULL, N'System', N'INSERT_WITH_AI', N'EmployeeCertifications', 44, NULL, N'הסמכה נוספה : ארגונומיה', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-03T19:39:39.247' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (12, NULL, N'System', N'INSERT_WITH_AI', N'EmployeeCertifications', 45, NULL, N'הסמכה נוספה : חומרים מסוכנים', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-03T19:46:40.753' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (13, NULL, N'System', N'INSERT_WITH_AI', N'EmployeeCertifications', 46, NULL, N'הסמכה נוספה : עבודה בגובה', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-03T19:51:44.163' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (14, NULL, N'System', N'INSERT_WITH_AI', N'EmployeeCertifications', 47, NULL, N'הסמכה נוספה : כיבוי אש', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-03T19:53:30.057' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (15, NULL, NULL, N'INSERT', N'EmployeeCertifications', 48, NULL, N'הוספת הסמכה: חשמלאות', N'::1', NULL, CAST(N'2026-01-03T19:54:50.130' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (16, NULL, N'System', N'INSERT_WITH_AI', N'EmployeeCertifications', 49, NULL, N'הסמכה נוספה : עזרה ראשונה', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-03T20:05:07.263' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (17, NULL, N'System', N'INSERT_WITH_AI', N'EmployeeCertifications', 50, NULL, N'הסמכה נוספה : בטיחות מזון', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-03T20:07:21.650' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (18, NULL, N'System', N'INSERT_WITH_AI', N'EmployeeCertifications', 51, NULL, N'הסמכה נוספה : נהיגה מסחרית', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-03T20:19:32.020' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (19, NULL, N'System', N'INSERT_WITH_AI', N'EmployeeCertifications', 52, NULL, N'הסמכה נוספה : ריתוך', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-03T20:21:31.807' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (20, NULL, N'System', N'INSERT_WITH_AI', N'EmployeeCertifications', 53, NULL, N'הסמכה נוספה : ארגונומיה', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-03T20:26:13.483' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (21, NULL, NULL, N'INSERT', N'EmployeeCertifications', 54, NULL, N'הוספת הסמכה: ריתוך', N'::1', NULL, CAST(N'2026-01-03T20:27:05.063' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (22, NULL, NULL, N'INSERT', N'EmployeeCertifications', 55, NULL, N'הוספת הסמכה: אינסטלציה', N'::1', NULL, CAST(N'2026-01-03T20:27:25.747' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (23, NULL, NULL, N'INSERT', N'EmployeeCertifications', 52, NULL, N'הוספת הסמכה: כיבוי אש', N'::1', NULL, CAST(N'2026-01-03T20:34:32.177' AS DateTime))
GO
INSERT [dbo].[AuditLogs] ([LogID], [UserID], [UserName], [Action], [TableName], [RecordID], [OldValue], [NewValue], [IPAddress], [UserAgent], [CreatedDate]) VALUES (24, NULL, N'System', N'INSERT_WITH_AI', N'EmployeeCertifications', 56, NULL, N'הסמכה נוספה : אינסטלציה', N'::1', N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', CAST(N'2026-01-03T22:59:38.190' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[AuditLogs] OFF
GO
SET IDENTITY_INSERT [dbo].[CertificationTypes] ON 
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (1, N'עזרה ראשונה', N'FIRST_AID', N'קורס מגיש עזרה ראשונה', 24, N'Critical', 1, N'מגן דוד אדום', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (2, N'עבודה בגובה', N'HEIGHT_WORK', N'הסמכה לעבודה מעל 2 מטר', 12, N'Critical', 1, N'משרד העבודה', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (3, N'חשמלאות', N'ELECTRICIAN', N'רישיון חשמלאי מוסמך', 60, N'Critical', 1, N'משרד האנרגיה', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (4, N'מלגזן', N'FORKLIFT', N'רישיון הפעלת מלגזה', 36, N'High', 1, N'משרד התחבורה', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (5, N'מעליות', N'ELEVATOR', N'ממונה בטיחות מעליות', 12, N'Critical', 1, N'משרד העבודה', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (6, N'חומרים מסוכנים', N'HAZMAT', N'טיפול בחומרים מסוכנים', 24, N'High', 1, N'משרד הגנת הסביבה', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (7, N'ריתוך', N'WELDING', N'הסמכת ריתוך', 36, N'Medium', 1, N'מכון התקנים', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (8, N'מנוף', N'CRANE', N'הפעלת מנוף', 12, N'High', 1, N'משרד התחבורה', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (9, N'בטיחות כללית', N'GENERAL_SAFETY', N'הדרכת בטיחות כללית', 12, N'Medium', 1, N'ממונה בטיחות', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (10, N'ארגונומיה', N'ERGONOMICS', N'הדרכת ארגונומיה', 24, N'Low', 1, N'משרד הבריאות', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (11, N'כיבוי אש', N'FIRE_SAFETY', N'הדרכת כיבוי אש', 12, N'High', 1, N'כבאות והצלה', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (12, N'מערכות אוויר', N'HVAC', N'מיזוג אוויר', 36, N'Medium', 1, N'מכון התקנים', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (13, N'אינסטלציה', N'PLUMBING', N'אינסטלטור מוסמך', 60, N'Medium', 1, N'משרד האנרגיה', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (14, N'בטיחות מזון', N'FOOD_SAFETY', N'בטיחות ותעשיית מזון', 24, N'High', 1, N'משרד הבריאות', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
INSERT [dbo].[CertificationTypes] ([CertificationTypeID], [CertificationName], [CertificationCode], [Description], [ValidityPeriodMonths], [CriticalityLevel], [RequiresRenewal], [RegulatoryBody], [CreatedDate], [ModifiedDate]) VALUES (15, N'נהיגה מסחרית', N'COMMERCIAL_DRIVE', N'רישיון נהיגה מסחרי', 60, N'High', 1, N'משרד התחבורה', CAST(N'2025-12-31T21:49:46.453' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[CertificationTypes] OFF
GO
SET IDENTITY_INSERT [dbo].[DepartmentRequirements] ON 
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (1, 1, 1, 1, 1, 1, N'חובה: לפחות מגיש עזרה ראשונה אחד במשמרת', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (2, 1, 3, 2, 1, 1, N'חובה: 2 חשמלאים מוסמכים', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (3, 1, 5, 1, 1, 1, N'חובה: ממונה מעליות', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (4, 1, 2, 3, 2, 1, N'רצוי: 3 עובדים עם הסמכת גובה', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (5, 1, 9, 15, 3, 1, N'כולם צריכים בטיחות כללית', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (6, 2, 1, 2, 1, 1, N'חובה: 2 מגישי עזרה ראשונה במשמרת', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (7, 2, 9, 45, 1, 1, N'כולם צריכים בטיחות כללית', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (8, 2, 11, 3, 2, 1, N'חובה: 3 מדריכי כיבוי אש', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (9, 3, 1, 1, 1, 1, N'חובה: מגיש עזרה ראשונה', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (10, 3, 4, 3, 1, 1, N'חובה: 3 מלגזנים מוסמכים', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (11, 3, 9, 12, 2, 1, N'כולם צריכים בטיחות כללית', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (12, 4, 1, 1, 1, 1, N'חובה: מגיש עזרה ראשונה', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (13, 4, 9, 20, 1, 1, N'כולם צריכים בטיחות כללית', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (14, 4, 10, 5, 3, 1, N'רצוי: הדרכת ארגונומיה', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (15, 5, 1, 1, 1, 1, N'חובה: מגיש עזרה ראשונה', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (16, 5, 15, 4, 1, 1, N'חובה: 4 נהגים מסחריים', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
INSERT [dbo].[DepartmentRequirements] ([RequirementID], [DepartmentID], [CertificationTypeID], [MinimumRequired], [Priority], [IsActive], [Notes], [CreatedDate], [ModifiedDate]) VALUES (17, 5, 9, 8, 2, 1, N'כולם צריכים בטיחות כללית', CAST(N'2025-12-31T21:49:46.673' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[DepartmentRequirements] OFF
GO
SET IDENTITY_INSERT [dbo].[Departments] ON 
GO
INSERT [dbo].[Departments] ([DepartmentID], [DepartmentName], [DepartmentCode], [Description], [ManagerEmployeeID], [MinimumStaffCount], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (1, N'מחלקת תחזוקה', N'MAINT', N'תחזוקה שוטפת של מערכות ומתקנים', 3, 15, 1, CAST(N'2025-12-31T21:49:46.270' AS DateTime), NULL)
GO
INSERT [dbo].[Departments] ([DepartmentID], [DepartmentName], [DepartmentCode], [Description], [ManagerEmployeeID], [MinimumStaffCount], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (2, N'מחלקת ייצור', N'PROD', N'קווי ייצור ראשיים', 16, 45, 1, CAST(N'2025-12-31T21:49:46.270' AS DateTime), NULL)
GO
INSERT [dbo].[Departments] ([DepartmentID], [DepartmentName], [DepartmentCode], [Description], [ManagerEmployeeID], [MinimumStaffCount], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (3, N'מחלקת מחסן', N'WAREHOUSE', N'קבלה, אחסון ושילוח', 61, 12, 1, CAST(N'2025-12-31T21:49:46.270' AS DateTime), NULL)
GO
INSERT [dbo].[Departments] ([DepartmentID], [DepartmentName], [DepartmentCode], [Description], [ManagerEmployeeID], [MinimumStaffCount], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (4, N'מחלקת אריזה', N'PACKAGE', N'אריזה ומיתוג מוצרים', 73, 20, 1, CAST(N'2025-12-31T21:49:46.270' AS DateTime), NULL)
GO
INSERT [dbo].[Departments] ([DepartmentID], [DepartmentName], [DepartmentCode], [Description], [ManagerEmployeeID], [MinimumStaffCount], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (5, N'מחלקת לוגיסטיקה', N'LOGISTICS', N'תכנון והפצה', 93, 8, 1, CAST(N'2025-12-31T21:49:46.270' AS DateTime), NULL)
GO
INSERT [dbo].[Departments] ([DepartmentID], [DepartmentName], [DepartmentCode], [Description], [ManagerEmployeeID], [MinimumStaffCount], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (6, N'מחלקת בקרת איכות', N'QC', N'בקרת איכות ובדיקות', 101, 10, 1, CAST(N'2025-12-31T21:49:46.270' AS DateTime), NULL)
GO
INSERT [dbo].[Departments] ([DepartmentID], [DepartmentName], [DepartmentCode], [Description], [ManagerEmployeeID], [MinimumStaffCount], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (7, N'מחלקת מנהלה', N'ADMIN', N'ניהול ותמיכה', 111, 5, 1, CAST(N'2025-12-31T21:49:46.270' AS DateTime), NULL)
GO
INSERT [dbo].[Departments] ([DepartmentID], [DepartmentName], [DepartmentCode], [Description], [ManagerEmployeeID], [MinimumStaffCount], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (8, N'מחלקת בטיחות', N'SAFETY', N'ממוני בטיחות', 116, 3, 1, CAST(N'2025-12-31T21:49:46.270' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[Departments] OFF
GO
SET IDENTITY_INSERT [dbo].[EmployeeCertifications] ON 
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (1, 1, 1, N'FA-2023-001', CAST(N'2023-06-15' AS Date), CAST(N'2025-06-15' AS Date), N'Active', N'certPdf.pdf', NULL, CAST(N'2025-12-31T21:49:46.583' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (2, 1, 2, N'HW-2024-001', CAST(N'2024-03-10' AS Date), CAST(N'2025-03-10' AS Date), N'Active', N'cert1.jpg', NULL, CAST(N'2025-12-31T21:49:46.583' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (3, 1, 9, N'GS-2024-001', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', N'cert2.jpg', NULL, CAST(N'2025-12-31T21:49:46.583' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (4, 2, 3, N'ELEC-2020-045', CAST(N'2020-01-20' AS Date), CAST(N'2025-01-20' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.587' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (5, 2, 1, N'FA-2023-012', CAST(N'2023-07-01' AS Date), CAST(N'2025-07-01' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.587' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (6, 2, 9, N'GS-2024-002', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.587' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (7, 3, 1, N'FA-2023-020', CAST(N'2023-08-15' AS Date), CAST(N'2025-08-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.593' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (8, 3, 9, N'GS-2024-003', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.593' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (9, 3, 10, N'ERG-2023-001', CAST(N'2023-05-10' AS Date), CAST(N'2025-05-10' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.593' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (10, 4, 7, N'WELD-2022-089', CAST(N'2022-04-20' AS Date), CAST(N'2025-04-20' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.597' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (11, 4, 9, N'GS-2024-004', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.597' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (12, 5, 9, N'GS-2024-005', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.600' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (13, 6, 12, N'HVAC-2022-156', CAST(N'2022-09-01' AS Date), CAST(N'2025-09-01' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.607' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (14, 6, 9, N'GS-2024-006', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.607' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (15, 7, 13, N'PLUMB-2019-234', CAST(N'2019-11-15' AS Date), CAST(N'2024-11-15' AS Date), N'Expired', NULL, NULL, CAST(N'2025-12-31T21:49:46.610' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (16, 7, 9, N'GS-2024-007', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.610' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (20, 62, 4, N'FORK-2022-345', CAST(N'2022-06-01' AS Date), CAST(N'2025-06-01' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.613' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (21, 62, 1, N'FA-2024-101', CAST(N'2024-01-10' AS Date), CAST(N'2026-01-10' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.613' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (22, 63, 4, N'FORK-2023-567', CAST(N'2023-04-15' AS Date), CAST(N'2026-04-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.613' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (23, 63, 1, N'FA-2024-102', CAST(N'2024-02-01' AS Date), CAST(N'2026-02-01' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.613' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (24, 64, 4, N'FORK-2024-789', CAST(N'2024-05-20' AS Date), CAST(N'2027-05-20' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.613' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (25, 64, 9, N'GS-2024-050', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.613' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (30, 16, 1, N'FA-2023-200', CAST(N'2023-09-01' AS Date), CAST(N'2025-09-01' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.620' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (31, 16, 9, N'GS-2024-201', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.620' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (32, 17, 9, N'GS-2024-202', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.620' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (33, 18, 9, N'GS-2024-203', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.620' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (34, 19, 9, N'GS-2023-204', CAST(N'2023-12-01' AS Date), CAST(N'2024-12-01' AS Date), N'Expired', NULL, NULL, CAST(N'2025-12-31T21:49:46.620' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (35, 20, 9, N'GS-2024-205', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.620' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (40, 61, 1, N'FA-2023-300', CAST(N'2023-10-15' AS Date), CAST(N'2025-10-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.623' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (41, 61, 9, N'GS-2024-301', CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Active', NULL, NULL, CAST(N'2025-12-31T21:49:46.623' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (42, 1, 5, N'GS-2024-001', CAST(N'2026-01-02' AS Date), CAST(N'2027-01-02' AS Date), N'Active', N'cert3.jpg', N'', CAST(N'2026-01-02T01:01:33.340' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (44, 1, 10, N'CERT-88209', CAST(N'2026-01-02' AS Date), CAST(N'2026-01-09' AS Date), N'Active', N'1_20260103193443_76a9a5f874b042ce9b924838d552a76a.jpg', N'', CAST(N'2026-01-03T19:39:16.303' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (45, 1, 6, N'01234567', CAST(N'2024-01-10' AS Date), CAST(N'2028-01-10' AS Date), N'Active', N'1_20260103194625_37c33b6a22e841a9822493efe6c26fc7.pdf', N'', CAST(N'2026-01-03T19:46:39.640' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (46, 1, 2, N'CERT-88209', CAST(N'2026-01-01' AS Date), CAST(N'2026-01-10' AS Date), N'Active', N'1_20260103195144_113cdefcf89848eeb802226afc6b567e.jpg', N'', CAST(N'2026-01-03T19:51:44.133' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (47, 1, 11, N'CERT-88209', CAST(N'2026-01-02' AS Date), CAST(N'2026-02-03' AS Date), N'Active', N'1_20260103195330_231904f615da4917a1c6b49e624982f8.jpg', N'', CAST(N'2026-01-03T19:53:30.040' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (48, 1, 3, N'CERT-88209', CAST(N'2026-01-03' AS Date), CAST(N'2028-01-03' AS Date), N'Active', NULL, N'', CAST(N'2026-01-03T19:54:50.117' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (49, 2, 1, N'01234567', CAST(N'2024-01-10' AS Date), CAST(N'2028-01-10' AS Date), N'Active', N'2_20260103200507_ca14242d48bc4230b74f7d1a3f496e27.pdf', N'', CAST(N'2026-01-03T20:05:07.233' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (50, 3, 14, N'01234567', CAST(N'2024-01-10' AS Date), CAST(N'2028-01-10' AS Date), N'Active', N'3_20260103200721_902fc75fb07b4800b84821b3f0d8448d.pdf', N'', CAST(N'2026-01-03T20:07:21.620' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (51, 5, 15, N'01234567', CAST(N'2024-01-10' AS Date), CAST(N'2028-01-10' AS Date), N'Active', N'5_20260103201931_b1aad0afe0db4cb49956c8cf2cc4bd8f.pdf', N'', CAST(N'2026-01-03T20:19:31.983' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (52, 5, 11, N'01234567', CAST(N'2026-01-03' AS Date), CAST(N'2029-01-03' AS Date), N'Active', NULL, N'', CAST(N'2026-01-03T20:21:31.793' AS DateTime), CAST(N'2026-01-03T20:34:32.140' AS DateTime))
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (53, 6, 10, N'01234567', CAST(N'2024-01-10' AS Date), CAST(N'2028-01-10' AS Date), N'Active', N'6_20260103202613_56f8171750c44ca5aa9271bf7dcf37b9.pdf', N'', CAST(N'2026-01-03T20:26:13.453' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (54, 6, 7, N'HVAC-2022-156', CAST(N'2026-01-03' AS Date), CAST(N'2029-01-03' AS Date), N'Active', NULL, N'', CAST(N'2026-01-03T20:27:05.050' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (55, 6, 13, N'HVAC-2022-156', CAST(N'2026-01-03' AS Date), CAST(N'2029-01-03' AS Date), N'Active', NULL, N'', CAST(N'2026-01-03T20:27:25.743' AS DateTime), NULL)
GO
INSERT [dbo].[EmployeeCertifications] ([EmployeeCertificationID], [EmployeeID], [CertificationTypeID], [CertificateNumber], [IssueDate], [ExpiryDate], [Status], [CertificateFileName], [Notes], [CreatedDate], [ModifiedDate]) VALUES (56, 72, 13, N'01234567', CAST(N'2024-01-10' AS Date), CAST(N'2028-01-10' AS Date), N'Active', N'72_20260103225907_6550c9f4a1e94a47b7e7928294b3154b.pdf', N'', CAST(N'2026-01-03T22:59:27.693' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[EmployeeCertifications] OFF
GO
SET IDENTITY_INSERT [dbo].[Employees] ON 
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (1, N'EMP001', N'דוד', N'כהן', N'david.cohen@company.com', N'052-1234567', 1, N'טכנאי תחזוקה', CAST(N'2020-01-15' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (2, N'EMP002', N'משה', N'לוי', N'moshe.levi@company.com', N'052-2345678', 1, N'טכנאי חשמל', CAST(N'2019-03-20' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (3, N'EMP003', N'יוסף', N'ברק', N'yosef.barak@company.com', N'052-3456789', 1, N'מנהל תחזוקה', CAST(N'2018-05-10' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (4, N'EMP004', N'אבי', N'שמיר', N'avi.shamir@company.com', N'052-4567890', 1, N'טכנאי מכונות', CAST(N'2021-02-14' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (5, N'EMP005', N'רון', N'גולן', N'ron.golan@company.com', N'052-5678901', 1, N'טכנאי מעליות', CAST(N'2020-06-18' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (6, N'EMP006', N'עמי', N'דרור', N'ami.dror@company.com', N'052-6789012', 1, N'טכנאי מיזוג', CAST(N'2019-08-22' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (7, N'EMP007', N'גיל', N'אשר', N'gil.asher@company.com', N'052-7890123', 1, N'טכנאי אינסטלציה', CAST(N'2021-09-05' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (8, N'EMP008', N'תומר', N'פז', N'tomer.paz@company.com', N'052-8901234', 1, N'טכנאי בטיחות', CAST(N'2020-11-11' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (9, N'EMP009', N'עודד', N'נוי', N'oded.noy@company.com', N'052-9012345', 1, N'טכנאי כללי', CAST(N'2019-12-30' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (10, N'EMP010', N'אור', N'מור', N'or.mor@company.com', N'053-0123456', 1, N'טכנאי כללי', CAST(N'2021-03-17' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (11, N'EMP011', N'גל', N'כץ', N'gal.katz@company.com', N'053-1234567', 1, N'טכנאי כללי', CAST(N'2020-07-25' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (12, N'EMP012', N'נועם', N'רון', N'noam.ron@company.com', N'053-2345678', 1, N'טכנאי כללי', CAST(N'2019-04-08' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (13, N'EMP013', N'איתי', N'בן', N'itai.ben@company.com', N'053-3456789', 1, N'טכנאי כללי', CAST(N'2021-05-20' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (14, N'EMP014', N'ליאור', N'שי', N'lior.shai@company.com', N'053-4567890', 1, N'טכנאי כללי', CAST(N'2020-10-13' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (15, N'EMP015', N'יניב', N'דן', N'yaniv.dan@company.com', N'053-5678901', 1, N'טכנאי כללי', CAST(N'2019-11-28' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (16, N'EMP016', N'שרה', N'מזרחי', N'sara.mizrahi@company.com', N'054-1111111', 2, N'מנהלת ייצור', CAST(N'2018-01-10' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (17, N'EMP017', N'רחל', N'אביב', N'rachel.aviv@company.com', N'054-2222222', 2, N'מפעילת קו ייצור', CAST(N'2019-02-15' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (18, N'EMP018', N'רבקה', N'שלום', N'rivka.shalom@company.com', N'054-3333333', 2, N'מפעילת קו ייצור', CAST(N'2020-03-20' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (19, N'EMP019', N'דינה', N'צור', N'dina.tzur@company.com', N'054-4444444', 2, N'מפעילת מכונות', CAST(N'2019-04-25' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (20, N'EMP020', N'מרים', N'פלד', N'miriam.feld@company.com', N'054-5555555', 2, N'מפעילת מכונות', CAST(N'2021-05-30' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (21, N'EMP021', N'אסתר', N'גור', N'esther.gur@company.com', N'054-6666666', 2, N'טכנאית ייצור', CAST(N'2020-06-15' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (22, N'EMP022', N'יעל', N'כרמי', N'yael.karmi@company.com', N'054-7777777', 2, N'טכנאית ייצור', CAST(N'2019-07-20' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (23, N'EMP023', N'תמר', N'גל', N'tamar.gal@company.com', N'054-8888888', 2, N'פועלת ייצור', CAST(N'2021-08-25' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (24, N'EMP024', N'נעמי', N'רז', N'naomi.raz@company.com', N'054-9999999', 2, N'פועלת ייצור', CAST(N'2020-09-30' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (25, N'EMP025', N'חנה', N'בר', N'hanna.bar@company.com', N'055-1111111', 2, N'פועלת ייצור', CAST(N'2019-10-15' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (61, N'EMP061', N'אריה', N'סער', N'arye.saar@company.com', N'056-1111111', 3, N'מנהל מחסן', CAST(N'2018-02-01' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (62, N'EMP062', N'יגאל', N'נחום', N'yigal.nahum@company.com', N'056-2222222', 3, N'מלגזן', CAST(N'2019-03-15' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (63, N'EMP063', N'בועז', N'רם', N'boaz.ram@company.com', N'056-3333333', 3, N'מלגזן', CAST(N'2020-04-20' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (64, N'EMP064', N'עידו', N'אור', N'ido.or@company.com', N'056-4444444', 3, N'מלגזן', CAST(N'2019-05-25' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (65, N'EMP065', N'שלמה', N'זהב', N'shlomo.zahav@company.com', N'056-5555555', 3, N'פועל מחסן', CAST(N'2021-06-30' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (66, N'EMP066', N'זאב', N'לב', N'zeev.lev@company.com', N'056-6666666', 3, N'פועל מחסן', CAST(N'2020-07-15' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (67, N'EMP067', N'אלי', N'נתן', N'eli.natan@company.com', N'056-7777777', 3, N'פועל מחסן', CAST(N'2019-08-20' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (68, N'EMP068', N'חיים', N'ים', N'haim.yam@company.com', N'056-8888888', 3, N'פועל מחסן', CAST(N'2021-09-25' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (69, N'EMP069', N'מאיר', N'שחר', N'meir.shahar@company.com', N'056-9999999', 3, N'פועל מחסן', CAST(N'2020-10-30' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (70, N'EMP070', N'דורון', N'עוז', N'doron.oz@company.com', N'057-1111111', 3, N'פועל מחסן', CAST(N'2019-11-15' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (71, N'EMP071', N'רמי', N'אש', N'rami.esh@company.com', N'057-2222222', 3, N'פועל מחסן', CAST(N'2021-12-20' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (72, N'EMP072', N'טל', N'גן', N'tal.gan@company.com', N'057-3333333', 3, N'פועל מחסן', CAST(N'2020-01-25' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (73, N'EMP073', N'לאה', N'אדום', N'lea.adom@company.com', N'057-4444444', 4, N'מנהלת אריזה', CAST(N'2018-03-01' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (74, N'EMP074', N'רות', N'ירוק', N'ruth.yarok@company.com', N'057-5555555', 4, N'פועלת אריזה', CAST(N'2019-04-15' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (75, N'EMP075', N'שושנה', N'כחול', N'shoshana.kahol@company.com', N'057-6666666', 4, N'פועלת אריזה', CAST(N'2020-05-20' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (93, N'EMP093', N'נדב', N'הר', N'nadav.har@company.com', N'058-1111111', 5, N'מנהל לוגיסטיקה', CAST(N'2018-04-01' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (94, N'EMP094', N'עמית', N'עמק', N'amit.emek@company.com', N'058-2222222', 5, N'רכז לוגיסטיקה', CAST(N'2019-05-15' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (101, N'EMP101', N'מיכל', N'נוף', N'michal.nof@company.com', N'059-1111111', 6, N'מנהלת איכות', CAST(N'2018-05-01' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (111, N'EMP111', N'דניאל', N'מלך', N'daniel.melech@company.com', N'060-1111111', 7, N'מנהל כללי', CAST(N'2017-01-01' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (112, N'EMP112', N'אנה', N'שרה', N'anna.sara@company.com', N'060-2222222', 7, N'מנהלת משאבי אנוש', CAST(N'2018-02-01' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (116, N'EMP116', N'אבי', N'בטוח', N'avi.batuah@company.com', N'061-1111111', 8, N'ממונה בטיחות ראשי', CAST(N'2017-03-01' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (117, N'EMP117', N'מיכאל', N'שומר', N'michael.shomer@company.com', N'061-2222222', 8, N'ממונה בטיחות', CAST(N'2019-04-15' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeNumber], [FirstName], [LastName], [Email], [PhoneNumber], [DepartmentID], [PositionTitle], [HireDate], [TerminationDate], [IsActive], [PhotoFileName], [CreatedDate], [ModifiedDate]) VALUES (118, N'EMP118', N'רונית', N'בוחן', N'ronit.bohen@company.com', N'061-3333333', 8, N'רכזת בטיחות', CAST(N'2020-05-20' AS Date), NULL, 1, N'oved.jpg', CAST(N'2025-12-31T21:49:46.370' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[Employees] OFF
GO
SET IDENTITY_INSERT [dbo].[ReadinessAlerts] ON 
GO
INSERT [dbo].[ReadinessAlerts] ([AlertID], [DepartmentID], [AlertType], [Severity], [Title], [Description], [RelatedCertificationTypeID], [RelatedEmployeeID], [Status], [CreatedDate], [ResolvedDate], [ResolvedByUserID], [ResolutionNotes]) VALUES (1, 1, N'MissingCriticalCert', N'Critical', N'חסר ממונה מעליות', N'מחלקת תחזוקה: רון גולן (EMP005) אמור להיות ממונה מעליות אך חסרה לו ההסמכה. יש לטפל מיידית!', 5, 5, N'Active', CAST(N'2025-12-31T21:49:46.797' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ReadinessAlerts] ([AlertID], [DepartmentID], [AlertType], [Severity], [Title], [Description], [RelatedCertificationTypeID], [RelatedEmployeeID], [Status], [CreatedDate], [ResolvedDate], [ResolvedByUserID], [ResolutionNotes]) VALUES (2, 1, N'ExpiredCertificate', N'High', N'הסמכת אינסטלציה פגה', N'מחלקת תחזוקה: גיל אשר (EMP007) - הסמכת אינסטלציה פגה בתאריך 15/11/2024. יש לחדש!', 13, 7, N'Active', CAST(N'2025-12-31T21:49:46.797' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ReadinessAlerts] ([AlertID], [DepartmentID], [AlertType], [Severity], [Title], [Description], [RelatedCertificationTypeID], [RelatedEmployeeID], [Status], [CreatedDate], [ResolvedDate], [ResolvedByUserID], [ResolutionNotes]) VALUES (3, 2, N'ExpiredCertificate', N'Medium', N'הדרכת בטיחות פגה', N'מחלקת ייצור: דינה צור (EMP019) - הדרכת בטיחות כללית פגה. יש לשלוח לריענון.', 9, 19, N'Active', CAST(N'2025-12-31T21:49:46.797' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[ReadinessAlerts] ([AlertID], [DepartmentID], [AlertType], [Severity], [Title], [Description], [RelatedCertificationTypeID], [RelatedEmployeeID], [Status], [CreatedDate], [ResolvedDate], [ResolvedByUserID], [ResolutionNotes]) VALUES (4, 1, N'AbsentEmployee', N'High', N'עובד קריטי נעדר', N'מחלקת תחזוקה: רון גולן (ממונה מעליות) לא הגיע למשמרת היום. אין מחליף!', 5, 5, N'Active', CAST(N'2025-12-31T21:49:46.797' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[ReadinessAlerts] OFF
GO
SET IDENTITY_INSERT [dbo].[ReadinessHistory] ON 
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (1, 1, CAST(N'2025-12-01' AS Date), 1, CAST(85.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (2, 3, CAST(N'2025-12-01' AS Date), 1, CAST(95.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (3, 2, CAST(N'2025-12-01' AS Date), 1, CAST(88.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (4, 1, CAST(N'2025-12-02' AS Date), 1, CAST(86.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-02T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (5, 3, CAST(N'2025-12-02' AS Date), 1, CAST(96.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-02T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (6, 2, CAST(N'2025-12-02' AS Date), 1, CAST(89.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-02T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (7, 1, CAST(N'2025-12-03' AS Date), 1, CAST(87.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (8, 3, CAST(N'2025-12-03' AS Date), 1, CAST(97.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (9, 2, CAST(N'2025-12-03' AS Date), 1, CAST(90.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (10, 1, CAST(N'2025-12-04' AS Date), 1, CAST(88.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (11, 3, CAST(N'2025-12-04' AS Date), 1, CAST(98.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (12, 2, CAST(N'2025-12-04' AS Date), 1, CAST(91.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (13, 1, CAST(N'2025-12-05' AS Date), 1, CAST(89.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (14, 3, CAST(N'2025-12-05' AS Date), 1, CAST(99.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (15, 2, CAST(N'2025-12-05' AS Date), 1, CAST(92.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (16, 1, CAST(N'2025-12-06' AS Date), 1, CAST(90.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (17, 3, CAST(N'2025-12-06' AS Date), 1, CAST(95.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (18, 2, CAST(N'2025-12-06' AS Date), 1, CAST(93.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (19, 1, CAST(N'2025-12-07' AS Date), 1, CAST(91.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (20, 3, CAST(N'2025-12-07' AS Date), 1, CAST(96.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (21, 2, CAST(N'2025-12-07' AS Date), 1, CAST(94.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (22, 1, CAST(N'2025-12-08' AS Date), 1, CAST(92.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-08T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (23, 3, CAST(N'2025-12-08' AS Date), 1, CAST(97.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-08T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (24, 2, CAST(N'2025-12-08' AS Date), 1, CAST(95.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-08T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (25, 1, CAST(N'2025-12-09' AS Date), 1, CAST(93.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-09T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (26, 3, CAST(N'2025-12-09' AS Date), 1, CAST(98.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-09T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (27, 2, CAST(N'2025-12-09' AS Date), 1, CAST(88.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-09T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (28, 1, CAST(N'2025-12-10' AS Date), 1, CAST(94.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (29, 3, CAST(N'2025-12-10' AS Date), 1, CAST(99.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (30, 2, CAST(N'2025-12-10' AS Date), 1, CAST(89.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (31, 1, CAST(N'2025-12-11' AS Date), 1, CAST(85.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (32, 3, CAST(N'2025-12-11' AS Date), 1, CAST(95.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (33, 2, CAST(N'2025-12-11' AS Date), 1, CAST(90.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (34, 1, CAST(N'2025-12-12' AS Date), 1, CAST(86.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (35, 3, CAST(N'2025-12-12' AS Date), 1, CAST(96.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (36, 2, CAST(N'2025-12-12' AS Date), 1, CAST(91.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (37, 1, CAST(N'2025-12-13' AS Date), 1, CAST(87.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (38, 3, CAST(N'2025-12-13' AS Date), 1, CAST(97.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (39, 2, CAST(N'2025-12-13' AS Date), 1, CAST(92.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (40, 1, CAST(N'2025-12-14' AS Date), 1, CAST(88.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (41, 3, CAST(N'2025-12-14' AS Date), 1, CAST(98.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (42, 2, CAST(N'2025-12-14' AS Date), 1, CAST(93.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (43, 1, CAST(N'2025-12-15' AS Date), 1, CAST(89.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-15T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (44, 3, CAST(N'2025-12-15' AS Date), 1, CAST(99.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-15T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (45, 2, CAST(N'2025-12-15' AS Date), 1, CAST(94.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-15T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (46, 1, CAST(N'2025-12-16' AS Date), 1, CAST(90.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-16T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (47, 3, CAST(N'2025-12-16' AS Date), 1, CAST(95.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-16T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (48, 2, CAST(N'2025-12-16' AS Date), 1, CAST(95.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-16T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (49, 1, CAST(N'2025-12-17' AS Date), 1, CAST(91.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (50, 3, CAST(N'2025-12-17' AS Date), 1, CAST(96.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (51, 2, CAST(N'2025-12-17' AS Date), 1, CAST(88.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (52, 1, CAST(N'2025-12-18' AS Date), 1, CAST(92.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (53, 3, CAST(N'2025-12-18' AS Date), 1, CAST(97.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (54, 2, CAST(N'2025-12-18' AS Date), 1, CAST(89.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (55, 1, CAST(N'2025-12-19' AS Date), 1, CAST(93.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (56, 3, CAST(N'2025-12-19' AS Date), 1, CAST(98.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (57, 2, CAST(N'2025-12-19' AS Date), 1, CAST(90.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (58, 1, CAST(N'2025-12-20' AS Date), 1, CAST(94.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (59, 3, CAST(N'2025-12-20' AS Date), 1, CAST(99.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (60, 2, CAST(N'2025-12-20' AS Date), 1, CAST(91.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (61, 1, CAST(N'2025-12-21' AS Date), 1, CAST(85.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (62, 3, CAST(N'2025-12-21' AS Date), 1, CAST(95.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (63, 2, CAST(N'2025-12-21' AS Date), 1, CAST(92.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (64, 1, CAST(N'2025-12-22' AS Date), 1, CAST(86.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-22T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (65, 3, CAST(N'2025-12-22' AS Date), 1, CAST(96.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-22T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (66, 2, CAST(N'2025-12-22' AS Date), 1, CAST(93.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-22T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (67, 1, CAST(N'2025-12-23' AS Date), 1, CAST(87.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-23T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (68, 3, CAST(N'2025-12-23' AS Date), 1, CAST(97.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-23T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (69, 2, CAST(N'2025-12-23' AS Date), 1, CAST(94.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-23T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (70, 1, CAST(N'2025-12-24' AS Date), 1, CAST(88.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (71, 3, CAST(N'2025-12-24' AS Date), 1, CAST(98.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (72, 2, CAST(N'2025-12-24' AS Date), 1, CAST(95.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (73, 1, CAST(N'2025-12-25' AS Date), 1, CAST(89.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (74, 3, CAST(N'2025-12-25' AS Date), 1, CAST(99.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (75, 2, CAST(N'2025-12-25' AS Date), 1, CAST(88.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (76, 1, CAST(N'2025-12-26' AS Date), 1, CAST(90.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (77, 3, CAST(N'2025-12-26' AS Date), 1, CAST(95.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (78, 2, CAST(N'2025-12-26' AS Date), 1, CAST(89.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (79, 1, CAST(N'2025-12-27' AS Date), 1, CAST(91.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (80, 3, CAST(N'2025-12-27' AS Date), 1, CAST(96.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (81, 2, CAST(N'2025-12-27' AS Date), 1, CAST(90.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (82, 1, CAST(N'2025-12-28' AS Date), 1, CAST(92.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (83, 3, CAST(N'2025-12-28' AS Date), 1, CAST(97.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (84, 2, CAST(N'2025-12-28' AS Date), 1, CAST(91.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (85, 1, CAST(N'2025-12-29' AS Date), 1, CAST(93.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-29T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (86, 3, CAST(N'2025-12-29' AS Date), 1, CAST(98.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-29T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (87, 2, CAST(N'2025-12-29' AS Date), 1, CAST(92.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-29T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (88, 1, CAST(N'2025-12-30' AS Date), 1, CAST(94.50 AS Decimal(5, 2)), 15, 12, 10, 0, 1, 2, 1, NULL, CAST(N'2025-12-30T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (89, 3, CAST(N'2025-12-30' AS Date), 1, CAST(99.00 AS Decimal(5, 2)), 12, 12, 12, 0, 0, 0, 0, NULL, CAST(N'2025-12-30T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[ReadinessHistory] ([HistoryID], [DepartmentID], [CalculationDate], [ShiftID], [ReadinessScore], [TotalRequired], [TotalPresent], [TotalCompliant], [CriticalGaps], [HighGaps], [MediumGaps], [LowGaps], [Notes], [CreatedDate]) VALUES (90, 2, CAST(N'2025-12-30' AS Date), 1, CAST(93.00 AS Decimal(5, 2)), 45, 40, 36, 0, 1, 3, 5, NULL, CAST(N'2025-12-30T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[ReadinessHistory] OFF
GO
SET IDENTITY_INSERT [dbo].[ScheduledTasks] ON 
GO
INSERT [dbo].[ScheduledTasks] ([TaskID], [TaskName], [TaskType], [Schedule], [LastRunDate], [NextRunDate], [LastRunStatus], [LastRunMessage], [IsEnabled], [CreatedDate], [ModifiedDate]) VALUES (1, N'בדיקת כשירות יומית', N'ReadinessCheck', N'Daily at 02:00', NULL, CAST(N'2026-01-01T02:00:00.000' AS DateTime), NULL, NULL, 1, CAST(N'2025-12-31T21:53:51.967' AS DateTime), NULL)
GO
INSERT [dbo].[ScheduledTasks] ([TaskID], [TaskName], [TaskType], [Schedule], [LastRunDate], [NextRunDate], [LastRunStatus], [LastRunMessage], [IsEnabled], [CreatedDate], [ModifiedDate]) VALUES (2, N'התראות על פקיעת הסמכות', N'ExpiryNotification', N'Daily at 08:00', NULL, CAST(N'2025-12-31T08:00:00.000' AS DateTime), NULL, NULL, 1, CAST(N'2025-12-31T21:53:51.967' AS DateTime), NULL)
GO
INSERT [dbo].[ScheduledTasks] ([TaskID], [TaskName], [TaskType], [Schedule], [LastRunDate], [NextRunDate], [LastRunStatus], [LastRunMessage], [IsEnabled], [CreatedDate], [ModifiedDate]) VALUES (3, N'דוח יומי למנהלים', N'DailyReport', N'Daily at 17:00', NULL, CAST(N'2025-12-31T17:00:00.000' AS DateTime), NULL, NULL, 1, CAST(N'2025-12-31T21:53:51.967' AS DateTime), NULL)
GO
INSERT [dbo].[ScheduledTasks] ([TaskID], [TaskName], [TaskType], [Schedule], [LastRunDate], [NextRunDate], [LastRunStatus], [LastRunMessage], [IsEnabled], [CreatedDate], [ModifiedDate]) VALUES (4, N'דוח שבועי', N'WeeklyReport', N'Every Sunday at 09:00', NULL, CAST(N'2026-01-04T09:00:00.000' AS DateTime), NULL, NULL, 1, CAST(N'2025-12-31T21:53:51.967' AS DateTime), NULL)
GO
INSERT [dbo].[ScheduledTasks] ([TaskID], [TaskName], [TaskType], [Schedule], [LastRunDate], [NextRunDate], [LastRunStatus], [LastRunMessage], [IsEnabled], [CreatedDate], [ModifiedDate]) VALUES (5, N'ניקוי נתונים ישנים', N'DataCleanup', N'Monthly on 1st at 03:00', NULL, CAST(N'2026-01-01T03:00:00.000' AS DateTime), NULL, NULL, 1, CAST(N'2025-12-31T21:53:51.967' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[ScheduledTasks] OFF
GO
SET IDENTITY_INSERT [dbo].[ShiftAssignments] ON 
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (1, 1, 1, 1, CAST(N'2026-01-02' AS Date), 1, CAST(N'2026-01-02T04:51:04.260' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (2, 2, 1, 1, CAST(N'2026-01-02' AS Date), 1, CAST(N'2026-01-01T04:51:04.260' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (3, 3, 1, 1, CAST(N'2025-01-02' AS Date), 1, CAST(N'2026-01-01T04:51:04.260' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (4, 4, 1, 1, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:04.260' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (5, 6, 1, 1, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:04.260' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (6, 7, 1, 1, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:04.260' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (7, 8, 1, 1, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:04.260' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (8, 9, 1, 1, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:04.260' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (9, 5, 1, 1, CAST(N'2025-12-31' AS Date), 0, NULL, NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (10, 10, 1, 1, CAST(N'2025-12-31' AS Date), 0, NULL, NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (11, 11, 1, 1, CAST(N'2025-12-31' AS Date), 0, NULL, NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (12, 12, 1, 1, CAST(N'2025-12-31' AS Date), 0, NULL, NULL, NULL, CAST(N'2025-12-31T21:51:04.260' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (13, 61, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (14, 62, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (15, 63, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (16, 64, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (17, 65, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (18, 66, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (19, 67, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (20, 68, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (21, 69, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (22, 70, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (23, 71, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (24, 72, 1, 3, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:32.787' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:32.787' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (25, 16, 1, 2, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:53.520' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:53.520' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (26, 17, 1, 2, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:53.520' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:53.520' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (27, 18, 1, 2, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:53.520' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:53.520' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (28, 19, 1, 2, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:53.520' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:53.520' AS DateTime), NULL)
GO
INSERT [dbo].[ShiftAssignments] ([AssignmentID], [EmployeeID], [ShiftID], [DepartmentID], [AssignmentDate], [IsPresent], [CheckInTime], [CheckOutTime], [Notes], [CreatedDate], [ModifiedDate]) VALUES (29, 20, 1, 2, CAST(N'2025-12-31' AS Date), 1, CAST(N'2026-01-01T04:51:53.520' AS DateTime), NULL, NULL, CAST(N'2025-12-31T21:51:53.520' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[ShiftAssignments] OFF
GO
SET IDENTITY_INSERT [dbo].[Shifts] ON 
GO
INSERT [dbo].[Shifts] ([ShiftID], [ShiftName], [ShiftCode], [StartTime], [EndTime], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (1, N'משמרת בוקר', N'A', CAST(N'07:00:00' AS Time), CAST(N'15:00:00' AS Time), 1, CAST(N'2025-12-31T21:49:46.683' AS DateTime), NULL)
GO
INSERT [dbo].[Shifts] ([ShiftID], [ShiftName], [ShiftCode], [StartTime], [EndTime], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (2, N'משמרת צהריים', N'B', CAST(N'15:00:00' AS Time), CAST(N'23:00:00' AS Time), 1, CAST(N'2025-12-31T21:49:46.683' AS DateTime), NULL)
GO
INSERT [dbo].[Shifts] ([ShiftID], [ShiftName], [ShiftCode], [StartTime], [EndTime], [IsActive], [CreatedDate], [ModifiedDate]) VALUES (3, N'משמרת לילה', N'C', CAST(N'23:00:00' AS Time), CAST(N'07:00:00' AS Time), 1, CAST(N'2025-12-31T21:49:46.683' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[Shifts] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([UserID], [Username], [PasswordHash], [Email], [FullName], [Role], [EmployeeID], [IsActive], [LastLoginDate], [FailedLoginAttempts], [LockedUntil], [CreatedDate], [ModifiedDate]) VALUES (1, N'admin', N'AQAAAAEAACcQAAAAEGxV5m8pj7K8pzQ...', N'admin@company.com', N'מנהל מערכת', N'Admin', NULL, 1, NULL, 0, NULL, CAST(N'2025-12-31T21:49:46.783' AS DateTime), NULL)
GO
INSERT [dbo].[Users] ([UserID], [Username], [PasswordHash], [Email], [FullName], [Role], [EmployeeID], [IsActive], [LastLoginDate], [FailedLoginAttempts], [LockedUntil], [CreatedDate], [ModifiedDate]) VALUES (2, N'safety_manager', N'AQAAAAEAACcQAAAAEGxV5m8pj7K8pzQ...', N'avi.batuah@company.com', N'אבי בטוח', N'SafetyManager', 116, 1, NULL, 0, NULL, CAST(N'2025-12-31T21:49:46.783' AS DateTime), NULL)
GO
INSERT [dbo].[Users] ([UserID], [Username], [PasswordHash], [Email], [FullName], [Role], [EmployeeID], [IsActive], [LastLoginDate], [FailedLoginAttempts], [LockedUntil], [CreatedDate], [ModifiedDate]) VALUES (3, N'shift_manager_a', N'AQAAAAEAACcQAAAAEGxV5m8pj7K8pzQ...', N'yosef.barak@company.com', N'יוסף ברק', N'ShiftManager', 3, 1, NULL, 0, NULL, CAST(N'2025-12-31T21:49:46.783' AS DateTime), NULL)
GO
INSERT [dbo].[Users] ([UserID], [Username], [PasswordHash], [Email], [FullName], [Role], [EmployeeID], [IsActive], [LastLoginDate], [FailedLoginAttempts], [LockedUntil], [CreatedDate], [ModifiedDate]) VALUES (4, N'hr_manager', N'AQAAAAEAACcQAAAAEGxV5m8pj7K8pzQ...', N'anna.sara@company.com', N'אנה שרה', N'HR', 112, 1, NULL, 0, NULL, CAST(N'2025-12-31T21:49:46.783' AS DateTime), NULL)
GO
INSERT [dbo].[Users] ([UserID], [Username], [PasswordHash], [Email], [FullName], [Role], [EmployeeID], [IsActive], [LastLoginDate], [FailedLoginAttempts], [LockedUntil], [CreatedDate], [ModifiedDate]) VALUES (5, N'doctor', N'AQAAAAEAACcQAAAAEGxV5m8pj7K8pzQ...', N'doctor@company.com', N'ד"ר רפאל כהן', N'Doctor', NULL, 1, NULL, 0, NULL, CAST(N'2025-12-31T21:49:46.783' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
/****** Object:  Index [IX_Notification_Alert]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Notification_Alert] ON [dbo].[AlertNotifications]
(
	[AlertID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Notification_Status]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Notification_Status] ON [dbo].[AlertNotifications]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AuditLog_Action]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_AuditLog_Action] ON [dbo].[AuditLogs]
(
	[Action] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_AuditLog_Date]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_AuditLog_Date] ON [dbo].[AuditLogs]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AuditLog_Table]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_AuditLog_Table] ON [dbo].[AuditLogs]
(
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_AuditLog_User]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_AuditLog_User] ON [dbo].[AuditLogs]
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Certific__A47C70B0EB69A39B]    Script Date: 04/01/2026 0:01:08 ******/
ALTER TABLE [dbo].[CertificationTypes] ADD UNIQUE NONCLUSTERED 
(
	[CertificationCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_CertType_Code]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_CertType_Code] ON [dbo].[CertificationTypes]
(
	[CertificationCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_CertType_Criticality]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_CertType_Criticality] ON [dbo].[CertificationTypes]
(
	[CriticalityLevel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Report_Date]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Report_Date] ON [dbo].[ComplianceReports]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Report_Type]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Report_Type] ON [dbo].[ComplianceReports]
(
	[ReportType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_DeptReq]    Script Date: 04/01/2026 0:01:08 ******/
ALTER TABLE [dbo].[DepartmentRequirements] ADD  CONSTRAINT [UQ_DeptReq] UNIQUE NONCLUSTERED 
(
	[DepartmentID] ASC,
	[CertificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_DeptReq_Active]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_DeptReq_Active] ON [dbo].[DepartmentRequirements]
(
	[IsActive] ASC
)
WHERE ([IsActive]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_DeptReq_CertType]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_DeptReq_CertType] ON [dbo].[DepartmentRequirements]
(
	[CertificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_DeptReq_Department]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_DeptReq_Department] ON [dbo].[DepartmentRequirements]
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Departme__6EA8896D81B12A4F]    Script Date: 04/01/2026 0:01:08 ******/
ALTER TABLE [dbo].[Departments] ADD UNIQUE NONCLUSTERED 
(
	[DepartmentCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Department_Active]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Department_Active] ON [dbo].[Departments]
(
	[IsActive] ASC
)
WHERE ([IsActive]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Department_Code]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Department_Code] ON [dbo].[Departments]
(
	[DepartmentCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EmpCert_CertType]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_EmpCert_CertType] ON [dbo].[EmployeeCertifications]
(
	[CertificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EmpCert_Employee]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_EmpCert_Employee] ON [dbo].[EmployeeCertifications]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EmpCert_Expiry]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_EmpCert_Expiry] ON [dbo].[EmployeeCertifications]
(
	[ExpiryDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_EmpCert_Status]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_EmpCert_Status] ON [dbo].[EmployeeCertifications]
(
	[Status] ASC
)
WHERE ([Status]='Active')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Employee__8D66359821F2C757]    Script Date: 04/01/2026 0:01:08 ******/
ALTER TABLE [dbo].[Employees] ADD UNIQUE NONCLUSTERED 
(
	[EmployeeNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Employee_Active]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Employee_Active] ON [dbo].[Employees]
(
	[IsActive] ASC
)
WHERE ([IsActive]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Employee_Department]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Employee_Department] ON [dbo].[Employees]
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Employee_Name]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Employee_Name] ON [dbo].[Employees]
(
	[LastName] ASC,
	[FirstName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Employee_Number]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Employee_Number] ON [dbo].[Employees]
(
	[EmployeeNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Alert_CreatedDate]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Alert_CreatedDate] ON [dbo].[ReadinessAlerts]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Alert_Department]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Alert_Department] ON [dbo].[ReadinessAlerts]
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Alert_Severity]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Alert_Severity] ON [dbo].[ReadinessAlerts]
(
	[Severity] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Alert_Status]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Alert_Status] ON [dbo].[ReadinessAlerts]
(
	[Status] ASC
)
WHERE ([Status]='Active')
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ReadHistory_Date]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_ReadHistory_Date] ON [dbo].[ReadinessHistory]
(
	[CalculationDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ReadHistory_Department]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_ReadHistory_Department] ON [dbo].[ReadinessHistory]
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ReadHistory_Score]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_ReadHistory_Score] ON [dbo].[ReadinessHistory]
(
	[ReadinessScore] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Suggestion_Department]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Suggestion_Department] ON [dbo].[ReplacementSuggestions]
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Suggestion_Employee]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Suggestion_Employee] ON [dbo].[ReplacementSuggestions]
(
	[SuggestedEmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Suggestion_Status]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Suggestion_Status] ON [dbo].[ReplacementSuggestions]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Task_Enabled]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Task_Enabled] ON [dbo].[ScheduledTasks]
(
	[IsEnabled] ASC
)
WHERE ([IsEnabled]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Task_NextRun]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Task_NextRun] ON [dbo].[ScheduledTasks]
(
	[NextRunDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_ShiftAssignment]    Script Date: 04/01/2026 0:01:08 ******/
ALTER TABLE [dbo].[ShiftAssignments] ADD  CONSTRAINT [UQ_ShiftAssignment] UNIQUE NONCLUSTERED 
(
	[EmployeeID] ASC,
	[ShiftID] ASC,
	[AssignmentDate] ASC,
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShiftAssign_Date]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_ShiftAssign_Date] ON [dbo].[ShiftAssignments]
(
	[AssignmentDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShiftAssign_Department]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_ShiftAssign_Department] ON [dbo].[ShiftAssignments]
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShiftAssign_Employee]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_ShiftAssign_Employee] ON [dbo].[ShiftAssignments]
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShiftAssign_Shift]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_ShiftAssign_Shift] ON [dbo].[ShiftAssignments]
(
	[ShiftID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Shift_Code]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_Shift_Code] ON [dbo].[Shifts]
(
	[ShiftCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__536C85E473910946]    Script Date: 04/01/2026 0:01:08 ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_User_Active]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_User_Active] ON [dbo].[Users]
(
	[IsActive] ASC
)
WHERE ([IsActive]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_User_Role]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_User_Role] ON [dbo].[Users]
(
	[Role] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_User_Username]    Script Date: 04/01/2026 0:01:08 ******/
CREATE NONCLUSTERED INDEX [IX_User_Username] ON [dbo].[Users]
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AlertNotifications] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[AlertNotifications] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[AuditLogs] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[CertificationTypes] ADD  DEFAULT ((12)) FOR [ValidityPeriodMonths]
GO
ALTER TABLE [dbo].[CertificationTypes] ADD  DEFAULT ('Medium') FOR [CriticalityLevel]
GO
ALTER TABLE [dbo].[CertificationTypes] ADD  DEFAULT ((1)) FOR [RequiresRenewal]
GO
ALTER TABLE [dbo].[CertificationTypes] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ComplianceReports] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[DepartmentRequirements] ADD  DEFAULT ((1)) FOR [MinimumRequired]
GO
ALTER TABLE [dbo].[DepartmentRequirements] ADD  DEFAULT ((1)) FOR [Priority]
GO
ALTER TABLE [dbo].[DepartmentRequirements] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DepartmentRequirements] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Departments] ADD  DEFAULT ((1)) FOR [MinimumStaffCount]
GO
ALTER TABLE [dbo].[Departments] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Departments] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[EmployeeCertifications] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[EmployeeCertifications] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Employees] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Employees] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ReadinessAlerts] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[ReadinessAlerts] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ReadinessHistory] ADD  DEFAULT ((0)) FOR [CriticalGaps]
GO
ALTER TABLE [dbo].[ReadinessHistory] ADD  DEFAULT ((0)) FOR [HighGaps]
GO
ALTER TABLE [dbo].[ReadinessHistory] ADD  DEFAULT ((0)) FOR [MediumGaps]
GO
ALTER TABLE [dbo].[ReadinessHistory] ADD  DEFAULT ((0)) FOR [LowGaps]
GO
ALTER TABLE [dbo].[ReadinessHistory] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ReplacementSuggestions] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[ReplacementSuggestions] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ScheduledTasks] ADD  DEFAULT ((1)) FOR [IsEnabled]
GO
ALTER TABLE [dbo].[ScheduledTasks] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ShiftAssignments] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Shifts] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Shifts] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [FailedLoginAttempts]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[AlertNotifications]  WITH CHECK ADD  CONSTRAINT [FK_Notification_Alert] FOREIGN KEY([AlertID])
REFERENCES [dbo].[ReadinessAlerts] ([AlertID])
GO
ALTER TABLE [dbo].[AlertNotifications] CHECK CONSTRAINT [FK_Notification_Alert]
GO
ALTER TABLE [dbo].[ComplianceReports]  WITH CHECK ADD  CONSTRAINT [FK_Report_User] FOREIGN KEY([GeneratedByUserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[ComplianceReports] CHECK CONSTRAINT [FK_Report_User]
GO
ALTER TABLE [dbo].[DepartmentRequirements]  WITH CHECK ADD  CONSTRAINT [FK_DeptReq_CertType] FOREIGN KEY([CertificationTypeID])
REFERENCES [dbo].[CertificationTypes] ([CertificationTypeID])
GO
ALTER TABLE [dbo].[DepartmentRequirements] CHECK CONSTRAINT [FK_DeptReq_CertType]
GO
ALTER TABLE [dbo].[DepartmentRequirements]  WITH CHECK ADD  CONSTRAINT [FK_DeptReq_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Departments] ([DepartmentID])
GO
ALTER TABLE [dbo].[DepartmentRequirements] CHECK CONSTRAINT [FK_DeptReq_Department]
GO
ALTER TABLE [dbo].[Departments]  WITH CHECK ADD  CONSTRAINT [FK_Department_Manager] FOREIGN KEY([ManagerEmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[Departments] CHECK CONSTRAINT [FK_Department_Manager]
GO
ALTER TABLE [dbo].[EmployeeCertifications]  WITH CHECK ADD  CONSTRAINT [FK_EmpCert_CertType] FOREIGN KEY([CertificationTypeID])
REFERENCES [dbo].[CertificationTypes] ([CertificationTypeID])
GO
ALTER TABLE [dbo].[EmployeeCertifications] CHECK CONSTRAINT [FK_EmpCert_CertType]
GO
ALTER TABLE [dbo].[EmployeeCertifications]  WITH CHECK ADD  CONSTRAINT [FK_EmpCert_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[EmployeeCertifications] CHECK CONSTRAINT [FK_EmpCert_Employee]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Departments] ([DepartmentID])
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employee_Department]
GO
ALTER TABLE [dbo].[ReadinessAlerts]  WITH CHECK ADD  CONSTRAINT [FK_Alert_CertType] FOREIGN KEY([RelatedCertificationTypeID])
REFERENCES [dbo].[CertificationTypes] ([CertificationTypeID])
GO
ALTER TABLE [dbo].[ReadinessAlerts] CHECK CONSTRAINT [FK_Alert_CertType]
GO
ALTER TABLE [dbo].[ReadinessAlerts]  WITH CHECK ADD  CONSTRAINT [FK_Alert_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Departments] ([DepartmentID])
GO
ALTER TABLE [dbo].[ReadinessAlerts] CHECK CONSTRAINT [FK_Alert_Department]
GO
ALTER TABLE [dbo].[ReadinessAlerts]  WITH CHECK ADD  CONSTRAINT [FK_Alert_Employee] FOREIGN KEY([RelatedEmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[ReadinessAlerts] CHECK CONSTRAINT [FK_Alert_Employee]
GO
ALTER TABLE [dbo].[ReadinessHistory]  WITH CHECK ADD  CONSTRAINT [FK_ReadHistory_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Departments] ([DepartmentID])
GO
ALTER TABLE [dbo].[ReadinessHistory] CHECK CONSTRAINT [FK_ReadHistory_Department]
GO
ALTER TABLE [dbo].[ReadinessHistory]  WITH CHECK ADD  CONSTRAINT [FK_ReadHistory_Shift] FOREIGN KEY([ShiftID])
REFERENCES [dbo].[Shifts] ([ShiftID])
GO
ALTER TABLE [dbo].[ReadinessHistory] CHECK CONSTRAINT [FK_ReadHistory_Shift]
GO
ALTER TABLE [dbo].[ReplacementSuggestions]  WITH CHECK ADD  CONSTRAINT [FK_Suggestion_CertType] FOREIGN KEY([RequiredCertificationTypeID])
REFERENCES [dbo].[CertificationTypes] ([CertificationTypeID])
GO
ALTER TABLE [dbo].[ReplacementSuggestions] CHECK CONSTRAINT [FK_Suggestion_CertType]
GO
ALTER TABLE [dbo].[ReplacementSuggestions]  WITH CHECK ADD  CONSTRAINT [FK_Suggestion_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Departments] ([DepartmentID])
GO
ALTER TABLE [dbo].[ReplacementSuggestions] CHECK CONSTRAINT [FK_Suggestion_Department]
GO
ALTER TABLE [dbo].[ReplacementSuggestions]  WITH CHECK ADD  CONSTRAINT [FK_Suggestion_Employee] FOREIGN KEY([SuggestedEmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[ReplacementSuggestions] CHECK CONSTRAINT [FK_Suggestion_Employee]
GO
ALTER TABLE [dbo].[ShiftAssignments]  WITH CHECK ADD  CONSTRAINT [FK_ShiftAssign_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Departments] ([DepartmentID])
GO
ALTER TABLE [dbo].[ShiftAssignments] CHECK CONSTRAINT [FK_ShiftAssign_Department]
GO
ALTER TABLE [dbo].[ShiftAssignments]  WITH CHECK ADD  CONSTRAINT [FK_ShiftAssign_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[ShiftAssignments] CHECK CONSTRAINT [FK_ShiftAssign_Employee]
GO
ALTER TABLE [dbo].[ShiftAssignments]  WITH CHECK ADD  CONSTRAINT [FK_ShiftAssign_Shift] FOREIGN KEY([ShiftID])
REFERENCES [dbo].[Shifts] ([ShiftID])
GO
ALTER TABLE [dbo].[ShiftAssignments] CHECK CONSTRAINT [FK_ShiftAssign_Shift]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_User_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_User_Employee]
GO
ALTER TABLE [dbo].[AlertNotifications]  WITH CHECK ADD  CONSTRAINT [CHK_NotificationStatus] CHECK  (([Status]='Cancelled' OR [Status]='Failed' OR [Status]='Sent' OR [Status]='Pending'))
GO
ALTER TABLE [dbo].[AlertNotifications] CHECK CONSTRAINT [CHK_NotificationStatus]
GO
ALTER TABLE [dbo].[AlertNotifications]  WITH CHECK ADD  CONSTRAINT [CHK_NotificationType] CHECK  (([NotificationType]='InApp' OR [NotificationType]='Push' OR [NotificationType]='SMS' OR [NotificationType]='Email'))
GO
ALTER TABLE [dbo].[AlertNotifications] CHECK CONSTRAINT [CHK_NotificationType]
GO
ALTER TABLE [dbo].[CertificationTypes]  WITH CHECK ADD  CONSTRAINT [CHK_CriticalityLevel] CHECK  (([CriticalityLevel]='Low' OR [CriticalityLevel]='Medium' OR [CriticalityLevel]='High' OR [CriticalityLevel]='Critical'))
GO
ALTER TABLE [dbo].[CertificationTypes] CHECK CONSTRAINT [CHK_CriticalityLevel]
GO
ALTER TABLE [dbo].[CertificationTypes]  WITH CHECK ADD  CONSTRAINT [CHK_ValidityPeriod] CHECK  (([ValidityPeriodMonths]>(0)))
GO
ALTER TABLE [dbo].[CertificationTypes] CHECK CONSTRAINT [CHK_ValidityPeriod]
GO
ALTER TABLE [dbo].[ComplianceReports]  WITH CHECK ADD  CONSTRAINT [CHK_ReportType] CHECK  (([ReportType]='AdHoc' OR [ReportType]='Annual' OR [ReportType]='Quarterly' OR [ReportType]='Monthly' OR [ReportType]='Weekly' OR [ReportType]='Daily'))
GO
ALTER TABLE [dbo].[ComplianceReports] CHECK CONSTRAINT [CHK_ReportType]
GO
ALTER TABLE [dbo].[DepartmentRequirements]  WITH CHECK ADD  CONSTRAINT [CHK_MinRequired] CHECK  (([MinimumRequired]>(0)))
GO
ALTER TABLE [dbo].[DepartmentRequirements] CHECK CONSTRAINT [CHK_MinRequired]
GO
ALTER TABLE [dbo].[Departments]  WITH CHECK ADD  CONSTRAINT [CHK_MinStaffCount] CHECK  (([MinimumStaffCount]>(0)))
GO
ALTER TABLE [dbo].[Departments] CHECK CONSTRAINT [CHK_MinStaffCount]
GO
ALTER TABLE [dbo].[EmployeeCertifications]  WITH CHECK ADD  CONSTRAINT [CHK_CertStatus] CHECK  (([Status]='Cancelled' OR [Status]='Suspended' OR [Status]='Expired' OR [Status]='Active'))
GO
ALTER TABLE [dbo].[EmployeeCertifications] CHECK CONSTRAINT [CHK_CertStatus]
GO
ALTER TABLE [dbo].[EmployeeCertifications]  WITH CHECK ADD  CONSTRAINT [CHK_ExpiryDate] CHECK  (([ExpiryDate]>[IssueDate]))
GO
ALTER TABLE [dbo].[EmployeeCertifications] CHECK CONSTRAINT [CHK_ExpiryDate]
GO
ALTER TABLE [dbo].[ReadinessAlerts]  WITH CHECK ADD  CONSTRAINT [CHK_AlertSeverity] CHECK  (([Severity]='Info' OR [Severity]='Low' OR [Severity]='Medium' OR [Severity]='High' OR [Severity]='Critical'))
GO
ALTER TABLE [dbo].[ReadinessAlerts] CHECK CONSTRAINT [CHK_AlertSeverity]
GO
ALTER TABLE [dbo].[ReadinessAlerts]  WITH CHECK ADD  CONSTRAINT [CHK_AlertStatus] CHECK  (([Status]='Expired' OR [Status]='Dismissed' OR [Status]='Resolved' OR [Status]='Active'))
GO
ALTER TABLE [dbo].[ReadinessAlerts] CHECK CONSTRAINT [CHK_AlertStatus]
GO
ALTER TABLE [dbo].[ReadinessHistory]  WITH CHECK ADD  CONSTRAINT [CHK_ReadinessScore] CHECK  (([ReadinessScore]>=(0) AND [ReadinessScore]<=(100)))
GO
ALTER TABLE [dbo].[ReadinessHistory] CHECK CONSTRAINT [CHK_ReadinessScore]
GO
ALTER TABLE [dbo].[ReplacementSuggestions]  WITH CHECK ADD  CONSTRAINT [CHK_ConfidenceScore] CHECK  (([ConfidenceScore]>=(0) AND [ConfidenceScore]<=(100)))
GO
ALTER TABLE [dbo].[ReplacementSuggestions] CHECK CONSTRAINT [CHK_ConfidenceScore]
GO
ALTER TABLE [dbo].[ReplacementSuggestions]  WITH CHECK ADD  CONSTRAINT [CHK_SuggestionStatus] CHECK  (([Status]='Expired' OR [Status]='Rejected' OR [Status]='Accepted' OR [Status]='Pending'))
GO
ALTER TABLE [dbo].[ReplacementSuggestions] CHECK CONSTRAINT [CHK_SuggestionStatus]
GO
ALTER TABLE [dbo].[ScheduledTasks]  WITH CHECK ADD  CONSTRAINT [CHK_TaskType] CHECK  (([TaskType]='DataCleanup' OR [TaskType]='MonthlyReport' OR [TaskType]='WeeklyReport' OR [TaskType]='DailyReport' OR [TaskType]='ExpiryNotification' OR [TaskType]='ReadinessCheck'))
GO
ALTER TABLE [dbo].[ScheduledTasks] CHECK CONSTRAINT [CHK_TaskType]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [CHK_UserRole] CHECK  (([Role]='Viewer' OR [Role]='Doctor' OR [Role]='HR' OR [Role]='ShiftManager' OR [Role]='SafetyManager' OR [Role]='Admin'))
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [CHK_UserRole]
GO
/****** Object:  StoredProcedure [dbo].[sp_CalculateDepartmentGaps]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CalculateDepartmentGaps]
    @DepartmentID INT,
    @Date DATE = NULL,
    @ShiftID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    
-- =============================================
-- SP 1: פירוט פערים
-- sp_CalculateDepartmentReadiness
-- =============================================
-- תיאור: מחשב ציון כשירות למחלקה בזמן אמת
-- מצליב בין: עובדים נוכחים, הסמכות תקפות, דרישות מחלקה
-- מחזיר: ציון 0-100 + פירוט פערים
-- =============================================


    -- ברירת מחדל: תאריך היום
    IF @Date IS NULL
        SET @Date = CAST(GETDATE() AS DATE);
    
    -- ==========================================
    -- CTE 1: עובדים שמשובצים למשמרת
    -- ==========================================
    ;WITH AssignedEmployees AS (
        SELECT 
            sa.EmployeeID,
            sa.IsPresent,
            e.FirstName,
            e.LastName,
            sa.ShiftID
        FROM ShiftAssignments sa
        INNER JOIN Employees e ON sa.EmployeeID = e.EmployeeID
        WHERE sa.DepartmentID = @DepartmentID
            AND sa.AssignmentDate = @Date
            AND (@ShiftID IS NULL OR sa.ShiftID = @ShiftID)
            AND e.IsActive = 1
    ),
    
    -- ==========================================
    -- CTE 2: הסמכות תקפות של עובדים
    -- ==========================================
    ValidCertifications AS (
        SELECT 
            ec.EmployeeID,
            ec.CertificationTypeID,
            ct.CertificationName,
            ct.CriticalityLevel,
            ec.ExpiryDate,
            CASE 
                WHEN ec.ExpiryDate < @Date THEN 0
                ELSE 1
            END AS IsValid
        FROM EmployeeCertifications ec
        INNER JOIN CertificationTypes ct ON ec.CertificationTypeID = ct.CertificationTypeID
        WHERE ec.Status = 'Active'
    ),
    
    -- ==========================================
    -- CTE 3: דרישות המחלקה
    -- ==========================================
    Requirements AS (
        SELECT 
            dr.CertificationTypeID,
            ct.CertificationName,
            ct.CriticalityLevel,
            dr.MinimumRequired,
            dr.Priority
        FROM DepartmentRequirements dr
        INNER JOIN CertificationTypes ct ON dr.CertificationTypeID = ct.CertificationTypeID
        WHERE dr.DepartmentID = @DepartmentID
            AND dr.IsActive = 1
    ),
    
    -- ==========================================
    -- CTE 4: עובדים כשירים לפי סוג הסמכה
    -- ==========================================
    CompliantEmployees AS (
        SELECT 
            r.CertificationTypeID,
            r.CertificationName,
            r.CriticalityLevel,
            r.MinimumRequired,
            COUNT(DISTINCT CASE 
                WHEN ae.IsPresent = 1 AND vc.IsValid = 1 
                THEN ae.EmployeeID 
            END) AS ActualCompliant,
            r.MinimumRequired - COUNT(DISTINCT CASE 
                WHEN ae.IsPresent = 1 AND vc.IsValid = 1 
                THEN ae.EmployeeID 
            END) AS Gap
        FROM Requirements r
        LEFT JOIN ValidCertifications vc ON r.CertificationTypeID = vc.CertificationTypeID
        LEFT JOIN AssignedEmployees ae ON vc.EmployeeID = ae.EmployeeID
        GROUP BY 
            r.CertificationTypeID,
            r.CertificationName,
            r.CriticalityLevel,
            r.MinimumRequired
    ),
    
    -- ==========================================
    -- CTE 5: חישוב ציונים לפי רמת קריטיות
    -- ==========================================
    ScoringMatrix AS (
        SELECT 
            CertificationTypeID,
            CertificationName,
            CriticalityLevel,
            MinimumRequired,
            ActualCompliant,
            Gap,
            CASE 
                WHEN Gap <= 0 THEN 100.0
                ELSE 
                    CASE CriticalityLevel
                        WHEN 'Critical' THEN GREATEST(0, 100 - (Gap * 50.0))
                        WHEN 'High' THEN GREATEST(0, 100 - (Gap * 30.0))
                        WHEN 'Medium' THEN GREATEST(0, 100 - (Gap * 15.0))
                        WHEN 'Low' THEN GREATEST(0, 100 - (Gap * 5.0))
                    END
            END AS Score,
            CASE CriticalityLevel
                WHEN 'Critical' THEN 4
                WHEN 'High' THEN 3
                WHEN 'Medium' THEN 2
                WHEN 'Low' THEN 1
            END AS Weight
        FROM CompliantEmployees
    )
    
    
    
    -- ==========================================
    -- טבלה נוספת: פירוט פערים
    -- ==========================================
    SELECT 
        CertificationName,
        CriticalityLevel,
        MinimumRequired,
        ActualCompliant,
        Gap,
        CAST(Score AS DECIMAL(5,2)) AS CertificationScore
    FROM ScoringMatrix
    WHERE Gap > 0
    ORDER BY 
        CASE CriticalityLevel
            WHEN 'Critical' THEN 1
            WHEN 'High' THEN 2
            WHEN 'Medium' THEN 3
            WHEN 'Low' THEN 4
        END,
        Gap DESC;
        
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CalculateDepartmentReadiness]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CalculateDepartmentReadiness]
    @DepartmentID INT,
    @Date DATE = NULL,
    @ShiftID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    
-- =============================================
-- SP 1: חישוב ציון כשירות מחלקה
-- sp_CalculateDepartmentReadiness
-- =============================================
-- תיאור: מחשב ציון כשירות למחלקה בזמן אמת
-- מצליב בין: עובדים נוכחים, הסמכות תקפות, דרישות מחלקה
-- מחזיר: ציון 0-100 + פירוט פערים
-- =============================================


    -- ברירת מחדל: תאריך היום
    IF @Date IS NULL
        SET @Date = CAST(GETDATE() AS DATE);
    
    -- ==========================================
    -- CTE 1: עובדים שמשובצים למשמרת
    -- ==========================================
    ;WITH AssignedEmployees AS (
        SELECT 
            sa.EmployeeID,
            sa.IsPresent,
            e.FirstName,
            e.LastName,
            sa.ShiftID
        FROM ShiftAssignments sa
        INNER JOIN Employees e ON sa.EmployeeID = e.EmployeeID
        WHERE sa.DepartmentID = @DepartmentID
            AND sa.AssignmentDate = @Date
            AND (@ShiftID IS NULL OR sa.ShiftID = @ShiftID)
            AND e.IsActive = 1
    ),
    
    -- ==========================================
    -- CTE 2: הסמכות תקפות של עובדים
    -- ==========================================
    ValidCertifications AS (
        SELECT 
            ec.EmployeeID,
            ec.CertificationTypeID,
            ct.CertificationName,
            ct.CriticalityLevel,
            ec.ExpiryDate,
            CASE 
                WHEN ec.ExpiryDate < @Date THEN 0
                ELSE 1
            END AS IsValid
        FROM EmployeeCertifications ec
        INNER JOIN CertificationTypes ct ON ec.CertificationTypeID = ct.CertificationTypeID
        WHERE ec.Status = 'Active'
    ),
    
    -- ==========================================
    -- CTE 3: דרישות המחלקה
    -- ==========================================
    Requirements AS (
        SELECT 
            dr.CertificationTypeID,
            ct.CertificationName,
            ct.CriticalityLevel,
            dr.MinimumRequired,
            dr.Priority
        FROM DepartmentRequirements dr
        INNER JOIN CertificationTypes ct ON dr.CertificationTypeID = ct.CertificationTypeID
        WHERE dr.DepartmentID = @DepartmentID
            AND dr.IsActive = 1
    ),
    
    -- ==========================================
    -- CTE 4: עובדים כשירים לפי סוג הסמכה
    -- ==========================================
    CompliantEmployees AS (
        SELECT 
            r.CertificationTypeID,
            r.CertificationName,
            r.CriticalityLevel,
            r.MinimumRequired,
            COUNT(DISTINCT CASE 
                WHEN ae.IsPresent = 1 AND vc.IsValid = 1 
                THEN ae.EmployeeID 
            END) AS ActualCompliant,
            r.MinimumRequired - COUNT(DISTINCT CASE 
                WHEN ae.IsPresent = 1 AND vc.IsValid = 1 
                THEN ae.EmployeeID 
            END) AS Gap
        FROM Requirements r
        LEFT JOIN ValidCertifications vc ON r.CertificationTypeID = vc.CertificationTypeID
        LEFT JOIN AssignedEmployees ae ON vc.EmployeeID = ae.EmployeeID
        GROUP BY 
            r.CertificationTypeID,
            r.CertificationName,
            r.CriticalityLevel,
            r.MinimumRequired
    ),
    
    -- ==========================================
    -- CTE 5: חישוב ציונים לפי רמת קריטיות
    -- ==========================================
    ScoringMatrix AS (
        SELECT 
            CertificationTypeID,
            CertificationName,
            CriticalityLevel,
            MinimumRequired,
            ActualCompliant,
            Gap,
            CASE 
                WHEN Gap <= 0 THEN 100.0
                ELSE 
                    CASE CriticalityLevel
                        WHEN 'Critical' THEN GREATEST(0, 100 - (Gap * 50.0))
                        WHEN 'High' THEN GREATEST(0, 100 - (Gap * 30.0))
                        WHEN 'Medium' THEN GREATEST(0, 100 - (Gap * 15.0))
                        WHEN 'Low' THEN GREATEST(0, 100 - (Gap * 5.0))
                    END
            END AS Score,
            CASE CriticalityLevel
                WHEN 'Critical' THEN 4
                WHEN 'High' THEN 3
                WHEN 'Medium' THEN 2
                WHEN 'Low' THEN 1
            END AS Weight
        FROM CompliantEmployees
    )
    
    -- ==========================================
    -- תוצאה סופית: ציון משוקלל + פירוט
    -- ==========================================
    SELECT 
        @DepartmentID AS DepartmentID,
        d.DepartmentName,
        @Date AS CalculationDate,
        
        -- ציון כללי משוקלל
        CAST(
            SUM(sm.Score * sm.Weight) / NULLIF(SUM(sm.Weight), 0)
        AS DECIMAL(5,2)) AS ReadinessScore,
        
        -- סטטיסטיקות כלליות
        (SELECT COUNT(*) FROM AssignedEmployees) AS TotalAssigned,
        (SELECT COUNT(*) FROM AssignedEmployees WHERE IsPresent = 1) AS TotalPresent,
        
        -- פירוט פערים לפי רמת חומרה
        SUM(CASE WHEN sm.CriticalityLevel = 'Critical' AND sm.Gap > 0 THEN 1 ELSE 0 END) AS CriticalGaps,
        SUM(CASE WHEN sm.CriticalityLevel = 'High' AND sm.Gap > 0 THEN 1 ELSE 0 END) AS HighGaps,
        SUM(CASE WHEN sm.CriticalityLevel = 'Medium' AND sm.Gap > 0 THEN 1 ELSE 0 END) AS MediumGaps,
        SUM(CASE WHEN sm.CriticalityLevel = 'Low' AND sm.Gap > 0 THEN 1 ELSE 0 END) AS LowGaps,
        
        -- סטטוס כללי
        CASE 
            WHEN SUM(CASE WHEN sm.CriticalityLevel = 'Critical' AND sm.Gap > 0 THEN 1 ELSE 0 END) > 0 
                THEN 'Critical'
            WHEN SUM(CASE WHEN sm.CriticalityLevel = 'High' AND sm.Gap > 0 THEN 1 ELSE 0 END) > 0 
                THEN 'Warning'
            WHEN SUM(CASE WHEN sm.Gap > 0 THEN 1 ELSE 0 END) > 0 
                THEN 'Attention'
            ELSE 'OK'
        END AS Status
        
    FROM ScoringMatrix sm
    CROSS JOIN Departments d
    WHERE d.DepartmentID = @DepartmentID
    GROUP BY d.DepartmentName;
    
   
        
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateComplianceReport]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GenerateComplianceReport]
    @StartDate DATE,
    @EndDate DATE,
    @DepartmentID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- ==========================================
    -- חלק 1: סיכום כללי
    -- ==========================================
    SELECT 
        @StartDate AS PeriodStart,
        @EndDate AS PeriodEnd,
        DATEDIFF(DAY, @StartDate, @EndDate) + 1 AS PeriodDays,
        
        -- ממוצע ציון כשירות בתקופה
        AVG(rh.ReadinessScore) AS AvgReadinessScore,
        MIN(rh.ReadinessScore) AS MinReadinessScore,
        MAX(rh.ReadinessScore) AS MaxReadinessScore,
        
        -- סה"כ התראות
        (SELECT COUNT(*) FROM ReadinessAlerts 
         WHERE CreatedDate BETWEEN @StartDate AND @EndDate
         AND (@DepartmentID IS NULL OR DepartmentID = @DepartmentID)) AS TotalAlerts,
         
        (SELECT COUNT(*) FROM ReadinessAlerts 
         WHERE CreatedDate BETWEEN @StartDate AND @EndDate
         AND Severity = 'Critical'
         AND (@DepartmentID IS NULL OR DepartmentID = @DepartmentID)) AS CriticalAlerts,
         
        -- הסמכות שפג תוקפן
        (SELECT COUNT(*) FROM EmployeeCertifications ec
         INNER JOIN Employees e ON ec.EmployeeID = e.EmployeeID
         WHERE ec.ExpiryDate BETWEEN @StartDate AND @EndDate
         AND ec.Status = 'Active'
         AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)) AS ExpiredCertifications
         
    FROM ReadinessHistory rh
    WHERE rh.CalculationDate BETWEEN @StartDate AND @EndDate
        AND (@DepartmentID IS NULL OR rh.DepartmentID = @DepartmentID);
    
    -- ==========================================
    -- חלק 2: ביצועים לפי מחלקה
    -- ==========================================
    SELECT 
        d.DepartmentName,
        AVG(rh.ReadinessScore) AS AvgScore,
        MIN(rh.ReadinessScore) AS MinScore,
        MAX(rh.ReadinessScore) AS MaxScore,
        
        -- ימים ב"אדום" (מתחת ל-70)
        SUM(CASE WHEN rh.ReadinessScore < 70 THEN 1 ELSE 0 END) AS DaysBelow70,
        
        -- ימים ב"ירוק" (מעל 90)
        SUM(CASE WHEN rh.ReadinessScore >= 90 THEN 1 ELSE 0 END) AS DaysAbove90,
        
        -- סה"כ פערים קריטיים
        SUM(rh.CriticalGaps) AS TotalCriticalGaps,
        
        -- מגמה
        CASE 
            WHEN AVG(CASE WHEN rh.CalculationDate >= DATEADD(DAY, -7, @EndDate) 
                         THEN rh.ReadinessScore END) >
                 AVG(CASE WHEN rh.CalculationDate < DATEADD(DAY, -7, @EndDate) 
                         THEN rh.ReadinessScore END)
            THEN N'📈 משתפרת'
            WHEN AVG(CASE WHEN rh.CalculationDate >= DATEADD(DAY, -7, @EndDate) 
                         THEN rh.ReadinessScore END) <
                 AVG(CASE WHEN rh.CalculationDate < DATEADD(DAY, -7, @EndDate) 
                         THEN rh.ReadinessScore END)
            THEN N'📉 יורדת'
            ELSE N'➡️ יציבה'
        END AS Trend
        
    FROM ReadinessHistory rh
    INNER JOIN Departments d ON rh.DepartmentID = d.DepartmentID
    WHERE rh.CalculationDate BETWEEN @StartDate AND @EndDate
        AND (@DepartmentID IS NULL OR rh.DepartmentID = @DepartmentID)
    GROUP BY d.DepartmentName
    ORDER BY AvgScore ASC;
    
    -- ==========================================
    -- חלק 3: Top 10 אירועים קריטיים
    -- ==========================================
    SELECT TOP 10
        ra.CreatedDate,
        d.DepartmentName,
        ra.Severity,
        ra.Title,
        ra.Description,
        ISNULL(ra.ResolvedDate, GETDATE()) AS ResolvedDate,
        DATEDIFF(HOUR, ra.CreatedDate, ISNULL(ra.ResolvedDate, GETDATE())) AS HoursToResolve
    FROM ReadinessAlerts ra
    INNER JOIN Departments d ON ra.DepartmentID = d.DepartmentID
    WHERE ra.CreatedDate BETWEEN @StartDate AND @EndDate
        AND (@DepartmentID IS NULL OR ra.DepartmentID = @DepartmentID)
    ORDER BY 
        CASE ra.Severity
            WHEN 'Critical' THEN 1
            WHEN 'High' THEN 2
            WHEN 'Medium' THEN 3
            ELSE 4
        END,
        ra.CreatedDate DESC;
        
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetEmployeeReadinessHistory]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetEmployeeReadinessHistory]
    @EmployeeID INT
AS
BEGIN


-- =============================================
-- SP 4: היסטוריית כשירות עובד
-- sp_GetEmployeeReadinessHistory
-- =============================================
-- תיאור: מציג את כל היסטוריית ההסמכות של עובד
-- כולל: הסמכות נוכחיות, פגות, עתידיות
-- =============================================

    SET NOCOUNT ON;
    
    DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE);
    
    -- ==========================================
    -- חלק 1: מידע כללי על העובד
    -- ==========================================
    SELECT 
        e.EmployeeID,
        e.EmployeeNumber,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.Email,
        e.PhoneNumber,
        d.DepartmentName,
        e.PositionTitle,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, @CurrentDate) AS YearsOfService,
        e.IsActive,
        
        -- סטטיסטיקות הסמכות
        (SELECT COUNT(*) 
         FROM EmployeeCertifications 
         WHERE EmployeeID = @EmployeeID 
         AND Status = 'Active'
         AND ExpiryDate > @CurrentDate) AS ActiveCertifications,
         
        (SELECT COUNT(*) 
         FROM EmployeeCertifications 
         WHERE EmployeeID = @EmployeeID 
         AND Status = 'Active'
         AND ExpiryDate <= @CurrentDate) AS ExpiredCertifications,
         
        (SELECT COUNT(*) 
         FROM EmployeeCertifications 
         WHERE EmployeeID = @EmployeeID 
         AND Status = 'Active'
         AND ExpiryDate BETWEEN @CurrentDate AND DATEADD(DAY, 30, @CurrentDate)) AS ExpiringIn30Days
         
    FROM Employees e
    INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE e.EmployeeID = @EmployeeID;
    
    -- ==========================================
    -- חלק 2: פירוט הסמכות
    -- ==========================================
    SELECT 
        ec.EmployeeCertificationID,
        ct.CertificationName,
        ct.CertificationCode,
        ct.CriticalityLevel,
        ec.CertificateNumber,
        ec.IssueDate,
        ec.ExpiryDate,
        DATEDIFF(DAY, @CurrentDate, ec.ExpiryDate) AS DaysUntilExpiry,
        ec.Status,
        
        -- סטטוס ויזואלי
        CASE 
            WHEN ec.ExpiryDate < @CurrentDate THEN N'🔴 פג תוקף'
            WHEN ec.ExpiryDate <= DATEADD(DAY, 7, @CurrentDate) THEN N'🔴 פוקע בשבוע הקרוב'
            WHEN ec.ExpiryDate <= DATEADD(DAY, 30, @CurrentDate) THEN N'🟡 פוקע בחודש הקרוב'
            WHEN ec.ExpiryDate <= DATEADD(DAY, 90, @CurrentDate) THEN N'🟢 פוקע ב-90 הימים הקרובים'
            ELSE N'✅ תקף'
        END AS StatusIcon,
        
        -- אחוז תקופת תוקף שנותרה
        CAST(
            100.0 * DATEDIFF(DAY, @CurrentDate, ec.ExpiryDate) / 
            NULLIF(DATEDIFF(DAY, ec.IssueDate, ec.ExpiryDate), 0)
        AS DECIMAL(5,2)) AS PercentRemaining,
        
        ec.Notes
        
    FROM EmployeeCertifications ec
    INNER JOIN CertificationTypes ct ON ec.CertificationTypeID = ct.CertificationTypeID
    WHERE ec.EmployeeID = @EmployeeID
    ORDER BY 
        CASE 
            WHEN ec.ExpiryDate < @CurrentDate THEN 1
            WHEN ec.ExpiryDate <= DATEADD(DAY, 30, @CurrentDate) THEN 2
            ELSE 3
        END,
        ec.ExpiryDate;
        
    -- ==========================================
    -- חלק 3: הסמכות חסרות (לפי דרישות המחלקה)
    -- ==========================================
    SELECT 
        ct.CertificationName,
        ct.CriticalityLevel,
        dr.MinimumRequired,
        N'חובה למחלקה: ' + d.DepartmentName AS Reason
    FROM DepartmentRequirements dr
    INNER JOIN CertificationTypes ct ON dr.CertificationTypeID = ct.CertificationTypeID
    INNER JOIN Employees e ON dr.DepartmentID = e.DepartmentID
    INNER JOIN Departments d ON dr.DepartmentID = d.DepartmentID
    WHERE e.EmployeeID = @EmployeeID
        AND dr.IsActive = 1
        AND NOT EXISTS (
            SELECT 1 
            FROM EmployeeCertifications ec
            WHERE ec.EmployeeID = @EmployeeID
                AND ec.CertificationTypeID = dr.CertificationTypeID
                AND ec.Status = 'Active'
                AND ec.ExpiryDate > @CurrentDate
        )
    ORDER BY 
        CASE ct.CriticalityLevel
            WHEN 'Critical' THEN 1
            WHEN 'High' THEN 2
            WHEN 'Medium' THEN 3
            WHEN 'Low' THEN 4
        END;
        
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetHotspots]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetHotspots]
    @ThresholdScore DECIMAL(5,2) = 75.0,
    @Date DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    
-- =============================================
-- SP 2: זיהוי נקודות חמות (Hotspots)
-- sp_GetHotspots
-- =============================================
-- תיאור: מזהה מחלקות בסיכון גבוה
-- קריטריונים: ציון נמוך, פערים קריטיים, מגמה שלילית
-- =============================================


    IF @Date IS NULL
        SET @Date = CAST(GETDATE() AS DATE);
    
    -- ==========================================
    -- CTE 1: ציוני כשירות נוכחיים
    -- ==========================================
    ;WITH CurrentReadiness AS (
        SELECT 
            d.DepartmentID,
            d.DepartmentName,
            d.DepartmentCode,
            COALESCE(
                (SELECT TOP 1 ReadinessScore 
                 FROM ReadinessHistory 
                 WHERE DepartmentID = d.DepartmentID 
                 ORDER BY CalculationDate DESC),
                0
            ) AS CurrentScore,
            COALESCE(
                (SELECT TOP 1 CriticalGaps 
                 FROM ReadinessHistory 
                 WHERE DepartmentID = d.DepartmentID 
                 ORDER BY CalculationDate DESC),
                0
            ) AS CriticalGaps
        FROM Departments d
        WHERE d.IsActive = 1
    ),
    
    -- ==========================================
    -- CTE 2: מגמות (7 ימים אחרונים)
    -- ==========================================
    RecentTrends AS (
        SELECT 
            DepartmentID,
            AVG(ReadinessScore) AS AvgScore7Days,
            MAX(ReadinessScore) AS MaxScore7Days,
            MIN(ReadinessScore) AS MinScore7Days,
            -- חישוב מגמה (regression פשוט)
            CASE 
                WHEN AVG(CASE WHEN CalculationDate >= DATEADD(DAY, -3, @Date) THEN ReadinessScore END) <
                     AVG(CASE WHEN CalculationDate < DATEADD(DAY, -3, @Date) THEN ReadinessScore END)
                THEN 'Declining'
                ELSE 'Stable'
            END AS Trend
        FROM ReadinessHistory
        WHERE CalculationDate >= DATEADD(DAY, -7, @Date)
            AND CalculationDate <= @Date
        GROUP BY DepartmentID
    ),
    
    -- ==========================================
    -- CTE 3: התראות פעילות
    -- ==========================================
    ActiveAlertCounts AS (
        SELECT 
            DepartmentID,
            COUNT(*) AS ActiveAlerts,
            SUM(CASE WHEN Severity = 'Critical' THEN 1 ELSE 0 END) AS CriticalAlerts
        FROM ReadinessAlerts
        WHERE Status = 'Active'
            AND CreatedDate >= DATEADD(DAY, -7, @Date)
        GROUP BY DepartmentID
    ),
    
    -- ==========================================
    -- CTE 4: הסמכות שיפקעו בקרוב
    -- ==========================================
    UpcomingExpirations AS (
        SELECT 
            e.DepartmentID,
            COUNT(*) AS CertsExpiringIn30Days
        FROM EmployeeCertifications ec
        INNER JOIN Employees e ON ec.EmployeeID = e.EmployeeID
        INNER JOIN CertificationTypes ct ON ec.CertificationTypeID = ct.CertificationTypeID
        WHERE ec.ExpiryDate BETWEEN @Date AND DATEADD(DAY, 30, @Date)
            AND ec.Status = 'Active'
            AND ct.CriticalityLevel IN ('Critical', 'High')
        GROUP BY e.DepartmentID
    )
    
    -- ==========================================
    -- תוצאה: נקודות חמות
    -- ==========================================
    SELECT 
        cr.DepartmentID,
        cr.DepartmentName,
        cr.DepartmentCode,
        cr.CurrentScore,
        cr.CriticalGaps,
        COALESCE(rt.AvgScore7Days, cr.CurrentScore) AS AvgScore7Days,
        COALESCE(rt.Trend, 'Unknown') AS Trend,
        COALESCE(aac.ActiveAlerts, 0) AS ActiveAlerts,
        COALESCE(aac.CriticalAlerts, 0) AS CriticalAlerts,
        COALESCE(ue.CertsExpiringIn30Days, 0) AS CertsExpiringIn30Days,
        
        -- חישוב Risk Score (0-100, ככל שגבוה יותר = מסוכן יותר)
        CAST(
            (100 - cr.CurrentScore) * 0.4 + -- 40% ציון נוכחי
            (cr.CriticalGaps * 10) * 0.3 + -- 30% פערים קריטיים
            (COALESCE(aac.CriticalAlerts, 0) * 10) * 0.2 + -- 20% התראות
            (COALESCE(ue.CertsExpiringIn30Days, 0) * 5) * 0.1 -- 10% פקיעות
        AS DECIMAL(5,2)) AS RiskScore,
        
        -- סיווג רמת סיכון
        CASE 
            WHEN cr.CurrentScore < 50 OR cr.CriticalGaps > 2 THEN 'Critical'
            WHEN cr.CurrentScore < @ThresholdScore OR cr.CriticalGaps > 0 THEN 'High'
            WHEN cr.CurrentScore < 90 THEN 'Medium'
            ELSE 'Low'
        END AS RiskLevel,
        
        -- המלצות
        CASE 
            WHEN cr.CriticalGaps > 0 THEN N'טיפול מיידי נדרש - חסרות הסמכות קריטיות'
            WHEN COALESCE(ue.CertsExpiringIn30Days, 0) > 5 THEN N'תכנן הדרכות דחופות - מספר רב של הסמכות יפוג'
            WHEN COALESCE(rt.Trend, '') = 'Declining' THEN N'מגמה שלילית - בדוק סיבות'
            ELSE N'מעקב שוטף'
        END AS Recommendation
        
    FROM CurrentReadiness cr
    LEFT JOIN RecentTrends rt ON cr.DepartmentID = rt.DepartmentID
    LEFT JOIN ActiveAlertCounts aac ON cr.DepartmentID = aac.DepartmentID
    LEFT JOIN UpcomingExpirations ue ON cr.DepartmentID = ue.DepartmentID
    WHERE cr.CurrentScore < @ThresholdScore 
        OR cr.CriticalGaps > 0
        OR COALESCE(aac.CriticalAlerts, 0) > 0
    ORDER BY RiskScore DESC, cr.CurrentScore ASC;
    
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetReplacementSuggestions]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- גרסה סופית: sp_GetReplacementSuggestions
-- תיאור: מציע עובדים חלופיים כשחסר עובד מוסמך
-- אלגוריתם AI: זמינות + כישורים + ניסיון + ותק
-- =============================================

-- מחיקת הגרסה הישנה אם קיימת


CREATE PROCEDURE [dbo].[sp_GetReplacementSuggestions]
    @DepartmentID INT,                      -- המחלקה שחסר בה עובד
    @RequiredCertificationTypeID INT,       -- ההסמכה הנדרשת
    @Date DATE = NULL,                      -- תאריך המשמרת (ברירת מחדל: היום)
    @ShiftID INT = NULL,                    -- משמרת ספציפית (אופציונלי)
    @MaxResults INT = 10                    -- מקסימום תוצאות להחזיר
AS
BEGIN
    SET NOCOUNT ON;
    
    -- ברירת מחדל לתאריך
    IF @Date IS NULL
        SET @Date = CAST(GETDATE() AS DATE);
    
    -- ==========================================
    -- CTE 1: עובדים מוסמכים מכל המפעל
    -- מחפש רק מחוץ למחלקה הנוכחית!
    -- ==========================================
    ;WITH QualifiedEmployees AS (
        SELECT DISTINCT
            e.EmployeeID,
            e.FirstName + ' ' + e.LastName AS FullName,
            e.DepartmentID,
            d.DepartmentName AS CurrentDepartment,
            e.PositionTitle,
            ec.ExpiryDate,
            ec.IssueDate,
            ec.CertificateNumber
        FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        INNER JOIN EmployeeCertifications ec ON e.EmployeeID = ec.EmployeeID
        WHERE ec.CertificationTypeID = @RequiredCertificationTypeID
            AND ec.Status = 'Active'
            AND ec.ExpiryDate > @Date
            AND e.IsActive = 1
            AND e.DepartmentID <> @DepartmentID  -- 🎯 חשוב! רק מחוץ למחלקה
    ),
    
    -- ==========================================
    -- CTE 2: בדיקת זמינות
    -- האם העובד כבר משובץ למשמרת?
    -- ==========================================
    AvailabilityCheck AS (
        SELECT 
            qe.EmployeeID,
            CASE 
                WHEN EXISTS (
                    SELECT 1 FROM ShiftAssignments sa
                    WHERE sa.EmployeeID = qe.EmployeeID
                    AND sa.AssignmentDate = @Date
                    AND (@ShiftID IS NULL OR sa.ShiftID = @ShiftID)
                    AND (sa.IsPresent = 1 OR sa.IsPresent IS NULL) -- גם אם עוד לא הגיע
                ) THEN 0  -- לא זמין
                ELSE 1    -- זמין
            END AS IsAvailable
        FROM QualifiedEmployees qe
    ),
    
    -- ==========================================
    -- CTE 3: ספירת הסמכות נוספות
    -- יותר הסמכות = עובד יותר מוסמך
    -- ==========================================
    AdditionalSkills AS (
        SELECT 
            ec.EmployeeID,
            COUNT(DISTINCT ec.CertificationTypeID) AS TotalCertifications,
            SUM(CASE WHEN ct.CriticalityLevel = 'Critical' THEN 1 ELSE 0 END) AS CriticalCertifications,
            SUM(CASE WHEN ct.CriticalityLevel = 'High' THEN 1 ELSE 0 END) AS HighCertifications
        FROM EmployeeCertifications ec
        INNER JOIN CertificationTypes ct ON ec.CertificationTypeID = ct.CertificationTypeID
        WHERE ec.Status = 'Active'
            AND ec.ExpiryDate > @Date
        GROUP BY ec.EmployeeID
    ),
    
    -- ==========================================
    -- CTE 4: היסטוריית עבודה במחלקה המבוקשת
    -- האם העובד כבר עבד שם בעבר?
    -- ==========================================
    PreviousExperience AS (
        SELECT 
            sa.EmployeeID,
            COUNT(DISTINCT sa.AssignmentDate) AS DaysWorkedInDept,
            MAX(sa.AssignmentDate) AS LastWorkDate
        FROM ShiftAssignments sa
        WHERE sa.DepartmentID = @DepartmentID
            AND sa.AssignmentDate >= DATEADD(MONTH, -6, @Date)
            AND sa.IsPresent = 1  -- רק משמרות שבאמת עבד
        GROUP BY sa.EmployeeID
    ),
    
    -- ==========================================
    -- CTE 5: חישוב ותק בהסמכה
    -- כמה זמן יש לו את ההסמכה?
    -- ==========================================
    CertificationSeniority AS (
        SELECT 
            EmployeeID,
            DATEDIFF(MONTH, IssueDate, @Date) AS MonthsWithCert,
            DATEDIFF(DAY, @Date, ExpiryDate) AS DaysUntilExpiry
        FROM QualifiedEmployees
    ),
    
    -- ==========================================
    -- CTE 6: חישוב ציונים
    -- ==========================================
    ScoredCandidates AS (
        SELECT 
            qe.EmployeeID,
            qe.FullName,
            qe.CurrentDepartment,
            qe.PositionTitle,
            qe.CertificateNumber,
            
            -- נתונים גולמיים
            ac.IsAvailable,
            COALESCE(ask.TotalCertifications, 0) AS TotalCertifications,
            COALESCE(ask.CriticalCertifications, 0) AS CriticalCertifications,
            COALESCE(ask.HighCertifications, 0) AS HighCertifications,
            COALESCE(pe.DaysWorkedInDept, 0) AS PreviousExperienceDays,
            COALESCE(pe.LastWorkDate, NULL) AS LastWorkDate,
            COALESCE(cs.MonthsWithCert, 0) AS MonthsWithCertification,
            cs.DaysUntilExpiry,
            
            -- חישוב ציוני משנה
            -- 1. ציון זמינות (35 נקודות)
            CAST(ac.IsAvailable * 35 AS DECIMAL(5,2)) AS AvailabilityScore,
            
            -- 2. ציון הסמכות נוספות (25 נקודות)
            CAST(
                LEAST(COALESCE(ask.TotalCertifications, 0), 5) * 5
            AS DECIMAL(5,2)) AS SkillsScore,
            
            -- 3. ציון ניסיון קודם (25 נקודות)
            CAST(
                CASE 
                    WHEN COALESCE(pe.DaysWorkedInDept, 0) >= 30 THEN 25
                    WHEN COALESCE(pe.DaysWorkedInDept, 0) >= 15 THEN 20
                    WHEN COALESCE(pe.DaysWorkedInDept, 0) >= 5 THEN 15
                    WHEN COALESCE(pe.DaysWorkedInDept, 0) >= 1 THEN 10
                    ELSE 0
                END
            AS DECIMAL(5,2)) AS ExperienceScore,
            
            -- 4. ציון ותק בהסמכה (15 נקודות)
            CAST(
                CASE 
                    WHEN COALESCE(cs.MonthsWithCert, 0) >= 36 THEN 15  -- 3+ שנים
                    WHEN COALESCE(cs.MonthsWithCert, 0) >= 24 THEN 12  -- 2-3 שנים
                    WHEN COALESCE(cs.MonthsWithCert, 0) >= 12 THEN 10  -- 1-2 שנים
                    WHEN COALESCE(cs.MonthsWithCert, 0) >= 6 THEN 7    -- 6-12 חודשים
                    ELSE 4                                              -- פחות מ-6 חודשים
                END
            AS DECIMAL(5,2)) AS SeniorityScore,
            
            -- תוקף הסמכה
            qe.ExpiryDate AS CertificationExpiry
            
        FROM QualifiedEmployees qe
        INNER JOIN AvailabilityCheck ac ON qe.EmployeeID = ac.EmployeeID
        LEFT JOIN AdditionalSkills ask ON qe.EmployeeID = ask.EmployeeID
        LEFT JOIN PreviousExperience pe ON qe.EmployeeID = pe.EmployeeID
        LEFT JOIN CertificationSeniority cs ON qe.EmployeeID = cs.EmployeeID
    )
    
    -- ==========================================
    -- תוצאה סופית: המלצות ממוינות
    -- ==========================================
    SELECT TOP (@MaxResults)
        EmployeeID,
        FullName,
        CurrentDepartment,
        PositionTitle,
        CertificateNumber,
        
        -- גורמי התאמה
        IsAvailable,
        TotalCertifications,
        CriticalCertifications,
        HighCertifications,
        PreviousExperienceDays,
        LastWorkDate,
        MonthsWithCertification,
        DaysUntilExpiry,
        
        -- ציונים מפורטים
        AvailabilityScore,
        SkillsScore,
        ExperienceScore,
        SeniorityScore,
        
        -- ציון כולל (0-100)
        CAST(
            AvailabilityScore + SkillsScore + ExperienceScore + SeniorityScore
        AS DECIMAL(5,2)) AS MatchScore,
        
        -- המלצה טקסטואלית
        CASE 
            WHEN IsAvailable = 0 THEN N'❌ לא זמין - כבר משובץ למשמרת'
            WHEN PreviousExperienceDays >= 20 THEN N'⭐⭐⭐ מומלץ ביותר - ניסיון רב במחלקה'
            WHEN PreviousExperienceDays >= 10 THEN N'⭐⭐ מומלץ מאוד - עבד כבר במחלקה'
            WHEN PreviousExperienceDays >= 3 THEN N'⭐ מומלץ - יש ניסיון במחלקה'
            WHEN CriticalCertifications >= 3 THEN N'✓ מתאים - מוסמך בתחומים קריטיים'
            WHEN MonthsWithCertification >= 24 THEN N'✓ מתאים - ותיק בהסמכה'
            WHEN TotalCertifications >= 4 THEN N'✓ מתאים - רב כישורים'
            ELSE N'○ אפשרי - יש הסמכה נדרשת'
        END AS Recommendation,
        
        -- אינדיקציה ויזואלית
        CASE 
            WHEN IsAvailable = 0 THEN 0  -- אדום
            WHEN (AvailabilityScore + SkillsScore + ExperienceScore + SeniorityScore) >= 85 THEN 3  -- ירוק כהה
            WHEN (AvailabilityScore + SkillsScore + ExperienceScore + SeniorityScore) >= 70 THEN 2  -- ירוק בהיר
            WHEN (AvailabilityScore + SkillsScore + ExperienceScore + SeniorityScore) >= 55 THEN 1  -- צהוב
            ELSE 0  -- אפור
        END AS ColorIndicator,
        
        -- תוקף הסמכה
        CertificationExpiry
        
    FROM ScoredCandidates
    
    -- סינון: רק רלוונטיים
    WHERE 
        IsAvailable = 1  -- רק זמינים!
        OR PreviousExperienceDays > 15  -- או עם ניסיון גבוה (גם אם לא זמין - כדאי לשקול)
    
    -- מיון: זמינים קודם, אחר כך לפי ציון
    ORDER BY 
        IsAvailable DESC,           -- זמינים למעלה
        ExperienceScore DESC,       -- ניסיון קודם חשוב ביותר!
        SkillsScore DESC,           -- אחר כך כישורים
        SeniorityScore DESC,        -- ותק
        FullName ASC;               -- סדר אלפביתי
    
END
GO
/****** Object:  StoredProcedure [dbo].[sp_PredictFutureGaps]    Script Date: 04/01/2026 0:01:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PredictFutureGaps]
    @DepartmentID INT = NULL,
    @DaysAhead INT = 30
AS
BEGIN
    SET NOCOUNT ON;
    
    
-- =============================================
-- SP 3: חיזוי פערים עתידיים
-- sp_PredictFutureGaps
-- =============================================
-- תיאור: מזהה בעיות כשירות צפויות
-- מנתח: הסמכות שיפקעו, חופשות מתוכננות, מגמות
-- =============================================


    DECLARE @StartDate DATE = CAST(GETDATE() AS DATE);
    DECLARE @EndDate DATE = DATEADD(DAY, @DaysAhead, @StartDate);
    
    -- ==========================================
    -- CTE 1: הסמכות שיפקעו בתקופה
    -- ==========================================
    ;WITH ExpiringCerts AS (
        SELECT 
            e.DepartmentID,
            d.DepartmentName,
            ec.EmployeeID,
            emp.FirstName + ' ' + emp.LastName AS EmployeeName,
            ec.CertificationTypeID,
            ct.CertificationName,
            ct.CriticalityLevel,
            ec.ExpiryDate,
            DATEDIFF(DAY, @StartDate, ec.ExpiryDate) AS DaysUntilExpiry
        FROM EmployeeCertifications ec
        INNER JOIN Employees e ON ec.EmployeeID = e.EmployeeID
        INNER JOIN Employees emp ON ec.EmployeeID = emp.EmployeeID
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
        INNER JOIN CertificationTypes ct ON ec.CertificationTypeID = ct.CertificationTypeID
        WHERE ec.ExpiryDate BETWEEN @StartDate AND @EndDate
            AND ec.Status = 'Active'
            AND e.IsActive = 1
            AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
    ),
    
    -- ==========================================
    -- CTE 2: ספירת פקיעות לפי מחלקה והסמכה
    -- ==========================================
    ExpirationSummary AS (
        SELECT 
            DepartmentID,
            DepartmentName,
            CertificationTypeID,
            CertificationName,
            CriticalityLevel,
            COUNT(*) AS ExpiringCount,
            MIN(DaysUntilExpiry) AS MinDaysUntil,
            STRING_AGG(EmployeeName, ', ') AS AffectedEmployees
        FROM ExpiringCerts
        GROUP BY 
            DepartmentID,
            DepartmentName,
            CertificationTypeID,
            CertificationName,
            CriticalityLevel
    ),
    
    -- ==========================================
    -- CTE 3: דרישות מחלקה
    -- ==========================================
    DeptRequirements AS (
        SELECT 
            dr.DepartmentID,
            dr.CertificationTypeID,
            dr.MinimumRequired
        FROM DepartmentRequirements dr
        WHERE dr.IsActive = 1
            AND (@DepartmentID IS NULL OR dr.DepartmentID = @DepartmentID)
    ),
    
    -- ==========================================
    -- CTE 4: עובדים כשירים כרגע
    -- ==========================================
    CurrentCompliant AS (
        SELECT 
            e.DepartmentID,
            ec.CertificationTypeID,
            COUNT(DISTINCT ec.EmployeeID) AS CurrentCount
        FROM EmployeeCertifications ec
        INNER JOIN Employees e ON ec.EmployeeID = e.EmployeeID
        WHERE ec.Status = 'Active'
            AND ec.ExpiryDate > @StartDate
            AND e.IsActive = 1
            AND (@DepartmentID IS NULL OR e.DepartmentID = @DepartmentID)
        GROUP BY e.DepartmentID, ec.CertificationTypeID
    )
    
    -- ==========================================
    -- תוצאה: חיזוי פערים
    -- ==========================================
    SELECT 
        es.DepartmentID,
        es.DepartmentName,
        es.CertificationName,
        es.CriticalityLevel,
        COALESCE(dr.MinimumRequired, 0) AS Required,
        COALESCE(cc.CurrentCount, 0) AS CurrentCompliant,
        es.ExpiringCount,
        COALESCE(cc.CurrentCount, 0) - es.ExpiringCount AS ProjectedCompliant,
        CASE 
            WHEN COALESCE(cc.CurrentCount, 0) - es.ExpiringCount < COALESCE(dr.MinimumRequired, 0)
            THEN COALESCE(dr.MinimumRequired, 0) - (COALESCE(cc.CurrentCount, 0) - es.ExpiringCount)
            ELSE 0
        END AS ProjectedGap,
        es.MinDaysUntil,
        es.AffectedEmployees,
        
        -- רמת דחיפות
        CASE 
            WHEN es.CriticalityLevel = 'Critical' AND es.MinDaysUntil <= 7 THEN 'Urgent'
            WHEN es.CriticalityLevel = 'Critical' AND es.MinDaysUntil <= 14 THEN 'High'
            WHEN es.CriticalityLevel IN ('Critical', 'High') AND es.MinDaysUntil <= 30 THEN 'Medium'
            ELSE 'Low'
        END AS Urgency,
        
        -- פעולות מומלצות
        CASE 
            WHEN es.MinDaysUntil <= 7 THEN N'פעולה מיידית - תכנן הדרכה בשבוע הקרוב!'
            WHEN es.MinDaysUntil <= 14 THEN N'תכנן הדרכה בשבועיים הקרובים'
            WHEN es.MinDaysUntil <= 21 THEN N'צור קשר עם ספק הדרכות'
            ELSE N'מעקב שוטף'
        END AS RecommendedAction,
        
        -- עלות משוערת
        es.ExpiringCount * 
        CASE es.CriticalityLevel
            WHEN 'Critical' THEN 2000
            WHEN 'High' THEN 1500
            WHEN 'Medium' THEN 1000
            WHEN 'Low' THEN 500
        END AS EstimatedCost
        
    FROM ExpirationSummary es
    LEFT JOIN DeptRequirements dr ON es.DepartmentID = dr.DepartmentID 
        AND es.CertificationTypeID = dr.CertificationTypeID
    LEFT JOIN CurrentCompliant cc ON es.DepartmentID = cc.DepartmentID 
        AND es.CertificationTypeID = cc.CertificationTypeID
    WHERE COALESCE(cc.CurrentCount, 0) - es.ExpiringCount < COALESCE(dr.MinimumRequired, 1)
        OR es.CriticalityLevel IN ('Critical', 'High')
    ORDER BY 
        CASE
            WHEN es.CriticalityLevel = 'Critical' AND es.MinDaysUntil <= 7 THEN 1 --'Urgent'
            WHEN es.CriticalityLevel = 'Critical' AND es.MinDaysUntil <= 14 THEN 2 --'High'
            WHEN es.CriticalityLevel IN ('Critical', 'High') AND es.MinDaysUntil <= 30 THEN 3 --'Medium'
            ELSE 4 --'Low'
        END,
        es.MinDaysUntil,
        CASE es.CriticalityLevel
            WHEN 'Critical' THEN 1
            WHEN 'High' THEN 2
            WHEN 'Medium' THEN 3
            WHEN 'Low' THEN 4
        END;
        
END
GO
