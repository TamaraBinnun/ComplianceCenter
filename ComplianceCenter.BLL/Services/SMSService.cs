using System;
using System.Configuration;

namespace ComplianceCenter.BLL.Services
{
    // =============================================
    // SMSService
    // שליחת SMS (Twilio)
    // =============================================

    public class SMSService
    {
        private readonly string _accountSid;
        private readonly string _authToken;
        private readonly string _fromPhone;

        public SMSService()
        {
            _accountSid = ConfigurationManager.AppSettings["TwilioAccountSid"];
            _authToken = ConfigurationManager.AppSettings["TwilioAuthToken"];
            _fromPhone = ConfigurationManager.AppSettings["TwilioPhoneNumber"];
        }

        // שליחת SMS
        public bool SendSMS(string toPhone, string message)
        {
            try
            {
                // בפועל כאן תהיה קריאה ל-Twilio API
                // לצורך הדוגמה רק מדמים:

                System.Diagnostics.Debug.WriteLine($"SMS to {toPhone}: {message}");

                // TODO: Implement actual Twilio API call
                // var client = new TwilioRestClient(_accountSid, _authToken);
                // var sms = client.SendMessage(_fromPhone, toPhone, message);

                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"SMS send failed: {ex.Message}");
                return false;
            }
        }

        // התראת SMS קריטית
        public bool SendCriticalAlert(string toPhone, string departmentName, string issue)
        {
            var message = $"התראה קריטית - {departmentName}: {issue}. יש לטפל מיידית!";
            return SendSMS(toPhone, message);
        }
    }
}
