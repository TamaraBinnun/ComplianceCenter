
namespace ComplianceCenter.BLL.DTO
{
    /// <summary>
    /// מודל לתוצאות ניתוח AI של הסמכה
    /// </summary>
    public class AIAnalysisResult
    {
        /// <summary>
        /// האם הניתוח הצליח
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// הודעת שגיאה במקרה של כישלון
        /// </summary>
        public string ErrorMessage { get; set; }

        /// <summary>
        /// סוג ההסמכה שזוהה
        /// </summary>
        public string CertificationType { get; set; }

        /// <summary>
        /// מספר תעודת ההסמכה
        /// </summary>
        public string CertificateNumber { get; set; }

        /// <summary>
        /// תאריך הנפקה (פורמט: yyyy-MM-dd)
        /// </summary>
        public string IssueDate { get; set; }

        /// <summary>
        /// תאריך פקיעה (פורמט: yyyy-MM-dd)
        /// </summary>
        public string ExpiryDate { get; set; }

        /// <summary>
        /// שם המחזיק בתעודה
        /// </summary>
        public string HolderName { get; set; }

        /// <summary>
        /// הגוף המנפיק
        /// </summary>
        public string IssuingAuthority { get; set; }

        /// <summary>
        /// הטקסט המלא שזוהה מהתמונה
        /// </summary>
        public string FullText { get; set; }

        /// <summary>
        /// רמת ביטחון בזיהוי (0-100)
        /// </summary>
        public int Confidence { get; set; }

        /// <summary>
        /// מטא-דאטה נוספת (אופציונלי)
        /// </summary>
        public AIAnalysisMetadata Metadata { get; set; }
    }

    /// <summary>
    /// מטא-דאטה לניתוח
    /// </summary>
    public class AIAnalysisMetadata
    {
        /// <summary>
        /// זמן עיבוד במילישניות
        /// </summary>
        public long ProcessingTimeMs { get; set; }

        /// <summary>
        /// OCR Engine שנעשה בו שימוש
        /// </summary>
        public string OcrEngine { get; set; }

        /// <summary>
        /// שפה שזוהתה
        /// </summary>
        public string DetectedLanguage { get; set; }

        /// <summary>
        /// כיוון הטקסט (RTL/LTR)
        /// </summary>
        public string TextDirection { get; set; }
    }
}
