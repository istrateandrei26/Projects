using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using Utilities;

namespace Server
{
    class DatabaseManager
    {
        public static int Register(string FirstName, string LastName, string email, string cnp, string age, string username, string paswword)
        {
            string salt = SecurityHelper.GenerateSalt();
            string hashed_passwd = SecurityHelper.GenerateSaltedHash(paswword, salt);

            var query = DatabaseConnection.GetConnection.CreateCommand();

            query.CommandType = CommandType.StoredProcedure;
            query.CommandText = "RegisterProcedure";
            query.Parameters.AddWithValue("@FirstName", FirstName);
            query.Parameters.AddWithValue("@LastName", LastName);
            query.Parameters.AddWithValue("@Email", email);
            query.Parameters.AddWithValue("@CNP", cnp);
            query.Parameters.AddWithValue("@Age", age);
            query.Parameters.AddWithValue("@username", username);
            query.Parameters.AddWithValue("@password", hashed_passwd);
            query.Parameters.AddWithValue("@salt", salt);

            var return_parameter = query.Parameters.Add("@numRows", SqlDbType.Int);
            return_parameter.Direction = ParameterDirection.InputOutput;

            //num_rows_modified = (int)query.ExecuteScalar();
            query.ExecuteNonQuery();


            if(Int32.Parse(return_parameter.Value.ToString()) == 1)
            {
                return Int32.Parse(Utilities.Utility._REGISTER_SUCCES);
            }
            else
            {
                return Int32.Parse(Utilities.Utility._REGISTER_FAILED);
            }

        }

        public static Message Login(string username, string password)
        {
            var query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"SELECT Salt FROM Credentials WHERE Username = '{username}'";
            query.CommandType = CommandType.Text;
            string salt = (string)query.ExecuteScalar();
            if(salt == null)
            {
                return new Message(Int32.Parse(Utilities.Utility._LOGIN_FAILED));
            }

            string hashed_passwd = SecurityHelper.GenerateSaltedHash(password, salt);

            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = "LoginProcedure";
            query.CommandType = CommandType.StoredProcedure;
            query.Parameters.AddWithValue("@username", username);
            query.Parameters.AddWithValue("@password", hashed_passwd);
            var clientID = query.ExecuteScalar();



            if(clientID != null)
            {
                Message response = new Message(Int32.Parse(Utilities.Utility._LOGIN_SUCCES));
                response.Add(clientID.ToString());
                return response;
            }
            else
            {
                return new Message(Int32.Parse(Utilities.Utility._LOGIN_FAILED));
            }
        }


        public static int ChangePassword(string clientID,string password, string oldPassword)
        {
            var query_for_oldPass = DatabaseConnection.GetConnection.CreateCommand();
            query_for_oldPass.CommandText = $"SELECT Salt FROM Credentials WHERE IdClient = '{clientID}'";
            query_for_oldPass.CommandType = CommandType.Text;
            string salt_password = (string)query_for_oldPass.ExecuteScalar();

            string old_pass_hash=SecurityHelper.GenerateSaltedHash(oldPassword, salt_password);
            string new_pass_hash = SecurityHelper.GenerateSaltedHash(password, salt_password);
            //--------
            query_for_oldPass.CommandText = $"SELECT COUNT(*) FROM Credentials WHERE IdClient = '{clientID}' AND Password = '{old_pass_hash}'";
            query_for_oldPass.CommandType = CommandType.Text;
            int results_found = (int)query_for_oldPass.ExecuteScalar();
            if (results_found > 0)
            {
                var query = DatabaseConnection.GetConnection.CreateCommand();
                query.CommandText = $"UPDATE C Set Password = '{new_pass_hash}' FROM Credentials AS C WHERE IdClient = {clientID}";
                query.CommandType = CommandType.Text;
                int rows_affected = (int)query.ExecuteNonQuery();

                if (rows_affected > 0)
                {
                    return Int32.Parse(Utility._CHANGE_PASS_SUCCESS);
                }
                else
                {
                    return Int32.Parse(Utility._CHANGE_PASS_FAILED);
                }
            }
            else
            {
                return Int32.Parse(Utility._CHANGE_PASS_FAILED);
            }


        }

        public static Message SendPersonalInfo(string clientID)
        {
            var query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"SELECT CL.Nume,CL.Prenume,CL.CNP,CL.Email,CR.Username FROM Clients AS CL INNER JOIN Credentials AS CR ON CL.IdClient = CR.IdClient WHERE CL.IdClient = {clientID}; ";
            query.CommandType = CommandType.Text;
            var reader = query.ExecuteReader();


            reader.Read();
            string LastName = reader[0].ToString();
            string FirstName = reader[1].ToString();
            string CNP = reader[2].ToString();
            string Email = reader[3].ToString();
            string username = reader[4].ToString();


            Message response = new Message(Int32.Parse(Utility._VIEW_PROFILE_SUCCESS));
            response.Add(LastName);
            response.Add(FirstName);
            response.Add(CNP);
            response.Add(Email);
            response.Add(username);
            response.AddEndOfMessage();

            reader.Close();
            return response;
            
        }


