using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using DevFun.Api.DTOs;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace DevFun.Api.Controllers
{
    [Produces("application/json")]
    [Route("api/Status")]
    public class StatusController : Controller
    {
        private IConfiguration configuration;

        public StatusController(IConfiguration configuration)
        {
            this.configuration = configuration;
        }

        [HttpGet()]
        [Produces(typeof(StatusResponse))]
        
        public Task<StatusResponse> GetCurrentStatus()
        {
            var status = new StatusResponse();
            status.AssemblyInfoVersion = this.GetType().Assembly.GetCustomAttribute<AssemblyInformationalVersionAttribute>().InformationalVersion;
            status.AssemblyVersion = this.GetType().Assembly.GetName().Version.ToString();
            status.AssemblyFileVersion = this.GetType().Assembly.GetCustomAttribute<AssemblyFileVersionAttribute>().Version;

            status.MachineName = Environment.MachineName;
            status.DeploymentEnvironment = this.configuration["DevFunOptions:DeploymentEnvironment"];    

            return Task.FromResult(status);
        }
    }
}