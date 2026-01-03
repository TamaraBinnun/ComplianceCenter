
using System;
using System.Web;
using System.Web.Http;
using System.Web.Optimization;
using System.Web.Routing;

namespace ComplianceCenter
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            // הפעלת Web API
            GlobalConfiguration.Configure(WebApiConfig.Register);

            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            // ניקוי קבצים זמניים ישנים
            CleanupOldTempFiles();
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            // אתחול session
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            // טיפול ב-CORS אם צריך
            if (HttpContext.Current.Request.HttpMethod == "OPTIONS")
            {
                HttpContext.Current.Response.StatusCode = 200;
                HttpContext.Current.Response.End();
            }
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {
            // אימות
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            // טיפול בשגיאות כלליות
            Exception ex = Server.GetLastError();

            // לוג השגיאה
            try
            {
                string logPath = Server.MapPath("~/Logs/global_errors.txt");
                string errorText = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {ex.GetType().Name}: {ex.Message}\n{ex.StackTrace}\n\n";
                System.IO.File.AppendAllText(logPath, errorText);
            }
            catch { }
        }

        protected void Session_End(object sender, EventArgs e)
        {
            // ניקוי session
        }

        protected void Application_End(object sender, EventArgs e)
        {
            // ניקוי משאבים
        }

        /// <summary>
        /// ניקוי קבצים זמניים ישנים (מעל 24 שעות)
        /// </summary>
        private void CleanupOldTempFiles()
        {
            try
            {
                string tempFolder = Server.MapPath("~/Uploads/Temp/");
                if (!System.IO.Directory.Exists(tempFolder))
                    return;

                var files = System.IO.Directory.GetFiles(tempFolder);
                var yesterday = DateTime.Now.AddHours(-24);

                foreach (var file in files)
                {
                    var fileInfo = new System.IO.FileInfo(file);
                    if (fileInfo.CreationTime < yesterday)
                    {
                        try
                        {
                            System.IO.File.Delete(file);
                        }
                        catch { }
                    }
                }
            }
            catch { }
        }
    }
}