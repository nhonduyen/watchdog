using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for WebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    public WebService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public int Insert(STOCK STOCK)
    {
        var stock = new STOCK();
        return stock.Insert(STOCK.CODE, STOCK.NAME, STOCK.PRICE);
    }

    [WebMethod]
    public int Update(STOCK STOCK)
    {
        var stock = new STOCK();
        return stock.Update(STOCK.CODE, STOCK.NAME, STOCK.PRICE);
    }
    [WebMethod]
    public int Remove(STOCK STOCK)
    {
        var stock = new STOCK();
        return stock.Delete(STOCK.CODE);
    }
}
