using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;

namespace ComplianceCenter
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // בדיקה אם המשתמש מחובר
            if (User.Identity.IsAuthenticated)
            {
                // אם המשתמש מחובר - העברה לדף הדש-בורד
                Response.Redirect("~/Pages/Dashboard.aspx");
            }
            else
            {
                // אם המשתמש לא מחובר - העברה לדף ההתחברות
                Response.Redirect("~/Account/Login.aspx");
            }
        }
    }
}