﻿using Microsoft.Owin;
using Owin;
/// <summary>
/// Summary description for Startup
/// </summary>
[assembly: OwinStartup(typeof(Startup))]
public static class Startup
{
    public static void Configuration(IAppBuilder app)
    {
        // For more information on how to configure your application using OWIN startup, visit http://go.microsoft.com/fwlink/?LinkID=316888

        app.MapSignalR();
    }
}