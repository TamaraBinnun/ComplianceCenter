# הוראות התקנה - ComplianceCenter

## תוכן עניינים
1. [דרישות מערכת](#דרישות-מערכת)
2. [התקנת סביבת פיתוח](#התקנת-סביבת-פיתוח)
3. [הגדרת מסד נתונים](#הגדרת-מסד-נתונים)
4. [הגדרת הפרויקט](#הגדרת-הפרויקט)
5. [הרצה ראשונית](#הרצה-ראשונית)
6. [התקנה על שרת](#התקנה-על-שרת)
7. [פתרון בעיות](#פתרון-בעיות)

---

## דרישות מערכת

### לפתח
- **Windows 10/11** או **Windows Server 2016+**
- **Visual Studio 2019** או גבוה יותר (עם תמיכה ב-.NET Framework)
- **.NET Framework 4.8.1** או גבוה יותר
- **SQL Server 2012** או גבוה יותר (או SQL Server Express)
- **IIS Express** (מגיע עם Visual Studio)

### לפרודקשן
- **Windows Server 2016+**
- **IIS 10+**
- **.NET Framework 4.8.1**
- **SQL Server 2012+**

---

## התקנת סביבת פיתוח

### 1. התקנת Visual Studio
1. הורד והתקן **Visual Studio 2019** או גבוה יותר
2. בחר את העבודה הבאה:
   - **ASP.NET and web development**
   - **.NET desktop development** (אופציונלי)

### 2. התקנת SQL Server
1. הורד והתקן **SQL Server Express** (חינמי) או **SQL Server Developer Edition**
2. במהלך ההתקנה, ודא ש-**SQL Server Database Engine** ו-**SQL Server Management Studio (SSMS)** מותקנים

### 3. התקנת .NET Framework
- .NET Framework 4.8.1 מותקן בדרך כלל עם Windows Update
- אם לא, הורד מ-[Microsoft](https://dotnet.microsoft.com/download/dotnet-framework/net481)

---

## הגדרת מסד נתונים

### 1. יצירת מסדי נתונים

המערכת דורשת שני מסדי נתונים:

#### מסד נתונים לזהות (Identity)
```sql
-- יצירת מסד נתונים לזהות
CREATE DATABASE ComplianceCenterIdentity;
```

#### מסד נתונים ראשי
```sql
-- יצירת מסד נתונים ראשי
CREATE DATABASE ComplianceCenter;
```

### 2. הרצת סקריפטי SQL

#### א. יצירת טבלאות
הרץ את הסקריפטים הבאים בסדר:

1. **יצירת טבלאות בסיסיות**:
   ```sql
   -- Departments
   CREATE TABLE Departments (
       DepartmentID INT PRIMARY KEY IDENTITY(1,1),
       DepartmentName NVARCHAR(100) NOT NULL,
       DepartmentCode NVARCHAR(20) NOT NULL,
       Description NVARCHAR(500),
       ManagerEmployeeID INT,
       MinimumStaffCount INT NOT NULL DEFAULT 1,
       IsActive BIT NOT NULL DEFAULT 1,
       CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
       ModifiedDate DATETIME
   );

   -- Employees
   CREATE TABLE Employees (
       EmployeeID INT PRIMARY KEY IDENTITY(1,1),
       EmployeeNumber NVARCHAR(50) NOT NULL UNIQUE,
       FirstName NVARCHAR(50) NOT NULL,
       LastName NVARCHAR(50) NOT NULL,
       Email NVARCHAR(100),
       PhoneNumber NVARCHAR(20),
       DepartmentID INT NOT NULL,
       PositionTitle NVARCHAR(100),
       HireDate DATETIME NOT NULL,
       TerminationDate DATETIME,
       IsActive BIT NOT NULL DEFAULT 1,
       PhotoFileName NVARCHAR(255),
       CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
       ModifiedDate DATETIME,
       FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
   );

   -- CertificationTypes
   CREATE TABLE CertificationTypes (
       CertificationTypeID INT PRIMARY KEY IDENTITY(1,1),
       CertificationName NVARCHAR(100) NOT NULL,
       CertificationCode NVARCHAR(20) NOT NULL,
       Description NVARCHAR(500),
       ValidityPeriodMonths INT,
       IsRequired BIT NOT NULL DEFAULT 0,
       IsActive BIT NOT NULL DEFAULT 1,
       CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
       ModifiedDate DATETIME
   );

   -- EmployeeCertifications
   CREATE TABLE EmployeeCertifications (
       EmployeeCertificationID INT PRIMARY KEY IDENTITY(1,1),
       EmployeeID INT NOT NULL,
       CertificationTypeID INT NOT NULL,
       CertificateNumber NVARCHAR(100),
       IssueDate DATETIME NOT NULL,
       ExpiryDate DATETIME NOT NULL,
       Status NVARCHAR(20) NOT NULL DEFAULT 'Active',
       CertificateFileName NVARCHAR(255),
       Notes NVARCHAR(1000),
       CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
       ModifiedDate DATETIME,
       FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
       FOREIGN KEY (CertificationTypeID) REFERENCES CertificationTypes(CertificationTypeID)
   );

   -- DepartmentRequirements
   CREATE TABLE DepartmentRequirements (
       RequirementID INT PRIMARY KEY IDENTITY(1,1),
       DepartmentID INT NOT NULL,
       CertificationTypeID INT NOT NULL,
       RequiredCount INT NOT NULL DEFAULT 1,
       IsCritical BIT NOT NULL DEFAULT 0,
       Notes NVARCHAR(500),
       CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
       ModifiedDate DATETIME,
       FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
       FOREIGN KEY (CertificationTypeID) REFERENCES CertificationTypes(CertificationTypeID)
   );

   -- Shifts
   CREATE TABLE Shifts (
       ShiftID INT PRIMARY KEY IDENTITY(1,1),
       ShiftName NVARCHAR(50) NOT NULL,
       ShiftCode NVARCHAR(10) NOT NULL,
       StartTime TIME NOT NULL,
       EndTime TIME NOT NULL,
       IsActive BIT NOT NULL DEFAULT 1,
       CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
       ModifiedDate DATETIME
   );

   -- ShiftAssignments
   CREATE TABLE ShiftAssignments (
       AssignmentID INT PRIMARY KEY IDENTITY(1,1),
       EmployeeID INT NOT NULL,
       DepartmentID INT NOT NULL,
       ShiftID INT NOT NULL,
       AssignmentDate DATE NOT NULL,
       IsPresent BIT NOT NULL DEFAULT 0,
       Notes NVARCHAR(500),
       CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
       ModifiedDate DATETIME,
       FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
       FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
       FOREIGN KEY (ShiftID) REFERENCES Shifts(ShiftID)
   );

   -- ReadinessAlerts
   CREATE TABLE ReadinessAlerts (
       AlertID INT PRIMARY KEY IDENTITY(1,1),
       DepartmentID INT NOT NULL,
       CertificationTypeID INT,
       EmployeeID INT,
       AlertType NVARCHAR(50) NOT NULL,
       Severity NVARCHAR(20) NOT NULL,
       Title NVARCHAR(200) NOT NULL,
       Description NVARCHAR(1000),
       IsResolved BIT NOT NULL DEFAULT 0,
       ResolvedDate DATETIME,
       CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
       ModifiedDate DATETIME,
       FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
       FOREIGN KEY (CertificationTypeID) REFERENCES CertificationTypes(CertificationTypeID),
       FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
   );

   -- ReadinessHistory
   CREATE TABLE ReadinessHistory (
       HistoryID INT PRIMARY KEY IDENTITY(1,1),
       DepartmentID INT NOT NULL,
       CalculationDate DATE NOT NULL,
       ShiftID INT,
       ReadinessScore DECIMAL(5,2) NOT NULL,
       PresentCount INT NOT NULL DEFAULT 0,
       RequiredCount INT NOT NULL DEFAULT 0,
       ReadyCount INT NOT NULL DEFAULT 0,
       GapCount INT NOT NULL DEFAULT 0,
       Notes NVARCHAR(500),
       CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
       FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
       FOREIGN KEY (ShiftID) REFERENCES Shifts(ShiftID)
   );
   ```

#### ב. יצירת Indexes
```sql
-- Indexes לשיפור ביצועים
CREATE INDEX IX_Employees_DepartmentID ON Employees(DepartmentID);
CREATE INDEX IX_EmployeeCertifications_EmployeeID ON EmployeeCertifications(EmployeeID);
CREATE INDEX IX_EmployeeCertifications_ExpiryDate ON EmployeeCertifications(ExpiryDate);
CREATE INDEX IX_ShiftAssignments_Date ON ShiftAssignments(AssignmentDate);
CREATE INDEX IX_ReadinessHistory_Date ON ReadinessHistory(CalculationDate);
```

#### ג. יצירת Stored Procedures
ראה את הקובץ `Database/Scripts/StoredProcedures.sql` (אם קיים) או ראה [INFRASTRUCTURE.md](INFRASTRUCTURE.md) לפרטים.

### 3. נתוני דוגמה

הרץ את הסקריפט הבא ליצירת נתוני דוגמה:

```sql
USE ComplianceCenter;

-- הוספת משמרות
INSERT INTO Shifts (ShiftName, ShiftCode, StartTime, EndTime) VALUES
('בוקר', 'M', '06:00', '14:00'),
('צהריים', 'A', '14:00', '22:00'),
('לילה', 'N', '22:00', '06:00');

-- הוספת מחלקות
INSERT INTO Departments (DepartmentName, DepartmentCode, MinimumStaffCount) VALUES
('מחלקת ייצור', 'PROD', 5),
('מחלקת תחזוקה', 'MAINT', 3),
('מחלקת מחסן', 'WARE', 2),
('מחלקת לוגיסטיקה', 'LOG', 4),
('מחלקת אריזה', 'PACK', 3);

-- הוספת סוגי הסמכות
INSERT INTO CertificationTypes (CertificationName, CertificationCode, ValidityPeriodMonths, IsRequired) VALUES
('הסמכת בטיחות כללית', 'SAFETY', 24, 1),
('הסמכת מפעיל מכונה', 'MACHINE', 12, 1),
('הסמכת מנוף', 'CRANE', 12, 1),
('הסמכת כיבוי אש', 'FIRE', 12, 1);
```

---

## הגדרת הפרויקט

### 1. Clone הפרויקט
```bash
git clone [repository-url]
cd ComplianceCenter
```

### 2. פתיחת הפתרון
1. פתח את `ComplianceCenter.sln` ב-Visual Studio
2. ודא שכל הפרויקטים נטענו:
   - ComplianceCenter (Web Application)
   - ComplianceCenter.BLL (Class Library)
   - ComplianceCenter.DAL (Class Library)

### 3. הגדרת Connection Strings

**⚠️ חשוב**: הפרויקט מגיע עם `Web.config.example` בלבד. עליך ליצור את `Web.config` בעצמך.

#### שלב 1: יצירת Web.config
1. העתק את `ComplianceCenter/Web.config.example` ל-`ComplianceCenter/Web.config`
2. ערוך את `Web.config` ועדכן את הערכים הבאים:

#### שלב 2: עדכון Connection Strings

ערוך את `ComplianceCenter/Web.config`:

```xml
<connectionStrings>
  <!-- Connection String לזהות (ASP.NET Identity) -->
  <add name="DefaultConnection"
       connectionString="Data Source=YOUR_SQL_SERVER;Initial Catalog=ComplianceCenterIdentity;Integrated Security=True;MultipleActiveResultSets=True"
       providerName="System.Data.SqlClient" />

  <!-- Connection String ראשי (Entity Framework) -->
  <add name="ComplianceCenterEntities"
       connectionString="metadata=res://*/ComplianceCenterModel.csdl|res://*/ComplianceCenterModel.ssdl|res://*/ComplianceCenterModel.msl;provider=System.Data.SqlClient;provider connection string=&quot;data source=YOUR_SQL_SERVER;initial catalog=ComplianceCenter;integrated security=True;trustservercertificate=True;MultipleActiveResultSets=True;App=EntityFramework&quot;"
       providerName="System.Data.EntityClient" />
</connectionStrings>
```

**החלף את `YOUR_SQL_SERVER`** באחד מהבאים:
- `.\SQLEXPRESS` - אם אתה משתמש ב-SQL Server Express מקומי
- `localhost` או `(local)` - אם SQL Server רץ על המחשב המקומי
- `SERVER_NAME\INSTANCE_NAME` - אם יש לך instance ספציפי
- `IP_ADDRESS` או `SERVER_NAME` - אם השרת מרוחק

**דוגמאות**:
```xml
<!-- SQL Server Express מקומי -->
Data Source=.\SQLEXPRESS

<!-- SQL Server מקומי עם instance ברירת מחדל -->
Data Source=localhost

<!-- SQL Server מרוחק -->
Data Source=192.168.1.100

<!-- SQL Server עם instance ספציפי -->
Data Source=MYSERVER\SQL2019
```

#### שלב 3: SQL Authentication (אופציונלי)

אם אתה משתמש ב-SQL Authentication במקום Windows Authentication:

```xml
<!-- במקום Integrated Security=True, השתמש ב: -->
Data Source=YOUR_SQL_SERVER;Initial Catalog=ComplianceCenterIdentity;User ID=your_username;Password=your_password;MultipleActiveResultSets=True
```

**⚠️ אזהרה**: אל תעלה את `Web.config` עם סיסמאות ל-GitHub! השתמש ב-Windows Authentication או ב-Environment Variables בפרודקשן.

#### שלב 4: עדכון App.Config בפרויקטים אחרים

עדכן גם את `ComplianceCenter.DAL/App.Config`:

1. העתק את `ComplianceCenter.DAL/App.Config.example` ל-`ComplianceCenter.DAL/App.Config`
2. עדכן את ה-Connection String באותו אופן

#### שלב 5: עדכון API Keys

ערוך את `appSettings` ב-`Web.config`:

```xml
<appSettings>
  <!-- API Key ל-OCR.space (לניתוח תמונות) -->
  <!-- הירשם ב-https://ocr.space/ocrapi לקבלת API Key חינמי -->
  <add key="OCRSpaceAPIKey" value="YOUR_OCR_API_KEY_HERE" />
  
  <!-- הגדרות העלאת קבצים -->
  <add key="MaxUploadSizeBytes" value="5242880" />  <!-- 5MB -->
  <add key="AllowedFileExtensions" value=".jpg,.jpeg,.png,.pdf" />
  <add key="UploadPath" value="~/Uploads/" />
</appSettings>
```

**הערה**: אם אינך משתמש בתכונת ניתוח תמונות, תוכל להשאיר את ה-API Key ריק או להסיר את השורה.

### 4. Build הפרויקט
1. לחץ **Build > Rebuild Solution**
2. ודא שאין שגיאות קומפילציה

### 5. עדכון Entity Framework Model
אם שינית את מבנה מסד הנתונים:
1. פתח את `ComplianceCenter.DAL/ComplianceCenterModel.edmx`
2. לחץ ימין > **Update Model from Database**
3. בחר את השינויים ולחץ **Finish**

---

## הרצה ראשונית

### 1. הגדרת משתמש ראשון
1. הרץ את האפליקציה (F5)
2. המערכת תעביר אותך לדף ההתחברות
3. לחץ על **Register** (אם קיים) או השתמש ב-Account קיים

**הערה**: אם הסרת את אופציית Register, צור משתמש ידנית ב-SQL:

```sql
USE ComplianceCenterIdentity;
-- הוסף משתמש דרך ASP.NET Identity
```

### 2. בדיקת המערכת
1. התחבר למערכת
2. ודא שהדשבורד נטען
3. בדוק שנתוני הדוגמה מופיעים

---

## התקנה על שרת

### 1. Publish הפרויקט
1. לחץ ימין על `ComplianceCenter` > **Publish**
2. בחר **Folder Profile** או **IIS**
3. הגדר את הנתיב ל-`C:\inetpub\wwwroot\ComplianceCenter`
4. לחץ **Publish**

### 2. הגדרת IIS
1. פתח **IIS Manager**
2. צור **Application Pool** חדש:
   - Name: `ComplianceCenterAppPool`
   - .NET CLR Version: **v4.0**
   - Managed Pipeline Mode: **Integrated**
3. צור **Website** חדש:
   - Name: `ComplianceCenter`
   - Physical Path: `C:\inetpub\wwwroot\ComplianceCenter`
   - Application Pool: `ComplianceCenterAppPool`
   - Binding: `http://your-server:80` (או פורט אחר)

### 3. הרשאות
1. ודא ש-Application Pool Identity יש גישה לתיקיית האפליקציה
2. ודא שיש גישה למסד הנתונים

### 4. הגדרת Firewall
פתח את הפורטים הנדרשים (80, 443) ב-Windows Firewall.

---

## פתרון בעיות

### שגיאת Connection String
- ודא ש-SQL Server רץ
- בדוק את שם השרת ב-Connection String
- ודא ש-Windows Authentication עובד

### שגיאת Entity Framework
- ודא שה-EDMX מעודכן
- בדוק שה-Connection String נכון
- Rebuild את הפרויקט

### שגיאת Permissions
- ודא ש-IIS Application Pool יש הרשאות לקרוא/לכתוב
- בדוק הרשאות למסד נתונים

### שגיאת NuGet Packages
- לחץ ימין על הפתרון > **Restore NuGet Packages**
- Rebuild את הפתרון

---

## צעדים הבאים

לאחר התקנה מוצלחת:
1. קרא את [INFRASTRUCTURE.md](INFRASTRUCTURE.md) להבנת הארכיטקטורה
2. הוסף נתוני דוגמה נוספים
3. הגדר התראות Email/SMS (אם נדרש)
4. התאם את ההגדרות לפי הצרכים

---

## אבטחה והעלאת קוד ל-GitHub

### ⚠️ חשוב: לפני העלאת קוד ל-GitHub

1. **ודא ש-Web.config לא נכלל ב-commit**:
   - הקובץ `Web.config` כבר ב-`.gitignore`
   - אם כבר commit-ת אותו, הסר אותו:
     ```bash
     git rm --cached ComplianceCenter/Web.config
     git commit -m "Remove Web.config from repository"
     ```

2. **ודא ש-App.Config לא נכלל**:
   ```bash
   git rm --cached ComplianceCenter.DAL/App.Config
   git commit -m "Remove App.Config from repository"
   ```

3. **בדוק שאין סיסמאות או API Keys בקוד**:
   - חפש ב-GitHub Desktop או ב-Git:
     ```bash
     git log --all --full-history --source -- "*.config"
     ```

4. **השתמש ב-Web.config.example**:
   - הקובץ `Web.config.example` מכיל template ללא ערכים רגישים
   - זה הקובץ שיועלה ל-GitHub

### אם כבר העלית קוד עם סיסמאות

אם כבר commit-ת קוד עם סיסמאות ל-GitHub:

1. **הסר את הסיסמאות מ-GitHub**:
   - שנה את הסיסמאות במסד הנתונים
   - הסר את ה-commit מהיסטוריה (אם זה repository פרטי)
   - או פשוט עדכן את הערכים ב-Web.config המקומי

2. **השתמש ב-GitHub Secrets** (לפרודקשן):
   - אם אתה משתמש ב-GitHub Actions, השתמש ב-Secrets
   - אל תכלול סיסמאות בקוד

---

**עזרה נוספת**: אם נתקלת בבעיות, פתח Issue ב-GitHub או צור קשר עם המפתחת.

