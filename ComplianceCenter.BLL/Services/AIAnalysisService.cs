using System;
using System.IO;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Configuration;
using Newtonsoft.Json.Linq;
using ComplianceCenter.BLL.DTO;

namespace ComplianceCenter.BLL.Services
{
    /// <summary>
    /// שירות ניתוח AI להסמכות
    /// משתמש ב-OCR.space API (חינמי!)
    /// </summary>
    public class AIAnalysisService : IDisposable
    {
        private readonly HttpClient _httpClient;
        private readonly string _ocrApiKey;

        public AIAnalysisService()
        {
            _httpClient = new HttpClient
            {
                Timeout = TimeSpan.FromSeconds(30)
            };

            // API Key מ-Web.config או ערך ברירת מחדל
            _ocrApiKey = ConfigurationManager.AppSettings["OCRSpaceAPIKey"] ?? "K87899142388957";
        }

        /// <summary>
        /// ניתוח אסינכרוני של תעודת הסמכה
        /// </summary>
        public async Task<AIAnalysisResult> AnalyzeCertificateAsync(string imagePath)
        {
            try
            {
                // שלב 1: OCR - חילוץ טקסט מהתמונה
                var extractedText = await ExtractTextFromImageAsync(imagePath);

                if (string.IsNullOrEmpty(extractedText))
                {
                    return new AIAnalysisResult
                    {
                        Success = false,
                        ErrorMessage = "לא הצלחנו לזהות טקסט בתמונה"
                    };
                }

                // שלב 2: ניתוח חכם של הטקסט
                var result = ParseCertificateText(extractedText);
                result.Success = true;
                result.FullText = extractedText;

                return result;
            }
            catch (Exception ex)
            {
                return new AIAnalysisResult
                {
                    Success = false,
                    ErrorMessage = $"שגיאה בניתוח: {ex.Message}"
                };
            }
        }

        #region OCR Integration

        /// <summary>
        /// חילוץ טקסט מתמונה באמצעות OCR.space API
        /// </summary>
        private async Task<string> ExtractTextFromImageAsync(string imagePath)
        {
            using (var formData = new MultipartFormDataContent())
            {
                // הוספת API Key
                formData.Add(new StringContent(_ocrApiKey), "apikey");

                // שפה: עברית + אנגלית
                formData.Add(new StringContent("eng"), "language");

                // זיהוי אוטומטי של כיוון
                formData.Add(new StringContent("true"), "detectOrientation");

                // OCR Engine 2 (הכי טוב לעברית)
                formData.Add(new StringContent("1"), "OCREngine");

                // קריאת הקובץ
                byte[] fileBytes = File.ReadAllBytes(imagePath);
                var fileContent = new ByteArrayContent(fileBytes);
                fileContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(GetMimeType(imagePath));
                formData.Add(fileContent, "file", Path.GetFileName(imagePath));

                // שליחת הבקשה
                var response = await _httpClient.PostAsync("https://api.ocr.space/parse/image", formData);
                var responseString = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                {
                    throw new Exception($"OCR API Error: {response.StatusCode}");
                }

                // פירוק התשובה
                var jsonResponse = JObject.Parse(responseString);

                // בדיקת שגיאה
                var isErrored = jsonResponse["IsErroredOnProcessing"]?.ToString();
                if (isErrored == "True")
                {
                    var errorMessage = jsonResponse["ErrorMessage"]?.ToString();
                    throw new Exception($"OCR Error: {errorMessage}");
                }

                // חילוץ הטקסט
                var parsedResults = jsonResponse["ParsedResults"];
                if (parsedResults != null && parsedResults.HasValues)
                {
                    var parsedText = parsedResults[0]["ParsedText"]?.ToString();
                    return parsedText;
                }

                return null;
            }
        }

        private string GetMimeType(string filePath)
        {
            string extension = Path.GetExtension(filePath).ToLower();
            switch (extension)
            {
                case ".jpg":
                case ".jpeg":
                    return "image/jpeg";
                case ".png":
                    return "image/png";
                case ".pdf":
                    return "application/pdf";
                default:
                    return "application/octet-stream";
            }
        }

