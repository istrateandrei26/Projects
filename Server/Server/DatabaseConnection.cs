using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace Server
{
    class DatabaseConnection
    {
        private static SqlConnection connection;
        public static void connectDatabase(string connection_string)
        {
            connection = new SqlConnection();
            connection.ConnectionString = connection_string;
            connection.Open();

        }
        public static void closeConnection()
        {
            connection.Close();
        }


        public static SqlConnection GetConnection
        {
            get
            {
                return connection;
            }
        }

        
    }
}
