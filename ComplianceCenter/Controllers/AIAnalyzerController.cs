using ComplianceCenter.BLL.Services;
using ComplianceCenter.Models;
using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace ComplianceCenter.Controllers
{
    /// <summary>
    /// Web API Controller לניתוח הסמכות באמצעות AI
    /// תומך ב-OCR.space API חינמי
    /// </summary>
    [RoutePrefix("api/aianalyzer")]
    public class AIAnalyzerController : ApiController
    {
        private readonly AIAnalysisService _aiService;
        private const int MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
        private static readonly string[] ALLOWED_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".pdf" };

        public AIAnalyzerController()
        {
            _aiService = new AIAnalysisService();
        }

        /// <summary>
        /// POST: api/aianalyzer/analyze
        /// מקבל קובץ ומנתח אותו באמצעות OCR + AI
        /// </summary>
        [HttpPost]
        [Route("analyze")]
        public async Task<IHttpActionResult> AnalyzeCertificate()
        {
            try
            {
                // בדיקה אם יש קובץ
                if (!Request.Content.IsMimeMultipartContent())
                {
                    return BadRequest("יש לשלוח קובץ בפורמט multipart/form-data");
                }

                var provider = new MultipartMemoryStreamProvider();
                await Request.Content.ReadAsMultipartAsync(provider);

                HttpContent fileContent = null;
                int? employeeId = null;

                // חילוץ הקובץ ו-EmployeeID
                foreach (var content in provider.Contents)
                {
                    var name = content.Headers.ContentDisposition.Name?.Trim('"');

                    if (name == "file")
                    {
                        fileContent = content;
                    }
                    else if (name == "employeeId")
                    {
                        var value = await content.ReadAsStringAsync();
                        if (int.TryParse(value, out int id))
                            employeeId = id;
                    }
                }

                if (fileContent == null)
                {
                    return BadRequest("לא נמצא קובץ בבקשה");
                }

                // קריאת הקובץ
                var fileBytes = await fileContent.ReadAsByteArrayAsync();
                var fileName = fileContent.Headers.ContentDisposition.FileName?.Trim('"');
                var fileExtension = Path.GetExtension(fileName)?.ToLower();

                // ולידציות
                if (!ALLOWED_EXTENSIONS.Contains(fileExtension))
                {
                    return BadRequest("סוג קובץ לא נתמך. רק JPG, PNG, PDF מותרים");
                }

                if (fileBytes.Length > MAX_FILE_SIZE)
                {
                    return BadRequest($"הקובץ גדול מדי. גודל מקסימלי: {MAX_FILE_SIZE / (1024 * 1024)}MB");
                }

                // שמירה זמנית
                var tempFilePath = SaveTemporaryFile(fileBytes, fileName, employeeId);

                // ניתוח AI (אסינכרוני)
                var analysisResult = await _aiService.AnalyzeCertificateAsync(tempFilePath);

                if (analysisResult == null || !analysisResult.Success)
                {
                    return Ok(new
                    {
                        success = false,
                        message = "לא הצלחנו לנתח את התעודה. אנא בדוק שהתמונה ברורה ונסה שוב.",
                        error = analysisResult?.ErrorMessage
                    });
                }

                // החזרת תוצאות
                return Ok(new
                {
                    success = true,
                    data = new
                    {
                        certificationType = analysisResult.CertificationType,
                        certificateNumber = analysisResult.CertificateNumber,
                        issueDate = analysisResult.IssueDate,
                        expiryDate = analysisResult.ExpiryDate,
                        holderName = analysisResult.HolderName,
                        issuingAuthority = analysisResult.IssuingAuthority,
                        fullText = analysisResult.FullText,
                        confidence = analysisResult.Confidence,
                        tempFileName = Path.GetFileName(tempFilePath)
                    }
                });
            }
            catch (Exception ex)
            {
                // לוג שגיאה
                LogError(ex);

                return InternalServerError(new Exception($"שגיאה בעיבוד: {ex.Message}"));
            }
        }

        /// <summary>
        /// GET: api/aianalyzer/status/{jobId}
        /// בדיקת סטטוס ניתוח (עבור polling)
        /// </summary>
        [HttpGet]
        [Route("status/{jobId}")]
        public IHttpActionResult GetAnalysisStatus(string jobId)
        {
            // אפשר להוסיף מנגנון tracking של jobs
            // לעת עתה מחזירים תמיד completed
            return Ok(new
            {
                status = "completed",
                progress = 100
            });
        }

        /// <summary>
        /// POST: api/aianalyzer/save
        /// שמירת הסמכה לאחר אישור המשתמש
        /// </summary>
        [HttpPost]
        [Route("save")]
        public async Task<IHttpActionResult> SaveCertification([FromBody] SaveCertificationRequest request)
        {
            try
            {
                if (request == null)
                {
                    return BadRequest("נתונים חסרים");
                }

                // ולידציות
                if (request.EmployeeId <= 0)
                    return BadRequest("מזהה עובד לא תקין");

                if (request.CertificationTypeId <= 0)
                    return BadRequest("יש לבחור סוג הסמכה");

                if (string.IsNullOrEmpty(request.IssueDate) || string.IsNullOrEmpty(request.ExpiryDate))
                    return BadRequest("יש למלא תאריכים");

                // העברת הקובץ ממיקום זמני לקבוע
                string permanentFileName = null;
                if (!string.IsNullOrEmpty(request.TempFileName))
                {
                    permanentFileName = MoveToPermanentStorage(request.TempFileName, request.EmployeeId);
                }

                // שמירה בבסיס נתונים - נעשה דרך code-behind
                var result = new
                {
                    success = true,
                    message = "ההסמכה נשמרה בהצלחה!",
                    permanentFileName = permanentFileName
                };

                return Ok(result);
            }
            catch (Exception ex)
            {
                LogError(ex);
                return InternalServerError(new Exception($"שגיאה בשמירה: {ex.Message}"));
            }
        }

        #region Helper Methods

        /// <summary>
        /// שמירת קובץ זמני
        /// </summary>
        private string SaveTemporaryFile(byte[] fileBytes, string fileName, int? employeeId)
        {
            var tempFolder = HttpContext.Current.Server.MapPath("~/Uploads/Temp/");
            if (!Directory.Exists(tempFolder))
                Directory.CreateDirectory(tempFolder);

            var extension = Path.GetExtension(fileName);
            var uniqueFileName = $"temp_{employeeId ?? 0}_{DateTime.Now:yyyyMMddHHmmss}_{Guid.NewGuid():N}{extension}";
            var filePath = Path.Combine(tempFolder, uniqueFileName);

            File.WriteAllBytes(filePath, fileBytes);

            // אופטימיזציה של תמונות
            if (extension == ".jpg" || extension == ".jpeg" || extension == ".png")
            {
                OptimizeImage(filePath);
            }

            return filePath;
        }

        /// <summary>
        /// העברה לאחסון קבוע
        /// </summary>
        private string MoveToPermanentStorage(string tempFileName, int employeeId)
        {
            var tempFolder = HttpContext.Current.Server.MapPath("~/Uploads/Temp/");
            var permanentFolder = HttpContext.Current.Server.MapPath("~/Uploads/Certificates/");

            if (!Directory.Exists(permanentFolder))
                Directory.CreateDirectory(permanentFolder);

            var tempPath = Path.Combine(tempFolder, tempFileName);
            if (!File.Exists(tempPath))
                return null;

            var extension = Path.GetExtension(tempFileName);
            var permanentFileName = $"{employeeId}_{DateTime.Now:yyyyMMddHHmmss}_{Guid.NewGuid():N}{extension}";
            var permanentPath = Path.Combine(permanentFolder, permanentFileName);

            File.Move(tempPath, permanentPath);

            return permanentFileName;
        }

        /// <summary>
        /// אופטימיזציה של תמונות (הקטנה אם צריך)
        /// </summary>
        private void OptimizeImage(string filePath)
        {
            try
            {
                using (var image = System.Drawing.Image.FromFile(filePath))
                {
                    if (image.Width > 2000 || image.Height > 2000)
                    {
                        int newWidth = image.Width > 2000 ? 2000 : image.Width;
                        int newHeight = (int)(image.Height * ((double)newWidth / image.Width));

                        using (var resized = new System.Drawing.Bitmap(newWidth, newHeight))
                        using (var graphics = System.Drawing.Graphics.FromImage(resized))
                        {
                            graphics.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
                            graphics.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                            graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

                            graphics.DrawImage(image, 0, 0, newWidth, newHeight);
                            File.Delete(filePath);
                            resized.Save(filePath, System.Drawing.Imaging.ImageFormat.Jpeg);
                        }
                    }
                }
            }
            catch { }
        }

        /// <summary>
        /// לוג שגיאות
        /// </summary>
        private void LogError(Exception ex)
        {
            try
            {
                var logFolder = HttpContext.Current.Server.MapPath("~/Logs/");
                if (!Directory.Exists(logFolder))
                    Directory.CreateDirectory(logFolder);

                var logFile = Path.Combine(logFolder, $"api_errors_{DateTime.Now:yyyyMMdd}.txt");
                var errorText = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {ex.GetType().Name}: {ex.Message}\n{ex.StackTrace}\n\n";

                File.AppendAllText(logFile, errorText);
            }
            catch { }
        }

        #endregion

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                _aiService?.Dispose();
            }
            base.Dispose(disposing);
        }
    }

    #region Request Models

    /// <summary>
    /// מודל לשמירת הסמכה
    /// </summary>
    public class SaveCertificationRequest
    {
        public int EmployeeId { get; set; }
        public int CertificationTypeId { get; set; }
        public string CertificateNumber { get; set; }
        public string IssueDate { get; set; }
        public string ExpiryDate { get; set; }
        public string Notes { get; set; }
        public string TempFileName { get; set; }
    }

    #endregion
}