        public static Message Destinations()
        {
            var query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"SELECT Destinatie FROM Flights";
            query.CommandType = CommandType.Text;

            var reader = query.ExecuteReader();

            if (!reader.HasRows)
            {
                reader.Close();
                return new Message(Int32.Parse(Utilities.Utility._DESTINATION_FAILED));

            }
            List<string> listWithElements = new List<string>();

            while(reader.Read())
            {
                listWithElements.Add(reader["Destinatie"].ToString());
            }
            Message response = new Message(Int32.Parse(Utilities.Utility._DESTINATION_SUCCESS));

            foreach(string item in listWithElements)
            {
                response.Add(item);
            }
            response.AddEndOfMessage();

            reader.Close();
            return response;
        }
        
        public static Message Departures()
        {
            var query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"SELECT Plecare FROM Flights";
            query.CommandType = CommandType.Text;

            var reader = query.ExecuteReader();

            if (!reader.HasRows)
            {
                reader.Close();
                return new Message(Int32.Parse(Utilities.Utility._DEPARTURE_FAILED));

            }
            List<string> listWithElements = new List<string>();

            while (reader.Read())
            {
                listWithElements.Add(reader["Plecare"].ToString());
            }
            Message response = new Message(Int32.Parse(Utilities.Utility._DEPARTURE_SUCCESS));

            foreach (string item in listWithElements)
            {
                response.Add(item);
            }
            response.AddEndOfMessage();

            reader.Close();
            return response;
        }

        public static Message Available_Flights(string destination, string departure, string data)
        {

            var query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $" select F.TotalLocuriDisponibile , F.Pret from Flights as F where F.Destinatie = '{destination}' AND F.Plecare = '{departure}' AND F.DataSiOraDecolarii = '{data}'";
            query.CommandType = CommandType.Text;

            var reader = query.ExecuteReader();

            if (!reader.HasRows)
            {
                reader.Close();
                return new Message(Int32.Parse(Utilities.Utility._AVAILABLE_FLIGHT_FAILED));

            }
            reader.Read();

            string totalLocuri=reader["TotalLocuriDisponibile"].ToString();
            string totalPret=reader["Pret"].ToString();

           
            Message response = new Message(Int32.Parse(Utilities.Utility._AVAILABLE_FLIGHT_SUCCESS));
            response.Add(totalLocuri);
            response.Add(totalPret);
            response.AddEndOfMessage();
           

            reader.Close();
            return response;

        }

