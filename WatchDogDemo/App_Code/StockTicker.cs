using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR.Hubs;
using TableDependency.EventArgs;
using TableDependency.Enums;
using System.Configuration;
using System.Data.SqlClient;
using TableDependency.SqlClient;
using Microsoft.AspNet.SignalR;
using TableDependency;
using TableDependency.Utilities;

/// <summary>
/// Summary description for StockTicker
/// </summary>
public class StockTicker
{
    // Singleton instance
    private readonly static Lazy<StockTicker> _instance = new Lazy<StockTicker>(
        () => new StockTicker(GlobalHost.ConnectionManager.GetHubContext<StockTickerHub>().Clients));

    private static SqlTableDependency<STOCK> _tableDependency;

    private StockTicker(IHubConnectionContext<dynamic> clients)
    {
        Clients = clients;

        var mapper = new ModelToTableMapper<STOCK>();
        mapper.AddMapping(s => s.CODE, "Code");

        _tableDependency = new SqlTableDependency<STOCK>(
            ConfigurationManager.ConnectionStrings["cnnString"].ConnectionString,
            "STOCK");

        _tableDependency.OnChanged += SqlTableDependency_Changed;
        _tableDependency.OnError += SqlTableDependency_OnError;
        _tableDependency.Start();
    }

    public static StockTicker Instance
    {
        get
        {
            return _instance.Value;
        }
    }

    private IHubConnectionContext<dynamic> Clients
    {
        get;
        set;
    }

    public List<STOCK> GetAllStocks()
    {
        var stock = new STOCK();
        return stock.Select();
    }

    void SqlTableDependency_OnError(object sender, ErrorEventArgs e)
    {
        Clients.All.onError(e.ToString());
        throw e.Error;
    }

    /// <summary>
    /// Broadcast New Stock Price
    /// </summary>
    void SqlTableDependency_Changed(object sender, RecordChangedEventArgs<STOCK> e)
    {
        if (e.ChangeType != ChangeType.None)
        {
            BroadcastStockPrice(e.Entity, (int)e.ChangeType);
        }
    }

    private void BroadcastStockPrice(STOCK stock, int changeType)
    {
        Clients.All.updateStockPrice(stock, changeType);
    }

    #region IDisposable Support
    private bool disposedValue = false; // To detect redundant calls

    protected virtual void Dispose(bool disposing)
    {
        if (!disposedValue)
        {
            if (disposing)
            {
                _tableDependency.Stop();
            }

            disposedValue = true;
        }
    }

    ~StockTicker()
    {
        Dispose(false);
    }

    // This code added to correctly implement the disposable pattern.
    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    #endregion
}