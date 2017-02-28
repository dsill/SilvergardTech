using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using BLToolkit.Data;
using BLToolkit.DataAccess;

namespace AngeionCalcsAPI.Helpers
{
    public class DAOHelpers
    {

        static public DataTable CreateDataTable<T>(IEnumerable<KeyValuePair<int, T>> IDValuePairs)
        {
            var dataTable = new DataTable();
            dataTable.Columns.Add("key", typeof(int));
            dataTable.Columns.Add("value", typeof(T));

            foreach (var IDValuePair in IDValuePairs)
            {
                var row = dataTable.NewRow();
                row[0] = IDValuePair.Key;
                row[1] = IDValuePair.Value;
                dataTable.Rows.Add(row);
            }

            return dataTable;
        }


        static public DataTable CreateDataTable<T>(IEnumerable<T> values)
        {
            var dataTable = new DataTable();
            dataTable.Columns.Add("value", typeof(int));

            foreach (var value in values)
            {
                var row = dataTable.NewRow();
                row[0] = value;
                dataTable.Rows.Add(row);
            }

            return dataTable;
        }

    }
}