        public static Message Book_Flight(string destination, string departure, string data,string clientID)
        {

            var query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $" select F.IdZbor from Flights as F where F.Destinatie = '{destination}' AND F.Plecare = '{departure}' AND F.DataSiOraDecolarii = '{data}'";
            query.CommandType = CommandType.Text;

            int IdZbor = (int)query.ExecuteScalar();
            if (IdZbor == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_FLIGHT_FAILED));
            }

            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $" insert into Tickets VALUES({IdZbor})";
            query.CommandType = CommandType.Text;
            int rowsAffected;
            rowsAffected = query.ExecuteNonQuery();
            if(rowsAffected==0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_FLIGHT_FAILED));
            }


            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"select TOP(1) IdBilet from Tickets order by IdBilet DESC";
            query.CommandType = CommandType.Text;

            int IdBilet = (int)query.ExecuteScalar();
            if (IdBilet == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_FLIGHT_FAILED));
            }


            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"insert into ClientsNTickets VALUES({clientID},{IdBilet});";
            query.CommandType = CommandType.Text;

            rowsAffected = query.ExecuteNonQuery();
            if (rowsAffected == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_FLIGHT_FAILED));
            }




            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"UPDATE F SET F.TotalLocuriDisponibile -= 1 FROM Flights AS F WHERE F.IdZbor = {IdZbor}";
            query.CommandType = CommandType.Text;
            rowsAffected = query.ExecuteNonQuery();
            if (rowsAffected == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_FLIGHT_FAILED));
            }

            Message response = new Message(Int32.Parse(Utilities.Utility._BOOK_FLIGHT_SUCCESS));
            return response;

        }

        public static Message Future_Flights(string IdClient)
        {
            var query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"select F.Destinatie,F.Plecare,F.DataSiOraDecolarii,F.DataSiOraSosirii,F.Pret from Clients as C inner join ClientsNTickets as N on C.IdClient = N.IdClient inner join Tickets as T on N.IdBilet = T.IdBilet inner join Flights as F on F.IdZbor = T.IdZbor where C.IdClient = {IdClient} AND GETDATE() < F.DataSiOraDecolarii";
            query.CommandType = CommandType.Text;

            var reader = query.ExecuteReader();

            if (!reader.HasRows)
            {
                reader.Close();
                return new Message(Int32.Parse(Utilities.Utility._FUTURE_FLIGHTS_FAILED));

            }
            List<string> listWithElements = new List<string>();

            while (reader.Read())
            {
                string result="";
                result += reader["Plecare"].ToString() + " -> ";
                result +=reader["Destinatie"].ToString() + " ";
                result+=reader["DataSiOraDecolarii"].ToString() + " ";
                result+=reader["DataSiOraSosirii"].ToString() + " ";
                result += reader["Pret"].ToString() + "$";
                listWithElements.Add(result);
            }
            Message response = new Message(Int32.Parse(Utilities.Utility._FUTURE_FLIGHTS_SUCCESS));

            foreach (string item in listWithElements)
            {
                response.Add(item);
            }
            response.AddEndOfMessage();

            reader.Close();
            return response;
        }

        public static Message Past_Flights(string IdClient)
        {
            var query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"select F.Destinatie,F.Plecare,F.DataSiOraDecolarii,F.DataSiOraSosirii,F.Pret from Clients as C inner join ClientsNTickets as N on C.IdClient = N.IdClient inner join Tickets as T on N.IdBilet = T.IdBilet inner join Flights as F on F.IdZbor = T.IdZbor where C.IdClient = {IdClient} AND GETDATE() > F.DataSiOraDecolarii";
            query.CommandType = CommandType.Text;

            var reader = query.ExecuteReader();

            if (!reader.HasRows)
            {
                reader.Close();
                return new Message(Int32.Parse(Utilities.Utility._PAST_FLIGHTS_FAILED));

            }
            List<string> listWithElements = new List<string>();

            while (reader.Read())
            {
                string result = "";
                result += reader["Plecare"].ToString() + " -> ";
                result += reader["Destinatie"].ToString() + " ";
                result += reader["DataSiOraDecolarii"].ToString() + " ";
                result += reader["DataSiOraSosirii"].ToString() + " ";
                result += reader["Pret"].ToString() + "$";
                listWithElements.Add(result);
            }
            Message response = new Message(Int32.Parse(Utilities.Utility._PAST_FLIGHTS_SUCCESS));

            foreach (string item in listWithElements)
            {
                response.Add(item);
            }
            response.AddEndOfMessage();

            reader.Close();
            return response;
        }


        public static Message Book_2Way_Flight(string destination, string departure, string data_dus, string data_intors, string clientID)
        {
            

            var query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $" select F.IdZbor from Flights as F where F.Destinatie = '{destination}' AND F.Plecare = '{departure}' AND F.DataSiOraDecolarii = '{data_dus}'";
            query.CommandType = CommandType.Text;

            int IdZborDus = (int)query.ExecuteScalar();
            if (IdZborDus == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_FAILED));
            }


            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $" select F.IdZbor from Flights as F where F.Destinatie = '{departure}' AND F.Plecare = '{destination}' AND F.DataSiOraDecolarii = '{data_intors}'";
            query.CommandType = CommandType.Text;

            int IdZborIntors = (int)query.ExecuteScalar();
            if (IdZborIntors == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_FAILED));
            }


            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $" insert into Tickets VALUES({IdZborDus})";
            query.CommandType = CommandType.Text;
            int rowsAffected;
            rowsAffected = query.ExecuteNonQuery();
            if (rowsAffected == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_FAILED));
            }

            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"select TOP(1) IdBilet from Tickets order by IdBilet DESC";
            query.CommandType = CommandType.Text;

            int IdBilet = (int)query.ExecuteScalar();
            if (IdBilet == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_FAILED));
            }

            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"insert into ClientsNTickets VALUES({clientID},{IdBilet});";
            query.CommandType = CommandType.Text;

            rowsAffected = query.ExecuteNonQuery();
            if (rowsAffected == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_FAILED));
            }



            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $" insert into Tickets VALUES({IdZborIntors})";
            query.CommandType = CommandType.Text;
            rowsAffected = query.ExecuteNonQuery();
            if (rowsAffected == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_FAILED));
            }


            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"select TOP(1) IdBilet from Tickets order by IdBilet DESC";
            query.CommandType = CommandType.Text;

            IdBilet = (int)query.ExecuteScalar();
            if (IdBilet == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_FAILED));
            }


            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"insert into ClientsNTickets VALUES({clientID},{IdBilet});";
            query.CommandType = CommandType.Text;

            rowsAffected = query.ExecuteNonQuery();
            if (rowsAffected == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_FAILED));
            }




            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"UPDATE F SET F.TotalLocuriDisponibile -= 1 FROM Flights AS F WHERE F.IdZbor = {IdZborDus}";
            query.CommandType = CommandType.Text;
            rowsAffected = query.ExecuteNonQuery();
            if (rowsAffected == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_FAILED));
            }

            query = DatabaseConnection.GetConnection.CreateCommand();
            query.CommandText = $"UPDATE F SET F.TotalLocuriDisponibile -= 1 FROM Flights AS F WHERE F.IdZbor = {IdZborIntors}";
            query.CommandType = CommandType.Text;
            rowsAffected = query.ExecuteNonQuery();
            if (rowsAffected == 0)
            {
                return new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_FAILED));
            }

            Message response = new Message(Int32.Parse(Utilities.Utility._BOOK_2WAY_FLIGHT_SUCCESS));
            return response;

        }
    }
}