        #endregion

        #region Smart Text Parsing

        /// <summary>
        /// ניתוח חכם של הטקסט שזוהה
        /// </summary>
        private AIAnalysisResult ParseCertificateText(string text)
        {
            var result = new AIAnalysisResult();

            try
            {
                // ניקוי טקסט
                text = CleanText(text);

                // 1. זיהוי סוג הסמכה
                result.CertificationType = DetectCertificationType(text);
                result.Confidence = CalculateConfidence(result.CertificationType);

                // 2. זיהוי מספר תעודה
                result.CertificateNumber = ExtractCertificateNumber(text);

                // 3. חילוץ תאריכים
                ExtractDates(text, out string issueDate, out string expiryDate);
                result.IssueDate = issueDate;
                result.ExpiryDate = expiryDate;

                // 4. חילוץ שם
                result.HolderName = ExtractName(text);

                // 5. חילוץ גוף מנפיק
                result.IssuingAuthority = ExtractIssuingAuthority(text);
            }
            catch (Exception ex)
            {
                result.ErrorMessage = $"שגיאה בפרסור: {ex.Message}";
            }

            return result;
        }

        /// <summary>
        /// ניקוי טקסט - הסרת תווים מיותרים
        /// </summary>
        private string CleanText(string text)
        {
            if (string.IsNullOrEmpty(text)) return text;

            // הסרת שורות ריקות מרובות
            text = Regex.Replace(text, @"[\r\n]+", " ");

            // הסרת רווחים מרובים
            text = Regex.Replace(text, @"\s+", " ");

            return text.Trim();
        }

        /// <summary>
        /// זיהוי סוג הסמכה לפי מילות מפתח
        /// </summary>
        private string DetectCertificationType(string text)
        {
            text = text.ToLower();

            // מילון מילות מפתח לסוגי הסמכות
            var keywords = new (string[] keys, string certType)[]
            {
                (new[] { "עזרה ראשונה", "first aid", "מגיש עזרה", "עזרה רפואית" }, "עזרה ראשונה"),
                (new[] { "בטיחות", "safety", "ממונה בטיחות", "בטיחות בעבודה" }, "ממונה בטיחות"),
                (new[] { "גובה", "עבודה בגובה", "working at height", "work at height" }, "עבודה בגובה"),
                (new[] { "מלגזה", "forklift", "מלגזן", "מפעיל מלגזה" }, "מפעיל מלגזה"),
                (new[] { "מנוף", "crane", "מנופאי", "מפעיל מנוף" }, "מפעיל מנוף"),
                (new[] { "חשמל", "electric", "חשמלאי", "חשמלאות" }, "חשמלאי מוסמך"),
                (new[] { "גז", "gas", "עבודה עם גזים" }, "עבודה עם גזים"),
                (new[] { "ריתוך", "welding", "רתך", "ריתוך מתכת" }, "רתך מוסמך"),
                (new[] { "אש", "fire", "כיבוי", "כיבוי אש" }, "כיבוי אש"),
                (new[] { "מסור", "saw", "משור", "מסור שרשרת" }, "מפעיל מסורים"),
                (new[] { "מעלית", "elevator", "מעלון" }, "מפעיל מעלית"),
                (new[] { "בדקן", "inspector", "בודק" }, "בדקן מוסמך"),
                (new[] { "היגיינה", "hygiene", "תברואה" }, "היגיינה"),
                (new[] { "נהג", "driver", "רישיון נהיגה" }, "רישיון נהיגה")
            };

            foreach (var (keys, certType) in keywords)
            {
                foreach (var key in keys)
                {
                    if (text.Contains(key))
                    {
                        return certType;
                    }
                }
            }

            return "לא זוהה";
        }

        /// <summary>
        /// חישוב רמת ביטחון בזיהוי
        /// </summary>
        private int CalculateConfidence(string certificationType)
        {
            if (certificationType == "לא זוהה") return 30;
            return 85; // ברירת מחדל לזיהוי מוצלח
        }

