using ComplianceCenter.DAL.Enums;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace ComplianceCenter.BLL.Helpers
{
    // =============================================
    // SecurityHelper
    // אבטחה והצפנה
    // =============================================

    public class SecurityHelper
    {
        // Hash סיסמה (SHA256 + Salt)
        public static string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                // יצירת Salt
                var salt = GenerateSalt();

                // שילוב סיסמה + Salt
                var saltedPassword = password + salt;

                // Hash
                var bytes = Encoding.UTF8.GetBytes(saltedPassword);
                var hash = sha256.ComputeHash(bytes);

                // המרה ל-Base64
                return Convert.ToBase64String(hash) + ":" + salt;
            }
        }

        // אימות סיסמה
        public static bool VerifyPassword(string password, string hashedPassword)
        {
            try
            {
                // פיצול Hash ו-Salt
                var parts = hashedPassword.Split(':');
                if (parts.Length != 2) return false;

                var hash = parts[0];
                var salt = parts[1];

                // Hash הסיסמה שהוזנה עם אותו Salt
                using (var sha256 = SHA256.Create())
                {
                    var saltedPassword = password + salt;
                    var bytes = Encoding.UTF8.GetBytes(saltedPassword);
                    var newHash = sha256.ComputeHash(bytes);
                    var newHashString = Convert.ToBase64String(newHash);

                    return newHashString == hash;
                }
            }
            catch
            {
                return false;
            }
        }

        // יצירת Salt אקראי
        private static string GenerateSalt()
        {
            var rng = new RNGCryptoServiceProvider();
            var buffer = new byte[32];
            rng.GetBytes(buffer);
            return Convert.ToBase64String(buffer);
        }

        // בדיקת חוזק סיסמה
        public static bool IsPasswordStrong(string password)
        {
            if (string.IsNullOrEmpty(password)) return false;
            if (password.Length < 8) return false;

            var hasUpper = password.Any(char.IsUpper);
            var hasLower = password.Any(char.IsLower);
            var hasDigit = password.Any(char.IsDigit);
            var hasSpecial = password.Any(c => !char.IsLetterOrDigit(c));

            return hasUpper && hasLower && hasDigit && hasSpecial;
        }

        // הצפנת מחרוזת (AES)
        public static string Encrypt(string plainText, string key)
        {
            using (var aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(key.PadRight(32).Substring(0, 32));
                aes.IV = new byte[16]; // IV פשוט לדוגמה

                var encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

                using (var msEncrypt = new MemoryStream())
                {
                    using (var csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                    using (var swEncrypt = new StreamWriter(csEncrypt))
                    {
                        swEncrypt.Write(plainText);
                    }
                    return Convert.ToBase64String(msEncrypt.ToArray());
                }
            }
        }

        // פענוח מחרוזת (AES)
        public static string Decrypt(string cipherText, string key)
        {
            using (var aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(key.PadRight(32).Substring(0, 32));
                aes.IV = new byte[16];

                var decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                using (var msDecrypt = new MemoryStream(Convert.FromBase64String(cipherText)))
                using (var csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                using (var srDecrypt = new StreamReader(csDecrypt))
                {
                    return srDecrypt.ReadToEnd();
                }
            }
        }

        // בדיקת הרשאות
        public static bool HasPermission(UserRole userRole, string requiredPermission)
        {
            var permissions = new Dictionary<UserRole, List<string>>
            {
                {
                    UserRole.Admin, new List<string>
                    {
                        "VIEW_ALL", "EDIT_ALL", "DELETE_ALL", "MANAGE_USERS",
                        "MANAGE_SETTINGS", "VIEW_REPORTS", "MANAGE_DEPARTMENTS"
                    }
                },
                {
                    UserRole.SafetyManager, new List<string>
                    {
                        "VIEW_ALL", "EDIT_CERTIFICATIONS", "MANAGE_ALERTS",
                        "VIEW_REPORTS", "MANAGE_REQUIREMENTS"
                    }
                },
                {
                    UserRole.ShiftManager, new List<string>
                    {
                        "VIEW_DEPARTMENT", "EDIT_SHIFTS", "VIEW_READINESS"
                    }
                },
                {
                    UserRole.HR, new List<string>
                    {
                        "VIEW_EMPLOYEES", "EDIT_EMPLOYEES", "VIEW_CERTIFICATIONS"
                    }
                },
                {
                    UserRole.Doctor, new List<string>
                    {
                        "VIEW_MEDICAL", "EDIT_MEDICAL"
                    }
                },
                {
                    UserRole.Viewer, new List<string>
                    {
                        "VIEW_READINESS"
                    }
                }
            };

            return permissions.ContainsKey(userRole) &&
                   permissions[userRole].Contains(requiredPermission);
        }
    }
}
