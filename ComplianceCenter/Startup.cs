using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ComplianceCenter.Startup))]
namespace ComplianceCenter
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