        /// <summary>
        /// חילוץ מספר תעודה
        /// </summary>
        private string ExtractCertificateNumber(string text)
        {
            // דפוס 1: "מספר: 123456" או "תעודה: 123456"
            var match = Regex.Match(text, @"(?:מספר|תעודה|מס[׳']|certificate|no|number)[\s:]+(\d{3,10})", RegexOptions.IgnoreCase);
            if (match.Success)
                return match.Groups[1].Value;

            // דפוס 2: אותיות+מספרים (ABC-12345)
            match = Regex.Match(text, @"\b([A-Z]{2,4}[-/]?\d{3,8})\b", RegexOptions.IgnoreCase);
            if (match.Success)
                return match.Groups[1].Value;

            // דפוס 3: רצף של 5-10 ספרות
            match = Regex.Match(text, @"\b(\d{5,10})\b");
            if (match.Success)
                return match.Groups[1].Value;

            return null;
        }

        /// <summary>
        /// חילוץ תאריכים
        /// </summary>
        private void ExtractDates(string text, out string issueDate, out string expiryDate)
        {
            issueDate = null;
            expiryDate = null;

            // דפוסי תאריכים
            var datePatterns = new[]
            {
                @"\b(\d{1,2})[/.-](\d{1,2})[/.-](\d{4})\b",  // DD/MM/YYYY
                @"\b(\d{4})[/.-](\d{1,2})[/.-](\d{1,2})\b",  // YYYY/MM/DD
                @"\b(\d{1,2})[/.-](\d{1,2})[/.-](\d{2})\b"   // DD/MM/YY
            };

            var allDates = new System.Collections.Generic.List<string>();

            foreach (var pattern in datePatterns)
            {
                var matches = Regex.Matches(text, pattern);
                foreach (Match match in matches)
                {
                    allDates.Add(match.Value);
                }
            }

            if (allDates.Count >= 2)
            {
                issueDate = NormalizeDate(allDates[0]);
                expiryDate = NormalizeDate(allDates[1]);
            }
            else if (allDates.Count == 1)
            {
                expiryDate = NormalizeDate(allDates[0]);
            }
        }

        /// <summary>
        /// נרמול תאריך לפורמט תקני
        /// </summary>
        private string NormalizeDate(string dateStr)
        {
            try
            {
                DateTime date;

                if (DateTime.TryParse(dateStr, out date))
                {
                    return date.ToString("yyyy-MM-dd");
                }

                var formats = new[] { "dd/MM/yyyy", "dd-MM-yyyy", "dd.MM.yyyy",
                                     "yyyy/MM/dd", "yyyy-MM-dd", "dd/MM/yy" };

                foreach (var format in formats)
                {
                    if (DateTime.TryParseExact(dateStr, format, null,
                        System.Globalization.DateTimeStyles.None, out date))
                    {
                        // תיקון לשנים דו-ספרתיות
                        if (date.Year < 100)
                        {
                            date = date.AddYears(2000);
                        }

                        return date.ToString("yyyy-MM-dd");
                    }
                }
            }
            catch { }

            return dateStr;
        }

        /// <summary>
        /// חילוץ שם
        /// </summary>
        private string ExtractName(string text)
        {
            var match = Regex.Match(text, @"(?:שם|name)[\s:]+([א-ת\s]+|[A-Za-z\s]+)", RegexOptions.IgnoreCase);
            if (match.Success)
            {
                return match.Groups[1].Value.Trim();
            }

            return null;
        }

        /// <summary>
        /// חילוץ גוף מנפיק
        /// </summary>
        private string ExtractIssuingAuthority(string text)
        {
            var authorities = new[]
            {
                "משרד העבודה",
                "מכון התקנים",
                "מד״א",
                "איכות הסביבה",
                "משטרת ישראל",
                "כבאות והצלה",
                "רשות הבטיחון",
                "מכון הבטיחות",
                "משרד הבריאות",
                "rescue authority"
            };

            foreach (var authority in authorities)
            {
                if (text.ToLower().IndexOf(authority, StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    return authority;
                }
            }

            return null;
        }

        #endregion

        public void Dispose()
        {
            _httpClient?.Dispose();
        }
    }
}