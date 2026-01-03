# ComplianceCenter - מרכז בקרה לכשירות משמרת

## תיאור הפרויקט

**ComplianceCenter** היא מערכת לניהול כשירות משמרת עבור ממונה בטיחות, המאפשרת מעקב אחר הסמכות עובדים, נוכחות במשמרות, וחישוב כשירות מחלקות בזמן אמת.

המערכת נבנתה על בסיס **ASP.NET Web Forms** ו-**Microsoft SQL Server**, ומספקת פתרון מקיף לניהול תאימות (Compliance) במפעלים וארגונים.

## למה נבחר המודול "מרכז בקרה לכשירות משמרת"?

בחירת המודול נעשתה מתוך הבנה מעמיקה של הצרכים האמיתיים של ממונה בטיחות:

### 1. **ערך משמעותי לממונה בטיחות**
ממונה בטיחות זקוק לראות תמונה כוללת של מצב הכשירות בכל המפעל, כדי לוודא שכל מחלקה עומדת בדרישות הבטיחות והתאימות. המערכת מספקת דשבורד מרכזי עם תצוגה היררכית:
- **רמה ארגונית**: ציון כשירות כללי, פערים קריטיים, התראות
- **רמה מחלקתית**: כשירות כל מחלקה, עובדים נוכחים, פערים ספציפיים
- **רמה אישית**: פרופיל עובד מלא עם כל ההסמכות, תאריכי תפוגה, ומצב נוכחות

### 2. **צורך בראייה היררכית**
המערכת מאפשרת ניווט טבעי:
- **דשבורד מרכזי** → רואה את כל המחלקות במבט אחד
- **דף מחלקה** → רואה את כל העובדים במחלקה, פערים, ודרישות
- **פרופיל עובד** → רואה את כל ההסמכות, תאריכי תפוגה, ומצב נוכחות במשמרות

### 3. **מידע קריטי לניהול בטיחות**
המידע במערכת קשור לשני היבטים מרכזיים:
- **הסמכות מחלקתיות**: כל מחלקה חייבת עובדים עם הסמכות מסוימות (למשל, מפעיל מכונה חייב הסמכת בטיחות)
- **הסמכות עובדים**: כל עובד צריך הסמכות תקפות, והמערכת עוקבת אחר תאריכי תפוגה
- **נוכחות במשמרות**: המערכת בודקת אם העובדים הנדרשים נוכחים במשמרת הספציפית

### 4. **פתרון לבעיה אמיתית**
במפעלים רבים, ניהול הסמכות עובדים נעשה באופן ידני או במערכות לא מתאימות. המערכת מספקת:
- חישוב אוטומטי של כשירות מחלקות
- התראות על פערים קריטיים
- המלצות AI למחליפים
- מעקב אחר תאריכי תפוגה

## טכנולוגיות

- **Frontend**: ASP.NET Web Forms, Bootstrap 5, Chart.js, Font Awesome
- **Backend**: C# (.NET Framework 4.8.1), Entity Framework 6
- **Database**: Microsoft SQL Server
- **Architecture**: 3-Tier Architecture (Presentation, Business Logic, Data Access)
- **Authentication**: ASP.NET Identity

## מבנה הפרויקט

```
ComplianceCenter/
├── ComplianceCenter/          # Presentation Layer (Web Forms)
│   ├── Pages/                  # דפי המערכת
│   ├── Account/                # ניהול משתמשים והתחברות
│   ├── Controls/               # User Controls
│   └── Models/                 # Identity Models
├── ComplianceCenter.BLL/       # Business Logic Layer
│   ├── Managers/               # ניהול ישויות
│   ├── Services/                # שירותים (AI, Email, SMS)
│   └── DTO/                     # Data Transfer Objects
└── ComplianceCenter.DAL/        # Data Access Layer
    └── Entity Framework Models  # מודל נתונים
```

## תכונות עיקריות

### ✅ תכונות בסיסיות (חובה)
- ✅ Page Lifecycle ו-ViewState
- ✅ Validation Forms
- ✅ GridView/Repeater
- ✅ User Controls
- ✅ SQL Server עם Stored Procedures
- ✅ Indexes ו-Query Optimization

