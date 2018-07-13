using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for STOCK
/// </summary>
public class STOCK
{
    public string CODE { get; set; }
    public string NAME { get; set; }
    public decimal PRICE { get; set; }


    public STOCK(string CODE, string NAME, decimal PRICE)
    {
        this.CODE = CODE;
        this.NAME = NAME;
        this.PRICE = PRICE;
    }
    public STOCK() { }


    public virtual List<STOCK> Select(int ID = 0, string listcolumn = "")
    {
        var sql = "SELECT * FROM [STOCK] ";
        if (!string.IsNullOrEmpty(listcolumn)) sql = sql.Replace("*", listcolumn);
        if (ID == 0) return DBManager<STOCK>.ExecuteReader(sql);
        sql += " WHERE ID=@ID";

        return DBManager<STOCK>.ExecuteReader(sql, new { ID = ID });
    }

    public virtual List<STOCK> SelectPaging(int start = 0, int end = 10, string query = "", string listcolumn = "")
    {
        var sql = "SELECT * FROM(SELECT ROW_NUMBER() OVER (order by id) AS ROWNUM, * FROM STOCK WHERE 1=1 " + query + ") as u  WHERE   RowNum BETWEEN @start AND @end ORDER BY RowNum;";
        if (!string.IsNullOrEmpty(listcolumn)) sql = sql.Replace("*", listcolumn);

        return DBManager<STOCK>.ExecuteReader(sql, new { start = start, end = end });
    }

    public virtual int GetCount(string query = "")
    {
        var sql = "SELECT COUNT(1) AS CNT FROM STOCK WHERE 1=1 " + query;
        return (int)DBManager<STOCK>.ExecuteScalar(sql);
    }
    public virtual int Update1Column(int ID, string COLUMN, string VALUE)
    {
        var sql = string.Format(@"UPDATE STOCK SET {0}=@VALUE WHERE ID=@ID", COLUMN);

        return DBManager<STOCK>.Execute(sql, new { ID = ID, VALUE = VALUE });
    }
    public virtual int Delete(string CODE = "")
    {
        var sql = "DELETE FROM STOCK ";
        if (string.IsNullOrEmpty(CODE)) return DBManager<STOCK>.Execute(sql);
        sql += " WHERE CODE=@CODE ";
        return DBManager<STOCK>.Execute(sql, new { CODE = CODE });
    }

    public virtual void DeleteAll()
    {
        DBManager<STOCK>.Execute("TRUNCATE TABLE STOCK");
    }
    public virtual int SpecialCount()
    {
        var sql = string.Format(@"
SELECT SUM (row_count)
FROM sys.dm_db_partition_stats
WHERE object_id=OBJECT_ID('STOCK')   
AND (index_id=0 or index_id=1);
");
        var result = DBManager<STOCK>.ExecuteScalar(sql);
        return Convert.ToInt32(result);
    }

    public virtual int Insert(string CODE, string NAME, decimal PRICE)
    {
        var sql = "INSERT INTO STOCK(CODE,NAME,PRICE) VALUES(@CODE,@NAME,@PRICE)";
        return DBManager<STOCK>.Execute(sql, new { CODE = CODE, NAME = NAME, PRICE = PRICE });
    }

    public virtual int Update(string CODE, string NAME, decimal PRICE)
    {
        var sql = "UPDATE STOCK SET NAME=@NAME,PRICE=@PRICE WHERE CODE=@CODE";

        return DBManager<STOCK>.Execute(sql, new { CODE = CODE, NAME = NAME, PRICE = PRICE });
    }

}