### 🚀 הרחבות מתקדמות
1. **אינטגרציות AI**: המלצות למחליפים, ניתוח פערים, חיזוי תפוגות
2. **דוחות וויזואליזציה**: Dashboard עם KPIs, גרפים, יצוא ל-Excel/PDF
3. **התראות ואוטומציות**: התראות על פערים קריטיים, תזכורות על תפוגות
4. **חיפוש מתקדם**: סינון לפי מחלקה, משמרת, תאריך
5. **תמיכה בריבוי שפות**: עברית/אנגלית, RTL/LTR
6. **Import/Export**: העלאת קבצי הסמכות, יצוא דוחות
7. **Logging & Monitoring**: לוגים למערכת, מעקב פעולות
8. **API פנימי**: Web API לניתוח AI
9. **העלאת קבצים חכמה**: תמונות/מסמכים, Preview, בדיקת סוג קובץ

## הוראות התקנה

לפרטים מלאים על התקנה והגדרה, ראה [SETUP.md](Documentation/SETUP.md)

### דרישות מערכת
- Windows Server עם IIS
- .NET Framework 4.8.1
- SQL Server 2012 או גבוה יותר
- Visual Studio 2019+ (לפיתוח)

### התקנה מהירה

1. **Clone את הפרויקט**
   ```bash
   git clone [repository-url]
   cd ComplianceCenter
   ```

2. **הגדרת Connection Strings**
   - העתק `ComplianceCenter/Web.config.example` ל-`ComplianceCenter/Web.config`
   - עדכן את `YOUR_SQL_SERVER` בכתובת השרת SQL שלך
   - עדכן את `YOUR_OCR_API_KEY_HERE` ב-API Key שלך (אופציונלי)
   - העתק `ComplianceCenter.DAL/App.Config.example` ל-`ComplianceCenter.DAL/App.Config` ועדכן גם שם

3. **יצירת מסדי נתונים**
   - צור שני מסדי נתונים: `ComplianceCenterIdentity` ו-`ComplianceCenter`
   - הרץ את סקריפטי ה-SQL ליצירת הטבלאות (ראה [SETUP.md](Documentation/SETUP.md))

4. **Build ו-Run**
   - פתח את `ComplianceCenter.sln` ב-Visual Studio
   - Build את הפתרון (Ctrl+Shift+B)
   - הרץ את הפרויקט (F5)

**⚠️ חשוב**: אל תעלה את `Web.config` או `App.Config` ל-GitHub! הם כבר ב-`.gitignore`.

## ארכיטקטורה

לפרטים מלאים על הארכיטקטורה והמבנה, ראה [INFRASTRUCTURE.md](Documentation/INFRASTRUCTURE.md)

### מבנה שכבות
- **Presentation Layer**: ASP.NET Web Forms Pages
- **Business Logic Layer**: Managers ו-Services
- **Data Access Layer**: Entity Framework עם Stored Procedures

### Database Schema
המערכת כוללת טבלאות מרכזיות:
- Departments (מחלקות)
- Employees (עובדים)
- EmployeeCertifications (הסמכות עובדים)
- DepartmentRequirements (דרישות מחלקה)
- Shifts & ShiftAssignments (משמרות והקצאות)
- ReadinessAlerts (התראות כשירות)
- ועוד...

## מצב יישום

### ✅ ממומש במלואו
- Dashboard מרכזי עם KPIs
- דף מחלקה עם כשירות ופערים
- פרופיל עובד מלא
- חישוב כשירות אוטומטי (Stored Procedures)
- מערכת התראות בסיסית
- העלאת קבצי הסמכות
- גרפים וויזואליזציה

### ⚠️ חלקי / בתהליך
- מערכת התראות מתקדמת (Email/SMS) - חלקית
- AI Recommendations - בסיסי, ניתן להרחבה
- Export ל-Excel/PDF - בסיסי
- Logging מתקדם - בסיסי

### 📋 לא ממומש (לעתיד)
- מצב Offline
- Import מ-Excel
- תמיכה מלאה ב-Microservices
- Dashboard מותאם אישית למשתמש

## תרומה לפרויקט

הפרויקט נבנה כחלק ממטלת בית ל-Datwise. לשאלות או הצעות, אנא פתח Issue.

## רישיון

פרויקט זה נבנה למטרות הערכה בלבד.

## קישורים

- [הוראות התקנה](Documentation/SETUP.md)
- [תיעוד ארכיטקטורה](Documentation/INFRASTRUCTURE.md)

---

**נבנה עבור**: Datwise Tech Lead Assignment 2025  
**מפתחת**: [שם המפתחת]  
**תאריך**: 2025

